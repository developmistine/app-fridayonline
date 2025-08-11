// To parse this JSON data, do
//
//     final otpCheckName = otpCheckNameFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

OtpCheckName otpCheckNameFromJson(String str) =>
    OtpCheckName.fromJson(json.decode(str));

String otpCheckNameToJson(OtpCheckName data) => json.encode(data.toJson());

class OtpCheckName {
  OtpCheckName({
    required this.status,
    required this.endUserid,
    required this.enduserName,
    required this.endusersurname,
    required this.enduserTel,
    required this.repCoderef,
  });

  String status;
  String endUserid;
  String enduserName;
  String endusersurname;
  String enduserTel;
  String repCoderef;

  factory OtpCheckName.fromJson(Map<String, dynamic> json) => OtpCheckName(
        status: json["status"] ?? "",
        endUserid: json["EndUserid"] ?? "",
        enduserName: json["EnduserName"] ?? "",
        endusersurname: json["Endusersurname"] ?? "",
        enduserTel: json["EnduserTel"] ?? "",
        repCoderef: json["RepCoderef"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "EndUserid": endUserid,
        "EnduserName": enduserName,
        "Endusersurname": endusersurname,
        "EnduserTel": enduserTel,
        "RepCoderef": repCoderef,
      };
}
