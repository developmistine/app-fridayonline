import 'dart:convert';

import 'package:fridayonline/model/cart/cart_cheer.dart';
import 'package:fridayonline/model/cart/cart_cheer_banner.dart';
import 'package:fridayonline/model/cart/cart_sale_by_repseq.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// CheerCart cheerCartFromJson
Future<CheerCart?> cartCheering(camp, totalAmt) async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/salescheering/Conditions");
    var jsonInsert = jsonEncode({
      "rep_seq": await data.repSeq,
      "rep_code": await data.repCode,
      "rep_type": await data.repType,
      "campaign": camp,
      "total_amount": totalAmt,
    });
    // log(jsonInsert);
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      final cheerCart = cheerCartFromJson(json);
      return cheerCart;
    }
  } catch (e) {
    debugPrint("error cheer cart api/v1/salescheering/Conditions are $e");
  }
  return null;
}

Future<List<Saleproductbyrepseq>?> saleProductByRepSeq(camp) async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/salescheering/Products");
    var jsonInsert = jsonEncode({
      "rep_seq": await data.repSeq,
      "rep_code": await data.repCode,
      "rep_type": await data.repType,
      "campaign": camp,
    });
    // log(jsonInsert);
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      // log(json);
      final saleproductbyrepseq = saleproductbyrepseqFromJson(json);
      return saleproductbyrepseq;
    }
  } catch (e) {
    debugPrint("error cheer cart api/v1/salescheering/Products are $e");
  }
  return null;
}

Future<CartCheerBanner?> cartCheeringBanner(camp) async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/salescheering/Banner");
    var jsonInsert = jsonEncode({
      "rep_seq": await data.repSeq,
      "rep_code": await data.repCode,
      "rep_type": await data.repType,
      "campaign": camp,
    });
    // log(jsonInsert);
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      final cheerCartBanner = cartCheerBannerFromJson(json);
      return cheerCartBanner;
    }
  } catch (e) {
    debugPrint("error cheer cart api/v1/salescheering/Banner are $e");
  }
  return null;
}
