// !controller for fetch cart items
// import 'dart:developer';

import 'package:fridayonline/model/cart/star_model.dart';
import 'package:fridayonline/service/cart/stars_service.dart';
import 'package:get/get.dart';

class FetchStar extends GetxController {
  StarReward? starMember;

  var isDataLoading = false.obs;
  RxInt discount = 0.obs; // ราคาส่วนลด
  RxInt useStar = 0.obs; // point ที่ใช้

  countpoint(discountInput, useStarInput) {
    discount.value = discountInput;
    useStar.value = useStarInput;
    // update();
  }

  fetchstar() async {
    try {
      isDataLoading(true);
      starMember = await GetStar();
      update();
    } finally {
      isDataLoading(false);
    }
  }
}
