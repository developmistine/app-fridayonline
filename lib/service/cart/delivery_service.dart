import 'dart:convert';
// import 'dart:developer';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

// import '../../homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../../model/cart/delivery_change.dart';
import '../../model/set_data/set_data.dart';

// ? controller for change delivery
Future<ChangeDelivery?> changeDeliver(
    // ignore: non_constant_identifier_names
    TotalAmount) async {
  // log(TotalAmount.toString());
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/cart/GetDetailDelivery");
    var jsonInsert = jsonEncode({
      "TokenApp": await data.tokenId,
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "TotalAmount": TotalAmount,
      "device": await data.device,
      "language": await data.language,
      "UserID": await data.enduserId,
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      ChangeDelivery dataChange = changeDeliveryFromJson(json);
      return dataChange;
    }
  } catch (e) {
    print("erroor delivery is $e");
  }
  return null;
}
