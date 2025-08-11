// To parse this JSON data, do
//
//     final getMslinfo = getMslinfoFromJson(jsonString);

import 'dart:convert';

GetMslinfo getMslinfoFromJson(String str) =>
    GetMslinfo.fromJson(json.decode(str));

String getMslinfoToJson(GetMslinfo data) => json.encode(data.toJson());

class GetMslinfo {
  GetMslinfo({
    required this.success,
    required this.message,
    required this.repSeq,
    required this.repCode,
    required this.repName,
    required this.member,
    required this.mobileno,
    required this.address1,
    required this.address2,
    required this.tumbon,
    required this.amphur,
    required this.province,
    required this.postal,
    required this.saleType,
    required this.arBalance,
    required this.bprFwd,
    required this.bprCurrent,
    required this.bprAdj,
    required this.bprUse,
    required this.bprExp,
    required this.bprBalance,
    required this.savStatus,
    required this.savCode,
    required this.savProject,
    required this.savYear,
    required this.savCampaign,
    required this.savCurrAmt,
    required this.savBfAmt,
    required this.savAdjAmt,
    required this.savBalance,
    required this.idcardRequire,
    required this.apptCampaign,
  });

  String success;
  String message;
  String repSeq;
  String repCode;
  String repName;
  String member;
  String mobileno;
  String address1;
  dynamic address2;
  String tumbon;
  String amphur;
  String province;
  String postal;
  String saleType;
  String arBalance;
  String bprFwd;
  String bprCurrent;
  String bprAdj;
  String bprUse;
  String bprExp;
  int bprBalance;
  String savStatus;
  String savCode;
  String savProject;
  String savYear;
  String savCampaign;
  String savCurrAmt;
  String savBfAmt;
  String savAdjAmt;
  String savBalance;
  String idcardRequire;
  String apptCampaign;

  factory GetMslinfo.fromJson(Map<String, dynamic> json) => GetMslinfo(
        success: json["success"] ?? "",
        message: json["message"] ?? "",
        repSeq: json["rep_seq"] ?? "",
        repCode: json["rep_code"] ?? "",
        repName: json["rep_name"] ?? "",
        member: json["member"] ?? "",
        mobileno: json["mobileno"] ?? "",
        address1: json["address1"] ?? "",
        address2: json["address2"] ?? "",
        tumbon: json["tumbon"] ?? "",
        amphur: json["amphur"] ?? "",
        province: json["province"] ?? "",
        postal: json["postal"] ?? "",
        saleType: json["sale_type"] ?? "",
        arBalance: json["ar_balance"] ?? "",
        bprFwd: json["bpr_fwd"] ?? "",
        bprCurrent: json["bpr_current"] ?? "",
        bprAdj: json["bpr_adj"] ?? "",
        bprUse: json["bpr_use"] ?? "",
        bprExp: json["bpr_exp"] ?? "",
        bprBalance: json["bpr_balance"] ?? 0,
        savStatus: json["sav_status"] ?? "",
        savCode: json["sav_code"] ?? "",
        savProject: json["sav_project"] ?? "",
        savYear: json["sav_year"] ?? "",
        savCampaign: json["sav_campaign"] ?? "",
        savCurrAmt: json["sav_curr_amt"] ?? "",
        savBfAmt: json["sav_bf_amt"] ?? "",
        savAdjAmt: json["sav_adj_amt"] ?? "",
        savBalance: json["sav_balance"] ?? "",
        idcardRequire: json["idcard_require"] ?? "",
        apptCampaign: json["appt_campaign"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "rep_seq": repSeq,
        "rep_code": repCode,
        "rep_name": repName,
        "member": member,
        "mobileno": mobileno,
        "address1": address1,
        "address2": address2,
        "tumbon": tumbon,
        "amphur": amphur,
        "province": province,
        "postal": postal,
        "sale_type": saleType,
        "ar_balance": arBalance,
        "bpr_fwd": bprFwd,
        "bpr_current": bprCurrent,
        "bpr_adj": bprAdj,
        "bpr_use": bprUse,
        "bpr_exp": bprExp,
        "bpr_balance": bprBalance,
        "sav_status": savStatus,
        "sav_code": savCode,
        "sav_project": savProject,
        "sav_year": savYear,
        "sav_campaign": savCampaign,
        "sav_curr_amt": savCurrAmt,
        "sav_bf_amt": savBfAmt,
        "sav_adj_amt": savAdjAmt,
        "sav_balance": savBalance,
        "idcard_require": idcardRequire,
        "appt_campaign": apptCampaign,
      };
}
