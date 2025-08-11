import 'dart:convert';
// import 'dart:developer';

import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

// import '../../../model/cart/get_ms_cart_info..dart';
import '../../../model/cart/get_ms_cart_stock.dart';
import '../../../model/set_data/set_data.dart';

// ? controller for get message info
Future<GetMessageCartStock?> getMessageStock() async {
  // log(TotalAmount.toString());
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/cart/popup/GetStockMessage");
    // "${baseurl_home}api/mslfightcovid/GetMessageCartStock/type/value");
    var jsonInsert = jsonEncode({
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "UserId": "",
      'language': await data.language,
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
      GetMessageCartStock getMessageCart = getMessageCartStockFromJson(json);
      return getMessageCart;
    }
  } catch (e) {
    print("erroor delivery is $e");
  }
  return null;
}
