import 'dart:convert';

import 'package:fridayonline/member/models/affiliate/response.model.dart';
import 'package:fridayonline/member/models/affiliate/status.model.dart';
import 'package:fridayonline/member/models/affiliate/username.model.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/member/utils/auth_fetch.dart';

class AffiliateService {
  final _data = SetData();

  Future<AccountStatus?> checkStatus() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/account/status");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = accountStatusFromJson(utf8.decode(jsonString));

        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/account/status');
    } catch (e) {
      print('error api/v1/affiliate/account/status : $e');
      return Future.error("$e  from api/v1/affiliate/account/status");
    }
  }

  Future<UsernameAvailable?> checkUsername(String username) async {
    var url = Uri.parse(
        "${b2c_api_url}api/v1/affiliate/account/check_username?user_name=$username");

    try {
      var jsonCall = await AuthFetch.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = usernameAvailableFromJson(utf8.decode(jsonString));
        printJSON(response);
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/account/check_username');
    } catch (e) {
      print('error api/v1/affiliate/account/check_username : $e');
      return Future.error("$e  from api/v1/affiliate/account/check_username");
    }
  }

  Future<Response?> register({
    required String username,
    required String shopName,
    required String email,
    required String mobile,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/account/register");

    final payload = {
      "user_name": username,
      "store_name": shopName,
      "email": email,
      "moblie": mobile
    };

    try {
      var jsonCall = await AuthFetch.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await _data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(payload),
      );
      if (jsonCall.statusCode == 200) {
        var jsonString = jsonCall.bodyBytes;
        final response = responseFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/account/check_username');
    } catch (e) {
      print('error api/v1/affiliate/account/check_username : $e');
      return Future.error("$e  from api/v1/affiliate/account/check_username");
    }
  }
}
