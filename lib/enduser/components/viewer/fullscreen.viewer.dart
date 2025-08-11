import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class FullScreenViewer extends StatefulWidget {
  final List<String> imageUrls;
  final String? videoUrl; // วิดีโออาจไม่มี
  final int initialIndex; // เริ่มแสดงรูปที่ถูกกด

  const FullScreenViewer({
    super.key,
    required this.imageUrls,
    this.videoUrl,
    this.initialIndex = 0,
  });

  @override
  _FullScreenViewerState createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<FullScreenViewer> {
  late PageController _pageController;
  VideoPlayerController? _videoController;
  bool isVideo = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);

    if (widget.videoUrl != null) {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
            ..initialize().then((_) {
              _videoController!.play();
              setState(() {});
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [];

    if (widget.videoUrl != null) {
      pages.add(_buildVideoPlayer());
    }

    pages.addAll(widget.imageUrls.map((url) => _buildImageView(url)).toList());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: pages,
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Center(
      child: _videoController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : const CircularProgressIndicator(),
    );
  }

  Widget _buildImageView(String imageUrl) {
    return PhotoView(
      imageProvider: NetworkImage(imageUrl),
      backgroundDecoration: const BoxDecoration(color: Colors.black),
    );
  }
}
