import 'dart:convert';

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/review/show_media_review.dart';
import 'package:fridayonline/homepage/review/video_thumbnails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../model/review/review_detials_model.dart';
import '../theme/theme_color.dart';
// import 'review.dart';

class HistoryReview extends StatefulWidget {
  const HistoryReview(this.reviewList, {super.key});
  final ReviewDetails reviewList;

  @override
  State<HistoryReview> createState() => _HistoryReviewState();
}

class _HistoryReviewState extends State<HistoryReview> {
  List<ReviewMedia>? reviewMedia = [];
  List<String> videoType = ["mp4", "mov", "avi", "wmv", "flv", "mkv", "webm"];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        // headerFridayReview(context),
        const SizedBox(
          height: 18,
        ),
        widget.reviewList.reviewHistory.isEmpty
            ? SizedBox(
                height: Get.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/logo/logofriday.png',
                          width: 70),
                    ),
                    const Text('ไม่พบประวัติการรีวิว'),
                  ],
                ),
              )
            : ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.reviewList.reviewHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.find<ProductDetailController>()
                          .productDetailController(
                              widget
                                  .reviewList.reviewHistory[index].orderCampaign
                                  .replaceAll("/", ""),
                              widget.reviewList.reviewHistory[index].billCode,
                              "",
                              "",
                              "27",
                              "");
                      Get.to(
                          () => const ProductDetailPage(
                                ref: 'product',
                                contentId: '',
                              ),
                          arguments: 1);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme_color_df,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        minVerticalPadding: 0,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  171, 171, 171, 1))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.reviewList
                                              .reviewHistory[index].image,
                                          errorWidget: (context, url, error) {
                                            return const Icon(Icons.error);
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 30,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: theme_color_df,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(4))),
                                      child: Text(
                                        '${widget.reviewList.reviewHistory[index].unit}x',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.reviewList.reviewHistory[index]
                                              .billDesc,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'เลขที่ใบกำกับภาษี ${widget.reviewList.reviewHistory[index].invoice}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'รอบการขาย ${widget.reviewList.reviewHistory[index].salesCampaign}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget
                                                  .reviewList
                                                  .reviewHistory[index]
                                                  .reviewDate,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: RatingBarIndicator(
                                                  itemSize: 14,
                                                  rating: widget
                                                      .reviewList
                                                      .reviewHistory[index]
                                                      .productRating
                                                      .toDouble(),
                                                  itemPadding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2.0),
                                                  itemBuilder:
                                                      (context, index) =>
                                                          Image.asset(
                                                    'assets/images/review/fullStar.png',
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                height: 1,
                                indent: 4,
                                thickness: 1,
                              ),
                            ),
                            Text(
                              widget.reviewList.reviewHistory[index].name,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: theme_color_df,
                                  fontWeight: FontWeight.bold),
                            ),
                            widget.reviewList.reviewHistory[index].comment != ""
                                ? Text(
                                    widget.reviewList.reviewHistory[index]
                                        .comment,
                                    style: const TextStyle(fontSize: 14),
                                  )
                                : const Text(
                                    '- ไม่มีเนื้อหา -',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            const SizedBox(
                              height: 12,
                            ),
                            widget.reviewList.reviewHistory[index].imageReview
                                    .isEmpty
                                ? const SizedBox()
                                : SizedBox(
                                    height: 55,
                                    child: ListView.builder(
                                        itemCount: widget
                                            .reviewList
                                            .reviewHistory[index]
                                            .imageReview
                                            .length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder: (context, indexMedia) {
                                          var listMedia = widget.reviewList
                                              .reviewHistory[index].imageReview;
                                          final media = listMedia[indexMedia]
                                              .split('.')
                                              .last;
                                          reviewMedia!.add(ReviewMedia(
                                              mediaType: videoType.contains(
                                                      listMedia[indexMedia]
                                                          .split(".")
                                                          .last)
                                                  ? "2"
                                                  : "1",
                                              url: listMedia[indexMedia],
                                              key: index));
                                          if (indexMedia < 3) {
                                            return videoType.contains(media)
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(() => ShowMediaReview(
                                                          indexMedia,
                                                          listMedia.length,
                                                          reviewMedia!
                                                              .where((element) =>
                                                                  element.key ==
                                                                  index)
                                                              .toList()));
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          width: 55,
                                                          height: 55,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 4),
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                          ),
                                                          child: AspectRatio(
                                                            aspectRatio: 1,
                                                            child:
                                                                VideoThumbnails(
                                                              path: listMedia[
                                                                  indexMedia],
                                                            ),
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .play_arrow_rounded,
                                                          color: Colors.white,
                                                          size: 30,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 4.0),
                                                    child: Container(
                                                      width: 55,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8)),
                                                          border: Border.all(
                                                              color:
                                                                  theme_color_df)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.to(() => ShowMediaReview(
                                                                indexMedia,
                                                                listMedia
                                                                    .length,
                                                                reviewMedia!
                                                                    .where((element) =>
                                                                        element
                                                                            .key ==
                                                                        index)
                                                                    .toList()));
                                                          },
                                                          child: CachedNetworkImage(
                                                              imageUrl: listMedia[
                                                                  indexMedia]),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                          } else if (indexMedia == 3) {
                                            return videoType.contains(media)
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(() => ShowMediaReview(
                                                          indexMedia,
                                                          listMedia.length,
                                                          reviewMedia!
                                                              .where((element) =>
                                                                  element.key ==
                                                                  index)
                                                              .toList()));
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        ColorFiltered(
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  Colors.grey
                                                                      .shade400,
                                                                  BlendMode
                                                                      .modulate),
                                                          child: Container(
                                                            width: 55,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 4),
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              8)),
                                                            ),
                                                            child: AspectRatio(
                                                              aspectRatio: 1,
                                                              child:
                                                                  VideoThumbnails(
                                                                path: listMedia[
                                                                    indexMedia],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              '+ ${listMedia.length - indexMedia}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 24),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Get.to(() => ShowMediaReview(
                                                          indexMedia,
                                                          listMedia.length,
                                                          reviewMedia!
                                                              .where((element) =>
                                                                  element.key ==
                                                                  index)
                                                              .toList()));
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        ColorFiltered(
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  Colors.grey
                                                                      .shade400,
                                                                  BlendMode
                                                                      .modulate),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 4.0),
                                                            child: Container(
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              width: 55,
                                                              height: 55,
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8))),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Get.to(() => ShowMediaReview(
                                                                      indexMedia,
                                                                      listMedia
                                                                          .length,
                                                                      reviewMedia!
                                                                          .where((element) =>
                                                                              element.key ==
                                                                              index)
                                                                          .toList()));
                                                                },
                                                                child:
                                                                    CachedNetworkImage(
                                                                        errorWidget: (context,
                                                                            url,
                                                                            error) {
                                                                          return const Icon(
                                                                              Icons.error);
                                                                        },
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        imageUrl:
                                                                            listMedia[indexMedia]),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              '+ ${listMedia.length - indexMedia}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 24),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                          } else {
                                            return const SizedBox();
                                          }
                                        }),
                                  ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'คุณภาพ ${widget.reviewList.reviewHistory[index].productRating}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: theme_color_df,
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      itemCount: 1,
                                      itemSize: 12,
                                      rating: 1,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      itemBuilder: (context, index) =>
                                          Image.asset(
                                        'assets/images/review/fullStar.png',
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'ขนส่ง ${widget.reviewList.reviewHistory[index].deliveryRating}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: theme_color_df,
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      itemCount: 1,
                                      itemSize: 12,
                                      rating: 1,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      itemBuilder: (context, index) =>
                                          Image.asset(
                                        'assets/images/review/fullStar.png',
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            widget.reviewList.reviewHistory[index]
                                        .replyToFeedback.comment !=
                                    ""
                                ? Container(
                                    width: double.infinity,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    color: const Color(0xFFC2E2F7),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.reviewList.reviewHistory[index].replyToFeedback.name} ",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Text(
                                              "${widget.reviewList.reviewHistory[index].replyToFeedback.comment} ",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 12,
                ),
              )
      ],
    ));
  }
}

List<ReviewMedia> reviewMediaFromJson(String str) => List<ReviewMedia>.from(
    json.decode(str).map((x) => ReviewMedia.fromJson(x)));

String reviewMediaToJson(List<ReviewMedia> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewMedia {
  String mediaType;
  String url;
  int key;
  ReviewMedia({
    required this.mediaType,
    required this.url,
    required this.key,
  });

  factory ReviewMedia.fromJson(Map<String, dynamic> json) => ReviewMedia(
        mediaType: json["mediaType"],
        url: json["url"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "mediaType": mediaType,
        "url": url,
        "key": key,
      };
}
