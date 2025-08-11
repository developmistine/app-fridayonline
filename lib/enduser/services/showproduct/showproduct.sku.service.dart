import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/showproduct/option.sku.dart';
import 'package:fridayonline/enduser/models/showproduct/product.category.model.dart';
import 'package:fridayonline/enduser/models/showproduct/product.sku.model.dart';
import 'package:fridayonline/enduser/models/showproduct/review.model.dart';
import 'package:fridayonline/enduser/models/showproduct/tier.variations.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<EndUserProductDetail?> fetchProductDetailService(productId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/products/detail");

  try {
    var jsonData = jsonEncode({
      "product_id": productId == "" ? 0 : int.parse(productId),
      "cust_id": await data.b2cCustID,
      "device": await data.device,
      "session_id": await data.sessionId,
    });

    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    if (jsonCall.statusCode == 200) {
      var jsonResponse = jsonCall.bodyBytes;

      final endUserProductDetail =
          endUserProductDetailFromJson(utf8.decode(jsonResponse));
      return endUserProductDetail;
    }
    return Future.error('Error get productdetail : b2c/api/v1/products/detail');
  } catch (e) {
    return Future.error('Error fetchProductDetailService : $e');
  }
}

Future<TierVariations?> fetchProductTierVariationService(
    EndUserProductOptions options) async {
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/products/detail/select");
  printWhite(jsonEncode(options));
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(options));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final tierVariations = tierVariationsFromJson(utf8.decode(jsonResponse));

      return tierVariations;
    }
    return Future.error(
        'Error get option productdetail : b2c/api/v1/products/detail/select');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<B2CReview?> fetchReivewSkuService(productId, type, limit, offset) async {
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/products/ratings");
  SetData data = SetData();
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "product_id": productId,
          "type": type,
          "limit": limit,
          "offset": offset,
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final b2CReview = b2CReviewFromJson(utf8.decode(jsonResponse));

      return b2CReview;
    }
    return Future.error(
        'Error get review productdetail : b2c/api/v1/products/review');
  } catch (e) {
    return Future.error('Error fetchReivewSkuService: $e');
  }
}

Future<ProductContent?> fetchProductRelateService(productId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/products/relate");

  try {
    var jsonData = jsonEncode({
      "product_id": productId == "" ? 0 : int.parse(productId),
      "cust_id": await data.b2cCustID,
      "device": await data.device,
      "session_id": await data.sessionId,
    });

    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    if (jsonCall.statusCode == 200) {
      var jsonResponse = jsonCall.bodyBytes;

      final relateProduct = productContentFromJson(utf8.decode(jsonResponse));
      return relateProduct;
    }
    return Future.error('Error get productdetail : b2c/api/v1/products/detail');
  } catch (e) {
    return Future.error('Error fetchProductDetailService : $e');
  }
}
