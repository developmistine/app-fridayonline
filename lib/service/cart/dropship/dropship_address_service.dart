import 'dart:convert';
// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../model/cart/dropship/drop_ship_address.dart';
import '../../../model/cart/dropship/dropship_msg.dart';
import '../../../model/set_data/set_data.dart';

// DropshipGetAddress dropshipGetAddressFromJson
// ? controller for get dropship address
Future<DropshipGetAddress?> getDropshipAddress() async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${baseurl_home}api/Dropship/GetAddress/type/value");
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
      DropshipGetAddress dropshipAddress = dropshipGetAddressFromJson(json);
      // printWhite(dropshipAddress.toJson());
      return dropshipAddress;
    }
  } catch (e) {
    if (kDebugMode) {
      print("erroor dropship is $e");
    }
  }
  return null;
}

//? controller for edit address dropship
// DropshipMsg dropshipMsgFromJson
Future<DropshipMsg?> editDropshipAddress(
    action,
    addressId,
    addressType,
    nameResive,
    mobileNo,
    addressL1,
    nameTumbon,
    nameAmphur,
    nameProvince,
    postCode) async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${baseurl_home}api/Dropship/EditAddress/type/value");
    var jsonInsert = jsonEncode({
      "RepCode": await data.repCode,
      "RepSeq": await data.repSeq,
      "RepType": await data.repType,
      "Action": action, // I(insert) ,E(edits) ,D(delete)
      "AddressId": addressId, //insert ไม่ต้องส่ง
      "AddressType": addressType, // 1 =  ที่อยู่หลัก / 2 = ที่อยู๋อื่นๆ
      "NameReceive": nameResive,
      "MobileNo": mobileNo,
      "AddressLine1": addressL1,
      "AddressLine2": "",
      "NameTumbon": nameTumbon,
      "NameAmphur": nameAmphur,
      "NameProvince": nameProvince,
      "PostCode": postCode
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (res.statusCode == 200) {
      final json = res.body;
      DropshipMsg dropmsg = dropshipMsgFromJson(json);
      return dropmsg;
    }
  } catch (e) {
    if (kDebugMode) {
      print("erroor dropship is $e");
    }
  }
  return null;
}

Future<DropshipMsg?> setMainAddressDropship(addressId) async {
  SetData data = SetData();
  try {
    var url = Uri.parse(
        "${baseurl_home}api/Dropship/SetMainDeliveryAddress/type/value");
    var jsonInsert = jsonEncode({
      "RepCode": await data.repCode,
      "RepSeq": await data.repSeq,
      "RepType": await data.repType,
      "AddressId": addressId
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (res.statusCode == 200) {
      final json = res.body;
      DropshipMsg dropmsg = dropshipMsgFromJson(json);
      return dropmsg;
    }
  } catch (e) {
    if (kDebugMode) {
      print("erroor dropship is $e");
    }
  }
  return null;
}
