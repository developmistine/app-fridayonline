import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/member/models/notify/notify.count.model.dart';
import 'package:fridayonline/member/models/notify/notify.group.model.dart';
import 'package:fridayonline/member/models/notify/notify.model.dart';
import 'package:fridayonline/member/utils/auth_fetch.dart';

import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<CountNotify> fetchNotifyCountService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/notify/count");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final countNotify = countNotifyFromJson(utf8.decode(jsonResponse));

      return countNotify;
    }
    return Future.error('Error fetchNotifyCountService : api/v1/notify/count');
  } catch (e) {
    return Future.error('Error fetchNotifyCountService: $e');
  }
}

Future<NotifyGroup> fetchNotifyGroupService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/notify/group");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          // "cust_id": 1,
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final notifyGroup = notifyGroupFromJson(utf8.decode(jsonResponse));

      return notifyGroup;
    }
    return Future.error('Error fetchNotifyGroupService : api/v1/notify/group');
  } catch (e) {
    return Future.error('Error fetchNotifyGroupService: $e');
  }
}

Future<B2CNotify> fetchNotifyService(int groupId, int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/notify");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          // "cust_id": 1,
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "limit": 20,
          "group_id": groupId,
          "offset": offset,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final b2CNotify = b2CNotifyFromJson(utf8.decode(jsonResponse));

      return b2CNotify;
    }
    return Future.error('Error fetchNotifyService : api/v1/notify');
  } catch (e) {
    return Future.error('Error fetchNotifyService: $e');
  }
}

Future readStatusNotifyService(int groupId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/notify/read_status");

  try {
    var jsonCall = await AuthFetch.patch(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          // "cust_id": 1,
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "group_id": groupId,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      var readStatus = jsonCall.body;

      return readStatus;
    }
    return Future.error(
        'Error readStatusNotifyService : api/v1/notify/read_status');
  } catch (e) {
    return Future.error('Error readStatusNotifyService: $e');
  }
}

Future<B2CNotify> fetchNotifyOrderTrackingService(
    int groupId, int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/notify");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          // "cust_id": 1,
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "limit": 20,
          "group_id": groupId,
          "offset": offset,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final notifyOrderTracking = b2CNotifyFromJson(utf8.decode(jsonResponse));

      return notifyOrderTracking;
    }
    return Future.error('Error fetchNotifyOrderTracking : api/v1/notify');
  } catch (e) {
    return Future.error('Error fetchNotifyOrderTracking: $e');
  }
}

Future<NotifyOrderRead> fetchNotifyReadService(
    int notifyId, bool isReadAll) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/notify/order_read");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "order_notify_id": notifyId,
          "is_read_all": isReadAll
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;

      final notifyOrderRead =
          notifyOrderReadFromJson(utf8.decode(jsonResponse));
      return notifyOrderRead;
    }
    return Future.error(
        'Error fetchNotifyReadService : api/v1/notify/order_read');
  } catch (e) {
    return Future.error('Error fetchNotifyReadService: $e');
  }
}

NotifyOrderRead notifyOrderReadFromJson(String str) =>
    NotifyOrderRead.fromJson(json.decode(str));

String notifyOrderReadToJson(NotifyOrderRead data) =>
    json.encode(data.toJson());

class NotifyOrderRead {
  String code;
  String message;

  NotifyOrderRead({
    required this.code,
    required this.message,
  });

  factory NotifyOrderRead.fromJson(Map<String, dynamic> json) =>
      NotifyOrderRead(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
