import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/home/hom.mall.model.dart';
import 'package:fridayonline/enduser/models/home/home.banner.model.dart';
import 'package:fridayonline/enduser/models/home/home.brands.model.dart';
import 'package:fridayonline/enduser/models/home/home.content.model.dart';
import 'package:fridayonline/enduser/models/home/home.popup.model.dart';
import 'package:fridayonline/enduser/models/home/home.recommend.dart';
import 'package:fridayonline/enduser/models/home/home.short.model.dart';
import 'package:fridayonline/enduser/models/home/home.topsales.model.dart';
import 'package:fridayonline/enduser/models/home/home.vouchers.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<HomeContent?> fetchHomeContentService(contentType) async {
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/content");
  SetData data = SetData();
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "content_group": contentType
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final homeContent = homeContentFromJson(utf8.decode(jsonResponse));
      return homeContent;
    }
    return Future.error('Error get home content : b2c/api/v1/home/content');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<HomeBanner?> fetchHomeBannerService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/banner");

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
      final homeBanner = homeBannerFromJson(utf8.decode(jsonResponse));
      return homeBanner;
    }
    return Future.error('Error get home banner : b2c/api/v1/home/banner');
  } catch (e) {
    return Future.error('Error: fetchHomeBannerService $e');
  }
}

Future<HomeShortMenu?> fetchHomeShorMenuService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/key_menu");

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
      final homeShortMenu = homeShortMenuFromJson(utf8.decode(jsonResponse));

      return homeShortMenu;
    }
    return Future.error('Error get home short menu : b2c/api/v1/home/key_menu');
  } catch (e) {
    return Future.error('Error: fetchHomeShorMenuService $e');
  }
}

Future<HomeVouchers> fetchHomeVoucherService(String groupType) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/vouchers");
  printWhite(await data.accessToken);
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "group_type": groupType
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final homeVouchers = homeVouchersFromJson(utf8.decode(jsonResponse));

      return homeVouchers;
    }
    return Future.error('Error get home vouchers : b2c/api/v1/home/vouchers');
  } catch (e) {
    return Future.error('Error: fetchHomeVoucherService $e');
  }
}

Future<HomeBrands?> fetctBrandsService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/brands");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final homeBrands = homeBrandsFromJson(utf8.decode(jsonResponse));

      return homeBrands;
    }
    return Future.error('Error get brand : b2c/api/v1/home/brands');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<HomeMalls?> fetchHomeMallService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/malls");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final homeMalls = homeMallsFromJson(utf8.decode(jsonResponse));

      return homeMalls;
    }
    return Future.error('Error get malls : b2c/api/v1/home/malls');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<ProductRecommend?> fetctProductRecommendService(int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/product/recommend");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "limit": 20,
          "offset": offset
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final productRecommend =
          productRecommendFromJson(utf8.decode(jsonResponse));
      return productRecommend;
    }
    return Future.error(
        'Error get product recommend: b2c/api/v1/home/product/recommend');
  } catch (e) {
    return Future.error('Error: fetctProductRecommendService $e');
  }
}

Future<EndUserPopup?> fetctPopupService(int popupType) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/popup");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "popup_type": popupType
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final response = endUserPopupFromJson(utf8.decode(jsonResponse));

      return response;
    }
    return Future.error('Error get brand : b2c/api/v1/home/popup');
  } catch (e) {
    return Future.error('Error : fetctPopupService $e');
  }
}

Future<TopSalesWeekly?> fetchTopSalesWeeklyService() async {
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/top_sales/weekly");

  try {
    var jsonCall = await AuthFetch.get(
      url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final topSalesWeekly = topSalesWeeklyFromJson(utf8.decode(jsonResponse));

      return topSalesWeekly;
    }
    return Future.error(
        'Error get top sales : b2c/api/v1/home/top_sales/weekly');
  } catch (e) {
    return Future.error('Error : fetchTopSalesWeekly $e');
  }
}
