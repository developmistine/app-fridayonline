import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:fridayonline/member/models/affiliate/contentType.model.dart';
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

  Future<ContentType?> getContentType() async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents/types");

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
        final response = contentTypeFromJson(utf8.decode(jsonString));
        return response;
      }
      return Future.error(
          'Error AffiliateService : api/v1/affiliate/contents/types');
    } catch (e) {
      print('error api/v1/affiliate/contents/types : $e');
      return Future.error("$e  from api/v1/affiliate/contents/types");
    }
  }

  Future<Response?> addProduct({
    required String tabType, // content , product , category
    required int contentId, // id ของ content หรือ category
    required int productId,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents/products");

    final payload = {
      "target_type": tabType,
      "id": contentId,
      "product_id": productId
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

  Future<Response?> createContent({
    required String type, // product, image, video, text
    required String name,
    String? text,
    List<Map<String, dynamic>>? products,
    List<File>? files,
  }) async {
    var url = Uri.parse("${b2c_api_url}api/v1/affiliate/contents");

    try {
      // final token = await _data.accessToken;
      final info = <String, dynamic>{
        "content_type": type,
        "content_name": name,
        if (type == "text") "display_text": (text ?? "").trim(),
        if (type == "product" && (products?.isNotEmpty ?? false))
          "products": products,
      };
      final fields = <String, String>{
        "info": jsonEncode(info),
      };

      // --- form-data: files ---
      final List<http.MultipartFile> parts = <http.MultipartFile>[];
      if (files != null && files.isNotEmpty) {
        final fieldKey = (type == "video") ? "video" : "image";
        for (final f in files) {
          parts.add(await http.MultipartFile.fromPath(fieldKey, f.path));
        }
      }

      var streamed = await AuthFetch.multipartRequestWithAuth(
        url,
        method: 'POST',
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        fields: fields,
        files: parts,
      );

      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return responseFromJson(body);
      }
      return Future.error(
        'Error AffiliateService : api/v1/affiliate/contents '
        '-> ${streamed.statusCode} : $body',
      );
    } catch (e) {
      print('error api/v1/affiliate/contents : $e');
      return Future.error("$e  from api/v1/affiliate/contents");
    }
  }
}
