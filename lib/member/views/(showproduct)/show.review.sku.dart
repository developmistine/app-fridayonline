import 'package:fridayonline/member/components/appbar/appbar.nosearch.dart';
import 'package:fridayonline/member/controller/review.ctr.dart';
import 'package:fridayonline/member/views/(showproduct)/medias.review.dart';
import 'package:fridayonline/member/views/(showproduct)/video.review.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final ReviewEndUserCtr reviewCtr = Get.find();

class ShowReviewProductSku extends StatefulWidget {
  const ShowReviewProductSku({
    super.key,
  });

  @override
  State<ShowReviewProductSku> createState() => _ShowReviewProductSkuState();
}

class _ShowReviewProductSkuState extends State<ShowReviewProductSku>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  int offset = 10;
  // int type = 0;

  @override
  void initState() {
    super.initState();
    // ตรวจสอบการเลื่อนถึงท้ายรายการ
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !reviewCtr.isLoadingMore.value) {
        fetchMoreReviews();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    offset = 10;
    reviewCtr.selectStar.value = 0;
    reviewCtr.isAll.value = true;
    reviewCtr.resetReview();
    _scrollController.dispose();
  }

  void fetchMoreReviews() async {
    reviewCtr.isLoadingMore.value = true;
    bool isZero = reviewCtr.selectStar.value == 0;
    try {
      final newReviews = await reviewCtr.fetchMoreEndUserReivew(
          reviewCtr.proId.value,
          isZero ? reviewCtr.selectStar.value : 6 - reviewCtr.selectStar.value,
          10,
          offset);

      if (newReviews!.data.ratings.isNotEmpty) {
        reviewCtr.reviews!.data.ratings.addAll(newReviews.data.ratings);
        offset += 10;
      }
    } finally {
      reviewCtr.isLoadingMore.value = false; // จบการโหลดข้อมูล
    }
  }

  List<String> mediaUrls = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: appbarEnduser(
      //   ctx: context,
      //   isSetAppbar: true ,
      // ),
      appBar: appBarNoSearchEndUser('คะแนน'),
      body: Obx(() {
        if (!reviewCtr.isLoadingReview.value) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: Theme(
                data: Theme.of(context).copyWith(
                    textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
                      Theme.of(context).textTheme,
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                        style: OutlinedButton.styleFrom(
                            textStyle: GoogleFonts.notoSansThaiLooped()))),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                        // physics: const ClampingScrollPhysics(),
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        child: Column(
                          children: [
                            filterMethods(context),
                            const Divider(
                              height: 0,
                            ),
                            if (reviewCtr.reviews!.code == '-9')
                              SizedBox(
                                height: Get.height / 1.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/search/zero_search.png',
                                      width: 150,
                                    ),
                                    Text(
                                      'ไม่พบข้อมูลรีวิว',
                                      style: GoogleFonts.notoSansThaiLooped(),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: EdgeInsets.zero,
                                  itemCount: reviewCtr
                                          .reviews!.data.ratings.length +
                                      (reviewCtr.isLoadingMore.value ? 1 : 0),
                                  // reviewCtr.reviews!.data.ratings.length,
                                  itemBuilder: (context, index) {
                                    // ตรวจสอบว่ามีข้อมูลทั้งหมดกี่รายการก่อนแสดง
                                    if (index ==
                                            reviewCtr
                                                .reviews!.data.ratings.length &&
                                        reviewCtr.isLoadingMore.value) {
                                      // แสดง loader เมื่อมีการโหลดข้อมูลเพิ่มเติม
                                      return const SizedBox.shrink();
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 23,
                                                      height: 23,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors
                                                            .grey.shade300,
                                                        child: const Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      reviewCtr
                                                          .reviews!
                                                          .data
                                                          .ratings[index]
                                                          .custName,
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                RatingBarIndicator(
                                                  itemSize: 12,
                                                  rating: reviewCtr
                                                      .reviews!
                                                      .data
                                                      .ratings[index]
                                                      .ratingStar,
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
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
                                                if (reviewCtr
                                                        .reviews!
                                                        .data
                                                        .ratings[index]
                                                        .comment !=
                                                    "")
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: Text(
                                                      reviewCtr
                                                          .reviews!
                                                          .data
                                                          .ratings[index]
                                                          .comment,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                mediaReview(indexMedia: index),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      reviewCtr
                                                          .reviews!
                                                          .data
                                                          .ratings[index]
                                                          .creDate,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade700,
                                                          fontSize: 12)),
                                                ),
                                                if (reviewCtr
                                                        .reviews!
                                                        .data
                                                        .ratings[index]
                                                        .ratingReply
                                                        .comment !=
                                                    "")
                                                  Container(
                                                    color: Colors.grey.shade100,
                                                    width: Get.width,
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Wrap(
                                                      children: [
                                                        Text.rich(
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          TextSpan(
                                                            text:
                                                                'การตอบกลับ : ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            children: [
                                                              TextSpan(
                                                                text: reviewCtr
                                                                    .reviews!
                                                                    .data
                                                                    .ratings[
                                                                        index]
                                                                    .ratingReply
                                                                    .comment,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ]),
                                        ),
                                        const Divider(
                                          height: 0,
                                        ),
                                      ],
                                    );
                                  })
                          ],
                        )),
                  ],
                ),
              ));
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      }),
      // bottomNavigationBar:
    );
  }

  Container filterMethods(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(() {
            return Row(children: [
              reviewCtr.isAll.value
                  ? outlineActive(
                      title: 'ทั้งหมด',
                      count: reviewCtr.allReview.value.toString())
                  : outlineNotActive(
                      title: 'ทั้งหมด',
                      count: reviewCtr.allReview.value.toString()),
              outlineDropdown(
                  title: Row(
                    children: [
                      const Text('ดาว',
                          style: TextStyle(fontSize: 12, color: Colors.black)),
                      const Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber,
                        size: 18,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: Colors.grey.shade700,
                      )
                    ],
                  ),
                  count: 'ทั้งหมด',
                  context: context),
            ]);
          })),
    );
  }

  outlineActive({required String title, required String count}) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 100),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: themeColorDefault,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: themeColorDefault),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
              onPressed: () {
                if (reviewCtr.isAll.value) {
                  return;
                }
                reviewCtr.isAll.value = true;
              },
              child: Center(
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '($count)',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ))),
    );
  }

  outlineNotActive({required String title, required String count}) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade200),
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
            onPressed: () {
              reviewCtr.isAll.value = true;
              reviewCtr.fetchEndUserReivew(reviewCtr.proId.value, 0, 10, 0);
              reviewCtr.selectStar.value = 0;
            },
            child: Center(
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  Text(
                    '($count)',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  outlineDropdown(
      {required Widget title,
      required String count,
      required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100),
        child: Obx(() {
          return OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: reviewCtr.isAll.value
                          ? Colors.grey.shade200
                          : themeColorDefault),
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
              onPressed: () {
                sortRating(context);
              },
              child: Center(
                child: Column(
                  children: [
                    title,
                    Text(
                      count,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
  }

  sortRating(BuildContext context) {
    Get.bottomSheet(
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.white,
        Theme(
          data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: SafeArea(
              child: Container(
            color: Colors.white,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.zero,
                      itemCount: reviewCtr
                          .reviews!.data.itemSummary.ratingCount.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                // setState(() {
                                // type = 5 - index;
                                // });

                                reviewCtr.selectStar.value = index + 1;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 12),
                                child: Obx(() {
                                  return Row(
                                    children: [
                                      reviewCtr.selectStar.value == index + 1
                                          ? Icon(
                                              Icons
                                                  .radio_button_checked_rounded,
                                              color: themeColorDefault,
                                            )
                                          : Icon(
                                              Icons.circle_outlined,
                                              color: Colors.grey.shade500,
                                            ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      RatingBarIndicator(
                                        itemSize: 14,
                                        rating: 5,
                                        direction: Axis.horizontal,
                                        itemCount: 5 - index,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        itemBuilder: (context, index) =>
                                            Image.asset(
                                          'assets/images/review/fullStar.png',
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "${reviewCtr.reviews!.data.itemSummary.ratingCount.reversed.toList()[index]}",
                                        style: TextStyle(
                                            height: 2,
                                            color: Colors.grey.shade700,
                                            fontSize: 12),
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ),
                            const Divider(
                              height: 0,
                            )
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  reviewCtr.selectStar.value = 0;
                                  if (reviewCtr.isAll.value) {
                                    Get.back();
                                    return;
                                  }
                                  reviewCtr.isAll.value = true;
                                  reviewCtr.fetchEndUserReivew(
                                      reviewCtr.proId.value, 0, 10, 0);
                                  Get.back();
                                },
                                style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(0, 40),
                                    backgroundColor: Colors.white,
                                    foregroundColor: themeColorDefault,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    side: BorderSide(color: themeColorDefault)),
                                child: Text(
                                  'ดูทั้งหมด',
                                  style: GoogleFonts.notoSansThaiLooped(
                                      color: themeColorDefault),
                                )),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (reviewCtr.selectStar.value == 0) {
                                    Get.back();
                                    return;
                                  }
                                  reviewCtr.isAll.value = false;
                                  reviewCtr.fetchEndUserReivew(
                                      reviewCtr.proId.value,
                                      6 - reviewCtr.selectStar.value,
                                      10,
                                      0);
                                  Get.back(
                                    result: 6 - reviewCtr.selectStar.value,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 40),
                                    elevation: 0,
                                    backgroundColor: themeColorDefault,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    side: BorderSide(color: themeColorDefault)),
                                child: Text(
                                  'ตกลง',
                                  style: GoogleFonts.notoSansThaiLooped(),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
        ));
  }

  tile({
    required String imagePath,
    required List<String> images,
    required List<String> urls,
    required int index,
  }) {
    List<String> videoType = ["mp4", "mov", "avi", "wmv", "flv", "mkv", "webm"];
    final ext = imagePath.split('.').last.split('?').first.toLowerCase();

    if (videoType.contains(ext)) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black87, Colors.grey.shade700])),
        child: VideoThumbnailList(
          videoUrls: imagePath,
          imgUrls: images,
          aspectRatio: 1,
        ),
      );
    }
    if (mediaUrls.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black87, Colors.grey.shade700])),
        child: InkWell(
          onTap: () {
            Get.to(() => EndUserMediaReviews(
                  mediaUrls: urls,
                  index: index,
                ));
            // Get.to(() => ProductMedias(mediaUrls: [imagePath], index: 0));
          },
          child: CachedNetworkImage(
            imageUrl: imagePath,
            errorWidget: (context, url, error) {
              return const Icon(Icons.image_not_supported_rounded);
            },
          ),
        ),
      );
    }
  }

  Widget mediaReview({required int indexMedia}) {
    mediaUrls = [
      ...reviewCtr.reviews!.data.ratings[indexMedia].video,
      ...reviewCtr.reviews!.data.ratings[indexMedia].images
    ];
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: List.generate(mediaUrls.length, (index) {
        // กำหนด layout ตามจำนวนรายการ
        if (mediaUrls.length == 1) {
          // Layout สำหรับ 1 รูป
          return StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: tile(
                imagePath: mediaUrls[index],
                images: reviewCtr.reviews!.data.ratings[indexMedia].images,
                urls: mediaUrls,
                index: index),
          );
        } else if (mediaUrls.length == 2) {
          // Layout สำหรับ 2 รูป
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: tile(
                imagePath: mediaUrls[index],
                images: reviewCtr.reviews!.data.ratings[indexMedia].images,
                urls: mediaUrls,
                index: index),
          );
        } else if (mediaUrls.length == 3) {
          // Layout สำหรับ 3 รูป
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: index == 0 ? 2 : 1,
            child: tile(
                imagePath: mediaUrls[index],
                images: reviewCtr.reviews!.data.ratings[indexMedia].images,
                urls: mediaUrls,
                index: index),
          );
        } else {
          if (index <= 3) {
            // Layout สำหรับมากกว่า 4 รูปขึ้นไป
            return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  tile(
                      imagePath: mediaUrls[index],
                      images:
                          reviewCtr.reviews!.data.ratings[indexMedia].images,
                      urls: mediaUrls,
                      index: index),
                  if (index == 3 && mediaUrls.length > 4)
                    Positioned(
                      bottom: 4,
                      right: 12,
                      child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                              Text(
                                '+${mediaUrls.length - 4}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ],
                          )),
                    )
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        }
      }),
    );
  }
}
