import 'dart:convert';
import 'package:fridayonline/model/address/address_list.dart';
import 'package:fridayonline/model/address/address_show.dart';
import 'package:fridayonline/model/address/response_update_address.dart';
import '../../model/set_data/set_data.dart';
import '../../service/pathapi.dart';
import 'package:http/http.dart' as http;

Future<AddressShow> callAddressShow() async {
  try {
    SetData data = SetData();
    var url = Uri.parse("${base_api_app}api/v1/config/GetAddressShow");
    var jsonData = jsonEncode(
        {"RepSeq": await data.repSeq, "RepCode": await data.repCode});

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    print(jsonResponse);
    AddressShow addressShow = addressShowFromJson(jsonResponse);
    return addressShow;
  } catch (e) {
    var json = jsonEncode({"ShowList": 2});
    AddressShow addressShow = addressShowFromJson(json);
    return addressShow;
  }
}

Future<AddressList> callAddressListAll() async {
  try {
    SetData data = SetData();
    var url =
        Uri.parse("https://api.bsmartneoapp.com/ms/api/v1/msladdress/info");
    var jsonData =
        jsonEncode({"rep_seq": int.parse(await data.repSeq), "addr_type": 1});

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    AddressList address1 = addressListFromJson(jsonResponse);
    for (var i = 0; i < address1.data.length; i++) {
      if (address1.data[i].defaultFlag == "1") {
        AddressList addressList = addressListFromJson(jsonEncode({
          "code": 1000,
          "message": "success",
          "data": [address1.data[i]]
        }));
        return addressList;
      }
    }

    var jsonData1 =
        jsonEncode({"rep_seq": int.parse(await data.repSeq), "addr_type": 3});
    var jsonCall1 = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData1);

    var jsonResponse1 = jsonCall1.body;
    AddressList address2 = addressListFromJson(jsonResponse1);
    for (var i = 0; i < address2.data.length; i++) {
      if (address2.data[i].defaultFlag == "1") {
        AddressList addressList = addressListFromJson(jsonEncode({
          "code": 1000,
          "message": "success",
          "data": [address2.data[i]]
        }));
        return addressList;
      }
    }
  } catch (e) {
    AddressList addressList = addressListFromJson(
        jsonEncode({"code": 0, "message": "error", "data": []}));
    return addressList;
  }

  AddressList addressList = addressListFromJson(
      jsonEncode({"code": 0, "message": "error", "data": []}));
  return addressList;
}

Future<AddressList> callAddressList1() async {
  try {
    SetData data = SetData();
    var url =
        Uri.parse("https://api.bsmartneoapp.com/ms/api/v1/msladdress/info");
    var jsonData =
        jsonEncode({"rep_seq": int.parse(await data.repSeq), "addr_type": 1});

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    AddressList addressList = addressListFromJson(jsonResponse);
    return addressList;
  } catch (e) {
    var json = jsonEncode({"code": 1000, "message": "success", "data": []});
    AddressList addressList = addressListFromJson(json);
    return addressList;
  }
}

Future<AddressList> callAddressList3() async {
  try {
    SetData data = SetData();
    var url =
        Uri.parse("https://api.bsmartneoapp.com/ms/api/v1/msladdress/info");
    var jsonData =
        jsonEncode({"rep_seq": int.parse(await data.repSeq), "addr_type": 3});

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    AddressList addressList = addressListFromJson(jsonResponse);
    return addressList;
  } catch (e) {
    var json = jsonEncode({"code": 1000, "message": "success", "data": []});
    AddressList addressList = addressListFromJson(json);
    return addressList;
  }
}

Future<ResponseUpdateAddress> callSaveAddressMsl(
    address1,
    address2,
    amphurCode,
    defaultFlag,
    note,
    contactName,
    mobileNo,
    tumbonCode,
    provinceCode,
    postalCode) async {
  try {
    SetData data = SetData();
    var url =
        Uri.parse("https://api.bsmartneoapp.com/ms/api/v1/msladdr/create");
    var jsonData = jsonEncode({
      "address_type": 3,
      "addrline_1": address1,
      "addrline_2": address2,
      "branch": "",
      "delivery_note": note,
      "deliver_contact": contactName,
      "mobile_no": mobileNo,
      "default_flag": defaultFlag,
      "mode": "create",
      "tumbon_code": tumbonCode,
      "amphur_code": amphurCode,
      "province_code": provinceCode,
      "postal_code": postalCode,
      "rep_seq": int.parse(await data.repSeq),
      "cre_by": await data.repSeq,
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    ResponseUpdateAddress response =
        responseUpdateAddressFromJson(jsonResponse);
    return response;
  } catch (e) {
    var json = jsonEncode({"code": 500, "message": "error", "data": ""});
    ResponseUpdateAddress response = responseUpdateAddressFromJson(json);
    return response;
  }
}

Future<ResponseUpdateAddress> callUpdateAddressMsl(
    addressId,
    address1,
    address2,
    amphurCode,
    defaultFlag,
    note,
    contactName,
    mobileNo,
    tumbonCode,
    provinceCode,
    postalCode) async {
  try {
    SetData data = SetData();
    var url =
        Uri.parse("https://api.bsmartneoapp.com/ms/api/v1/msladdr/update");
    var jsonData = jsonEncode({
      "msladdr_id": addressId,
      "address_type": 3,
      "addrline_1": address1,
      "addrline_2": address2,
      "branch": "",
      "delivery_note": note,
      "deliver_contact": contactName,
      "mobile_no": mobileNo,
      "default_flag": defaultFlag,
      "mode": "update",
      "tumbon_code": tumbonCode,
      "amphur_code": amphurCode,
      "province_code": provinceCode,
      "postal_code": postalCode,
      "rep_seq": int.parse(await data.repSeq),
      "cre_by": await data.repSeq,
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    ResponseUpdateAddress response =
        responseUpdateAddressFromJson(jsonResponse);
    return response;
  } catch (e) {
    var json = jsonEncode({"code": 500, "message": "error", "data": ""});
    ResponseUpdateAddress response = responseUpdateAddressFromJson(json);
    return response;
  }
}

Future<ResponseUpdateAddress> callDeleteAddressMsl(addressId) async {
  try {
    SetData data = SetData();
    var url =
        Uri.parse("https://api.bsmartneoapp.com/ms/api/v1/msladdr/delete");
    var jsonData = jsonEncode({
      "mode": "delete",
      "msladdr_id": addressId,
      "cre_by": await data.repSeq
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    print(jsonResponse);
    ResponseUpdateAddress response =
        responseUpdateAddressFromJson(jsonResponse);
    return response;
  } catch (e) {
    var json = jsonEncode({"code": 500, "message": "error", "data": ""});
    ResponseUpdateAddress response = responseUpdateAddressFromJson(json);
    return response;
  }
}
