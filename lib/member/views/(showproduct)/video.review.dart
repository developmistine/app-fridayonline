import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnailList extends StatefulWidget {
  final String videoUrls;
  final List<String> imgUrls;
  final int? aspectRatio;

  const VideoThumbnailList(
      {super.key,
      required this.videoUrls,
      required this.imgUrls,
      this.aspectRatio});

  @override
  _VideoThumbnailListState createState() => _VideoThumbnailListState();
}

class _VideoThumbnailListState extends State<VideoThumbnailList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VideoPlayerController>(
      future: _initializeVideoController(widget.videoUrls),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 200, minWidth: 200),
              child: const Center(child: CircularProgressIndicator.adaptive()));
        } else if (snapshot.hasError) {
          return const SizedBox();
        }

        final controller = snapshot.data!;

        return GestureDetector(
          onTap: () {
            List<String> urls = [widget.videoUrls, ...widget.imgUrls];
            // print('d');
            _playVideo(context, controller, urls);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                  child: widget.aspectRatio != null
                      ? AspectRatio(
                          aspectRatio: 1, child: VideoPlayer(controller))
                      : VideoPlayer(controller)),
              const Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
            ],
          ),
        );
      },
    );
  }

  Future<VideoPlayerController> _initializeVideoController(String url) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    controller.setVolume(0.0);

    await controller.seekTo(Duration.zero);
    return controller;
  }

  void _playVideo(BuildContext context, VideoPlayerController controller,
      List<String> urls) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullscreenVideoPlayer(controller: controller, urls: urls),
      ),
    );
  }
}

class FullscreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final List<String> urls;

  const FullscreenVideoPlayer(
      {super.key, required this.controller, required this.urls});

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.play();
  }

  @override
  void dispose() {
    widget.controller.pause();
    super.dispose();
  }

  int activeIndex = 0;
  bool _isZoomed = false;
  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            padEnds: false,
            clipBehavior: Clip.antiAlias,
            itemCount: widget.urls.length,
            onPageChanged: (int index) {
              // printWhite(widget.urls[index]);
              setState(() {
                activeIndex = index;
              });
            },
            controller: PageController(initialPage: 0),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (widget.controller.value.isPlaying) {
                            widget.controller.pause();
                          } else {
                            widget.controller.play();
                          }
                        });
                      },
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: widget.controller.value.aspectRatio,
                          child: VideoPlayer(widget.controller),
                        ),
                      ),
                    ),
                    if (!widget.controller.value.isPlaying)
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (widget.controller.value.isPlaying) {
                              widget.controller.pause();
                            } else {
                              widget.controller.play();
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
              return GestureDetector(
                onDoubleTapDown: (details) {
                  final tapPosition = details.localPosition;
                  setState(() {
                    if (_isZoomed) {
                      // Reset zoom
                      _transformationController.value = Matrix4.identity();
                      _isZoomed = false;
                    } else {
                      // Zoom in at the tapped position
                      const scale = 1.5; // Zoom level
                      final x = -tapPosition.dx * 0.5;
                      final y = -tapPosition.dy * 0.5;

                      _transformationController.value = Matrix4.identity()
                        ..scale(scale)
                        ..translate(x, y);
                      _isZoomed = true;
                    }
                  });
                },
                child: InteractiveViewer(
                    transformationController: _transformationController,
                    boundaryMargin: const EdgeInsets.all(20.0),
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.network(widget.urls[index])),
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
                    Get.back();
                  },
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${activeIndex + 1}/${widget.urls.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
