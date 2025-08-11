// To parse this JSON data, do
//
//     final sellerChatList = sellerChatListFromJson(jsonString);

import 'dart:convert';

SellerChatList sellerChatListFromJson(String str) =>
    SellerChatList.fromJson(json.decode(str));

String sellerChatListToJson(SellerChatList data) => json.encode(data.toJson());

class SellerChatList {
  String code;
  List<SellerChat> data;
  String message;

  SellerChatList({
    required this.code,
    required this.data,
    required this.message,
  });

  factory SellerChatList.fromJson(Map<String, dynamic> json) => SellerChatList(
        code: json["code"],
        data: List<SellerChat>.from(
            json["data"].map((x) => SellerChat.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class SellerChat {
  int chatRoomId;
  int customerId;
  String customerName;
  String customerImage;
  int sellerId;
  String sellerName;
  String sellerImage;
  int messageType;
  String messageText;
  String lastSend;
  int unRead;

  SellerChat({
    required this.chatRoomId,
    required this.customerId,
    required this.customerName,
    required this.customerImage,
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.messageType,
    required this.messageText,
    required this.lastSend,
    required this.unRead,
  });

  factory SellerChat.fromJson(Map<String, dynamic> json) => SellerChat(
        chatRoomId: json["chat_room_id"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerImage: json["customer_image"],
        sellerId: json["seller_id"],
        sellerName: json["seller_name"],
        sellerImage: json["seller_image"],
        messageType: json["message_type"],
        messageText: json["message_text"],
        lastSend: json["last_send"],
        unRead: json["un_read"],
      );

  Map<String, dynamic> toJson() => {
        "chat_room_id": chatRoomId,
        "customer_id": customerId,
        "customer_name": customerName,
        "customer_image": customerImage,
        "seller_id": sellerId,
        "seller_name": sellerName,
        "seller_image": sellerImage,
        "message_type": messageType,
        "message_text": messageText,
        "last_send": lastSend,
        "un_read": unRead,
      };
}
