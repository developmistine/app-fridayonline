// To parse this JSON data, do
//
//     final homeSpecialB2C = homeSpecialB2CFromJson(jsonString);

import 'dart:convert';

HomeSpecialB2C homeSpecialB2CFromJson(String str) => HomeSpecialB2C.fromJson(json.decode(str));

String homeSpecialB2CToJson(HomeSpecialB2C data) => json.encode(data.toJson());

class HomeSpecialB2C {
    String code;
    List<Datum> data;
    String message;

    HomeSpecialB2C({
        required this.code,
        required this.data,
        required this.message,
    });

    factory HomeSpecialB2C.fromJson(Map<String, dynamic> json) => HomeSpecialB2C(
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
    int contentId;
    String contentName;
    int actionType;
    String actionValue;
    String image;
    String imageDesktop;

    Datum({
        required this.contentId,
        required this.contentName,
        required this.actionType,
        required this.actionValue,
        required this.image,
        required this.imageDesktop,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        contentId: json["content_id"],
        contentName: json["content_name"],
        actionType: json["action_type"],
        actionValue: json["action_value"],
        image: json["image"],
        imageDesktop: json["image_desktop"],
    );

    Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "content_name": contentName,
        "action_type": actionType,
        "action_value": actionValue,
        "image": image,
        "image_desktop": imageDesktop,
    };
}
