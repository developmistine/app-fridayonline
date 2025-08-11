import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class EndUserMediaReviews extends StatefulWidget {
  const EndUserMediaReviews(
      {super.key, required this.mediaUrls, required this.index});
  final List<String> mediaUrls;
  final int index;

  @override
  State<EndUserMediaReviews> createState() => _ProductMediasState();
}

class _ProductMediasState extends State<EndUserMediaReviews> {
  int activeIndex = 0;
  final List<VideoPlayerController> _controllers = [];

  List<String> videoType = ["mp4", "mov", "avi", "wmv", "flv", "mkv", "webm"];

  @override
  void initState() {
    super.initState();
    activeIndex = widget.index;
    initVideos();
  }

  initVideos() async {
    // กรอง URL ที่เป็นวิดีโอจาก mediaUrls
    final videoUrls = widget.mediaUrls.where((url) {
      final ext = url.split('.').last.split('?').first.toLowerCase();
      return videoType.contains(ext);
    }).toList();

    if (videoUrls.isNotEmpty) {
      // ล้างคอนโทรลเลอร์เดิม (หากมี)
      for (var controller in _controllers) {
        await controller.dispose();
      }
      _controllers.clear();

      // สร้างและ initialize คอนโทรลเลอร์ใหม่สำหรับแต่ละวิดีโอ
      for (var url in videoUrls) {
        final controller = VideoPlayerController.networkUrl(Uri.parse(url));
        await controller.initialize();
        _controllers.add(controller);
      }

      // อัปเดต UI หลังจากโหลดวิดีโอเสร็จทั้งหมด
      setState(() {});
    }
  }

  @override
  void dispose() {
    // ล้างคอนโทรลเลอร์ทั้งหมดเมื่อเลิกใช้งาน
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            PageView.builder(
              padEnds: false,
              clipBehavior: Clip.antiAlias,
              itemCount: widget.mediaUrls.length,
              onPageChanged: (int index) {
                setState(() {
                  // หยุดวิดีโอเมื่อเปลี่ยนหน้า
                  for (int i = 0; i < _controllers.length; i++) {
                    if (_controllers[i].value.isPlaying) {
                      _controllers[i].pause();
                    }
                  }
                  // เล่นวิดีโอในหน้าใหม่ถ้าเป็นวิดีโอ
                  if (videoType.contains(widget.mediaUrls[index]
                      .split('.')
                      .last
                      .split('?')
                      .first
                      .toLowerCase())) {
                    _controllers[index].play();
                  }
                  activeIndex = index;
                });
              },
              controller: PageController(initialPage: widget.index),
              itemBuilder: (BuildContext context, int index) {
                final mediaUrl = widget.mediaUrls[index];
                final isVideo = videoType.contains(
                    mediaUrl.split('.').last.split('?').first.toLowerCase());
                if (isVideo && _controllers.isNotEmpty) {
                  final controller = _controllers[index];
                  return Stack(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                controller.play();
                              }
                            });
                          },
                          child: Center(
                              child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ))),
                      if (!controller.value.isPlaying)
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                controller.play();
                              }
                            });
                          },
                          child: Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: Colors.white, width: 0.5),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                }
                return PhotoView(
                  imageProvider: NetworkImage(widget.mediaUrls[index]),
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.black),
                );
              },
            ),
            Positioned(
              top: 60,
              left: 8,
              right: 8,
              // padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // ตรวจสอบว่ามี `_controllers` และ activeIndex ปัจจุบันเป็นวิดีโอหรือไม่
                      if (_controllers.isNotEmpty &&
                          activeIndex < _controllers.length) {
                        final currentController = _controllers[activeIndex];

                        Get.back();

                        // หยุดการเล่นวิดีโอก่อนกลับ
                        currentController.pause();
                      } else {
                        // กรณีไม่ใช่วิดีโอหรือไม่มีคอนโทรลเลอร์
                        Get.back();
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${activeIndex + 1}/${widget.mediaUrls.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
