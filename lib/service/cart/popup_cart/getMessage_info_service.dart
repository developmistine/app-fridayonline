import 'dart:convert';
// import 'dart:developer';

import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

import '../../../model/cart/get_ms_cart_info..dart';
import '../../../model/set_data/set_data.dart';

// ? controller for get message info
Future<GetMessageCardinfo?> getMessageInfo(cartType, totalAmount) async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/cart/popup/GetMessage");
    // "${baseurl_home}api/mslfightcovid/GetMessageCartPopup/type/value");
    var jsonInsert = jsonEncode({
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "TotalAmount": totalAmount,
      'language': await data.language,
      "CartType": cartType
    });
    // log(jsonInsert.toString());
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      // log(json);
      GetMessageCardinfo getMessageCart = getMessageCardinfoFromJson(json);
      return getMessageCart;
    }
  } catch (e) {
    print("erroor popup cheer is $e");
  }
  return null;
}
