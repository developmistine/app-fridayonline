// import 'dart:developer';

import 'package:fridayonline/controller/cart/coupon_discount_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_select_discout_coupon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../service/languages/multi_languages.dart';
import '../../../theme/theme_color.dart';
import '../cart_theme/cart_all_theme.dart';

Widget couponDiscount(context, double cTotalAmount) =>
    StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      FetchCouponDiscount valueCouponName = Get.find();

      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: InkWell(
          onTap: () async {
            await Get.put(FetchCouponDiscount()).fetchCoupon();
            Get.to(() => SelectDiscountCoupon(cTotalAmount));
          },
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/cart/discount_coupon.png',
                                width: 32,
                                scale: 1.5,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                MultiLanguages.of(context)!
                                    .translate('order_coupon_discount'),
                                style: TextStyle(fontWeight: boldText),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(MultiLanguages.of(context)!
                                  .translate('order_use_coupon_discount')),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: theme_color_df,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (valueCouponName.listCoupon.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    return Text(
                                      valueCouponName.listCoupon.length > 1
                                          ? "ใช้อยู่ ${valueCouponName.listCoupon.length} คูปอง"
                                          : valueCouponName
                                                  .listCoupon.isNotEmpty
                                              ? valueCouponName
                                                  .listCoupon[0].name
                                              : "",
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 253, 128, 111),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
