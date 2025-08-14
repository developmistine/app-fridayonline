import 'dart:async';

import 'package:fridayonline/member/models/fair/fair.banner.model.dart';
import 'package:fridayonline/member/models/fair/fair.swipe.model.dart';
import 'package:fridayonline/member/models/fair/fari.content.model.dart';
import 'package:fridayonline/member/models/fair/fari.product.model.dart';
import 'package:fridayonline/member/models/fair/festival.model.dart';
import 'package:fridayonline/member/services/fair/fair.service.dart';
import 'package:fridayonline/member/views/(initials)/fair/fair.view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FairController extends GetxController {
  RxInt countSwipe = 1.obs;
  RxInt limitSwipe = 2.obs;
  RxInt current = 0.obs;

  var isLoadingBanner = false.obs;
  var isLoadingNowTeaser = false.obs;
  var isLoadingNowDetail = false.obs;
  var isLoadingComingSoon = false.obs;
  // var isLoadingProductSwipe = false.obs;
  RxMap<int, bool?> isLoadingProductSwipes = <int, bool?>{}.obs;
  var isLoadingTopProduct = false.obs;
  var isLoadingSwipeContent = false.obs;

  Festival? nowTeaser;
  Festival? comingSoon;
  Festival? nowDetail;
  FairBanner? banner;
  FairsProductSwipe? productSwipe;
  Map<int, FairsProductSwipe?> productSwipes = {};
  FairsTopProduct? topProducts;
  ProductSwipeContent? swipeContent;

  // swipe.Data? product;

  RxMap<int, int?> selectedOptions = <int, int?>{}.obs;
  RxInt itemId = 0.obs;
  RxDouble htmlHeight = 0.0.obs;
  Rxn<dynamic> productPrice = Rxn<dynamic>();
  Rxn<dynamic> productTier = Rxn<dynamic>();
  RxString imageFirst = "".obs;

  RxInt userDailyQuota = 0.obs;
  RxInt userRemainingQuota = 0.obs;

  addSwipe() {
    countSwipe.value += 1;
  }

  fetchSwipeContent() async {
    try {
      isLoadingSwipeContent.value = true;
      swipeContent = await fetchFairContentService();
    } finally {
      for (var fairId in swipeContent!.data) {
        await fetchProductSwipe('current', null, fairId.promotionId);
      }
      isLoadingSwipeContent.value = false;
    }
  }

  fetchProductSwipe(String action, ProductData? productData, int fairId) async {
    try {
      isLoadingProductSwipes[fairId] = true;
      productSwipe =
          await fetchFairProductSwipeService(action, productData, fairId);
      productSwipes[fairId] = productSwipe;
    } finally {
      userDailyQuota.value = productSwipes[fairId]!.userDailyQuota;
      userRemainingQuota.value = productSwipes[fairId]!.userRemainingQuota;
      isLoadingProductSwipes[fairId] = false;
    }
  }

  fetchTopProduct() async {
    try {
      isLoadingTopProduct.value = true;
      topProducts = await fetchTopProductService();
    } finally {
      isLoadingTopProduct.value = false;
    }
  }

  fetchBanner() async {
    try {
      isLoadingBanner.value = true;
      banner = await fetchFairBannerService();
    } finally {
      isLoadingBanner.value = false;
    }
  }

  fetchFestival(String contentStage) async {
    switch (contentStage) {
      case "now_teaser":
        {
          try {
            isLoadingNowTeaser.value = true;
            nowTeaser = await fetchFestivalService(contentStage);
          } finally {
            isLoadingNowTeaser.value = false;
          }
          break;
        }
      case "coming_soon":
        {
          try {
            isLoadingComingSoon.value = true;
            comingSoon = await fetchFestivalService(contentStage);
          } finally {
            isLoadingComingSoon.value = false;
          }
          break;
        }
      case "now_detail":
        {
          try {
            isLoadingNowDetail.value = true;
            nowDetail = await fetchFestivalService(contentStage);
          } finally {
            isLoadingNowDetail.value = false;
          }
          break;
        }
      default:
    }
  }
}

// Controller สำหรับจัดการ countdown
class CountdownController extends GetxController {
  var timeText = "00:00:00".obs;
  Timer? _timer;

  // ฟังก์ชันเริ่มนับเวลา
  void startCountdown(String endTime) {
    _timer?.cancel();
    _updateTime(endTime);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime(endTime);
    });
  }

  void _updateTime(String endTime) {
    try {
      final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
      final DateTime endDateTime = formatter.parse(endTime);
      final DateTime currentDateTime = DateTime.now();

      final Duration difference = endDateTime.difference(currentDateTime);

      if (difference.isNegative) {
        timeText.value = "00:00:00";
        _timer?.cancel();
        return;
      }

      final int hours = difference.inHours;
      final int minutes = difference.inMinutes.remainder(60);
      final int seconds = difference.inSeconds.remainder(60);

      timeText.value = "${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";
    } catch (e) {
      timeText.value = "00:00:00";
    }
  }

  void stopCountdown() {
    _timer?.cancel();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
