// !controller for fetch cart items

import 'package:fridayonline/model/cart/point_member.dart';
import 'package:fridayonline/service/cart/point_service.dart';
import 'package:get/get.dart';
import 'coupon_discount_controller.dart';

class FetchPointMember extends GetxController {
  PointMember? pointMember;

  RxDouble discountPrices = Get.put(FetchCouponDiscount()).couponPrice;
  RxDouble get disCouponPrice => discountPrices; // ส่วนลดคูปอง

  var isDataLoading = false.obs;
  RxInt discount = 0.obs; // ราคาส่วนลด
  RxInt usePoint = 0.obs; // point ที่ใช้

  countpoint(discountInput, usePointInput) {
    discount.value = discountInput;
    usePoint.value = usePointInput;
    update();
  }

  fetchPoint() async {
    try {
      isDataLoading(true);
      pointMember = await GetPoint();
      update();
    } finally {
      isDataLoading(false);
    }
  }
}
