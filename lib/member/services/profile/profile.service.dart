import 'dart:convert';
import 'dart:io';
import 'package:fridayonline/member/models/profile/profile_special.dart';
import 'package:fridayonline/member/utils/auth_fetch.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:http/http.dart' as http;

import '../../../service/pathapi.dart';
import '../../models/profile/profile_data.dart';

class ApiProfile {
  Future<ProfileData?> fetchProfile() async {
    SetData data = SetData();
    final url = Uri.parse("${b2c_api_url}api/v1/customer/info");

    try {
      final response = await AuthFetch.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
        }),
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedJson['code'] == "100") {
          return ProfileData.fromJson(decodedJson);
        } else {
          return Future.error(
              'Unexpected response code: ${decodedJson['code']}');
        }
      }

      return Future.error(
          'Error fetching profile: ${response.statusCode} - ${response.body}');
    } catch (e) {
      return Future.error('Exception in fetchProfile: $e');
    }
  }

  Future<void> updateUserName(
      {required String displayName,
      required String gender,
      required String birthday,
      required String mobile,
      required String email}) async {
    SetData data = SetData();
    final url = Uri.parse("${b2c_api_url}api/v1/customer/edit/info");

    try {
      final response = await AuthFetch.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "display_name": displayName,
          "birth_date": birthday,
          "mobile": mobile,
          "gender": gender,
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedJson['code'] == "100") {
          return;
        } else {
          return Future.error(
              'Unexpected response code: ${decodedJson['code']}');
        }
      }

      return Future.error(
          'Error updating profile: ${response.statusCode} - ${response.body}');
    } catch (e) {
      return Future.error('Exception in updateProfile: $e');
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    SetData data = SetData();
    var url = Uri.parse("${b2c_api_url}api/v1/customer/edit/image");
    try {
      Map<String, String> fields = {};

      List<http.MultipartFile> files = [];

      files.add(
        await http.MultipartFile.fromPath(
          'profile',
          imageFile.path,
        ),
      );

      fields['profile'] = jsonEncode({"cust_id": await data.b2cCustID});

      // ใช้ AuthFetch สำหรับ multipart request
      var response = await AuthFetch.multipartRequestWithAuth(
        url, // แปลง Uri เป็น String
        method: 'POST',
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        fields: fields,
        files: files,
      );

      if (response.statusCode == 200) {
        final responseBytes = await response.stream.toBytes();
        final responseString = utf8.decode(responseBytes);
        print("Response body: $responseString");

        final decodedJson = jsonDecode(responseString);
        print("Decoded JSON: $decodedJson");

        if (decodedJson['code'] == "100") {
          return;
        } else {
          return Future.error(
              'Unexpected response code: ${decodedJson['code']}');
        }
      }
    } catch (e) {
      print("Error uploading profile image: $e");
    }
  }

  Future<HomeSpecialB2C> fetchSpecialProject() async {
    SetData data = SetData();
    final url = Uri.parse("${b2c_api_url}api/v1/home/special");
    try {
      final response = await AuthFetch.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId,
          "token_app": await data.tokenId
        }),
      );

      if (response.statusCode == 200) {
        final homeSpecialB2C =
            homeSpecialB2CFromJson(utf8.decode(response.bodyBytes));

        return homeSpecialB2C;
      }
      return Future.error(
          'Error fetch special project: ${response.statusCode} - ${response.body}');
    } catch (e) {
      return Future.error('Exception in fetchSpecialProject: $e');
    }
  }

  Future<Response> deleteAccountService() async {
    SetData data = SetData();
    final url = Uri.parse("${b2c_api_url}api/v1/customer/delete_account");
    try {
      final response = await AuthFetch.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
        }),
      );

      if (response.statusCode == 200) {
        final res = responseFromJson(utf8.decode(response.bodyBytes));
        return res;
      }
      return Future.error(
          'Error deleteAccountService: ${response.statusCode} - ${response.body}');
    } catch (e) {
      return Future.error('Exception in deleteAccountService: $e');
    }
  }
}

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  String code;
  String message1;
  String message2;

  Response({
    required this.code,
    required this.message1,
    required this.message2,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        code: json["code"],
        message1: json["message1"],
        message2: json["message2"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message1": message1,
        "message2": message2,
      };
}
