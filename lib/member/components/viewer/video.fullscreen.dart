import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayFulllScreenWidget extends StatefulWidget {
  const VideoPlayFulllScreenWidget({super.key, required this.path});
  final String path;

  @override
  State<VideoPlayFulllScreenWidget> createState() => _VideoPlayWidgetState();
}

class _VideoPlayWidgetState extends State<VideoPlayFulllScreenWidget> {
  VideoPlayerController? controller;
  late Future<void> futureController;
  ChewieController? chewieCtr;
  initVideo() {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.path));

    futureController = controller!.initialize().then((_) => setState(() {}));
  }

  @override
  void initState() {
    initVideo();
    controller!.addListener(() {
      if (controller!.value.isInitialized) {
        // printWhite("controller!.value.isInitialized");
        chewieCtr ??= ChewieController(
          showOptions: false,
          showControls: true,
          videoPlayerController: controller!,
          autoPlay: false,
          looping: false,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureController,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ));
          } else {
            return Stack(
              alignment: Alignment.center,
              children: [
                controller!.value.isInitialized
                    ? Container(
                        height: Get.height * 0.75,
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: controller!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: controller!.value.aspectRatio,
                                child: Chewie(
                                  controller: chewieCtr!,
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                      )
                    : const Center(
                        child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      ))
              ],
            );
          }
        });
  }
}
