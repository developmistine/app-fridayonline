import 'dart:convert';
import 'package:fridayonline/model/cart/enduser/enduser_add_data.dart';
import 'package:fridayonline/model/cart/enduser/enduser_address.dart';
import 'package:fridayonline/model/cart/enduser/enduser_getdetails_delivery.dart';
import 'package:fridayonline/model/cart/enduser/success_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../model/set_data/set_data.dart';
import '../../pathapi.dart';

Future<EndUserAddress?> getEnduserAddress() async {
  try {
    SetData data = SetData();
    var url = Uri.parse("${base_api_app}api/v1/memberinfo/enduser/MyAddress");
    var jsonInsert = jsonEncode({"enduser_id": await data.enduserId});

    // log(jsonInsert);
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      EndUserAddress cartItems = endUserAddressFromJson(json);
      return cartItems;
    } else {
      debugPrint('message error cart address enduser');
    }
  } catch (e) {
    debugPrint('message error cart address enduser');
    return null;
  }
  return null;
}

Future<SuccessResponse?> manageEnduserAddress(json) async {
  try {
    // SetData data = SetData();
    var url = Uri.parse("${base_api_app}api/v1/memberinfo/enduser/Address");
    json as EndUserAddressData;
    json.enduserId = await SetData().enduserId;
    var jsonInsert = jsonEncode(json);
    // printWhite(jsonEncode(json));
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    // printWhite(res);

    if (res.statusCode == 200) {
      final json = res.body;
      SuccessResponse cartItems = successResponseFromJson(json);
      return cartItems;
    } else {
      debugPrint('message error cart address enduser');
    }
  } catch (e) {
    debugPrint("message error form cart address enduser is $e");
    return null;
  }
  return null;
}

Future<SuccessResponse?> deleteEnduserAddress(id) async {
  try {
    // SetData data = SetData();
    var url =
        Uri.parse("${base_api_app}api/v1/memberinfo/enduser/DeleteAddress");
    var jsonInsert = jsonEncode({
      "id": id,
    });

    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    // printWhite(res);

    if (res.statusCode == 200) {
      final json = res.body;
      SuccessResponse cartItems = successResponseFromJson(json);
      return cartItems;
    } else {
      debugPrint('message error cart address enduser');
    }
  } catch (e) {
    debugPrint("message error form cart address enduser is $e");
    return null;
  }
  return null;
}

Future<EnduserGetDetailDelivery?> enduserGetDetailDelivery(totalAmount) async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/cart/enduser/GetDetailDelivery");
    var jsonInsert = jsonEncode({
      "TokenApp": await data.tokenId,
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "TotalAmount": totalAmount,
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
      EnduserGetDetailDelivery dataChange =
          enduserGetDetailDeliveryFromJson(json);
      return dataChange;
    }
  } catch (e) {
    print("erroor enduser change delivery is ${e.toString()}");
  }
  return null;
}
