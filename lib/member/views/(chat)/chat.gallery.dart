import 'dart:io';
import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/viewer/fullscreen.image.dart';
import 'package:fridayonline/member/controller/chat.ctr.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ChatGallary extends StatefulWidget {
  const ChatGallary({super.key});

  @override
  State<ChatGallary> createState() => _ChatGallaryState();
}

class _ChatGallaryState extends State<ChatGallary> {
  final ChatController chatController = Get.put(ChatController());
  final ImagePicker _imagePicker = ImagePicker();

  List<XFile> _selectedFiles = [];

  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxVideoSize = 30 * 1024 * 1024; // 30MB

  @override
  void dispose() {
    chatController.clearSelected();
    super.dispose();
  }

  // Pick multiple images and videos - compatible with all versions
  Future<void> _pickMultipleMedia() async {
    try {
      chatController.isLoadingGallery.value = true;

      List<XFile> pickedFiles = [];

      // Try pickMultipleMedia first (newer versions)
      try {
        pickedFiles = await _imagePicker.pickMultipleMedia(
          imageQuality: 100,
          requestFullMetadata: true,
        );
      } catch (e) {
        // Fallback: pick images and videos separately
        print('pickMultipleMedia not available, using fallback: $e');

        final images = await _imagePicker.pickMultiImage(
          imageQuality: 100,
        );

        final video = await _imagePicker.pickVideo(
          source: ImageSource.gallery,
        );

        pickedFiles.addAll(images);
        if (video != null) {
          pickedFiles.add(video);
        }
      }

      if (!mounted) return;

      if (pickedFiles.isEmpty) {
        chatController.isLoadingGallery.value = false;
        _showDialog(
          icon: Icons.info,
          message: "ไม่ได้เลือกรูปหรือวิดีโอ",
        );
        return;
      }

      setState(() {
        _selectedFiles = pickedFiles;
      });

      // Validate all selected files
      await _validateAllFiles();

      chatController.isLoadingGallery.value = false;
    } catch (e) {
      chatController.isLoadingGallery.value = false;
      print('Error picking media: $e');
      _showDialog(
        icon: Icons.error,
        message: "เกิดข้อผิดพลาดในการเลือกไฟล์",
      );
    }
  }

  // Validate all files for size
  Future<void> _validateAllFiles() async {
    List<XFile> validFiles = [];

    for (final file in _selectedFiles) {
      final isValid = await _checkFileSize(file);
      if (isValid) {
        validFiles.add(file);
      } else {
        final fileType = _getFileType(file);
        final maxSize = fileType == 'Video' ? '30MB' : '5MB';

        if (mounted) {
          _showDialog(
            icon: Icons.notification_important,
            message: "${file.name} มีขนาดเกิน $maxSize",
          );
        }
      }
    }

    setState(() {
      _selectedFiles = validFiles;
    });
  }

  // Get file type
  String _getFileType(XFile file) {
    // Check mimeType first
    final mime = file.mimeType ?? '';
    if (mime.startsWith('video')) return 'Video';
    if (mime.startsWith('image')) return 'Image';

    // Fallback to file extension
    final ext = file.path.split('.').last.toLowerCase();
    if (['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext)) {
      return 'Video';
    }
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext)) {
      return 'Image';
    }

    return 'Unknown';
  }

  // Check file size
  Future<bool> _checkFileSize(XFile file) async {
    try {
      final fileSize = await File(file.path).length();
      final fileType = _getFileType(file);

      print(
          'File: ${file.name}, Size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB, Type: $fileType, MimeType: ${file.mimeType}');

      if (fileType == 'Image') {
        final isValid = fileSize <= maxImageSize;
        print('Image validation: $isValid (Max: 5MB)');
        return isValid;
      } else if (fileType == 'Video') {
        final isValid = fileSize <= maxVideoSize;
        print('Video validation: $isValid (Max: 30MB)');
        return isValid;
      }

      print('Unknown file type');
      return false;
    } catch (e) {
      print('Error checking file size: $e');
      return false;
    }
  }

  // Show dialog
  void _showDialog({
    required IconData icon,
    required String message,
  }) {
    dialogAlert([
      Icon(
        icon,
        color: Colors.white,
        size: 40,
      ),
      Text(
        message,
        style: GoogleFonts.ibmPlexSansThai(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    ]);
    Future.delayed(const Duration(milliseconds: 1500), () {
      Get.back();
    });
  }

  // Toggle selection
  void _toggleSelection(int index) {
    final file = _selectedFiles[index];

    if (chatController.isSelected(file)) {
      chatController.removeFromSelected(file);
    } else {
      if (!chatController.canAddMore()) {
        _showDialog(
          icon: Icons.notification_important,
          message: "เลือกรูปภาพหรือวิดีโอได้สูงสุด 9 ไฟล์",
        );
        return;
      }

      chatController.addToSelected(file);
    }

    setState(() {});
  }

  // Get selected files as XFile
  List<XFile> getSelectedXFiles() {
    return chatController.selectedEntities.toList();
  }

  Widget _buildBody(BuildContext context) {
    if (chatController.isLoadingGallery.value) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_selectedFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'ยังไม่ได้เลือกรูปหรือวิดีโอ',
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _pickMultipleMedia,
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(
                'เลือกรูปหรือวิดีโอ',
                style: GoogleFonts.ibmPlexSansThai(),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColorDefault,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: _selectedFiles.length,
      itemBuilder: (BuildContext context, int index) {
        final file = _selectedFiles[index];

        return Obx(() {
          final isSelected = chatController.isSelected(file);

          return Stack(
            children: [
              // Image/Video Thumbnail
              InkWell(
                onTap: () => _toggleSelection(index),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                    width: Get.width,
                    height: Get.height,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Dark overlay when selected
              if (isSelected)
                Container(
                  margin: const EdgeInsets.all(1.0),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                  ),
                ),

              // Checkbox or check circle
              Positioned(
                top: 4,
                right: 4,
                child: InkWell(
                  onTap: () => _toggleSelection(index),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.transparent : Colors.white24,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 24,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),

              // Video indicator
              if (_getFileType(file) == 'Video')
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          appBar: appBarMasterEndUser('คลังภาพ'),
          body: Column(
            children: <Widget>[
              Expanded(child: _buildBody(context)),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.grey[400],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onPressed: _pickMultipleMedia,
                      icon: const Icon(Icons.add),
                      label: Text(
                        'เพิ่มเติม',
                        style: GoogleFonts.ibmPlexSansThai(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(() {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: themeColorDefault,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onPressed: chatController.selectedCount.value == 0
                            ? null
                            : () async {
                                var res = getSelectedXFiles();

                                if (Get.arguments == 2) {
                                  Get.back();
                                  Get.back(result: res);
                                } else {
                                  Get.back(result: res);
                                }
                              },
                        child: Text(
                          'ส่ง (${chatController.selectedCount.value})',
                          style: GoogleFonts.ibmPlexSansThai(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
