// To parse this JSON data, do
//
//     final getHistoryEnduser = getHistoryEnduserFromJson(jsonString);

import 'dart:convert';

GetHistoryEnduser getHistoryEnduserFromJson(String str) =>
    GetHistoryEnduser.fromJson(json.decode(str));

String getHistoryEnduserToJson(GetHistoryEnduser data) =>
    json.encode(data.toJson());

class GetHistoryEnduser {
  List<CessDetail> inprocessDetail;
  List<CessDetail> successDetail;

  GetHistoryEnduser({
    required this.inprocessDetail,
    required this.successDetail,
  });

  factory GetHistoryEnduser.fromJson(Map<String, dynamic> json) =>
      GetHistoryEnduser(
        inprocessDetail: List<CessDetail>.from(
            json["inprocess_detail"].map((x) => CessDetail.fromJson(x))),
        successDetail: List<CessDetail>.from(
            json["success_detail"].map((x) => CessDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "inprocess_detail":
            List<dynamic>.from(inprocessDetail.map((x) => x.toJson())),
        "success_detail":
            List<dynamic>.from(successDetail.map((x) => x.toJson())),
      };
}

class CessDetail {
  String userType;
  String repSeq;
  String repCode;
  String enduserId;
  String enduserName;
  String enduserTelnumber;
  String saleCampaign;
  String orderCampaign;
  String orderDate;
  String invoiceNo;
  int totalItems;
  double totalAmount;
  double grossAmount;
  double totalDiscount;
  String statusCode;
  String status;
  String reciveTypeText;

  CessDetail({
    required this.userType,
    required this.repSeq,
    required this.repCode,
    required this.enduserId,
    required this.enduserName,
    required this.enduserTelnumber,
    required this.saleCampaign,
    required this.orderCampaign,
    required this.orderDate,
    required this.invoiceNo,
    required this.totalItems,
    required this.totalAmount,
    required this.grossAmount,
    required this.totalDiscount,
    required this.statusCode,
    required this.status,
    required this.reciveTypeText,
  });

  factory CessDetail.fromJson(Map<String, dynamic> json) => CessDetail(
        userType: json["user_type"],
        repSeq: json["rep_seq"],
        repCode: json["rep_code"],
        enduserId: json["enduser_id"],
        enduserName: json["enduser_name"],
        enduserTelnumber: json["enduser_telnumber"],
        saleCampaign: json["sale_campaign"],
        orderCampaign: json["order_campaign"],
        orderDate: json["order_date"],
        invoiceNo: json["invoice_no"],
        totalItems: json["total_items"],
        totalAmount: double.parse(json["total_amount"].toString()),
        grossAmount: double.parse(json["gross_amount"].toString()),
        totalDiscount: double.parse(json["total_discount"].toString()),
        statusCode: json["status_code"],
        status: json["status"],
        reciveTypeText: json["recive_type_text"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "user_type": userType,
        "rep_seq": repSeq,
        "rep_code": repCode,
        "enduser_id": enduserId,
        "enduser_name": enduserName,
        "enduser_telnumber": enduserTelnumber,
        "sale_campaign": saleCampaign,
        "order_campaign": orderCampaign,
        "order_date": orderDate,
        "invoice_no": invoiceNo,
        "total_items": totalItems,
        "total_amount": totalAmount,
        "gross_amount": grossAmount,
        "total_discount": totalDiscount,
        "status_code": statusCode,
        "status": status,
        "recive_type_text": reciveTypeText,
      };
}
