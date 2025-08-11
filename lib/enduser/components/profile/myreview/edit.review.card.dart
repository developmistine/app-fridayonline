import 'package:fridayonline/enduser/components/profile/myreview/review.text.dart';
import 'package:fridayonline/enduser/components/profile/myreview/review.upload.dart';
import 'package:fridayonline/enduser/controller/review.ctr.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

Widget editReviewCard() {
  final pendingCtr = Get.find<MyReviewCtr>();

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: pendingCtr.pendingReviews!.data.length,
    itemBuilder: (context, index) {
      var data = pendingCtr.pendingReviews!.data[index];
      pendingCtr.textReview
          .putIfAbsent(data.itemId, () => TextEditingController());
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadowColor: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Image.network(
                      data.itemImage,
                      width: 32,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.productName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              data.option,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: grayTextShade700,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ให้คะแนนคุณภาพสินค้า',
                      style: TextStyle(fontSize: 14, color: grayTextShade700),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: RatingBar(
                        itemSize: 36,
                        initialRating: pendingCtr.productRatings[data.itemId]
                                ?.toDouble() ??
                            5.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.only(right: 4),
                        onRatingUpdate: (rating) {
                          pendingCtr.productRatings[data.itemId] =
                              rating.toInt();
                        },
                        ratingWidget: RatingWidget(
                          full: Image.asset(
                              'assets/images/review/new-fullstar.png'),
                          half: Image.asset(
                              'assets/images/review/new-halfstar.png'),
                          empty: Image.asset(
                              'assets/images/review/new-empstar.png'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'เพิ่มรูปภาพ/วิดีโอ',
                      style: TextStyle(fontSize: 14, color: grayTextShade700),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: UploadReviewImageandVideo(itemId: data.itemId),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'เขียนรีวิวสินค้า',
                      style: TextStyle(fontSize: 14, color: grayTextShade700),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextReviewWidget(
                        controller: pendingCtr.textReview[data.itemId]!,
                        maxLength: 360,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      );
    },
  );
}
