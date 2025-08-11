// ignore_for_file: body_might_complete_normally_nullable

import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;
import './models/push_message.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class PamPushNotificationAPI {
  PamPushNotificationAPI();

  Future<List<PamPushMessage>?> read(String? pixel) async {
    if (pixel != null) {
      var uri = Uri.parse(pixel);
      await http.get(uri);
    }
  }

  Future<List<PamPushMessage>?> loadPushNotificationsFromCustomerID(
      String customer) async {
    Response? response;

    try {
      var urlConfig = Uri.parse("${base_api_app}api/v1/config/GetPamConfig");
      var responseConfig = await http.get(urlConfig, headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      });
      var dataConfig = json.decode(responseConfig.body);
      var uri = Uri.parse(
          "${dataConfig["BaseAPIUrl"]}/api/app-notifications?_database=${dataConfig["DatabaseAlias"]}&customer=$customer");
      response = await http.get(uri);
    } catch (e) {
      debugPrint("\n\n🦄🦄🦄🦄🦄 ERROR 🦄🦄🦄🦄🦄🦄");
      debugPrint(e.toString());
    }

    if (response != null) {
      return PamPushMessage.parse(utf8.decode(response.bodyBytes));
    }

    return null;
  }
}
