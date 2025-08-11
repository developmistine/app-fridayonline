import 'dart:convert';

ResponseUpdateAddress responseUpdateAddressFromJson(String str) => ResponseUpdateAddress.fromJson(json.decode(str));

String responseUpdateAddressToJson(ResponseUpdateAddress data) => json.encode(data.toJson());

class ResponseUpdateAddress {
    int code;
    String message;
    String data;

    ResponseUpdateAddress({
        required this.code,
        required this.message,
        required this.data,
    });

    factory ResponseUpdateAddress.fromJson(Map<String, dynamic> json) => ResponseUpdateAddress(
        code: json["code"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
    };
}
