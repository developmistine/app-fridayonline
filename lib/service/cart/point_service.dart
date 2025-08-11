import 'dart:convert';
// import 'dart:developer';

import 'package:fridayonline/model/cart/point_member.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

import '../../model/set_data/set_data.dart';

// ? controller for call point or starrewards
Future<PointMember?> GetPoint() async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/cart/MslUsePoint");
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

      PointMember pointMember = pointMemberFromJson(json);
      return pointMember;
    }
  } catch (e) {
    debugPrint("error point is $e");
  }
  return null;
}
