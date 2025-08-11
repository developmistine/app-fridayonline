// เป็น Service ในส่วนที่ทำส่งข้อมูลไปทำการ Insert

import 'dart:convert';
// import 'dart:developer';
import 'package:http/http.dart' as http;

import '../pathapi.dart';

Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

Future<GetDistrict?> getDistrict(address, city, provincedId, dsmCode) async {
  try {
    // Path ในการ Call API เพื่อที่จะทำการ Get Service
    String lspathget = "${baseUrlWebView}DsmOrder/getmasterarea_app.php";
    var url = Uri.parse(lspathget);

    var jsonregister = jsonEncode({
      "address": address,
      "city": city,
      "provinceId": provincedId,
      "dsm_code": ""
    });

    var response = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonregister);
    if (response.statusCode == 200) {
      var jsonValue = response.body;
      // log(jsonValue.toString());
      GetDistrict value = getDistrictFromJson(jsonValue);
      return value;
    } else {
      print('api call district failed timeout');
      return null;
    }
  } catch (e) {
    print('api call district catch error');

    return GetDistrict(
      datatype: "",
      district: '',
      masterArea: '',
    );
  }
}

//? class get district

GetDistrict getDistrictFromJson(String str) =>
    GetDistrict.fromJson(json.decode(str));

String getDistrictToJson(GetDistrict data) => json.encode(data.toJson());

class GetDistrict {
  GetDistrict({
    required this.district,
    required this.masterArea,
    required this.datatype,
  });

  String district;
  String masterArea;
  String datatype;

  factory GetDistrict.fromJson(Map<String, dynamic> json) => GetDistrict(
        district: json["district"],
        masterArea: json["master_area"],
        datatype: json["datatype"],
      );

  Map<String, dynamic> toJson() => {
        "district": district,
        "master_area": masterArea,
        "datatype": datatype,
      };
}
