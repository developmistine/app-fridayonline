import 'package:appfridayecommerce/enduser/components/viewer/video.fullscreen.dart';
import 'package:flutter/material.dart';

class ProductMedias extends StatefulWidget {
  const ProductMedias(
      {super.key, required this.mediaUrls, required this.index});
  final List<String> mediaUrls;
  final int index;

  @override
  State<ProductMedias> createState() => _ProductMediasState();
}

class _ProductMediasState extends State<ProductMedias> {
  int activeIndex = 0;
  final TransformationController _transformationController =
      TransformationController();

  bool _isZoomed = false;
  List<String> videoType = ["mp4", "mov", "avi", "wmv", "flv", "mkv", "webm"];

  @override
  void initState() {
    super.initState();
    activeIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          PageView.builder(
            clipBehavior: Clip.antiAlias,
            itemCount: widget.mediaUrls.length,
            onPageChanged: (int index) {
              setState(() {
                activeIndex = index;
              });
            },
            controller: PageController(initialPage: widget.index),
            itemBuilder: (BuildContext context, int index) {
              if (videoType.contains(widget.mediaUrls[index]
                  .split('.')
                  .last
                  .split('?')
                  .first
                  .toLowerCase())) {
                return VideoPlayFulllScreenWidget(
                  path: widget.mediaUrls[index],
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
                    child: Image.network(widget.mediaUrls[index])),
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
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
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
                    '${activeIndex + 1}/${widget.mediaUrls.length}',
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
