// ignore_for_file: avoid_print, non_constant_identifier_names

// import 'dart:convert';
import 'dart:io';

import '../../model/lead/lead_project_model.dart';
import 'package:http/http.dart' as http;

import '../pathapi.dart';

// GetLeadProject getLeadProjectFromJson
Future<GetLeadProject?> call_projectLead() async {
  try {
    var url = Uri.parse("${base_api_app}api/v1/member/GetLeadProject");
    var jsonCall = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    var jsonResponse = jsonCall.body;
    GetLeadProject leadStatus = getLeadProjectFromJson(jsonResponse);
    return leadStatus;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<String> uploadImage(File? filePath) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://dl.fridayth.com/api/image-upload'));
  request.files.add(await http.MultipartFile.fromPath('image', filePath!.path));

  var fileName = filePath.path.split(Platform.pathSeparator).last;
  var linkPath =
      "https://student-id.s3.ap-southeast-1.amazonaws.com/id-card/$fileName";
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return linkPath;
  } else {
    print(response.reasonPhrase);
    return response.statusCode.toString();
  }
}
