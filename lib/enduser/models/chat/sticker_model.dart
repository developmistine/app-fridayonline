import 'dart:convert';
 
ChatStickerModel chatStickerModelFromJson(String str) => ChatStickerModel.fromJson(json.decode(str));
 
String chatStickerModelToJson(ChatStickerModel data) => json.encode(data.toJson());
 
class ChatStickerModel {
    String code;
    List<Sticker> data;
    String message;
 
    ChatStickerModel({
        required this.code,
        required this.data,
        required this.message,
    });
 
    factory ChatStickerModel.fromJson(Map<String, dynamic> json) => ChatStickerModel(
        code: json["code"],
        data: List<Sticker>.from(json["data"].map((x) => Sticker.fromJson(x))),
        message: json["message"],
    );
 
    Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}
 
class Sticker {
    int stickerId;
    String stickerName;
    String stickerImage;
 
    Sticker({
        required this.stickerId,
        required this.stickerName,
        required this.stickerImage,
    });
 
    factory Sticker.fromJson(Map<String, dynamic> json) => Sticker(
        stickerId: json["sticker_id"],
        stickerName: json["sticker_name"],
        stickerImage: json["sticker_image"],
    );
 
    Map<String, dynamic> toJson() => {
        "sticker_id": stickerId,
        "sticker_name": stickerName,
        "sticker_image": stickerImage,
    };
}