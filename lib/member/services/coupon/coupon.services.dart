import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/member/models/coupon/coupon.user.model.dart';
import 'package:fridayonline/member/models/coupon/vouchers.detail.dart';
import 'package:fridayonline/member/models/coupon/vouchers.group.model.dart';
import 'package:fridayonline/member/models/coupon/vouchers.items.model.dart';
import 'package:fridayonline/member/models/coupon/vouchers.platform.model.dart';
import 'package:fridayonline/member/models/coupon/vouchers.recommend.model.dart';
import 'package:fridayonline/member/models/coupon/vouchers.group.user.model.dart';
import 'package:fridayonline/member/models/coupon/vouchers.shopcode.model.dart';
import 'package:fridayonline/member/utils/auth_fetch.dart';

import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<VouchersGroup?> fetchVoucherGroupService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/vouchers/group");

  try {
    var jsonCall = await AuthFetch.post(
      url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final vouchersGroup = vouchersGroupFromJson(utf8.decode(jsonResponse));
      return vouchersGroup;
    }
    return Future.error('Error voucher group : api/v1/vouchers/group');
  } catch (e) {
    return Future.error('Error fetchVoucherGroupService : $e');
  }
}

Future<Vouchersitems?> fetchVoucherItemsService(int groupId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/vouchers/get");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "group_id": groupId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final vouchersitems = vouchersitemsFromJson(utf8.decode(jsonResponse));
      return vouchersitems;
    }
    return Future.error('Error voucher items : api/v1/vouchers/get');
  } catch (e) {
    return Future.error('Error fetchVoucherItemsService : $e');
  }
}

Future<VoucherDetail?> fetchVoucherDetail(int couponId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/vouchers/detail");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "coupon_id": couponId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final voucherDetail = voucherDetailFromJson(utf8.decode(jsonResponse));
      return voucherDetail;
    }
    return Future.error('Error voucher items : api/v1/vouchers/get');
  } catch (e) {
    return Future.error('Error fetchVoucherItemsService : $e');
  }
}

Future<VoucherRecommend?> fetchVoucherRecommend(int shopId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/vouchers/shop_recommend");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final voucherRecommend =
          voucherRecommendFromJson(utf8.decode(jsonResponse));
      return voucherRecommend;
    }
    return Future.error('Error voucher items : api/v1/vouchers/shop_recommend');
  } catch (e) {
    return Future.error('Error fetchVoucherRecommend : $e');
  }
}

Future<VouchersShopCode?> getCodeService(
    int shopId, String shopCode, String type) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/vouchers/shop_code");
  if (type == 'platform') {
    url = Uri.parse("${b2c_api_url}api/v1/vouchers/platform_code");
  }
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "voucher_code": shopCode
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;

      // final vouchersShopCode =
      //     vouchersShopCodeFromJson(utf8.decode(jsonResponse));
      final vouchersShopCode =
          vouchersShopCodeFromJson(utf8.decode(jsonResponse));
      return vouchersShopCode;
    }
    return Future.error('Error voucher shop code : api/v1/vouchers/shop_code');
  } catch (e) {
    return Future.error('Error getShopCodeService : $e');
  }
}

Future<Response> addVoucherItemsService(int listCouponId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/vouchers/add");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "vouchers": [listCouponId]
        }));
    if (jsonCall.statusCode == 200) {
      var jsonResponse = jsonCall.bodyBytes;
      final response = responseFromJson(utf8.decode(jsonResponse));
      return response;
    }
    return Future.error('Error voucher add : api/v1/vouchers/add');
  } catch (e) {
    return Future.error('Error addVoucherItemsService : $e');
  }
}

Future<PlatformRecommend?> fetchPlatFormVoucherRecommend() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/vouchers/platform_recommend");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;

      final platformRecommend =
          platformRecommendFromJson(utf8.decode(jsonResponse));
      return platformRecommend;
    }
    return Future.error(
        'Error voucher items : api/v1/vouchers/platform_recommend');
  } catch (e) {
    return Future.error('Error fetchPlatFormVoucherRecommend : $e');
  }
}

Future<VoucherGroupUser?> fetchVoucherGroupUser() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/vouchers/group_user");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;

      final voucherUser = voucherGroupUserFromJson(utf8.decode(jsonResponse));
      return voucherUser;
    }
    return Future.error('Error voucher items : api/v1/vouchers/group_user');
  } catch (e) {
    return Future.error('Error fetchVoucherUser : $e');
  }
}

Future<VoucherUser?> fetchVoucherUser(
    int voucherPage, int groupType, int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/vouchers/user");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "voucher_page": voucherPage,
          "group_type": groupType,
          "limit": 20,
          "offset": offset
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;

      final voucherUser = voucherUserFromJson(utf8.decode(jsonResponse));
      return voucherUser;
    }
    return Future.error('Error voucher items : api/v1/vouchers/group_user');
  } catch (e) {
    return Future.error('Error fetchVoucherUser : $e');
  }
}

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  String code;
  String message;

  Response({
    required this.code,
    required this.message,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
