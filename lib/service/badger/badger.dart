// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:fridayonline/model/badger/badger_profile_msl.dart';

import '../../model/badger/badger_notification.dart';
import '../../model/badger/badger_profile_response.dart';
import '../../model/badger/badger_response.dart';
import '../../model/set_data/set_data.dart';
import '../../service/pathapi.dart';
import 'package:http/http.dart' as http;

Future<BadgerNotification> call_badger_notification() async {
  try {
    SetData data = SetData(); //เรียกใช้ model
    var url = Uri.parse("${base_api_app}api/v1/config/CountBadger");
    // var url = Uri.parse(
    //     "${baseurl_yupinmodern}api/yupininitial//GetCountBadGer/type/value");
    var jsonData = jsonEncode({
      "TokenID": await data.tokenId,
      "repCode": await data.repCode,
      "repSeq": await data.repSeq,
      "Device": await data.device,
      "repType": await data.repType,
      "ParameterID": ""
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    BadgerNotification notification = badgerNotificationFromJson(jsonResponse);
    return notification;
  } catch (e) {
    var json = jsonEncode({
      "CountBadgerPushNotify": [
        {"Status": "1", "Message": "success", "CountBadger": "0"}
      ]
    });
    BadgerNotification notification = badgerNotificationFromJson(json);
    return notification;
  }
}

Future<BadgerRespones> call_badger_update_push_notification() async {
  SetData data = SetData(); //เรียกใช้ model
  //print(await data.repCode);
  var url = Uri.parse("${base_api_app}api/v1/config/UpdatePushNotification");
  // var url = Uri.parse(
  //     "${baseurl_yupinmodern}api/yupininitial/UpdatePushNotification/type/value");
  var jsonData = jsonEncode({
    "Device": await data.device,
    "TokenID": await data.tokenId,
    "RepCode": await data.repCode,
    "RepSeq": await data.repSeq,
    "RepType": await data.repType,
    "ParameterID": "103",
    "language": await data.language
  });

  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;

  BadgerRespones badgerRespones = badgerResponesFromJson(jsonResponse);
  return badgerRespones;
}

Future<BadgerProfileMsl> call_badger_profile_msl() async {
  try {
    var userId = "";
    SetData data = SetData(); //เรียกใช้ model
    if (await data.repType == '1') {
      userId = await data.enduserId;
    }
    var url = Uri.parse("${base_api_app}api/v1/config/GetBadger");
    // var url =
    //     Uri.parse("${baseurl_pathapi}api/apiserviceyupin/GetBadger/type/value");
    var jsonData = jsonEncode({
      "RepSeq": await data.repSeq,
      "UserType": await data.repType,
      "UserId": userId
    });

    //sprint(jsonData);

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;

    //print(jsonCall.body);
    BadgerProfileMsl badgerProfile = badgerProfileMslFromJson(jsonResponse);
    return badgerProfile;
  } catch (e) {
    print('call_badger_profile_msl error');
    var json = jsonEncode({
      "?xml": {"@version": "1.0", "@encoding": "utf-8"},
      "ConfigFile": {
        "Badger": {
          "OrderManage": {"NewMessage": "0"},
          "CustomerList": {"NewMessage": "0"},
          "CustomerBundle": {"NewMessage": "0"},
          "Promotion": {"NewMessage": "0"},
          "OrderMSL": {"NewMessage": "0"},
          "ProDed": {"NewMessage": "0"}
        }
      }
    });
    BadgerProfileMsl badgerProfile = badgerProfileMslFromJson(json);
    return badgerProfile;
  }
}

Future<BadgerProfilResppnse> call_badger_update_profile(key) async {
  var userId = "";
  SetData data = SetData(); //เรียกใช้ model
  if (await data.repType == '1') {
    userId = await data.enduserId;
  }
  var url = Uri.parse("${base_api_app}api/v1/config/DeleteBadger");
  // var url =
  //     Uri.parse("${baseurl_pathapi}api/apiserviceyupin/ReadBadger/type/value");
  var jsonData = jsonEncode({
    "RepSeq": await data.repSeq,
    "UserType": await data.repType,
    "UserId": userId,
    "PushType": key
  });

  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;

  BadgerProfilResppnse badgerProfileResponse =
      badgerProfilResppnseFromJson(jsonResponse);
  return badgerProfileResponse;
}
