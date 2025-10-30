import 'dart:convert';

import 'package:fridayonline/member/models/check_version/check_version_app_model.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class CheckVersionAppService {
  static Future<CheckAppversion> checkVersionApp() async {
    SetData data = SetData();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currectVersion = packageInfo.version;
    String platform = await data.device;

    var url = Uri.parse(
        "${b2c_api_url}app/check_version?platform=$platform&version=$currectVersion");

    try {
      var jsonData = await http.get(url, headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8',
      });

      if (jsonData.statusCode == 200) {
        var jsonRes = jsonData.bodyBytes;
        final checkAppVersion = checkAppversionFromJson(
          utf8.decode(jsonRes),
        );

        return checkAppVersion;
      }
      return Future.error('Error check version : api/v1/app/version-check');
    } catch (e) {
      return Future.error('Error check version : $e');
    }
  }
}
