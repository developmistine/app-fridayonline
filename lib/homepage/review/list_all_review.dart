import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/controller/reviews/revies_ctr.dart';
import 'package:fridayonline/homepage/dialogalert/modal_shopping.dart';
import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/review/history_review.dart';
import 'package:fridayonline/homepage/review/show_media_review.dart';
import 'package:fridayonline/homepage/review/video_thumbnails.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/review/review_product_model.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/service/languages/multi_languages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../theme/theme_color.dart';

class ListReview extends StatefulWidget {
  const ListReview(
      {super.key,
      required this.allReview,
      required this.ref,
      required this.contentId});
  final ReviewsProduct allReview;
  final String ref;
  final String contentId;

  @override
  State<ListReview> createState() => _ListReviewState();
}

class _ListReviewState extends State<ListReview> {
  double paddingReview = 12.0;
  double paddingReviewLeft = 8.0;
  PageController controller = PageController();
  int _activePage = 0;

  Color bgBlue = const Color.fromRGBO(195, 227, 248, 1);
  Color bgStar = const Color.fromRGBO(164, 214, 241, 1);
  var subtitleText = TextStyle(fontSize: 12, color: theme_color_df);

  List<String> btnList = ['ทั้งหมด', '5', '4', '3', '2 / 1'];
  @override
  void dispose() {
    controller.dispose();
    Get.find<ReviewsCtr>().disposePagination();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sized = MediaQuery.of(context).size;

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SafeAreaProvider(
        child: Scaffold(
          appBar: appBarTitleMaster("รีวิว"),
          backgroundColor: Colors.white,
          body: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            controller: controller,
            onPageChanged: ((value) {
              setState(() {
                _activePage = value;
              });
            }),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                if (widget.allReview.allRating.productReview.isEmpty) {
                  return noReview();
                }
                return allReview(sized,
                    listReview: widget.allReview.allRating.productReview);
              } else if (index == 1) {
                if (widget.allReview.fiveRating.productReview.isEmpty) {
                  return noReview();
                }
                return allReview(sized,
                    listReview: widget.allReview.fiveRating.productReview);
              } else if (index == 2) {
                if (widget.allReview.fourRating.productReview.isEmpty) {
                  return noReview();
                }
                return allReview(sized,
                    listReview: widget.allReview.fourRating.productReview);
              } else if (index == 3) {
                if (widget.allReview.threeRating.productReview.isEmpty) {
                  return noReview();
                }
                return allReview(sized,
                    listReview: widget.allReview.threeRating.productReview);
              } else {
                if (widget.allReview.twoRating.productReview.isEmpty &&
                    widget.allReview.oneRating.productReview.isEmpty) {
                  return noReview();
                }
                return allReview(sized,
                    listReview: widget.allReview.twoRating.productReview +
                        widget.allReview.oneRating.productReview);
              }
            },
          ),
          bottomNavigationBar: GetX<ProductDetailController>(builder: (detail) {
            return detail.isDataLoading.value
                ? Container(
                    width: Get.width,
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 18),
                  )
                : detail.productDetail!.billCode == ""
                    ? const SizedBox()
                    : Container(
                        height: 60,
                        color: theme_color_df,
                        child: InkWell(
                          onTap: () async {
                            // call เพื่อนำรูปและรายละเอียดมาโชว์
                            SetData userData = SetData();
                            String? lslogin;
                            lslogin = await userData.loginStatus;
                            if (lslogin == '1') {
                              Get.find<ProductDetailController>().countItems =
                                  1.obs;
                              // เรียกใช้งาน modal ตระกร้า
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                modalAddtoCart(
                                    context,
                                    detail.productDetail!,
                                    detail.listChannel,
                                    detail.listChannelId,
                                    widget.ref,
                                    widget.contentId);
                              });
                            } else {
                              Get.to(
                                  transition: Transition.rightToLeft,
                                  () => const Anonumouslogin());
                            }
                          },
                          child: Center(
                              child: Text(
                            MultiLanguages.of(context)!
                                .translate('btn_add_to_cart'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'notoreg',
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      );
          }),
        ),
      ),
    );
  }

  noReview() {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade100,
          padding: EdgeInsets.symmetric(horizontal: paddingReview),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 0, vertical: paddingReviewLeft),
            child: Column(
              children: [
                //? คะแนนรีวิวเฉลี่ย
                HeaderAverageReview(allReview: widget.allReview),
                //? ปุ่มคะแนนรีวิว
                ButtonStar(
                  controller: controller,
                  paddingReviewLeft: paddingReviewLeft,
                  bgStar: bgStar,
                  btnList: btnList,
                  activePage: _activePage,
                  reviews: widget.allReview,
                ),
              ],
            ),
          ),
        ),
        Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/review/feedback.png"),
                const Text(
                  "ยังไม่มีการรีวิวค่ะ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            )),
      ],
    );
  }

  allReview(Size sized, {required List<ProductReview> listReview}) {
    const int itemsPerPage = 10;
    final ctr = Get.find<ReviewsCtr>();
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: paddingReview),
              color: Colors.grey.shade100,
              // height: 100,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: paddingReviewLeft),
                child: Column(
                  children: [
                    //? คะแนนรีวิวเฉลี่ย
                    HeaderAverageReview(allReview: widget.allReview),
                    //? ปุ่มคะแนนรีวิว
                    ButtonStar(
                      controller: controller,
                      paddingReviewLeft: paddingReviewLeft,
                      bgStar: bgStar,
                      btnList: btnList,
                      activePage: _activePage,
                      reviews: widget.allReview,
                    ),
                  ],
                ),
              ),
            ),
            ListView.separated(
              itemCount:
                  (ctr.currentPage.value * itemsPerPage) > listReview.length
                      ? listReview.length
                      : (ctr.currentPage.value * itemsPerPage),
              physics: const NeverScrollableScrollPhysics(),
              primary: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? ชื่อผู้รีวิว ดาว
                        NameWithStars(
                          subtitleText: subtitleText,
                          listReview: listReview[index],
                        ),

                        //? ข้อความรีวิว
                        textReviewDetail(
                          listReview: listReview[index],
                        ),

                        //? ภาพรีวิวสินค้า
                        ReviewImage(
                            listReview: listReview,
                            imgList: listReview[index].medialist,
                            index: index),

                        //? รายละเอียดรอบสินค้า
                        DetailCampReview(
                          productReview: listReview[index],
                        ),

                        //? การคอมเม้นตอบกลับ
                        AdminReply(
                          paddingReviewLeft: paddingReviewLeft,
                          listReview: listReview[index],
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    height: 0,
                    indent: 0,
                    endIndent: 0);
              },
            ),
            if (ctr.currentPage.value * itemsPerPage < listReview.length)
              InkWell(
                  onTap: () {
                    ctr.setPagination();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: IntrinsicHeight(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 3,
                            ),
                          ),
                        ),
                        const Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('ดูเพิ่มเติม'),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        )),
                        Expanded(
                          child: IntrinsicHeight(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 3,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ))
          ],
        ),
      );
    });
  }

  textReviewDetail({required ProductReview listReview}) {
    return listReview.comment != ""
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              listReview.comment,
            ),
          )
        : const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '- ไม่มีเนื้อหา -',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          );
  }
}

class ButtonStar extends StatelessWidget {
  const ButtonStar({
    super.key,
    required this.controller,
    required this.paddingReviewLeft,
    required this.bgStar,
    required this.btnList,
    required this.activePage,
    required this.reviews,
  });
  final double paddingReviewLeft;
  final Color bgStar;
  final PageController controller;
  final List<String> btnList;
  final int activePage;
  final ReviewsProduct reviews;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runAlignment: WrapAlignment.center,
      children: [
        ...btnList.asMap().entries.map(
              (item) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: InkWell(
                  onTap: () {
                    controller.jumpToPage(
                      item.key,
                    );
                  },
                  child: item.key == 0
                      ? Container(
                          decoration: BoxDecoration(
                              color: activePage == item.key
                                  ? theme_color_df
                                  : bgStar,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 12),
                            child: Text(
                              item.value,
                              style: TextStyle(
                                color: activePage == item.key
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        )
                      : item.key != 4
                          ? Container(
                              // margin: EdgeInsets.symmetric(
                              //     horizontal: paddingReviewLeft, vertical: 4),
                              decoration: BoxDecoration(
                                  color: activePage == item.key
                                      ? theme_color_df
                                      : bgStar,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${item.value} ',
                                      style: TextStyle(
                                        color: activePage == item.key
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    RatingBar(
                                      ignoreGestures: true,
                                      itemSize: 18,
                                      initialRating: 1,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      glow: false,
                                      itemCount: 1,
                                      itemPadding: EdgeInsets.zero,
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                      ratingWidget: RatingWidget(
                                        full: Image.asset(
                                            'assets/images/review/fullStar.png'),
                                        half: Image.asset(
                                            'assets/images/review/halfStar.png'),
                                        empty: Image.asset(
                                            'assets/images/review/emptyStar.png'),
                                      ),
                                    ),
                                    Text(
                                      item.key == 0
                                          ? " (${reviews.allRating.productReview.length})"
                                          : item.key == 1
                                              ? " (${reviews.fiveRating.productReview.length})"
                                              : item.key == 2
                                                  ? " (${reviews.fourRating.productReview.length})"
                                                  : " (${reviews.threeRating.productReview.length})",
                                      style: TextStyle(
                                        color: activePage == item.key
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                ),
              ),
            ),
        InkWell(
          onTap: () => {controller.jumpToPage(4)},
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
                color: activePage == 4 ? theme_color_df : bgStar,
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '2 / 1',
                    style: TextStyle(
                      color: activePage == 4 ? Colors.white : Colors.black,
                    ),
                  ),
                  RatingBar(
                    ignoreGestures: true,
                    itemSize: 18,
                    initialRating: 1,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    glow: false,
                    itemCount: 1,
                    itemPadding: EdgeInsets.zero,
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                    ratingWidget: RatingWidget(
                      full: Image.asset('assets/images/review/fullStar.png'),
                      half: Image.asset('assets/images/review/halfStar.png'),
                      empty: Image.asset('assets/images/review/emptyStar.png'),
                    ),
                  ),
                  Text(
                    " (${reviews.twoRating.productReview.length + reviews.oneRating.productReview.length})",
                    style: TextStyle(
                      color: activePage == 4 ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HeaderAverageReview extends StatelessWidget {
  const HeaderAverageReview({
    super.key,
    required this.allReview,
  });
  final ReviewsProduct allReview;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    text: allReview.totalRating.toString(),
                    children: const [
                  TextSpan(
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                      text: " / 5 ")
                ])),
            RatingBarIndicator(
              itemSize: 18,
              rating: allReview.totalRating,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, index) => Image.asset(
                'assets/images/review/fullStar.png',
                color: Colors.amber,
              ),
            ),
          ],
        ),
        Text("${allReview.allRating.count} รีวิว")
      ],
    );
  }
}

class AdminReply extends StatelessWidget {
  const AdminReply({
    super.key,
    required this.paddingReviewLeft,
    required this.listReview,
  });

  final double paddingReviewLeft;
  final ProductReview listReview;

  @override
  Widget build(BuildContext context) {
    return listReview.replyToFeedback.comment != ""
        ? Container(
            width: Get.width,
            color: const Color.fromRGBO(195, 227, 248, 1),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10,
                  bottom: 20,
                  left: paddingReviewLeft,
                  right: paddingReviewLeft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listReview.replyToFeedback.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    listReview.replyToFeedback.comment,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

class DetailCampReview extends StatelessWidget {
  const DetailCampReview({
    super.key,
    required this.productReview,
  });
  final ProductReview productReview;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8),
      child: IntrinsicHeight(
          child: Row(
        children: [
          Text(
            "รอบการขาย ${productReview.orderCampaign} ",
            style: TextStyle(color: theme_grey_text),
          ),
          VerticalDivider(
            color: theme_grey_text,
            thickness: 1,
          ),
          Text(
            productReview.reviewDate,
            style: TextStyle(color: theme_grey_text),
          ),
        ],
      )),
    );
  }
}

class ReviewImage extends StatelessWidget {
  ReviewImage({
    super.key,
    required this.imgList,
    required this.index,
    required this.listReview,
  });

  final List<String> imgList;
  final int index;
  final List<ProductReview> listReview;
  final listTypeImg = ["jpg", "jpeg", "png", "webp"];
  final List<ReviewMedia>? reviewMedia = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imgList.isNotEmpty ? 65 : 0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: imgList.length,
        itemBuilder: (context, indexMedia) {
          final media = imgList[indexMedia].split('.').last;
          var listImgType = ['jpg', 'jpeg', 'png', 'webp'];
          reviewMedia!.add(ReviewMedia(
              mediaType: !listImgType.contains(
                      imgList[indexMedia].split(".").last.toLowerCase())
                  ? "2" // video
                  : "1", //imgage
              url: imgList[indexMedia],
              key: index));

          if (indexMedia < 3) {
            return !listImgType.contains(media)
                ? InkWell(
                    onTap: () {
                      Get.to(() => ShowMediaReview(
                          indexMedia,
                          listReview[index].medialist.length,
                          reviewMedia!
                              .where((element) => element.key == index)
                              .toList()));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          margin: const EdgeInsets.only(right: 4),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: VideoThumbnails(
                              path: listReview[index].medialist[indexMedia],
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 30,
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      width: 65,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: theme_color_df)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ShowMediaReview(
                                indexMedia,
                                listReview[index].medialist.length,
                                reviewMedia!
                                    .where((element) => element.key == index)
                                    .toList()));
                          },
                          child: CachedNetworkImage(
                              imageUrl:
                                  listReview[index].medialist[indexMedia]),
                        ),
                      ),
                    ),
                  );
          } else if (indexMedia == 3) {
            return !listImgType.contains(media)
                ? InkWell(
                    onTap: () {
                      Get.to(() => ShowMediaReview(
                          indexMedia,
                          listReview[index].medialist.length,
                          reviewMedia!
                              .where((element) => element.key == index)
                              .toList()));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.grey.shade400, BlendMode.modulate),
                          child: Container(
                            width: 55,
                            margin: const EdgeInsets.only(right: 4),
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: VideoThumbnails(
                                path: listReview[index].medialist[indexMedia],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '+ ${listReview[index].medialist.length - indexMedia}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
                          listReview[index].medialist.length,
                          reviewMedia!
                              .where((element) => element.key == index)
                              .toList()));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.grey.shade400, BlendMode.modulate),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              width: 55,
                              height: 55,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => ShowMediaReview(
                                      indexMedia,
                                      listReview[index].medialist.length,
                                      reviewMedia!
                                          .where(
                                              (element) => element.key == index)
                                          .toList()));
                                },
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: listReview[index]
                                        .medialist[indexMedia]),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '+ ${listReview[index].medialist.length - indexMedia}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
        },
      ),
    );
  }
}

class NameWithStars extends StatelessWidget {
  const NameWithStars({
    super.key,
    required this.subtitleText,
    required this.listReview,
  });

  final TextStyle subtitleText;
  final ProductReview listReview;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listReview.repName,
              style: TextStyle(
                  height: 2,
                  fontWeight: FontWeight.bold,
                  color: theme_color_df),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "จำนวน ${listReview.unit} ชิ้น",
                      style: subtitleText,
                    ),
                    const VerticalDivider(
                      thickness: 1,
                    ),
                    Text(
                      "คุณภาพ ${listReview.productRating}",
                      style: subtitleText,
                    ),
                    Center(
                      child: RatingBar(
                        ignoreGestures: true,
                        itemSize: 12,
                        initialRating: 1,
                        minRating: 0,
                        direction: Axis.horizontal,
                        glow: false,
                        itemCount: 1,
                        itemPadding: const EdgeInsets.only(
                            right: 2, bottom: 4, left: 2.0),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                        ratingWidget: RatingWidget(
                          full:
                              Image.asset('assets/images/review/fullStar.png'),
                          half:
                              Image.asset('assets/images/review/halfStar.png'),
                          empty:
                              Image.asset('assets/images/review/emptyStar.png'),
                        ),
                      ),
                    ),
                    Text(
                      "ขนส่ง ${listReview.deliveryRating}",
                      style: subtitleText,
                    ),
                    Center(
                      child: RatingBar(
                        ignoreGestures: true,
                        itemSize: 12,
                        initialRating: 1,
                        minRating: 0,
                        direction: Axis.horizontal,
                        glow: false,
                        itemCount: 1,
                        itemPadding: const EdgeInsets.only(
                            right: 2, bottom: 4, left: 2.0),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                        ratingWidget: RatingWidget(
                          full:
                              Image.asset('assets/images/review/fullStar.png'),
                          half:
                              Image.asset('assets/images/review/halfStar.png'),
                          empty:
                              Image.asset('assets/images/review/emptyStar.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        RatingBarIndicator(
          itemCount: 5,
          itemSize: 16,
          rating: listReview.productRating,
          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, index) => Image.asset(
            'assets/images/review/fullStar.png',
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}
