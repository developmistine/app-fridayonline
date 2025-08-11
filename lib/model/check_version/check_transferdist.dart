import 'dart:convert';

TransFerDist transFerDistFromJson(String str) =>
    TransFerDist.fromJson(json.decode(str));

String transFerDistToJson(TransFerDist data) => json.encode(data.toJson());

class TransFerDist {
  TransFerDist({
    required this.flagTransfer,
    required this.repCode,
    required this.repSeq,
    required this.repName,
    required this.telNumber,
    required this.msgAlert1,
    required this.msgAlert2,
  });

  String flagTransfer;
  String repCode;
  String repSeq;
  String repName;
  String telNumber;
  String msgAlert1;
  String msgAlert2;

  factory TransFerDist.fromJson(Map<String, dynamic> json) => TransFerDist(
        flagTransfer: json["FlagTransfer"] ?? "",
        repCode: json["RepCode"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        repName: json["RepName"] ?? "",
        telNumber: json["TelNumber"] ?? "",
        msgAlert1: json["MsgAlert1"] ?? "",
        msgAlert2: json["MsgAlert2"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "FlagTransfer": flagTransfer,
        "RepCode": repCode,
        "RepSeq": repSeq,
        "RepName": repName,
        "TelNumber": telNumber,
        "MsgAlert1": msgAlert1,
        "MsgAlert2": msgAlert2,
      };
}
