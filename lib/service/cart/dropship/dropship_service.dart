import 'dart:convert';

// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../model/cart/dropship/dropship_model.dart';
import '../../../model/cart/dropship/dropship_status_addcart.dart';
import '../../../model/set_data/set_data.dart';

// ? controller for call dropship product
Future<Dropship?> getDropshipProduct() async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${baseurl_home}api/Dropship/GetCart/type/value");
    var jsonInsert = jsonEncode({
      "RepCode": await data.repCode,
      "RepSeq": await data.repSeq,
      "RepType": await data.repType,
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (res.statusCode == 200) {
      final json = res.body;
      Dropship dropship = dropshipFromJson(json);
      // printWhite(jsonEncode(dropship.cartHeader.cartDetail));
      return dropship;
    } else {
      return Dropship(
          cartHeader: CartHeader(
              cartDetail: [],
              repCode: '',
              repType: '',
              repSeq: '',
              totalAmount: 0,
              totalItem: 0));
    }
  } catch (e) {
    if (kDebugMode) {
      print("error dropship is $e");
    }
  }
  return null;
}

//? dropship edit cart
Future<CartDropshipStatus?> dropshipEditcart(billB2C, qty, action) async {
  try {
    SetData data = SetData();
    var url = Uri.parse('${baseurl_home}api/Dropship/EditCart/type/value');

    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "Language": await data.language,
      "BillB2C": billB2C,
      "Qty": qty,
      "Action": action
    });

    var res = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      CartDropshipStatus dropshipProduct = cartDropshipStatusFromJson(json);
      // printWhite(dropshipProduct.toJson());
      return dropshipProduct;
    }

    //? call เพื่อโชว?เทส
  } catch (e) {
    return null;
  }
  return null;
}
