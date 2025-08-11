import 'dart:convert';

import '../../model/cart/dropship/dropship_status_addcart.dart';
import '../../model/cart/save_order.dart';
// import '../../model/set_data/set_data.dart';
import '../pathapi.dart';
import 'package:http/http.dart' as http;

Future<SaveOrder?> saveorderService(Map<String, dynamic> orderTotal) async {
  try {
    // SetData data = SetData(); dev_api_app
    var url = Uri.parse("${base_api_app}api/v1/cart/SaveOrder");
    // var url = Uri.parse("${dev_api_app}api/v1/cart/SaveOrder");
    var jsonInsert = jsonEncode({"OrderEndUser": orderTotal});

    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      SaveOrder cartItems = saveOrderFromJson(json);
      return cartItems;
    } else {
      print('message error cart SaveOrder');
    }
  } catch (e) {
    print("message error form cart SaveOrder is $e");
    return null;
  }
  return null;
}

Future<SaveOrder?> saveorderEndUserService(
    Map<String, dynamic> orderTotal) async {
  try {
    // SetData data = SetData(); dev_api_app
    var url = Uri.parse("${base_api_app}api/v1/cart/enduser/SaveOrder");
    var jsonInsert = jsonEncode({"OrderEndUser": orderTotal});
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      SaveOrder cartItems = saveOrderFromJson(json);
      return cartItems;
    } else {
      print('message error cart SaveOrder');
    }
  } catch (e) {
    print("message error form cart SaveOrder is $e");
    return null;
  }
  return null;
}

Future<CartDropshipStatus?> saveOrderDropship(
    Map<String, dynamic> dropshipConfirm) async {
  try {
    var url = Uri.parse("${baseurl_home}api/Dropship/ConfirmOrder/type/value");
    var jsonInsert = jsonEncode(dropshipConfirm);
    // printWhite(jsonInsert);
    // log(jsonInsert);
    var res = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      // printWhite(json);
      CartDropshipStatus cartDropship = cartDropshipStatusFromJson(json);
      // printWhite(cartDropship.toJson());
      return cartDropship;
    } else {
      // printWhite('message error cart');
    }
  } catch (e) {
    // printWhite("message error form cart edit is $e");
    return null;
  }
  return null;
}
