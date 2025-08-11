import 'dart:convert';
import 'package:fridayonline/model/check_information/payment/get_payment_enduser.dart';
import 'package:fridayonline/model/check_information/payment/get_payment_msl.dart';
import 'package:fridayonline/model/check_information/payment/main_payment.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
import 'package:fridayonline/service/paymentsystem/paymentobject.dart';
import 'package:intl/intl.dart';

import '../../model/set_data/set_data.dart';

// เป็นส่วนที่ดำเนินการ Call ไปที่ Api
Future<Objectpayment> paymentService(
    String repcode, String amount, String transDate) async {
  SetData data = SetData();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyMMdd');
  final String formatted = formatter.format(now);
  String date2 = formatted;
  String addStr = "0000000000${await data.repSeq}";
  String lastNineDigits = addStr.substring(addStr.length - 9);
  String repSeqDate = lastNineDigits + date2;

  // กรณีที่ทำการ Call  API
  String billerID = '010553102726481';

  // String Ref1 = '005486041220921';
  String merchantID = 'YUP';

  var url = Uri.parse("${base_api_app}api/v1/memberinfo/QRPayment");
  // var url = Uri.parse(
  //     "${baseurl_yupinmodern}api/yupininitial/PaymentOnline/type/value");
  var jsonData = jsonEncode({
    'BillerID': billerID,
    'Ref1': repSeqDate,
    'Ref2': repcode,
    'MerchantID': merchantID,
    'Amount': double.parse(amount),
    'RefType': '12',
    'TransDate': int.parse(transDate),
  });
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  Objectpayment objectpayment = objectpaymentFromJson(jsonResponse);
  // ระบบ Return Objet ออกจากระบบ
  return objectpayment;
}

// call main page payment
Future<MainPayment> paymentMainpage() async {
  SetData data = SetData();
  var url = Uri.parse("${base_api_app}api/v1/payment/MainPayment");
  var jsonData = jsonEncode({
    "RepSeq": await data.repSeq,
    "RepCode": await data.repCode,
    "RepType": await data.repType,
    "language": await data.language,
    "Device": await data.device,
  });
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  return mainPaymentFromJson(jsonResponse);
}

// call payment msl
Future<List<GetMslPayment>> getPaymentMsl() async {
  SetData data = SetData();
  var url = Uri.parse("${base_api_app}api/v2/payment/GetMslPayment");
  // var url = Uri.parse("${base_api_app}api/v1/payment/GetMslPayment");
  var jsonData = jsonEncode({
    "RepSeq": await data.repSeq,
    "RepCode": await data.repCode,
    "RepType": await data.repType,
    "language": await data.language,
    "Device": await data.device,
  });
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;

  return getMslPaymentFromJson(jsonResponse);
}

// call payment enduser
Future<GetEnduserPayment> getPaymentEndUser() async {
  SetData data = SetData();
  var url = Uri.parse("${base_api_app}api/v2/payment/GetEnduserPayment");
  var jsonData = jsonEncode({
    "RepSeq": await data.repSeq,
    "RepCode": await data.repCode,
    "RepType": await data.repType,
    "language": await data.language,
    "Device": await data.device,
  });
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  return getEnduserPaymentFromJson(jsonResponse);
}
