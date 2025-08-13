import 'dart:convert';

import 'package:fridayonline/enduser/models/address/address.model.dart';
import 'package:fridayonline/enduser/models/address/b2caddrss.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<AddressList?> fetchAddressListService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/customer/address_list");

  SetData data = SetData();

  try {
    var jsonData = jsonEncode(
        {"cust_id": await data.b2cCustID, "device": await data.device});

    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    if (jsonCall.statusCode == 200) {
      var jsonString = jsonCall.bodyBytes;
      final addressList = addressListFromJson(utf8.decode(jsonString));
      return addressList;
    }
    return Future.error(
        'Error fetchAddressListService : api/v1/customer/address_list');
  } catch (e) {
    print('Error fetchAddressListService : $e');
    return Future.error(e);
  }
}

Future<B2CAddress?> searchAddressB2cService() async {
  var url = Uri.parse("${b2c_api_url}address");

  SetData data = SetData();

  try {
    var jsonCall = await AuthFetch.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ${await data.accessToken}',
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      var jsonString = jsonCall.bodyBytes;
      final b2CAddress = b2CAddressFromJson(utf8.decode(jsonString));
      return b2CAddress;
    }
    return Future.error('Error searchAddressB2cService : b2c/address');
  } catch (e) {
    print('Error searchAddressB2cService : $e');
    return Future.error("$e  from b2c/addrss");
  }
}

Future<Response?> setAddressService(json) async {
  var url = Uri.parse("${b2c_api_url}api/v1/customer/edit/address");

  SetData data = SetData();

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: json);
    if (jsonCall.statusCode == 200) {
      var jsonString = jsonCall.bodyBytes;
      final response = responseFromJson(utf8.decode(jsonString));
      return response;
    }
    return Future.error(
        'Error setAddressService : api/v1/customer/edit/address');
  } catch (e) {
    print('error api/v1/customer/edit/address : $e');
    return Future.error("$e  from api/v1/customer/edit/address");
  }
}

Future<Response?> setAddressDefalutService(int addressId) async {
  var url = Uri.parse("${b2c_api_url}api/v1/customer/edit/default_address");

  SetData data = SetData();

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer ${await data.accessToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(
            {"cust_id": await data.b2cCustID, "addr_id": addressId}));
    if (jsonCall.statusCode == 200) {
      var jsonString = jsonCall.bodyBytes;
      final response = responseFromJson(utf8.decode(jsonString));
      return response;
    }
    return Future.error(
        'Error setAddressDefalutService : api/v1/customer/edit/default_address');
  } catch (e) {
    print('error api/v1/customer/edit/default_address : $e');
    return Future.error("$e  from api/v1/customer/edit/default_address");
  }
}

// model response set address
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
