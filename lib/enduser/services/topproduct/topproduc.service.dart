import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/home/home.topproduct.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<TopProductsWeekly?> fetchTopProductsService(productLineId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/products/top_products/weekly");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "prodline_id": productLineId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final topProductsWeekly =
          topProductsWeeklyFromJson(utf8.decode(jsonResponse));

      return topProductsWeekly;
    }
    return Future.error(
        'Error get top producs : b2c/api/v1/products/top_products/weekly');
  } catch (e) {
    return Future.error('Error : fetchTopProductsService $e');
  }
}
