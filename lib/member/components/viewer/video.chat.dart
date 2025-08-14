import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoMessageWidget extends StatefulWidget {
  final String videoUrl;

  const VideoMessageWidget({super.key, required this.videoUrl});

  @override
  State<VideoMessageWidget> createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  static final Map<String, VideoPlayerController> _controllerCache = {};

  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    if (_controllerCache.containsKey(widget.videoUrl)) {
      _controller = _controllerCache[widget.videoUrl]!;
      _initializeVideoPlayerFuture = Future.value();
    } else {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        _controllerCache[widget.videoUrl] = _controller;
      });
    }
  }

  @override
  void dispose() {
    // ไม่ dispose controller ที่แคชไว้ เพื่อให้เล่นซ้ำได้ แต่ถ้าต้องการเคลียร์จริง ๆ
    // _controller.dispose();
    _controllerCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: GestureDetector(
              onTap: () async {
                await Get.to(() => FullscreenVideoPlayer(
                      controller: _controller,
                      tag: widget.videoUrl,
                    ));
                setState(() {});
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Hero(
                              tag: widget.videoUrl,
                              child: VideoPlayer(_controller)))),
                  if (!_controller.value.isPlaying)
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 52,
                    )
                ],
              ),
            ),
          );
        } else {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
      },
    );
  }
}

// Fullscreen Video Page
class FullscreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String tag;

  const FullscreenVideoPlayer(
      {super.key, required this.controller, required this.tag});

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  late VideoPlayerController _controller;

  double verticalDragStartY = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    // เล่นวิดีโอทันทีถ้ายังไม่เล่น
    if (!_controller.value.isPlaying) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    // ไม่ dispose controller เพราะแชร์กับหน้าอื่น
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    // details.delta.dy > 0 คือเลื่อนลง
    if (details.delta.dy > 10) {
      Get.back(result: _controller.value.isPlaying);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onTap: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Hero(
          tag: widget.tag,
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ),
    );
  }
}
