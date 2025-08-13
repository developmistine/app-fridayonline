import 'dart:convert';
import 'dart:typed_data';

import 'package:appfridayecommerce/enduser/models/showproduct/product.category.model.dart';
import 'package:appfridayecommerce/enduser/utils/auth_fetch.dart';

import 'package:appfridayecommerce/preferrence.dart';
import 'package:appfridayecommerce/service/pathapi.dart';

Future<ProductContent?> fetchProductContentService(
    int actionType, String actionValue, int offset) async {
  // actionType 1 url
  // actionType 2 category
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/products/content");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "action_type": actionType,
          "action_value": actionValue == "" ? 0 : int.parse(actionValue),
          "limit": 10,
          "offset": offset
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final homeContent = productContentFromJson(utf8.decode(jsonResponse));
      return homeContent;
    }
    return Future.error(
        'Error get  product content : b2c/api/v1/products/content');
  } catch (e) {
    return Future.error('Error fetchProductContentService: $e');
  }
}
