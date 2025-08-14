// To parse this JSON data, do
//
//     final voucherUser = voucherGroupUserFromJson(jsonString);

import 'dart:convert';

VoucherGroupUser voucherGroupUserFromJson(String str) =>
    VoucherGroupUser.fromJson(json.decode(str));

String voucherUserToJson(VoucherGroupUser data) => json.encode(data.toJson());

class VoucherGroupUser {
  String code;
  List<Datum> data;
  String message;

  VoucherGroupUser({
    required this.code,
    required this.data,
    required this.message,
  });

  factory VoucherGroupUser.fromJson(Map<String, dynamic> json) =>
      VoucherGroupUser(
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
  int voucherPage;
  int voucherGroupId;
  String voucherGroup;

  Datum({
    required this.voucherPage,
    required this.voucherGroupId,
    required this.voucherGroup,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        voucherPage: json["voucher_page"],
        voucherGroupId: json["voucher_group_id"],
        voucherGroup: json["voucher_group"],
      );

  Map<String, dynamic> toJson() => {
        "voucher_page": voucherPage,
        "voucher_group_id": voucherGroupId,
        "voucher_group": voucherGroup,
      };
}
