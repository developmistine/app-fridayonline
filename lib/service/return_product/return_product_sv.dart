// HistoryBySeq

import 'dart:convert';

import '../../model/check_information/order_history/get_history_invoice.dart';
import '../../model/return_product/history_all.dart';
import '../../model/return_product/history_by_seq.dart';
import '../../model/return_product/return_detail.dart';
import '../../model/set_data/set_data.dart';
import 'package:http/http.dart' as http;
import '../pathapi.dart';

Future<GetProductByInvioce?> getProductByInvoice(invoiceNo) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v2/return/GetProductByInvoice");
    // Uri.parse("${base_api_app}api/v1/dropship/GetDropshipOrderHistory");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "InvNo": invoiceNo,
      "language": await data.language,
      "Token": await data.tokenId,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    GetProductByInvioce? productByinvoice =
        getProductByInvioceFromJson(jsonResponse);
    // log('productByinvoice is $productByinvoice');
    return productByinvoice;
  } catch (e) {
    print('Error function >>getProductByInvoice<< is $e');
  }
  return null;
}

Future<StatusReturn?> returnProductService(ReturnProductJson json) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v2/return/Product");
    json.repcode = await data.repCode;
    json.repseq = await data.repSeq;
    json.device = await data.device;
    var jsonData = jsonEncode(json);

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    StatusReturn? status = statusReturnFromJson(jsonResponse);
    return status;
  } catch (e) {
    print('Error function >>ReturnProductService<< is $e');
  }
  return null;
}

Future<List<HistoryReturnAll>?> getHistoryAll() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v2/return/HistoryProduct");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "language": await data.language,
      "Token": await data.tokenId,
      "Device": await data.device
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    List<HistoryReturnAll>? status = historyReturnAllFromJson(jsonResponse);
    if (status.isEmpty) {
      const json = [
        {
          "seq_no": "1",
          "status": "1",
          "invoice": "1100500074",
          "cre_date": "24 พ.ค. 66 16:51",
          "camp_date": "08/2023",
          "total_all": "1 รายการ, 1 ชิ่้น",
          "amount": 89
        }
      ];
      return historyReturnAllFromJson(jsonEncode(json));
    }
    return status;
  } catch (e) {
    print('Error function >>getHistoryAll<< is $e');
  }
  return null;
}

Future<HistoryReturnBySeq?> getHistoryBySeq(invoice, seqno) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v2/return/HistoryBySeq");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "seq_no": seqno,
      "InvNo": invoice,
      "language": await data.language,
      "Token": await data.tokenId,
      "Device": await data.device
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    HistoryReturnBySeq? status = historyReturnBySeqFromJson(jsonResponse);
    return status;
  } catch (e) {
    print('Error function >>ReturnProductService<< is $e');
  }
  return null;
}

Future<int> getBadger() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v2/return/GetBadger");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "language": await data.language,
      "Token": await data.tokenId,
      "Device": await data.device
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    return int.parse(jsonCall.body);
  } catch (e) {
    print('Error function >>getHistoryAll<< is $e');
  }
  return 0;
}

// class สำหรับ รับค่าจาก API
StatusReturn statusReturnFromJson(String str) =>
    StatusReturn.fromJson(json.decode(str));

String statusReturnToJson(StatusReturn data) => json.encode(data.toJson());

class StatusReturn {
  String code;
  String message1;
  String message2;
  String message3;

  StatusReturn({
    required this.code,
    required this.message1,
    required this.message2,
    required this.message3,
  });

  factory StatusReturn.fromJson(Map<String, dynamic> json) => StatusReturn(
        code: json["Code"],
        message1: json["Message1"],
        message2: json["Message2"],
        message3: json["Message3"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message1": message1,
        "Message2": message2,
        "Message3": message3,
      };
}
