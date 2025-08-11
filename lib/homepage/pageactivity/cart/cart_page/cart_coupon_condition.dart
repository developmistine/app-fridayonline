import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/cart/coupon_discount.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartCouponConditions extends StatelessWidget {
  CartCouponConditions({super.key, required this.couponDetails});
  final Couponlist couponDetails;
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitleMaster(
          "คูปองส่วนลด",
        ),
        body: SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SizedBox(
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: CachedNetworkImage(
                              imageUrl: couponDetails.imgCoupon,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    couponDetails.couponName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(couponDetails.condition,
                                      style: const TextStyle(fontSize: 12)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "หมดอายุภายใน ${couponDetails.expire.toString()} วัน",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'กติกาและเงื่อนไข',
                              style: TextStyle(
                                  color: theme_color_df,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              padding: const EdgeInsets.only(bottom: 0),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: couponDetails.descriptions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(
                                    "● ${couponDetails.descriptions[index]}");
                              },
                            )
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ระยะเวลาการใช้คูปอง',
                              style: TextStyle(
                                  color: theme_color_df,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(couponDetails.timeText),
                          ]),
                    ),
                  )
                ],
              ),
            )));
  }
}
