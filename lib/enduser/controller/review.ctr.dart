import 'dart:io';

import 'package:fridayonline/enduser/models/reviews/pending.model.dart';
import 'package:fridayonline/enduser/models/reviews/reviewed.mode.dart';
import 'package:fridayonline/enduser/models/showproduct/review.model.dart';
import 'package:fridayonline/enduser/services/review%20/review.service.dart';
import 'package:fridayonline/enduser/services/showproduct/showproduct.sku.service.dart';
import 'package:fridayonline/enduser/widgets/dialog.error.dart';
import 'package:fridayonline/homepage/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewEndUserCtr extends GetxController {
  final RxBool isLoadingReview = false.obs;
  B2CReview? reviews;
  RxInt filterType = 0.obs;
  RxInt proId = 0.obs;
  RxBool isShowFilter = false.obs;
  RxBool isAll = true.obs;
  RxInt selectStar = 0.obs;
  RxInt allReview = 0.obs;
  RxBool isLoadingMore = false.obs;

  setFilterType(type) {
    filterType.value = type;
  }

  fetchEndUserReivew(productId, type, limit, offet) async {
    proId.value = productId;
    try {
      isLoadingReview.value = true;
      reviews = await fetchReivewSkuService(productId, type, limit, offet);
      if (type == 0) {
        allReview.value = reviews!.data.itemSummary.countReview;
      }
    } finally {
      if (reviews == null) {
        isLoadingReview.value = false;
        dialogError('เกิดข้อผิดพลาด\nกรุณาลองใหม่อีกครั้ง').then((value) => {
              Get.off(() => const SplashScreen()),
              isLoadingReview.value = false
            });
      } else {
        isLoadingReview.value = false;
      }
    }
  }

  void resetReview() {
    if (reviews != null && reviews!.data.ratings.length > 10) {
      reviews!.data.ratings = reviews!.data.ratings.sublist(0, 10);
    }
  }

  Future<B2CReview?>? fetchMoreEndUserReivew(
      productId, type, limit, offet) async {
    return await fetchReivewSkuService(productId, type, limit, offet);
  }
}

class MyReviewCtr extends GetxController {
  RxBool isLoading = false.obs;
  PendingReviews? pendingReviews;
  Reviewed? reviewed;
  Map<int, List<File>> imageFile = {};
  Map<int, File> videoFile = {};
  Map<int, int> productRatings = {};
  Map<int, TextEditingController> textReview = {};

  fetchPendingReview(int orderShopId) async {
    try {
      isLoading(true);
      pendingReviews = await fetchPendingReviewService(orderShopId);
    } finally {
      if (pendingReviews != null) {
        for (var item in pendingReviews!.data) {
          if (productRatings[item.itemId] == null) {
            productRatings[item.itemId] = 0;
          }
          productRatings[item.itemId] = 5;
        }
      }
      isLoading(false);
    }
  }

  fetchReviewed(int orderShopId) async {
    try {
      isLoading(true);
      reviewed = await fetchReviewedService(orderShopId);
    } finally {
      isLoading(false);
    }
  }
}
