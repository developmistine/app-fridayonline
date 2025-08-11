import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/flashsale/flashsale.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<B2CFlashSale?> fetchFlashSaleHomeService(int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}b2c/api/v1/home/flash_sales");

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
      final homeContent = b2CFlashSaleFromJson(utf8.decode(jsonResponse));
      return homeContent;
    }
    return Future.error('Error home flash sale : b2c/api/v1/home/flash_sales');
  } catch (e) {
    return Future.error('Error fetchFlashSaleHomeService : $e');
  }
}
