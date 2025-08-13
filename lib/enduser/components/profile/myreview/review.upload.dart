import 'dart:async';
import 'dart:io' as io;

import 'package:appfridayecommerce/enduser/controller/review.ctr.dart';
import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class UploadReviewImageandVideo extends StatefulWidget {
  final int itemId;
  const UploadReviewImageandVideo({super.key, required this.itemId});

  @override
  State<UploadReviewImageandVideo> createState() =>
      _UploadReviewImageandVideoState();
}

class _UploadReviewImageandVideoState extends State<UploadReviewImageandVideo> {
  final pendingCtr = Get.find<MyReviewCtr>();

  final List<io.File> _imageFileList = [];
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;

  bool isPlay = true;
  ImageProvider? provider;
  bool isLoadImg = false;

  var countImg = 0;

  final ImagePicker _pickerImage = ImagePicker();
  final ImagePicker _pickerVideo = ImagePicker();

  _openImagePicker() async {
    List<XFile>? result = await _pickerImage.pickMultiImage();
    if (result.isNotEmpty) {
      setState(() {
        isLoadImg = true;
      });
      countImg += result.length;
      if (countImg > 5) {
        countImg -= result.length;
        setState(() {
          isLoadImg = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Get.snackbar('ฟรายเดย์', 'อัปโหลดรูปภาพได้ไม่เกิน 5 รูป');
          result.clear();
        });
      } else {
        final f = result
            .asMap()
            .map((i, path) => MapEntry(i, io.File(path.path.toString())))
            .values
            .toList();

        List<int> sizeInBytes = f.map((e) => e.lengthSync()).toList();
        //? หาขนาดไฟล? MB
        var limitSize = sizeInBytes.map((e) => e / (1024 * 1024)).toList();
        for (var i = 0; i < limitSize.length; i++) {
          if (limitSize[i].toDouble() <= 5.00) {
            setState(() {
              _imageFileList.add(io.File(result[i].path.toString()));
              if (pendingCtr.imageFile[widget.itemId] == null) {
                pendingCtr.imageFile[widget.itemId] = [];
              }
              pendingCtr.imageFile[widget.itemId]!
                  .add(io.File(result[i].path.toString()));
              isLoadImg = false;
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.snackbar('ฟรายเดย์', 'ไฟล์ภาพที่มีขนาดเกิน 5 MB จะถูกคัดออก');
            });
          }
        }
      }
    } else {
      final dir = await path_provider.getTemporaryDirectory();
      final file = io.File('${dir.absolute.path}/CacheImageReview');
      final directory = io.Directory(file.path);

      if (await directory.exists()) {
        final files = directory.listSync();
        for (final file in files) {
          if (file is io.File) {
            await file.delete();
          }
        }
      }
      setState(() {
        countImg = 0;
        pendingCtr.imageFile[widget.itemId]!.clear();
        _imageFileList.clear();
      });
    }
  }

  io.File createFile(String path) {
    final file = io.File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file;
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  _openVidePicker() async {
    try {
      XFile? file = await _pickerVideo.pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 10));

      if (file != null && mounted) {
        await _disposeVideoController();
        late VideoPlayerController testLengthController;
        testLengthController = VideoPlayerController.file(io.File(file.path));
        _controller = testLengthController;
        if (!pendingCtr.videoFile.containsKey(widget.itemId)) {
          pendingCtr.videoFile[widget.itemId] =
              io.File(_controller!.dataSource);
        } else {
          pendingCtr.videoFile[widget.itemId] =
              io.File(_controller!.dataSource);
        }
        await testLengthController.initialize();
        setState(() {});
        if (testLengthController.value.duration.inMinutes > 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Get.snackbar('ฟรายเดย์', 'วิดีโอที่อัปโหลดต้องไม่เกิน 1 นาที');

            await _disposeVideoController();
            setState(() {});
          });
          return;
        }
      }
    } catch (e) {
      Get.snackbar('ฟรายเดย์', '$e');
      return;
    }
  }

  getFileImage(String filePick, int i) async {
    final img = io.File(filePick);

    final dir = await path_provider.getTemporaryDirectory();

    var dateName = DateTime.now();
    var formatDate = DateFormat('mdy_HHmmss').format(dateName);

    final file = io.File('${dir.absolute.path}/CacheImageReview');
    if (!file.existsSync()) {
      io.Directory('${dir.absolute.path}/CacheImageReview').createSync();
    }
    final targetPath =
        '${dir.absolute.path}/CacheImageReview/temp_${formatDate}_$i.webp';
    final imgFile = await compressAndGetFile(img, targetPath);
    if (imgFile == null) {
      return;
    }
    safeSetState(() {
      provider = FileImage(imgFile);
      print('provider $provider');
    });
  }

  Future<io.File?> compressAndGetFile(io.File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
      format: CompressFormat.webp,
    );

    setState(() {
      _imageFileList.add(io.File(result!.path.toString()));

      isLoadImg = false;
    });
    if (kDebugMode) {
      print('covert image patch ${_imageFileList.map((e) => e.path)}');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? โชว์ภาพที่อัพโหลด
        isLoadImg && _imageFileList.isNotEmpty
            ? Column(
                children: [const Text('กำลังประมวลผลรูปภาพ...'), showUpload()],
              )
            : isLoadImg && _imageFileList.isEmpty
                ? const Text('กำลังประมวลผลรูปภาพ...')
                : _imageFileList.isNotEmpty
                    ? showUpload()
                    : Container(),
        if (_imageFileList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              height: 28,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor:
                        const Color.fromARGB(255, 244, 243, 243),
                  ),
                  onPressed: null,
                  child: Text(
                    '${_imageFileList.length}/5',
                    style: const TextStyle(
                      color: Color(0xFF515050),
                    ),
                  )),
            ),
          ),
        if (_controller != null)
          //? โชว์วิดีโอที่อัพโหลด
          _previewVideo(),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2,
          ),
          children: [
            //? Upload ภาพ
            InkWell(
              onTap: () async {
                if (countImg >= 10) {
                  return;
                } else {
                  await _openImagePicker();
                }
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [6, 2],
                strokeWidth: 0.5,
                color: Colors.grey.shade700,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 28, color: Colors.grey.shade700),
                      Text(
                        'รูปภาพ',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //? Upload วิดีโอ
            InkWell(
              onTap: () {
                // CompressFile('s');
                isPlay = true;
                _openVidePicker();
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [6, 2],
                strokeWidth: 0.5,
                color: Colors.grey.shade700,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam_outlined,
                          size: 28, color: Colors.grey.shade700),
                      Text(
                        'วิดีโอ',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //? โชว์วิดีโอ
  _previewVideo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                      color: const Color.fromARGB(255, 191, 191, 191))),
              child: Center(
                child: Visibility(
                    visible: _controller != null,
                    child: _controller != null &&
                            _controller!.value.isInitialized
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: Chewie(
                                    controller: ChewieController(
                                      videoPlayerController: _controller!,
                                      allowFullScreen: false,
                                      showControls: false,
                                    ),
                                  )),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPlay = !isPlay;
                                      if (isPlay) {
                                        setState(() {
                                          _controller!.pause();
                                        });
                                      }
                                      if (!isPlay) {
                                        setState(() {
                                          _controller!.play();
                                        });
                                      }
                                    });
                                  },
                                  child: isPlay
                                      ? CircleAvatar(
                                          backgroundColor:
                                              Colors.white.withOpacity(0.4),
                                          radius: 10,
                                          child: const Icon(
                                            Icons.play_circle_fill,
                                            size: 20,
                                            color: Colors.white,
                                          ))
                                      : CircleAvatar(
                                          backgroundColor:
                                              Colors.white.withOpacity(0.4),
                                          radius: 10,
                                          child: const Icon(
                                            Icons.pause_circle,
                                            size: 20,
                                            color: Colors.white,
                                          ))),
                            ],
                          )
                        : const SizedBox()),
              )),
          InkWell(
            onTap: () {
              setState(() {
                pendingCtr.videoFile
                    .removeWhere((key, value) => key == widget.itemId);
                _controller!.dispose();
                _controller = null;
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(8)),
                color: Colors.black45,
              ),
              child: const Icon(
                size: 18,
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //? โชว์ภาพหรือวิดีโอที่อัพโหลด
  showUpload() {
    return Wrap(
      children: pendingCtr.imageFile[widget.itemId]!
          .asMap()
          .map((i, listImg) => MapEntry(
              i,
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 191, 191, 191))),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.file(
                                fit: BoxFit.cover, io.File(listImg.path)))),
                    InkWell(
                      onTap: () async {
                        await removeImageAndCache(i);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          color: Colors.black45,
                        ),
                        child: const Icon(
                          size: 18,
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )))
          .values
          .toList(),
    );
  }

  //? function remove image and remove cache
  Future<void> removeImageAndCache(int i) async {
    countImg -= 1;
    // ignore: avoid_print
    print("image count is $countImg");

    var fileCache = io.File(pendingCtr.imageFile[widget.itemId]![i].path);
    if (fileCache.existsSync()) {
      await fileCache.delete(recursive: true);
    }
    pendingCtr.imageFile[widget.itemId]!.removeWhere((element) =>
        element.path == pendingCtr.imageFile[widget.itemId]![i].path);
    _imageFileList
        .removeWhere((element) => element.path == _imageFileList[i].path);
    setState(() {});
  }
}

extension _StateExtension on State {
  /// [setState] when it's not building, then wait until next frame built.
  FutureOr<void> safeSetState(FutureOr<dynamic> Function() fn) async {
    await fn();
    if (mounted &&
        !context.debugDoingBuild &&
        context.owner?.debugBuilding == false) {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    }
    final Completer<void> completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      completer.complete();
    });
    return completer.future;
  }
}
