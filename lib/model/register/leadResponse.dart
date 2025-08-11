//     final responseLead = responseLeadFromJson(jsonString);

import 'dart:convert';

ResponseLead responseLeadFromJson(String str) =>
    ResponseLead.fromJson(json.decode(str));

String responseLeadToJson(ResponseLead data) => json.encode(data.toJson());

class ResponseLead {
  String code;
  String message;
  int leadId;
  String repCode;
  int repSeq;

  ResponseLead({
    required this.code,
    required this.message,
    required this.leadId,
    required this.repCode,
    required this.repSeq,
  });

  factory ResponseLead.fromJson(Map<String, dynamic> json) => ResponseLead(
        code: json["code"],
        message: json["message"],
        leadId: json["lead_id"] ?? 0,
        repCode: json["rep_code"] ?? "",
        repSeq: json["rep_seq"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "lead_id": leadId,
        "rep_code": repCode,
        "rep_seq": repSeq,
      };
}
