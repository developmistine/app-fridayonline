// import 'dart:developer';

import 'package:fridayonline/controller/cart/coupon_discount_controller.dart';
import 'package:fridayonline/controller/cart/point_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_coupon_condition.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
// import 'package:fridayonline/model/cart/coupon_discount.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/theme_color.dart';
import '../../../theme/theme_loading.dart';
import '../../../widget/appbarmaster.dart';

class SelectDiscountCoupon extends StatelessWidget {
  SelectDiscountCoupon(this.cTotalAmount, {super.key});
  final double cTotalAmount;
  final FetchPointMember discoutPoint = Get.find();

  @override
  Widget build(BuildContext context) {
    // var numDiscountPoint = widget.discoutPoint.discount.value;
    int dataCouponDiscount =
        Get.find<FetchCouponDiscount>().couponDiscount!.couponlist.length;
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: appBarTitleMaster(
          "ส่วนลดของฉัน",
        ),
        body: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: SizedBox(
            child: GetX<FetchCouponDiscount>(builder: (couponList) {
              int listCount = couponList.couponDiscount!.couponlist.length;
              return couponList.isDataLoading.value
                  ? Center(child: theme_loading_df)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 8),
                      child: Center(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          children: [
                            listCount == 0
                                ? const SizedBox(
                                    width: double.infinity,
                                    height: 400,
                                    child: Center(
                                      child: Text(
                                        'ไม่พบส่วนลดคูปอง',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 90, 90, 90),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: couponList
                                        .couponDiscount!.couponlist.length,
                                    itemBuilder: (context, i) {
                                      if (couponList.couponDiscount!
                                              .couponlist[i].usecoupon
                                              .toUpperCase() ==
                                          "N") {
                                        return GestureDetector(
                                          onTap: () => false,
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Card(
                                                surfaceTintColor: Colors.white,
                                                color: Colors.grey[300],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                elevation: 0.3,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    leading: ColorFiltered(
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        Colors.grey[300]!,
                                                        BlendMode.saturation,
                                                      ),
                                                      child: CachedNetworkImage(
                                                        width: 60,
                                                        imageUrl: couponList
                                                            .couponDiscount!
                                                            .couponlist[i]
                                                            .imgCoupon,
                                                      ),
                                                    ),
                                                    trailing: couponList
                                                            .listCoupon
                                                            .any((element) =>
                                                                element.id ==
                                                                couponList
                                                                    .couponDiscount!
                                                                    .couponlist[
                                                                        i]
                                                                    .couponId)
                                                        ? Icon(
                                                            Icons.check_box,
                                                            color:
                                                                theme_color_df,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .check_box_outline_blank,
                                                            color:
                                                                theme_color_back1),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Wrap(
                                                          alignment:
                                                              WrapAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              couponList
                                                                  .couponDiscount!
                                                                  .couponlist[i]
                                                                  .couponName,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15.5),
                                                            )
                                                          ],
                                                        ),
                                                        Wrap(
                                                          alignment:
                                                              WrapAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              couponList
                                                                  .couponDiscount!
                                                                  .couponlist[i]
                                                                  .condition,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    subtitle: Text(
                                                      "จะหมดอายุภายใน:  ${couponList.couponDiscount!.couponlist[i].expire}  วัน",
                                                      style: const TextStyle(
                                                          height: 2,
                                                          color: Color.fromARGB(
                                                              255,
                                                              139,
                                                              139,
                                                              139)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => Get.to(() =>
                                                    CartCouponConditions(
                                                        couponDetails: couponList
                                                            .couponDiscount!
                                                            .couponlist[i])),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8),
                                                  child: Text(
                                                    'เงื่อนไข',
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: theme_color_df),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      return Obx(() {
                                        return GestureDetector(
                                          onTap: () async {
                                            // setState(() {
                                            couponList.setCouponList(
                                                couponList.couponDiscount!
                                                    .couponlist[i].couponId,
                                                couponList.couponDiscount!
                                                    .couponlist[i].couponName,
                                                couponList.couponDiscount!
                                                    .couponlist[i].price,
                                                couponList
                                                    .couponDiscount!
                                                    .couponlist[i]
                                                    .categoryCoupon);
                                            // });
                                          },
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Card(
                                                surfaceTintColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                elevation: 0.3,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    leading: CachedNetworkImage(
                                                        width: 60,
                                                        imageUrl: couponList
                                                            .couponDiscount!
                                                            .couponlist[i]
                                                            .imgCoupon),
                                                    trailing: couponList
                                                            .listCoupon
                                                            .any((element) =>
                                                                element.id ==
                                                                couponList
                                                                    .couponDiscount!
                                                                    .couponlist[
                                                                        i]
                                                                    .couponId)
                                                        ? Icon(
                                                            Icons.check_box,
                                                            color:
                                                                theme_color_df,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .check_box_outline_blank,
                                                            color:
                                                                theme_color_df),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Wrap(
                                                          alignment:
                                                              WrapAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              couponList
                                                                  .couponDiscount!
                                                                  .couponlist[i]
                                                                  .couponName,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15.5),
                                                            )
                                                          ],
                                                        ),
                                                        Wrap(
                                                          alignment:
                                                              WrapAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              couponList
                                                                  .couponDiscount!
                                                                  .couponlist[i]
                                                                  .condition,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    subtitle: Text(
                                                      "จะหมดอายุภายใน:  ${couponList.couponDiscount!.couponlist[i].expire}  วัน",
                                                      style: const TextStyle(
                                                          height: 2,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => Get.to(() =>
                                                    CartCouponConditions(
                                                        couponDetails: couponList
                                                            .couponDiscount!
                                                            .couponlist[i])),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8),
                                                  child: Text(
                                                    'เงื่อนไข',
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: theme_color_df),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                    }),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    );
            }),
          ),
        ),
        bottomNavigationBar: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: dataCouponDiscount != 0
              ? InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 60,
                    color: theme_color_df,
                    child: const Center(
                        child: Text("ตกลง",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16))),
                  ),
                )
              : InkWell(
                  onTap: () async {
                    await Get.find<FetchCouponDiscount>().setEmptyCouponList();
                    Get.back();
                  },
                  child: Container(
                    height: 60,
                    color: theme_color_back1,
                    child: const Center(
                        child: Text("ปิด",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16))),
                  ),
                ),
        ),
      ),
    );
  }
}
