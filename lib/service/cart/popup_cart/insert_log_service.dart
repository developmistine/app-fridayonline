import 'dart:convert';
// import 'dart:developer';

import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

import '../../../model/cart/InsertLogEventCovid.dart';
import '../../../model/cart/insActionStockMessage_model.dart';
// import '../../../model/cart/insert_log_stock.dart' as stock;
import '../../../model/set_data/set_data.dart';

// ? controller for get message info
Future<Valuesinsert?> insertLogEventCovid(
    projectCode, amount, event, cartType) async {
  // log(TotalAmount.toString());
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/cart/popup/InsActionMessage");
    var jsonInsert = jsonEncode({
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "UserId": "",
      'language': await data.language,
      "ProjectCode": projectCode,
      "Amount": amount.toString(),
      "Event": event,
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
      Valuesinsert getMessageCart = valuesinsertFromJson(json);
      return getMessageCart;
    }
  } catch (e) {
    print("erroor log is $e");
  }
  return null;
}

// ? controller for get message stock
Future<InsActionStockMessage?> InsertLogCartStock(event) async {
  // log(TotalAmount.toString());
  SetData data = SetData();
  try {
    var url =
        Uri.parse("${base_api_app}api/v1/cart/popup/InsActionStockMessage");
    // "${baseurl_home}api/mslfightcovid/InsertLogCartStock/type/value");
    var jsonInsert = jsonEncode({
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "UserId": "",
      'language': await data.language,
      "Event":
          event, //Edit =ปิดป้อปอัพเพื่อสั่งซื้อต่อ,   Confirm=ยืนยันคำสั่งซื้อ
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
      InsActionStockMessage getMessageCart =
          insActionStockMessageFromJson(json);
      return getMessageCart;
    }
  } catch (e) {
    print("erroor delivery is $e");
  }
  return null;
}
