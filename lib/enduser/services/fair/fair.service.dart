import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/fair/coininfo.model.dart';
import 'package:fridayonline/enduser/models/fair/cointransaction.model.dart';
import 'package:fridayonline/enduser/models/fair/fair.banner.model.dart';
import 'package:fridayonline/enduser/models/fair/fair.swipe.model.dart';
import 'package:fridayonline/enduser/models/fair/fari.content.model.dart';
import 'package:fridayonline/enduser/models/fair/fari.product.model.dart';
import 'package:fridayonline/enduser/models/fair/festival.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/enduser/views/(initials)/fair/fair.view.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<ProductSwipeContent?> fetchFairContentService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/fairs/product_swipe/content");

  try {
    var jsonCall = await AuthFetch.get(url, headers: <String, String>{
      'Content-type': 'application/json; charset=utf-8'
    });
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final productSwipeContent =
          productSwipeContentFromJson(utf8.decode(jsonResponse));

      return productSwipeContent;
    }
    return Future.error(
        'Error fetchFairContentService : /api/v1/fairs/product_swipe/content');
  } catch (e) {
    return Future.error('Error fetchFairContentService : $e');
  }
}

Future<CoinsTransaction?> fetchCoinsTransactionService(int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/activity/coins/transaction");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId,
          "coins_type": "all",
          "limit": 50,
          "offset": offset
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final coinsTransaction =
          coinsTransactionFromJson(utf8.decode(jsonResponse));
      return coinsTransaction;
    }
    return Future.error(
        'Error fetchCoinsTransactionService : api/v1/activity/coins/transaction');
  } catch (e) {
    return Future.error('Error fetchCoinsTransactionService : $e');
  }
}

Future<CoinsInfo?> fetchCoinsInfoService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/activity/coins/info");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final coinsInfo = coinsInfoFromJson(utf8.decode(jsonResponse));
      return coinsInfo;
    }
    return Future.error(
        'Error fetchCoinsInfoService : api/v1/activity/coins/info');
  } catch (e) {
    return Future.error('Error fetchCoinsInfoService : $e');
  }
}

Future<Festival?> fetchFestivalService(String contentStage) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/fairs/festival");
  // printWhite(await data.accessToken);
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId,
          "content_stage": contentStage
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final festival = festivalFromJson(utf8.decode(jsonResponse));
      return festival;
    }
    return Future.error('Error fetchFestivalService : api/v1/fairs/festival');
  } catch (e) {
    return Future.error('Error fetchFestivalService : $e');
  }
}

Future<FairBanner?> fetchFairBannerService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/fairs/banner");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final fairBanner = fairBannerFromJson(utf8.decode(jsonResponse));
      return fairBanner;
    }
    return Future.error('Error fetchFairBannerService : api/v1/fairs/festival');
  } catch (e) {
    return Future.error('Error fetchFairBannerService : $e');
  }
}

Future<FairsProductSwipe?> fetchFairProductSwipeService(
  String action,
  ProductData? productData,
  int fairId,
) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/fairs/product_swipe");
  var payload = {};
  if (productData == null) {
    payload = {
      "cust_id": await data.b2cCustID,
      "device": await data.device,
      "session_id": await data.sessionId,
      "action": action,
      "fair_id": fairId
    };
  } else {
    payload = {
      "cust_id": await data.b2cCustID,
      "device": await data.device,
      "session_id": await data.sessionId,
      "action": action,
      "fair_id": fairId,
      "product_data": {
        "shop_id": productData.productData.shopId,
        "seq_no": productData.productData.seqNo,
        "product_id": productData.productData.productId,
        "item_id": productData.productData.itemId,
        "qty": 1,
      }
    };
  }
  printJSON(payload);

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final fairsProductSwipe =
          fairsProductSwipeFromJson(utf8.decode(jsonResponse));

      return fairsProductSwipe;
    }
    return Future.error(
        'Error fetchFairProductSwipeService : api/v1/fairs/product_swipe');
  } catch (e) {
    return Future.error('Error fetchFairProductSwipeService : $e');
  }
}

Future<FairsTopProduct?> fetchTopProductService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/fairs/top/products");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final fairsTopProduct =
          fairsTopProductFromJson(utf8.decode(jsonResponse));

      return fairsTopProduct;
    }
    return Future.error(
        'Error fetchTopProductService : api/v1/fairs/top/products');
  } catch (e) {
    return Future.error('Error fetchTopProductService : $e');
  }
}

Future<FairsRedeem?> fetchProductSwipeRedeemService(
    String action, int fairId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/fairs/product_swipe/redeem");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId,
          "action": action,
          "fair_id": fairId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;

      final fairsRedeem = fairsRedeemFromJson(utf8.decode(jsonResponse));

      return fairsRedeem;
    }
    return Future.error(
        'Error fetchProductSwipeRedeemService : fairs/product_swipe/redeem');
  } catch (e) {
    return Future.error('Error fetchProductSwipeRedeemService : $e');
  }
}

Future<bool> fetchFairVisibilityService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/fairs/visibility");

  try {
    var jsonCall = await AuthFetch.get(
      url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      var jsonResponse = jsonCall.body;

      final visibility = jsonDecode(jsonResponse);

      return visibility["show_fair_button"];
    }
    return Future.error(
        'Error fetchFairVisibilityService : api/v1/fairs/visibility');
  } catch (e) {
    return Future.error('Error fetchFairVisibilityService : $e');
  }
}

FairsRedeem fairsRedeemFromJson(String str) =>
    FairsRedeem.fromJson(json.decode(str));

String fairsRedeemToJson(FairsRedeem data) => json.encode(data.toJson());

class FairsRedeem {
  String code;
  String message;

  FairsRedeem({
    required this.code,
    required this.message,
  });

  factory FairsRedeem.fromJson(Map<String, dynamic> json) => FairsRedeem(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
