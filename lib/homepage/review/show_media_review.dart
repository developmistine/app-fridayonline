import 'package:fridayonline/homepage/review/videoplay_fullscreen.dart';
import 'package:fridayonline/homepage/review/video_thumbnails.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:photo_view/photo_view.dart';

class ShowMediaReview extends StatefulWidget {
  final int index;
  final int length;
  final List<dynamic> mediaList;
  const ShowMediaReview(this.index, this.length, this.mediaList, {super.key});

  @override
  State<ShowMediaReview> createState() => _ShowMediaReviewState();
}

class _ShowMediaReviewState extends State<ShowMediaReview> {
  PageController controller = PageController();
  int _activePage = 0;

  @override
  void initState() {
    super.initState();

    controller = PageController(initialPage: widget.index);
    _activePage = widget.index;
    setSystemUIOverlayStyle();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  PhotoViewScaleStateController zoomControl = PhotoViewScaleStateController();
  @override
  Widget build(BuildContext context) {
    setSystemUIOverlayStyle();
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          PageView.builder(
              controller: controller,
              itemCount: widget.length,
              clipBehavior: Clip.antiAlias,
              onPageChanged: (int page) {
                setState(() {
                  _activePage = page;
                });
              },
              itemBuilder: ((context, index) {
                return widget.mediaList[index].mediaType == "1"
                    ? PhotoView(
                        scaleStateController: zoomControl,
                        backgroundDecoration:
                            const BoxDecoration(color: Colors.transparent),
                        imageProvider: CachedNetworkImageProvider(
                            widget.mediaList[index].url),
                        initialScale: PhotoViewComputedScale.contained,
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.contained * 3)
                    : VideoPlayFulllScreenWidget(
                        path: widget.mediaList[index].url);
                // : FutureBuilder(
                //     future: _initializeVideoPlayerFuture(
                //         widget.mediaList[index].url),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState ==
                //           ConnectionState.done) {
                //         final chewieController = ChewieController(
                //           allowFullScreen: false,
                //           showControls: true,
                //           videoPlayerController: _controller[index],
                //           autoPlay: false,
                //           looping: false,
                //         );
                //         if (_controller.isEmpty) {
                //           chewieController.dispose();
                //         }

                //         return Container(
                //           color: Colors.transparent,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               AspectRatio(
                //                   aspectRatio:
                //                       _controller[index].value.aspectRatio,
                //                   child: Chewie(
                //                     controller: chewieController,
                //                   ))
                //             ],
                //           ),
                //         );
                //       } else {
                //         return Center(
                //           child: theme_loading_df,
                //         );
                //       }
                //     });
              })),
          // if (1 > 1)
          Positioned(
            bottom: 0,
            left: 15,
            right: 10,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 60,
              alignment: Alignment.center,
              color: Colors.transparent,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    children: List<Widget>.generate(
                        widget.mediaList.length,
                        (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () {
                                  controller.animateToPage(index,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                },
                                child: ColorFiltered(
                                  colorFilter: _activePage != index
                                      ? const ColorFilter.mode(
                                          Colors.grey, BlendMode.modulate)
                                      : const ColorFilter.mode(
                                          Colors.transparent,
                                          BlendMode.saturation),
                                  child: Container(
                                    width: 50,
                                    height: _activePage != index ? 50 : 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        border:
                                            Border.all(color: theme_color_df)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: widget.mediaList[index]
                                                    .mediaType ==
                                                "1"
                                            ? CachedNetworkImage(
                                                fit: BoxFit.contain,
                                                imageUrl:
                                                    widget.mediaList[index].url)
                                            : VideoThumbnails(
                                                path:
                                                    widget.mediaList[index].url,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 23,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: theme_color_df,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8))),
                      child: Text(
                        "${_activePage + 1}",
                        style: const TextStyle(
                          fontFamily: 'notoreg',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: 23,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Color(0xFFA4D6F1),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8))),
                      child: Text(
                        "${widget.length}",
                        style: const TextStyle(
                          fontFamily: 'notoreg',
                          fontWeight: FontWeight.bold,
                          // inherit: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 28,
              left: 20,
              height: 60,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () => Get.back(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
