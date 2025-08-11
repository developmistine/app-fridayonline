// To parse this JSON data, do
//
//     final reciveMessage = receieveMessageFromJson(jsonString);

import 'dart:convert';

ReciveMessage receieveMessageFromJson(String str) =>
    ReciveMessage.fromJson(json.decode(str));

String reciveMessageToJson(ReciveMessage data) => json.encode(data.toJson());

class ReciveMessage {
  String? event;
  MessageData messageData;
  bool isMe;

  ReciveMessage({
    required this.event,
    required this.messageData,
    required this.isMe,
  });

  factory ReciveMessage.fromJson(Map<String, dynamic> json) => ReciveMessage(
        event: json["event"] ?? "",
        messageData: MessageData.fromJson(json["message_data"]),
        isMe: json["is_me"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "message_data": messageData.toJson(),
        "is_me": isMe,
      };
}

class MessageData {
  int messageId;
  int chatRoomId;
  int senderId;
  String senderRole;
  int messageType;
  String messageText;
  String attachment;
  int isRead;
  String sendDate;
  int productId;
  String title;
  double discount;
  double price;
  double priceBeforeDiscount;
  String image;
  String imgPath;
  String imgFilename;
  int orderId;
  String orderNo;
  int orderStatus;
  String orderColorCode;
  String orderStatusDesc;
  int orderTotalQty;
  double orderTotalAmount;

  MessageData({
    required this.messageId,
    required this.chatRoomId,
    required this.senderId,
    required this.senderRole,
    required this.messageType,
    required this.messageText,
    required this.attachment,
    required this.isRead,
    required this.sendDate,
    required this.productId,
    required this.title,
    required this.discount,
    required this.price,
    required this.priceBeforeDiscount,
    required this.image,
    required this.imgPath,
    required this.imgFilename,
    required this.orderId,
    required this.orderNo,
    required this.orderStatus,
    required this.orderColorCode,
    required this.orderStatusDesc,
    required this.orderTotalQty,
    required this.orderTotalAmount,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        messageId: json["message_id"] ?? 0,
        chatRoomId: json["chat_room_id"] ?? 0,
        senderId: json["sender_id"] ?? 0,
        senderRole: json["sender_role"] ?? "",
        messageType: json["message_type"] ?? 0,
        messageText: json["message_text"] ?? "",
        attachment: json["attachment"] ?? "",
        isRead: json["is_read"] ?? 0,
        sendDate: json["send_date"] ?? "",
        productId: json["product_id"] ?? 0,
        title: json["title"] ?? "",
        discount: json["discount"]?.toDouble() ?? 0,
        price: json["price"]?.toDouble() ?? 0,
        priceBeforeDiscount: json["price_before_discount"]?.toDouble() ?? 0,
        image: json["image"] ?? "",
        imgPath: json["img_path"] ?? "",
        imgFilename: json["img_filename"] ?? "",
        orderId: json["order_id"] ?? 0,
        orderNo: json["order_no"] ?? "",
        orderStatus: json["order_status"] ?? 0,
        orderColorCode: json["order_color_code"] ?? "",
        orderStatusDesc: json["order_status_desc"] ?? "",
        orderTotalQty: json["order_total_qty"] ?? 0,
        orderTotalAmount: json["order_total_amount"]?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "chat_room_id": chatRoomId,
        "sender_id": senderId,
        "sender_role": senderRole,
        "message_type": messageType,
        "message_text": messageText,
        "attachment": attachment,
        "is_read": isRead,
        "send_date": sendDate,
        "product_id": productId,
        "title": title,
        "discount": discount,
        "price": price,
        "price_before_discount": priceBeforeDiscount,
        "image": image,
        "img_filename": imgFilename,
        "img_path": imgPath,
        "order_id": orderId,
        "order_no": orderNo,
        "order_status": orderStatus,
        "order_color_code": orderColorCode,
        "order_status_desc": orderStatusDesc,
        "order_total_qty": orderTotalQty,
        "order_total_amount": orderTotalAmount,
      };
}

// class MessageData {
//   int messageId;
//   int chatRoomId;
//   int senderId;
//   String senderRole;
//   int messageType;
//   String messageText;
//   String imgPath;
//   String attachment;
//   String? imgFilename;
//   int isRead;
//   String sendDate;

//   MessageData({
//     required this.messageId,
//     required this.chatRoomId,
//     required this.senderId,
//     required this.senderRole,
//     required this.messageType,
//     required this.messageText,
//     required this.imgPath,
//     required this.attachment,
//     required this.imgFilename,
//     required this.isRead,
//     required this.sendDate,
//   });

//   factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
//         messageId: json["message_id"] ?? 0,
//         chatRoomId: json["chat_room_id"] ?? 0,
//         senderId: json["sender_id"] ?? 0,
//         senderRole: json["sender_role"] ?? "",
//         messageType: json["message_type"] ?? 0,
//         messageText: json["message_text"] ?? "",
//         imgPath: json["img_path"] ?? "",
//         attachment: json["attachment"] ?? "",
//         imgFilename: json["img_filename"] ?? "",
//         isRead: json["is_read"] ?? 0,
//         sendDate: json["send_date"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "message_id": messageId,
//         "chat_room_id": chatRoomId,
//         "sender_id": senderId,
//         "sender_role": senderRole,
//         "message_type": messageType,
//         "message_text": messageText,
//         "img_path": imgPath,
//         "attachment": attachment,
//         "img_filename": imgFilename,
//         "is_read": isRead,
//         "send_date": sendDate,
//       };
// }
