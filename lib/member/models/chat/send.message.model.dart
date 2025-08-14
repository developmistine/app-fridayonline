// To parse this JSON data, do
//
//     final sendMessage = sendMessageFromJson(jsonString);

import 'dart:convert';

SendMessage sendMessageFromJson(String str) =>
    SendMessage.fromJson(json.decode(str));

String sendMessageToJson(SendMessage data) => json.encode(data.toJson());

class SendMessage {
  String event;
  int receiverId;
  MessageData messageData;
  bool isMe;

  SendMessage({
    required this.event,
    required this.receiverId,
    required this.messageData,
    required this.isMe,
  });

  factory SendMessage.fromJson(Map<String, dynamic> json) => SendMessage(
        event: json["event"],
        receiverId: json["receiver_id"],
        messageData: MessageData.fromJson(json["message_data"]),
        isMe: json["is_me"],
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "receiver_id": receiverId,
        "message_data": messageData.toJson(),
        "is_me": isMe,
      };
}

class MessageData {
  int chatRoomId;
  int senderId;
  String senderRole;
  int messageType;
  String messageText;
  String imgPath;
  String imgFilename;

  MessageData({
    required this.chatRoomId,
    required this.senderId,
    required this.senderRole,
    required this.messageType,
    required this.messageText,
    required this.imgPath,
    required this.imgFilename,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        chatRoomId: json["chat_room_id"],
        senderId: json["sender_id"],
        senderRole: json["sender_role"],
        messageType: json["message_type"],
        messageText: json["message_text"],
        imgPath: json["img_path"],
        imgFilename: json["img_filename"],
      );

  Map<String, dynamic> toJson() => {
        "chat_room_id": chatRoomId,
        "sender_id": senderId,
        "sender_role": senderRole,
        "message_type": messageType,
        "message_text": messageText,
        "img_path": imgPath,
        "img_filename": imgFilename,
      };
}
