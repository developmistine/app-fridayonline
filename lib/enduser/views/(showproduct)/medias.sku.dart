import 'package:appfridayecommerce/enduser/controller/showproduct.sku.ctr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

final ShowProductSkuCtr showProductCtr = Get.find();

class EndUserProductMedias extends StatefulWidget {
  const EndUserProductMedias(
      {super.key, required this.mediaUrls, required this.index});
  final List<String> mediaUrls;
  final int index;

  @override
  State<EndUserProductMedias> createState() => _ProductMediasState();
}

class _ProductMediasState extends State<EndUserProductMedias> {
  int activeIndex = 0;
  VideoPlayerController? _controller;

  List<String> videoType = ["mp4", "mov", "avi", "wmv", "flv", "mkv", "webm"];

  @override
  void initState() {
    super.initState();
    activeIndex = widget.index;
    initVideo();
  }

  initVideo() async {
    if (videoType.contains(
        widget.mediaUrls[0].split('.').last.split('?').first.toLowerCase())) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrls[0]))
            ..initialize().then((_) => {
                  if (widget.index == 0) _controller!.play(),
                  setState(
                    () {},
                  )
                });
    }
  }

  @override
  void dispose() {
    if (_controller != null && !_controller!.value.isInitialized) {
      _controller!.dispose();
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
                  if (_controller != null) {
                    index == 0 ? _controller!.play() : _controller!.pause();
                  }
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
                  return Stack(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              if (_controller!.value.isPlaying) {
                                _controller!.pause();
                              } else {
                                _controller!.play();
                              }
                            });
                          },
                          child: Center(
                            child: AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!)),
                          )),
                      if (!_controller!.value.isPlaying)
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (_controller!.value.isPlaying) {
                                _controller!.pause();
                              } else {
                                _controller!.play();
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
                      showProductCtr.activeSlide.value = activeIndex;
                      if (_controller != null) {
                        Get.back(result: {
                          "postion": _controller!.value.position,
                          "isPlaying": _controller!.value.isPlaying,
                        });
                        _controller!.pause();
                      } else {
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
