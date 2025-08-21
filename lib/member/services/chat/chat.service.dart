import 'dart:convert';
import 'dart:typed_data';
// import 'dart:typed_data';

import 'package:fridayonline/member/models/chat/addchat.model.dart';
import 'package:fridayonline/member/models/chat/chat.login.mode.dart';
import 'package:fridayonline/member/models/chat/chat.upload.model.dart';
import 'package:fridayonline/member/models/chat/history.model.dart';
import 'package:fridayonline/member/models/chat/seller.list.model.dart';
import 'package:fridayonline/member/models/chat/sticker_model.dart';
import 'package:fridayonline/member/utils/auth_fetch.dart';

import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<ChatStickerModel> fetchChatSticker() async {
  var url = Uri.parse("${b2c_api_url}api/v1/messages/sticker");

  try {
    var jsonCall = await AuthFetch.post(
      url,
      body: jsonEncode({}),
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final stickerChatList =
          chatStickerModelFromJson(utf8.decode(jsonResponse));

      return stickerChatList;
    }
    return Future.error('Error chat conversations : api/v1/messages/sticker');
  } catch (e) {
    return Future.error('Error fetchChatSticker : $e');
  }
}

Future<ChatLogin> chatLoginService() async {
  SetData data = SetData();
  var url = Uri.parse("${base_api_url}ws/v1/login");

  try {
    var jsonCall = await http.post(
      url,
      body: jsonEncode(
          {"access_token": await data.accessToken, "role": "customer"}),
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final chatLogin = chatLoginFromJson(utf8.decode(jsonResponse));

      return chatLogin;
    }
    return Future.error('Error chatLoginService : ws/v1/login');
  } catch (e) {
    return Future.error('Error chatLoginService : $e');
  }
}

Future<SellerChatList> fetchSellerChatService(offset) async {
  SetData data = SetData();
  // var url = Uri.parse("${b2c_api_url}api/v1/messages/conversations");
  var url = Uri.parse("${base_api_url}ws/v1/conversations");

  try {
    var jsonCall = await http.post(
      url,
      body: jsonEncode({
        "limit": 40,
        "offset": offset,
        "user_id": await data.b2cCustID,
        "role": "customer", // customer, seller
        "read_status": 0 // 0: all, 1: unread, 2: read
      }),
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer ${await data.tokenChat}',
      },
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final sellerChatList = sellerChatListFromJson(utf8.decode(jsonResponse));

      return sellerChatList;
    }
    return Future.error(
        'Error chat conversations : api/v1/messages/conversations');
  } catch (e) {
    return Future.error('Error fetchSellerChat : $e');
  }
}

Future<ChatUpload?> chatUploadService({
  required Map<String, dynamic> json,
  required XFile? images,
  required XFile? video,
}) async {
  var url = Uri.parse("${b2c_api_url}api/v1/messages/attachments");
  try {
    // 🔹 เพิ่มข้อมูลรีวิว (แปลงเป็น JSON)
    Map<String, dynamic> reviewData = json;
    Map<String, String> fields = {
      'attachment': jsonEncode(reviewData),
    };
    List<http.MultipartFile> files = [];

    if (video != null) {
      files.add(
        await http.MultipartFile.fromPath(
          'video',
          video.path.replaceAll("file://", ""),
          // video.path,
        ),
      );
    }

    if (images != null) {
      files.add(
        await http.MultipartFile.fromPath(
          'image',
          images.path,
        ),
      );
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
      final chatUpload = chatUploadFromJson(responseBody);
      return chatUpload;
    }
    return Future.error(
        'Error chatUploadService : api/v1/messages/attachments');
  } catch (e) {
    print("❗ เกิดข้อผิดพลาด: $e");
    return null;
  }
}

Future<ChatHistory> fetchHistoryChatService(
  int roomId,
  int offset,
) async {
  SetData data = SetData();
  // var url = Uri.parse("${b2c_api_url}api/v1/messages/history");
  var url = Uri.parse("${base_api_url}ws/v1/history");
  try {
    var jsonCall = await AuthFetch.post(
      url,
      body: jsonEncode({
        "chat_room_id": roomId,
        "user_id": await data.b2cCustID,
        "limit": 40,
        "offset": offset,
        "role": "customer",
        "device": await data.device,
        "session_id": await data.sessionId,
      }),
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer ${await data.tokenChat}',
      },
    );
    if (jsonCall.statusCode == 200) {
      var jsonResponse = jsonCall.bodyBytes;
      final chatHistory = chatHistoryFromJson(utf8.decode(jsonResponse));

      return chatHistory;
    }
    return Future.error('Error chat chatHistory : api/v1/messages/history');
  } catch (e) {
    return Future.error('Error fetchHistoryChatService : $e');
  }
}

Future<AddChatRoom> addChatRoomService(int sellerId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/messages/add_chatroom");

  try {
    var jsonCall = await AuthFetch.post(
      url,
      body: jsonEncode({
        "user_id": await data.b2cCustID,
        "customer_id": await data.b2cCustID,
        "seller_id": sellerId,
        "device": await data.device
      }),
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final addChatRoom = addChatRoomFromJson(utf8.decode(jsonResponse));

      return addChatRoom;
    }
    return Future.error(
        'Error chat addChatRoomService : api/v1/messages/add_chatroom');
  } catch (e) {
    return Future.error('Error addChatRoomService : $e');
  }
}
