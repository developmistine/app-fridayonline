import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/reviews/pending.model.dart';
import 'package:fridayonline/enduser/models/reviews/reviewed.mode.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

Future<PendingReviews> fetchPendingReviewService(int orderShopId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/products/user/pending_review");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "ordshop_id": orderShopId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final pendingReviews = pendingReviewsFromJson(utf8.decode(jsonResponse));
      return pendingReviews;
    }
    return Future.error(
        'Error get pending review : api/v1/products/user/pending_review');
  } catch (e) {
    return Future.error('Error fetchPendingReviewService: $e');
  }
}

Future<Reviewed> fetchReviewedService(int orderShopId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/products/user/reviewed");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "ordshop_id": orderShopId,
          "sessionId": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final reviewed = reviewedFromJson(utf8.decode(jsonResponse));
      return reviewed;
    }
    return Future.error(
        'Error get reviewed review : api/v1/products/user/reviewed');
  } catch (e) {
    return Future.error('Error fetchReviewedService: $e');
  }
}

Future<Response?> submitReview({
  required Map<String, dynamic> json,
  required Map<int, List<File>?> images,
  Map<int, File>? video,
}) async {
  var url = Uri.parse("${b2c_api_url}api/v1/products/user/review");
  try {
    Map<String, dynamic> reviewData = json;
    Map<String, String> fields = {
      'review': jsonEncode(reviewData),
    };

    List<http.MultipartFile> files = [];

    // 🔹 แนบไฟล์วิดีโอ (1 ไฟล์ต่อ itemId)
    if (video != null) {
      for (var entry in video.entries) {
        int itemId = entry.key;
        File videoFile = entry.value;

        files.add(
          await http.MultipartFile.fromPath(
            'video_$itemId', // ชื่อ video_{itemId}
            videoFile.path.replaceAll("file://", ""),
          ),
        );
      }
    }

    // 🔹 แนบไฟล์รูปภาพ (รองรับหลายไฟล์ต่อ item_id)
    for (var entry in images.entries) {
      int itemId = entry.key;
      List<File>? imageFiles = entry.value;

      if (imageFiles != null) {
        for (int i = 0; i < imageFiles.length; i++) {
          files.add(
            await http.MultipartFile.fromPath(
              'image_$itemId', // ใช้ชื่อ image_itemId_ลำดับ
              imageFiles[i].path,
            ),
          );
        }
      }
    }

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

    // 🔹 อ่าน response body
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final response = responseFromJson(responseBody);
      return response;
    }
    return Future.error('Error: submitReview');
  } catch (e) {
    print("❗ เกิดข้อผิดพลาด: $e");
    return null;
  }
}

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  String code;
  String message;

  Response({
    required this.code,
    required this.message,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
