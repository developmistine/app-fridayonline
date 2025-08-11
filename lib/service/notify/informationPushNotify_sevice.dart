// !call group menu Category

import 'dart:convert';
// import 'dart:developer';

import 'package:fridayonline/model/notify/informationPushPromotionGroup.dart';
import 'package:fridayonline/model/push/pam_push_history.dart';
import 'package:flutter/material.dart';
import '../../model/notify/informationPushPromotionIndex.dart';
import '../../model/notify/informationpush.dart';
import '../../model/set_data/set_data.dart';
import '../pathapi.dart';
import 'package:http/http.dart' as http;

Future<InformationPushNotify?> Information_Push() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/notify/GetNotify");
    // var url = Uri.parse(
    //     "${baseurl_yupinmodern}api/yupininitial/GetAllPush/type/value");
    var jsonInsert = jsonEncode({
      "TokenID": await data.tokenId,
      "repCode": await data.repCode,
      "repSeq": await data.repType == '2' || await data.repType == '3'
          ? await data.repSeq
          : await data.enduserId,
      "repType": await data.repType,
      "parameterID": "",
      "language": await data.language,
      "Device": await data.device
    });

    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;
      // log(result);
      var pInformationPush = informationPushNotifyFromJson(result);

      // log(pInformationPush.informationPushNotify.toString());

      return pInformationPush;
    } else {
      ///error
    }
  } catch (e) {
    print('Error Information_Push => $e');
    var json = jsonEncode({"InformationPushNotify": []});
    var pInformationPush = informationPushNotifyFromJson(json);
    return pInformationPush;
  }
  return null;
}

Future<String?> GetYupinActivity(typename) async {
  SetData data = SetData(); //เรียกใช้ model
  // print(await data.language);

  try {
    var url = Uri.parse("${base_api_app}api/v1/notify/$typename");
    // "${baseurl_yupinmodern}api/yupininitial//type/value");
    var jsonInsert = jsonEncode({
      "TokenID": await data.tokenId,
      "repCode": await data.repCode,
      "repSeq": await data.repType == '2' || await data.repType == '3'
          ? await data.repSeq
          : await data.enduserId,
      "repType": await data.repType,
      "parameterID": "",
      "language": await data.language,
      "Device": await data.device
    });

    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;
      var jsonString = jsonDecode(result);
      return jsonString['URL'];
    } else {
      ///error
    }
  } catch (e) {
    print(e);
    return null;
  }
  return null;
}

Future<InformationPushPromotionGroup?> Information_Push_PromotionList(
    {required String idparm, required String typedataapi}) async {
  SetData data = SetData(); //เรียกใช้ model

  Uri url;
  try {
    if (typedataapi == "GetPromotionGroup") {
      url = Uri.parse("${base_api_app}api/v1/notify/GetAllNotifyPromotion");
    } else {
      //   url = Uri.parse(
      //       "${baseurl_yupinmodern}api/yupininitial/GetPromotionIndex/type/value");
      url = Uri.parse("${base_api_app}api/v1/notify/GetNotifyPromotion");
    }

    var jsonInsert = jsonEncode({
      "TokenID": await data.tokenId,
      "repCode": await data.repCode,
      "repSeq": await data.repType == '2' || await data.repType == '3'
          ? await data.repSeq
          : await data.enduserId,
      "repType": await data.repType,
      "Device": await data.device,
      "parameterID": idparm,
      "language": await data.language,
    });

    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;
      // log(result);

      var pInformationGroup = informationPushPromotionGroupFromJson(result);
      return pInformationGroup;
    } else {
      ///error
    }
  } catch (e) {
    return null;
  }
  return null;
}

Future<InformationPushPromotionIndex?> Information_Push_PromotionIndex(
    {required String idparm, required String typedataapi}) async {
  SetData data = SetData(); //เรียกใช้ model

  try {
    var url = Uri.parse(
        "${baseurl_yupinmodern}api/yupininitial/$typedataapi/type/value");
    var jsonInsert = jsonEncode({
      "TokenID": await data.tokenId,
      "repCode": await data.repCode,
      "repSeq": await data.repType == '2' || await data.repType == '3'
          ? await data.repSeq
          : await data.enduserId,
      "repType": await data.repType,
      "Device": await data.device,
      "parameterID": idparm,
      "language": await data.language,
    });

    var response = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;

      var pInformationPushPromotionIndex =
          informationPushPromotionIndexFromJson(result);
      return pInformationPushPromotionIndex;
    } else {
      ///error
    }
  } catch (e) {
    return null;
  }
  return null;
}

Future<ListPamPushHistory?> pamPushHistory() async {
  SetData data = SetData();
  if (await data.repType == "2") {
    try {
      var urlConfig = Uri.parse("${base_api_app}api/v1/config/GetPamConfig");
      var responseConfig = await http.get(urlConfig, headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      });
      var dataConfig = json.decode(responseConfig.body);
      var url = Uri.parse(
          "https://mistine.pams.ai/api/app-notifications?_database=${dataConfig["NotiDatabase"]}&customer=${await data.repSeq}");
      var request = http.Request('GET', url);
      http.StreamedResponse responseData = await request.send();
      if (responseData.statusCode == 200) {
        var response = await responseData.stream.bytesToString();
        var pInformationPush = listPamPushHistoryFromJson(response);
        return pInformationPush;
      } else {
        var json = jsonEncode({"items": []});
        var pInformationPush = listPamPushHistoryFromJson(json);
        return pInformationPush;
      }
    } catch (e) {
      debugPrint('Error Information_Push => $e');
      var json = jsonEncode({"items": []});
      var pInformationPush = listPamPushHistoryFromJson(json);
      return pInformationPush;
    }
  } else {
    var json = jsonEncode({"items": []});
    var pInformationPush = listPamPushHistoryFromJson(json);
    return pInformationPush;
  }
}
