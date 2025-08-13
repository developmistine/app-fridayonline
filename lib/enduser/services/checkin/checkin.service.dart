import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/checkin/checkin.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<CheckInData> fetchCheckInDataService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/activity/checkin/data");
  SetData data = SetData();
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final checkInData = checkInDataFromJson(utf8.decode(jsonResponse));
      return checkInData;
    }
    return Future.error(
        'Error fetchCheckInDataService : api/v1/activity/checkin/data');
  } catch (e) {
    return Future.error('Error fetchCheckInDataService: $e');
  }
}

Future collectCoinsService(int point) async {
  var url = Uri.parse("${b2c_api_url}api/v1/activity/checkin/collect_coins");
  SetData data = SetData();
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "points": point,
        }));
    if (jsonCall.statusCode == 200) {
      var jsonResponse = jsonDecode(jsonCall.body);
      return jsonResponse["code"];
    }
    return Future.error(
        'Error collectCoinsService : api/v1/activity/checkin/collect_coins');
  } catch (e) {
    return Future.error('Error collectCoinsService: $e');
  }
}
