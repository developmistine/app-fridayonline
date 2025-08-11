import 'package:fridayonline/model/cart/cart_cheer.dart';
import 'package:fridayonline/model/cart/cart_cheer_banner.dart';
import 'package:fridayonline/service/cart/cart_cheer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheerCartCtr extends GetxController {
  CheerCart? conditions;
  CartCheerBanner? cartCheerBanner;
  var isDataLoading = false.obs;
  var isBannerLoading = false.obs;
  fetchCartConditions(camp, totalAmt) async {
    try {
      isDataLoading(true);
      conditions = await cartCheering(camp, totalAmt);
    } catch (e) {
      debugPrint("error cheer cart from controller are $e");
    } finally {
      isDataLoading(false);
    }
  }

  fetchCartCheerBanner(camp) async {
    try {
      isBannerLoading(true);
      cartCheerBanner = await cartCheeringBanner(camp);
    } catch (e) {
      debugPrint("error cheer cart from controller are $e");
    } finally {
      isBannerLoading(false);
    }
  }
}
