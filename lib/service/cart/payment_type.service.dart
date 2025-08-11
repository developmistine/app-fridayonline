import 'dart:convert';

import 'package:fridayonline/model/payment_type/payment_type.model.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

import '../../model/set_data/set_data.dart';

Future<PaymentType?> paymentType() async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/payment/msl");
    var jsonInsert = jsonEncode({
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;

      final paymentType = paymentTypeFromJson(json);
      return paymentType;
    }
  } catch (e) {
    print(e);
  }
  return null;
}
