import 'dart:io';

import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
// import 'package:fridayonline/theme.dart';import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class StayPicture extends StatefulWidget {
  final XFile file;
  final int roomId;
  final int senderId;
  const StayPicture(
      {super.key,
      required this.file,
      required this.roomId,
      required this.senderId});

  @override
  State<StayPicture> createState() => _StayPictureState();
}

class _StayPictureState extends State<StayPicture> {
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxVideoSize = 30 * 1024 * 1024; // 30MB

  Future<bool> checkFileSize(XFile file) async {
    try {
      // ได้ขนาดไฟล์
      final fileSize = await file.length();

      // ได้ extension ของไฟล์
      final extension = file.path.split(".").last.toLowerCase();

      // เช็คว่าเป็นรูปภาพหรือวิดีโอ และเช็คขนาด
      if (imgType.contains(extension)) {
        // เป็นรูปภาพ - เช็คไม่เกิน 5MB
        return fileSize <= maxImageSize;
      } else {
        // เป็นวิดีโอ - เช็คไม่เกิน 30MB
        return fileSize <= maxVideoSize;
      }
    } catch (e) {
      print('Error checking file size: $e');
      return false;
    }
  }

  final imgType = ["jpg", "jpeg", "png", "webp"];
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    if (!imgType.contains(widget.file.name.split(".").last)) {
      _controller = VideoPlayerController.file(File(widget.file.path));
      _controller.initialize().then((_) {
        _controller.play();
      });
    }
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
            backgroundColor: Colors.black,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: MediaQuery(
                data: MediaQuery.of(Get.context!)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: AppBar(
                  elevation: 0.2,
                  leading: InkWell(
                    highlightColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            body: Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (imgType.contains(widget.file.name.split(".").last))
                    Image.file(
                      File(widget.file.path),
                      width: Get.width,
                    )
                  else
                    VideoPlayer(_controller),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: themeColorDefault, shape: BoxShape.circle),
                    child: InkWell(
                      onTap: () async {
                        final isValidSize = await checkFileSize(widget.file);
                        if (!isValidSize) {
                          // แสดง error message
                          final isImage = imgType.contains(
                              widget.file.name.split(".").last.toLowerCase());
                          final maxSize = isImage ? "5MB" : "30MB";
                          final fileType = isImage ? "รูปภาพ" : "วิดีโอ";

                          dialogAlert([
                            const Icon(
                              Icons.notification_important,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              "$fileType นี้มีขนาดเกิน $maxSize",
                              style: GoogleFonts.ibmPlexSansThai(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ]);
                          await Future.delayed(
                              const Duration(milliseconds: 2000), () {
                            Get.back();
                          });
                          return;
                        }

                        Get.back();
                        Get.back(result: widget.file);
                      },
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
