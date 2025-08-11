import 'dart:convert';

// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/model/cart/coupon_discount.dart';
import 'package:get/get.dart';

import '../../service/cart/coupon_discount_service.dart';

class FetchCouponDiscount extends GetxController {
  CouponDiscount? couponDiscount;
  RxList<CouponList> listCoupon = <CouponList>[].obs;
  RxDouble couponPrice = 0.0.obs;
  var isDataLoading = false.obs;
  // set list coupon
  setCouponList(id, name, price, categroyCoupon) {
    //? คูปองส่วนลดสินค้า 1 , คูปองส่งฟรี 2
    // ตรวจสอบว่ามี id ซ้ำหรือไม่
    if (!listCoupon.any((element) => element.id == id)) {
      // เพิ่มคูปองใหม่เมื่อ id ไม่ซ้ำกัน
      listCoupon.add(CouponList(
          price: price, id: id, name: name, categroyCoupon: categroyCoupon));
    } else {
      listCoupon.removeWhere((element) => element.id == id);
    }
    listCoupon.sort((a, b) {
      if (a.categroyCoupon == 1 && b.categroyCoupon != 1) {
        return -1;
      } else if (a.categroyCoupon != 1 && b.categroyCoupon == 1) {
        return 1;
      }
      return 0;
    });
    couponPrice.value = listCoupon.fold(0, (sum, item) => sum + item.price);
  }

  setEmptyCouponList() {
    listCoupon.clear();
    couponPrice.value = 0.0;
  }

  // Get coupon form service
  fetchCoupon() async {
    try {
      isDataLoading(true);
      couponDiscount = await GetCouponDiscount();
    } finally {
      isDataLoading(false);
    }
  }
}

CouponList couponListFromJson(String str) =>
    CouponList.fromJson(json.decode(str));

String couponListToJson(CouponList data) => json.encode(data.toJson());

class CouponList {
  double price;
  String id;
  String name;
  int categroyCoupon;

  CouponList({
    required this.price,
    required this.id,
    required this.name,
    required this.categroyCoupon,
  });

  factory CouponList.fromJson(Map<String, dynamic> json) => CouponList(
        price: json["price"].toDouble(),
        id: json["id"],
        name: json["name"],
        categroyCoupon: json["categroyCoupon"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "id": id,
        "name": name,
        "categroyCoupon": categroyCoupon,
      };
}
