import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/review/review_detials_model.dart';
import '../theme/theme_color.dart';
import 'write_review.dart';

class WaitReview extends StatelessWidget {
  const WaitReview(this.reviewList, {super.key});
  final ReviewDetails reviewList;
  @override
  Widget build(BuildContext context) {
    // reviewsDetails();
    return SingleChildScrollView(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          // headerFridayReview(context),
          const SizedBox(
            height: 18,
          ),
          reviewList.reviewWaiting.isEmpty
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
                      const Text('ไม่พบรายการรอรีวิว'),
                    ],
                  ),
                )
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviewList.reviewWaiting.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => WriteReview(
                            productReview: reviewList.reviewWaiting[index]));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Color.fromRGBO(204, 237, 255, 1)),
                        child: ListTile(
                          minVerticalPadding: 0,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          title: Row(
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
                                        imageUrl: reviewList
                                            .reviewWaiting[index].image,
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
                                      '${reviewList.reviewWaiting[index].unit}x',
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                        reviewList
                                            .reviewWaiting[index].billDesc,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'เลขที่ใบกำกับภาษี ${reviewList.reviewWaiting[index].invoice}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'รอบการขาย ${reviewList.reviewWaiting[index].salesCampaign}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                          subtitle: Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 12),
                            child: OutlinedButton(
                              onPressed: () {
                                Get.to(() => WriteReview(
                                    productReview:
                                        reviewList.reviewWaiting[index]));
                              },
                              style: OutlinedButton.styleFrom(
                                side:
                                    BorderSide(color: theme_color_df, width: 2),
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                              ),
                              child: Text(
                                'รีวิวเลย',
                                style: TextStyle(
                                    color: theme_color_df,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
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
      ),
    );
  }
}
