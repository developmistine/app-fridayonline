import 'dart:convert';
// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:flutter/material.dart';

import '../../model/product_detail/product_detail_model.dart';
import 'package:http/http.dart' as http;

import '../../model/set_data/set_data.dart';
import '../pathapi.dart';

Future<ProductDetailModel?> callProductDetails(
    campaign, billcode, media, sku, channel, channelId) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/product/GetProductDesc");

    var jsonData = jsonEncode({
      "fs_code": "",
      "bill_code": billcode,
      "bill_camp": campaign,
      "media": media,
      "rep_code": await data.repCode,
      "rep_seq": await data.repSeq,
      "rep_type": await data.repType,
      "channel": channel,
      "channel_id": channelId,
      "language": "TH",
      "device": await data.device,
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    // printWhite(jsonResponse);
    ProductDetailModel productDetail = productDetailModelFromJson(jsonResponse);

    return productDetail;
  } catch (e) {
    debugPrint("error product detail : $e");
  }
  return null;
}
