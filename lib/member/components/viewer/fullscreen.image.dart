import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<dynamic> imageUrls;
  final int initialIndex;
  final int? imgType;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
    this.imgType,
  });

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                if (widget.imgType == 0) {
                  return PhotoView(
                      imageProvider:
                          MemoryImage(widget.imageUrls[index] as Uint8List),
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.black));
                } else {
                  return PhotoView(
                      imageProvider: NetworkImage(
                        widget.imageUrls[index],
                      ),
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.black));
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${currentIndex + 1} / ${widget.imageUrls.length}",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
