import 'dart:convert';
import 'dart:typed_data';
import 'package:fridayonline/enduser/models/brands/brands.model.dart';
import 'package:fridayonline/enduser/models/brands/shopbanner.model.dart';
import 'package:fridayonline/enduser/models/brands/shopcategory.model.dart';
import 'package:fridayonline/enduser/models/brands/shopcontent.model.dart';
import 'package:fridayonline/enduser/models/brands/shopfilter.model.dart';
import 'package:fridayonline/enduser/models/brands/shopflashsale.model.dart';
import 'package:fridayonline/enduser/models/brands/shopinfo.model.dart';
import 'package:fridayonline/enduser/models/brands/shopvouchers.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<BrandsList?> fetchBrandsServices(String pageType, int categoryId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/brands");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "page_type": pageType,
          "device": await data.device,
          "category_id": categoryId,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final brandsList = brandsListFromJson(utf8.decode(jsonResponse));
      return brandsList;
    }
    return Future.error('Error get home brands : b2c/api/v1/home/brands');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<BrandsList?> fetchShopBrandsServices(shopId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/shops/brands");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final brandsList = brandsListFromJson(utf8.decode(jsonResponse));
      return brandsList;
    }
    return Future.error('Error get shop brands : b2c/api/v1/home/brands');
  } catch (e) {
    return Future.error('Error get shop brands : $e');
  }
}

Future<ShopsVouchers?> fetchShopCouponServices(shopId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/shops/vouchers");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final shopsVouchers = shopsVouchersFromJson(utf8.decode(jsonResponse));
      return shopsVouchers;
    }
    return Future.error('Error get shop vouchers : b2c/api/v1/shops/vouchers');
  } catch (e) {
    return Future.error('Error get shop vouchers : $e');
  }
}

Future<ShopInfo?> fetchShopInfoServices(int shopId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/shops/info");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final shopInfo = shopInfoFromJson(utf8.decode(jsonResponse));
      return shopInfo;
    }
    return Future.error('Error get shop info : b2c/api/v1/shops/info');
  } catch (e) {
    return Future.error('Error get shop info : $e');
  }
}

Future<ShopsFlashSale?> fetchShopFlashSaleServices(
    int shopId, int limit, int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/shops/flash_sales");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "limit": limit,
          "offset": offset,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final shopsFlashSale = shopsFlashSaleFromJson(utf8.decode(jsonResponse));
      return shopsFlashSale;
    }
    return Future.error(
        'Error get shop flashsale : b2c/api/v1/shops/flash_sales');
  } catch (e) {
    return Future.error('Error get shop flashsale : $e');
  }
}

Future<ShopContent?> fetchShopContentServices(int shopId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/shops/content");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final shopContent = shopContentFromJson(utf8.decode(jsonResponse));

      return shopContent;
    }
    return Future.error('Error get shop info : b2c/api/v1/shops/info');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<ShopCategory?> fetchShopCategoryServices(int shopId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/shops/categories");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final shopCategory = shopCategoryFromJson(utf8.decode(jsonResponse));

      return shopCategory;
    }
    return Future.error(
        'Error get shop category : b2c/api/v1/shops/categories');
  } catch (e) {
    return Future.error('Error b2c/api/v1/shops/categories : $e');
  }
}

Future<ShopBanner?> fetchShopBannerServices() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/shops/banner");

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
      final shopBanner = shopBannerFromJson(utf8.decode(jsonResponse));
      return shopBanner;
    }
    return Future.error('Error get shop banner : b2c/api/v1/shops/banner');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<ShopProductFilter?> fetchShopProductFilterServices(
  int sectionId,
  int shopId,
  String sortBy,
  String orderBy,
  int offset,
) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/shops/product_filters");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "section_id": sectionId,
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "sort_by": sortBy, // ctime
          "order": orderBy,
          "limit": 40,
          "offset": offset,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final shopProductFilter =
          shopProductFilterFromJson(utf8.decode(jsonResponse));

      return shopProductFilter;
    }
    return Future.error(
        'Error get shop product filter : b2c/api/v1/shops/product_filters');
  } catch (e) {
    return Future.error('Error b2c/api/v1/shops/product_filters : $e');
  }
}
