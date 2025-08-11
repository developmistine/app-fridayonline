import 'package:fridayonline/enduser/views/(showproduct)/video.review.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

var videoUrls = [
  'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  'https://www.w3schools.com/html/mov_bbb.mp4',
  'https://s3.catalog-yupin.com/review/24/56732/63311/2/1000019064.mp4'
];

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  _VideoPageViewScreenState createState() => _VideoPageViewScreenState();
}

class _VideoPageViewScreenState extends State<LivePage> {
  final PageController _pageController = PageController();
  final List<VideoPlayerController> _videoControllers = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
    _pageController.addListener(_onPageChanged);
  }

  void _initializeVideoControllers() {
    for (var url in videoUrls) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          setState(() {});
        });
      _videoControllers.add(controller);
    }
    // เริ่มเล่นวิดีโอแรก
    if (_videoControllers.isNotEmpty) {
      _videoControllers[_currentIndex].play();
    }
  }

  void _onPageChanged() {
    int newIndex = _pageController.page?.round() ?? 0;

    if (newIndex != _currentIndex) {
      _videoControllers[_currentIndex].pause(); // หยุดวิดีโอเก่า
      _currentIndex = newIndex;
      _videoControllers[_currentIndex].play(); // เล่นวิดีโอใหม่
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: VideoThumbnailList(
        videoUrls: videoUrls[0],
        imgUrls: const [],
      ),
      // body: PageView.builder(
      //   scrollDirection: Axis.vertical,
      //   controller: _pageController,
      //   itemCount: videoUrls.length,
      //   itemBuilder: (context, index) {
      //     return Center(
      //       child: _videoControllers[index].value.isInitialized
      //           ? AspectRatio(
      //               aspectRatio: _videoControllers[index].value.aspectRatio,
      //               child: VideoPlayer(_videoControllers[index]),
      //             )
      //           : const CircularProgressIndicator.adaptive(),
      //     );
      //   },
      // ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
