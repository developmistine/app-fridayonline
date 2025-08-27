import 'dart:convert';

import 'package:fridayonline/member/models/authen/b2clogin.model.dart';
import 'package:fridayonline/member/models/authen/b2cregis.model.dart';
import 'package:fridayonline/member/models/authen/b2creis.output.dart';
import 'package:fridayonline/member/utils/auth_fetch.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

Future<B2CRegisterOutput?> b2cRegisterService(B2CRegister regis) async {
  //! dev_api_b2c , b2c_api_url

  var url = Uri.parse("${b2c_api_url}register_v1");

  try {
    var jsonData = jsonEncode(regis);

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    final b2CRegisterOutput =
        b2CRegisterOutputFromJson(utf8.decode(jsonCall.bodyBytes));
    // printWhite("ss ${b2CRegisterOutput.data.accessToken}");
    return b2CRegisterOutput;
  } catch (e) {
    print('error b2c register: $e');
    return Future.error(e);
  }
}

Future<B2CLogin?> refreshTokenService() async {
  var url = Uri.parse("${b2c_api_url}refresh");

  SetData data = SetData();

  printWhite('refresh from service ${await data.refreshToken}');

  try {
    var jsonData = jsonEncode({
      // "access_token": await data.accessToken,
      "refresh_token": await data.refreshToken,
      "device": await data.device,
    });

    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    // กรณี 401 หรือ accessToken หมดอายุ
    if (jsonCall.statusCode != 200) {
      return null;
    }
    var jsonResponse = jsonCall.body;
    final b2CLogin = b2CLoginFromJson(jsonResponse);
    // กรณี 401 หรือ accessToken หมดอายุ หรือไม่ได้ token ใหม่
    if (b2CLogin.code != "100") {
      return null;
    }
    return b2CLogin;
  } catch (e) {
    if (kDebugMode) {
      print('error refresh: $e');
    }
    return null;
  }
}

Future<OtpResponse?> b2cSentOtpService(String otpType, String mobile) async {
  var url = Uri.parse("${b2c_api_url}sent_otp_v1");

  SetData data = SetData();

  try {
    var jsonData = jsonEncode({
      "cust_id": 0,
      "otp_type": otpType,
      "mobile_no": mobile,
      "device": await data.device
    });

    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    final b2cOtp = otpResponseFromJson(jsonResponse);
    return b2cOtp;
  } catch (e) {
    print('error sent_otp: $e');
    return Future.error(e);
  }
}

Future<OtpResponse?> b2cVerifyOtpService(
    String otpType, String mobile, String otpCode, String otpRef) async {
  var url = Uri.parse("${b2c_api_url}verify_otp");

  SetData data = SetData();

  try {
    var jsonData = jsonEncode({
      "cust_id": 0,
      "otp_type": otpType,
      "mobile_no": mobile,
      "device": await data.device,
      "otp_code": otpCode,
      "otp_ref": otpRef
    });

    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    final b2cOtp = otpResponseFromJson(jsonResponse);
    return b2cOtp;
  } catch (e) {
    print('error verify_otp: $e');
    return Future.error(e);
  }
}

Future b2cLogoutService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/customer/logout");
  var accessToken = await data.accessToken;
  if (accessToken == "null" || accessToken == "") {
    return;
  }

  try {
    var jsonCall = await AuthFetch.post(
      url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      print('logout success');
    } else {
      print('logout error');
    }
  } catch (e) {
    print('error b2c logout: $e');
    // return Future.error(e);
  }
}

OtpResponse otpResponseFromJson(String str) =>
    OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  String code;
  String message1;
  String message2;
  String? otpRef;

  OtpResponse({
    required this.code,
    required this.message1,
    required this.message2,
    required this.otpRef,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
      code: json["code"],
      message1: json["message1"],
      message2: json["message2"],
      otpRef: json["otp_ref"] ?? '');

  Map<String, dynamic> toJson() => {
        "code": code,
        "message1": message1,
        "message2": message2,
        "otp_ref": otpRef
      };
}

Future checkUserByPhoneService(String mobile) async {
  var url = Uri.parse("${b2c_api_url}check_msl_phone");

  SetData data = SetData();

  try {
    var jsonData = jsonEncode({
      "mobile_no": mobile,
      "device": await data.device,
    });

    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    if (jsonCall.statusCode == 200) {
      var response = jsonCall.body;

      return jsonDecode(response);
    } else {
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print('error refresh: $e');
    }
    return Future.error(e);
  }
}
