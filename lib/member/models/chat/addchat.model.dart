// To parse this JSON data, do
//
//     final addChatRoom = addChatRoomFromJson(jsonString);

import 'dart:convert';

AddChatRoom addChatRoomFromJson(String str) =>
    AddChatRoom.fromJson(json.decode(str));

String addChatRoomToJson(AddChatRoom data) => json.encode(data.toJson());

class AddChatRoom {
  String code;
  Data data;
  String message;

  AddChatRoom({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AddChatRoom.fromJson(Map<String, dynamic> json) => AddChatRoom(
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
  int chatRoomId;
  int customerId;
  int sellerId;

  Data({
    required this.chatRoomId,
    required this.customerId,
    required this.sellerId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        chatRoomId: json["chat_room_id"],
        customerId: json["customer_id"],
        sellerId: json["seller_id"],
      );

  Map<String, dynamic> toJson() => {
        "chat_room_id": chatRoomId,
        "customer_id": customerId,
        "seller_id": sellerId,
      };
}
