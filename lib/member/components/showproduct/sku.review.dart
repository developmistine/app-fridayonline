import 'package:fridayonline/member/controller/review.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/models/showproduct/review.model.dart';
import 'package:fridayonline/member/services/showproduct/showproduct.sku.service.dart';
import 'package:fridayonline/member/views/(showproduct)/video.review.dart';
import 'package:fridayonline/member/views/(showproduct)/medias.review.dart';
import 'package:fridayonline/member/views/(showproduct)/show.review.sku.dart';
import 'package:fridayonline/member/widgets/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final ShowProductSkuCtr showProductCtr = Get.find();
List<String> mediaUrls = [];

class ReViewSku extends StatelessWidget {
  const ReViewSku({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (showProductCtr
              .productDetail.value!.data.productReview.totalRatingCount ==
          0) {
        return const SizedBox();
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(showProductCtr.productDetail.value!.data.ratingStar
                        .toString()),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: RatingBarIndicator(
                        itemSize: 12,
                        rating: 1,
                        direction: Axis.horizontal,
                        itemCount: 1,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, index) => Image.asset(
                          'assets/images/review/fullStar.png',
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    Text(
                      'คะแนนสินค้า (${showProductCtr.productDetail.value!.data.productReview.totalRatingCount})',
                      style: GoogleFonts.ibmPlexSansThai(fontSize: 13),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    Get.find<ReviewEndUserCtr>().fetchEndUserReivew(
                        showProductCtr.productDetail.value!.data.productId,
                        0,
                        10,
                        0);
                    Get.to(() => const ShowReviewProductSku());
                  },
                  child: Row(
                    children: [
                      Text(
                        'ดูทั้งหมด',
                        style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: Colors.grey.shade600,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
            // future: _myFuture,
            future: fetchReivewSkuService(
                showProductCtr.productDetail.value!.data.productId, 0, 2, 0),
            builder:
                (BuildContext context, AsyncSnapshot<B2CReview?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else if (snapshot.connectionState == ConnectionState.done) {
                Data review = snapshot.data!.data;

                return Column(
                  children: List.generate(review.ratings.length, (index) {
                    List<String> urls = [
                      ...review.ratings[index].video,
                      ...review.ratings[index].images
                    ];
                    mediaUrls = [
                      ...review.ratings[index].video,
                      ...review.ratings[index].images
                    ];
                    bool isVideoEmpty = review.ratings[index].video.isEmpty;
                    int maxShow = isVideoEmpty ? 3 : 2;
                    int maxLength = review.ratings[index].video.length +
                        review.ratings[index].images.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.ratings[index].custName),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: RatingBarIndicator(
                                  itemSize: 12,
                                  rating: review.ratings[index].ratingStar,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  itemBuilder: (context, index) => Image.asset(
                                    'assets/images/review/fullStar.png',
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Text(
                                review.ratings[index].comment,
                                style:
                                    GoogleFonts.ibmPlexSansThai(fontSize: 13),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if (review.ratings[index].video.isNotEmpty)
                                      Container(
                                        height: 120,
                                        width: Get.width / 3.4,
                                        clipBehavior: Clip.antiAlias,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: VideoThumbnailList(
                                            videoUrls: review
                                                .ratings[index].video.first,
                                            imgUrls:
                                                review.ratings[index].images),
                                      ),
                                    for (int idxMedia = 0;
                                        idxMedia <
                                            review.ratings[index].images.length;
                                        idxMedia++)
                                      idxMedia < maxShow
                                          ? InkWell(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                bool videoEmpty = review
                                                    .ratings[index]
                                                    .video
                                                    .isNotEmpty;

                                                Get.to(
                                                    () => EndUserMediaReviews(
                                                          mediaUrls: urls,
                                                          index: videoEmpty
                                                              ? idxMedia + 1
                                                              : idxMedia,
                                                        ));
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: CachedNetworkImage(
                                                      height: 120,
                                                      width: Get.width / 3.4,
                                                      fit: BoxFit.cover,
                                                      imageUrl: review
                                                          .ratings[index]
                                                          .images[idxMedia],
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Container(
                                                          height: 120,
                                                          color: Colors
                                                              .grey.shade100,
                                                          child: const Icon(Icons
                                                              .image_not_supported_rounded),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  idxMedia ==
                                                              (isVideoEmpty
                                                                  ? maxShow
                                                                  : maxShow -
                                                                      1) &&
                                                          maxLength -
                                                                  maxShow -
                                                                  1 !=
                                                              0
                                                      ? Positioned(
                                                          bottom: 2,
                                                          right: 13,
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                  color: Colors
                                                                      .black54),
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .image_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  ),
                                                                  Text(
                                                                    '+ ${maxLength - maxShow - 1}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              )))
                                                      : const SizedBox()
                                                ],
                                              )
                                              //
                                              )
                                          : const SizedBox(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: index < review.ratings.length - 1
                              ? Colors.grey.shade300
                              : Colors.white,
                        ),
                      ],
                    );
                  }),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const Gap(
            height: 10,
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      );
    });
  }
}
