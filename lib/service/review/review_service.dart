import 'dart:convert';
import 'dart:io';
import 'package:fridayonline/model/review/review_product_model.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';
import '../../model/review/review_detials_model.dart';
import 'package:http/http.dart' as http;

Future<ReviewDetails?> reviewsDetails() async {
  try {
    SetData data = SetData();
    final url = Uri.parse("${base_api_app}api/v1/review/Detail");
    var jsonInsert = jsonEncode({
      "rep_type": await data.repType,
      "rep_seq": await data.repSeq,
      "rep_code": await data.repCode,
      "enduser_id": await data.enduserId,
    });
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (response.statusCode == 200) {
      final result = response.body;

      return reviewDetailsFromJson(result);
    } else {
      ///error
    }
  } catch (e) {
    print('Error review_service: $e');
  }
  return null;
}

Future<ReviewsProduct?> getReview(fsCode, fsCodeTemp) async {
  try {
    // SetData data = SetData();
    final url = Uri.parse("${base_api_app}api/v1/review/ByProduct");
    var jsonInsert = jsonEncode({
      "fs_code": fsCode,
      "fscode_temp": fsCodeTemp,
    });
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (response.statusCode == 200) {
      final result = response.body;

      return reviewsProductFromJson(result);
    } else {
      ///error
    }
  } catch (e) {
    print('Error review_service: $e');
  }
  return null;
}

Future<Success?> saveReview(
    List<File>? fileImg, List<File>? fileVideo, String reviewJson) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('${base_api_app}api/v1/review/Save'));

  var mapJson = {'review_text': reviewJson};
  request.fields.addAll(mapJson);

  for (var i2 = 0; i2 < fileVideo!.length; i2++) {
    request.files.add(await http.MultipartFile.fromPath(
      'review_video',
      fileVideo[i2].path.replaceAll("file://", ""),
    ));
  }

  for (var i = 0; i < fileImg!.length; i++) {
    request.files.add(await http.MultipartFile.fromPath(
      'review_image',
      fileImg[i].path,
    ));
  }

  try {
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      return successFromJson(result);
    } else {
      return null;
    }
  } catch (error) {
    print('Error uploading: $error');
    return null;
  }
}

// response
Success successFromJson(String str) => Success.fromJson(json.decode(str));

String successToJson(Success data) => json.encode(data.toJson());

class Success {
  String code;
  String message1;
  String message2;
  String message3;

  Success({
    required this.code,
    required this.message1,
    required this.message2,
    required this.message3,
  });

  factory Success.fromJson(Map<String, dynamic> json) => Success(
        code: json["Code"],
        message1: json["Message1"],
        message2: json["Message2"],
        message3: json["Message3"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message1": message1,
        "Message2": message2,
        "Message3": message3,
      };
}
