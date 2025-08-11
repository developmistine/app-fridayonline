import 'dart:convert';

import '../../model/cart/coupon_discount.dart';
import '../../model/set_data/set_data.dart';
import '../pathapi.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
Future<CouponDiscount?> GetCouponDiscount() async {
  SetData data = SetData();
  try {
    // var url = Uri.parse("${dev_api_app}api/v1/line/GetCoupon");
    // var url = Uri.parse("${base_api_app}api/v1/coupon/GetCartCoupon");
    var url = Uri.parse("${base_api_app}api/v3/coupon/GetCartCoupon");
    var jsonData = jsonEncode({
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "UserId": await data.enduserId,
    });

    // var http;
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    if (res.statusCode == 200) {
      final json = res.body;
      CouponDiscount couponDiscount = couponDiscountFromJson(json);
      return couponDiscount;
    }
  } catch (e) {
    print("no data from $e");
  }
  return null;
}
