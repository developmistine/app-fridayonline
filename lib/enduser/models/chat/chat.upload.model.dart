// To parse this JSON data, do
//
//     final chatUpload = chatUploadFromJson(jsonString);

import 'dart:convert';

ChatUpload chatUploadFromJson(String str) =>
    ChatUpload.fromJson(json.decode(str));

String chatUploadToJson(ChatUpload data) => json.encode(data.toJson());

class ChatUpload {
  String code;
  Data data;
  String message;

  ChatUpload({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ChatUpload.fromJson(Map<String, dynamic> json) => ChatUpload(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  int type;
  String imgPath;
  String imgFilename;

  Data({
    required this.type,
    required this.imgPath,
    required this.imgFilename,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        type: json["Type"],
        imgPath: json["ImgPath"],
        imgFilename: json["ImgFilename"],
      );

  Map<String, dynamic> toJson() => {
        "Type": type,
        "ImgPath": imgPath,
        "ImgFilename": imgFilename,
      };
}
