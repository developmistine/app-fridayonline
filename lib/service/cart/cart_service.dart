import 'dart:convert';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/model/cart/cart_getItems.dart';
import 'package:fridayonline/model/cart/cart_model.dart';
import 'package:fridayonline/model/cart/getsupplierDelivery.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../../model/set_data/set_data.dart';

// ?call ItemCartEdit
Future<ItemCartEdit?> CartService(
    campaign,
    billCode,
    qty,
    action,
    billType,
    brand,
    mediaCode,
    channel,
    channelId,
    String contentType,
    String contentId) async {
  try {
    SetData data = SetData();
    var enduserId = await data.enduserId;
    var checkType = await data.repType;
    var device = await data.device;

    var url = Uri.parse("${base_api_app}api/v1/cart/EditsCart");
    var jsonInsert = jsonEncode({
      "TokenApp":
          checkType == '2' || checkType == '3' ? await data.repSeq : enduserId,
      "TokenOrder": "",
      "RepCode": await data.repCode,
      "RepSeq":
          checkType == '2' || checkType == '3' ? await data.repSeq : enduserId,
      "RepType": await data.repType,
      "Campaign": campaign,
      "BillCode": billCode,
      "Qty": qty,
      "Action": action,
      "BillType": billType,
      "Brand": brand,
      "MediaCode": mediaCode,
      "Device": device,
      "language": await data.language,
      "channel": channel,
      "channelId": channelId,
      "RepName": await data.repName,
      "SessionId": await data.sessionId,
      "Channel1": "app",
      "DeviceType": await data.device,
      "DeviceToken": await data.tokenId == "null" ? "" : await data.tokenId,
      "ContentType": contentType,
      "ContentId": contentId
    });
    printWhite(jsonInsert);
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;

      ItemCartEdit cartItems = itemCartEditFromJson(json);
      return cartItems;
    } else {
      if (kDebugMode) {
        print('message error cart');
      }
    }
  } catch (e) {
    print(e);
    if (kDebugMode) {
      print("message error form cart edit is $e");
    }
    return null;
  }
  return null;
}

// ?call get items cart
Future<ItemsGetCart?> getCartService() async {
  SetData data = SetData();
  var enduserId = await data.enduserId;
  var checkType = await data.repType;
  try {
    var url = Uri.parse("${base_api_app}api/v2/cart/GetCart");
    var jsonInsert = jsonEncode({
      "RepSeq":
          checkType == '2' || checkType == '3' ? await data.repSeq : enduserId,
      "RepCode": await data.repCode,
      "UserID":
          checkType == '2' || checkType == '3' ? await data.repSeq : enduserId,
      "RepType": await data.repType,
      "language": await data.language,
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;

      ItemsGetCart itemsGetCart = itemsGetCartFromJson(json);
      return itemsGetCart;
    }
  } catch (e) {
    return Future.error('Error: getCartService() $e');
  }
  return null;
}

// ?GetSupplierDelivery
Future<GetSupplierDelivery?> getSupplierDeliveryService(
    String supplierCode) async {
  SetData data = SetData();
  var enduserId = await data.enduserId;
  var checkType = await data.repType;
  try {
    var url = Uri.parse("${base_api_app}api/v1/cart/GetSupplierDelivery");
    var jsonInsert = jsonEncode({
      "RepSeq": checkType == '2' ? await data.repSeq : enduserId,
      "RepCode": await data.repCode,
      "UserID": checkType == '2' ? await data.repSeq : enduserId,
      "RepType": await data.repType,
      "SupplierCode": supplierCode,
      "language": await data.language,
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;

      final getSupplierDelivery = getSupplierDeliveryFromJson(json);
      return getSupplierDelivery;
    }
  } catch (e) {
    return Future.error('Error: getSupplierDelivery() $e');
  }
  return null;
}
