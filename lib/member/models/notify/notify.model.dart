// To parse this JSON data, do
//
//     final b2CNotify = b2CNotifyFromJson(jsonString);

import 'dart:convert';

B2CNotify b2CNotifyFromJson(String str) => B2CNotify.fromJson(json.decode(str));

String b2CNotifyToJson(B2CNotify data) => json.encode(data.toJson());

class B2CNotify {
  String code;
  List<Datum> data;
  String message;

  B2CNotify({
    required this.code,
    required this.data,
    required this.message,
  });

  factory B2CNotify.fromJson(Map<String, dynamic> json) => B2CNotify(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int groupId;
  int notifyId;
  String title;
  String subTitle;
  String dateTime;
  int actionId;
  bool isContent;
  String actionType;
  String actionValue;
  String image;
  IdInfo idInfo;
  List<RichContent> richContents;
  bool isRead;

  Datum({
    required this.groupId,
    required this.notifyId,
    required this.title,
    required this.subTitle,
    required this.dateTime,
    required this.actionId,
    required this.isContent,
    required this.actionType,
    required this.actionValue,
    required this.image,
    required this.idInfo,
    required this.richContents,
    required this.isRead,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        groupId: json["group_id"],
        notifyId: json["notify_id"],
        title: json["title"],
        subTitle: json["sub_title"],
        dateTime: json["date_time"],
        actionId: json["action_id"],
        isContent: json["is_content"],
        actionType: json["action_type"],
        actionValue: json["action_value"],
        image: json["image"],
        idInfo: IdInfo.fromJson(json["id_info"]),
        richContents: List<RichContent>.from(
            json["rich_contents"].map((x) => RichContent.fromJson(x))),
        isRead: json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "notify_id": notifyId,
        "title": title,
        "sub_title": subTitle,
        "date_time": dateTime,
        "action_id": actionId,
        "is_content": isContent,
        "action_type": actionType,
        "action_value": actionValue,
        "image": image,
        "id_info": idInfo.toJson(),
        "rich_contents":
            List<dynamic>.from(richContents.map((x) => x.toJson())),
        "is_read": isRead,
      };
}

class IdInfo {
  int orderType;
  int orderId;
  int returnId;
  int shopId;

  IdInfo({
    required this.orderType,
    required this.orderId,
    required this.returnId,
    required this.shopId,
  });

  factory IdInfo.fromJson(Map<String, dynamic> json) => IdInfo(
        orderType: json["order_type"],
        orderId: json["order_id"],
        returnId: json["return_id"],
        shopId: json["shop_id"],
      );

  Map<String, dynamic> toJson() => {
        "order_type": orderType,
        "order_id": orderId,
        "return_id": returnId,
        "shop_id": shopId,
      };
}

class RichContent {
  String image;
  int discount;

  RichContent({
    required this.image,
    required this.discount,
  });

  factory RichContent.fromJson(Map<String, dynamic> json) => RichContent(
        image: json["image"],
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "discount": discount,
      };
}
