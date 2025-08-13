import 'package:fridayonline/enduser/components/viewer/fullscreen.image.dart';
import 'package:fridayonline/enduser/components/viewer/product.media.dart';
import 'package:fridayonline/enduser/controller/review.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

Widget myRatingCard() {
  final MyReviewCtr reviewedCtr = Get.find<MyReviewCtr>();

  return Obx(() {
    if (reviewedCtr.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    if (reviewedCtr.reviewed!.code == "-9") {
      return const Center(child: Text('ไม่พบข้อมูล'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: reviewedCtr.reviewed!.data.length,
      itemBuilder: (context, index) {
        var data = reviewedCtr.reviewed!.data[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadowColor: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            data.custImage,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.custName,
                              style: const TextStyle(fontSize: 14),
                            ),
                            RatingBar(
                              ignoreGestures: true,
                              glow: false,
                              itemSize: 10,
                              initialRating: data.detailRating.productQuality,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.only(right: 4),
                              ratingWidget: RatingWidget(
                                full: Image.asset(
                                    'assets/images/review/new-fullstar.png'),
                                half: Image.asset(
                                    'assets/images/review/new-halfstar.png'),
                                empty: Image.asset(
                                    'assets/images/review/new-empstar.png'),
                              ),
                              onRatingUpdate: (double value) {
                                return;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.comment,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      if (data.video.isNotEmpty || data.images.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                if (data.video.isNotEmpty)
                                  for (var video in data.video)
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SmallVideoPlayer(videoUrl: video),
                                        InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => FullScreenVideoPlayer(
                                                videoUrl: video,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: const Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: data.images.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => FullScreenImageViewer(
                                              imageUrls: data.images,
                                              initialIndex: index,
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: data.images[index],
                                          errorWidget: (context, url, error) {
                                            return Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.grey.shade100),
                                              child: const Icon(
                                                  Icons.image_not_supported),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      Text(
                        data.creDate,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      if (data.ratingReply.comment != "")
                        Container(
                          width: Get.width,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: themeColorDefault.withOpacity(0.1),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "การตอบกลับจากผู้ขาย:",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                data.ratingReply.comment,
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: data.items.length,
                        itemBuilder: (context, indexItem) {
                          return InkWell(
                            onTap: () {
                              Get.find<ShowProductSkuCtr>()
                                  .fetchB2cProductDetail(
                                      data.productId, 'profile_review');
                              Get.toNamed(
                                '/ShowProductSku/${data.productId}',
                              );
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey.shade100),
                              child: Row(children: [
                                Expanded(
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            data.items[indexItem].itemImg)),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    data.productName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                )
                              ]),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  });
}

Widget showUpload(BuildContext context, List<String> mediaUrls) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: mediaUrls.asMap().entries.map((entry) {
      int index = entry.key; // index ของรายการ
      String url = entry.value; // URL ของภาพในรายการ

      return InkWell(
        onTap: () {
          Get.to(() {
            return ProductMedias(mediaUrls: mediaUrls, index: index);
          });
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }).toList(),
  );
}

class SmallVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const SmallVideoPlayer({super.key, required this.videoUrl});

  @override
  _SmallVideoPlayerState createState() => _SmallVideoPlayerState();
}

class _SmallVideoPlayerState extends State<SmallVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _videoController.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _videoController,
        // aspectRatio: 16 / 9,
        autoPlay: false,
        looping: false,
        showControls: false);
    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return Container(
          color: Colors.grey.shade100,
          width: 100,
          child: const Center(child: CircularProgressIndicator.adaptive()));
    }

    return GestureDetector(
      onTap: () {
        Get.to(
          () => FullScreenVideoPlayer(videoUrl: widget.videoUrl),
        );
      },
      child: Container(
        // height: 100,
        width: 100,
        // width: double.infinity,
        color: Colors.grey.shade200,
        // margin: const EdgeInsets.symmetric(vertical: 10),
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPlayer({super.key, required this.videoUrl});

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _videoController.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _videoController,
        // aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        showControls: false);
    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.close)),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: InkWell(
            onTap: () {
              if (_chewieController != null) {
                if (_chewieController!.isPlaying) {
                  _chewieController!.pause();
                } else {
                  _chewieController!.play();
                }
                setState(() {});
              }
            },
            child: Chewie(controller: _chewieController!)),
      ),
    );
  }
}
