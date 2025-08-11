// To parse this JSON data, do
//
//     final enduserCheckInformation = enduserCheckInformationFromJson(jsonString);

import 'dart:convert';

EnduserCheckInformation enduserCheckInformationFromJson(String str) =>
    EnduserCheckInformation.fromJson(json.decode(str));

String enduserCheckInformationToJson(EnduserCheckInformation data) =>
    json.encode(data.toJson());

class EnduserCheckInformation {
  List<Inprocess> waitingForApproval;
  List<Inprocess> inprocess;
  List<Inprocess> success;
  List<Inprocess> unsuccessful;

  EnduserCheckInformation({
    required this.waitingForApproval,
    required this.inprocess,
    required this.success,
    required this.unsuccessful,
  });

  factory EnduserCheckInformation.fromJson(Map<String, dynamic> json) =>
      EnduserCheckInformation(
        waitingForApproval: List<Inprocess>.from(
            json["waiting_for_approval"].map((x) => Inprocess.fromJson(x))),
        inprocess: List<Inprocess>.from(
            json["inprocess"].map((x) => Inprocess.fromJson(x))),
        success: List<Inprocess>.from(
            json["success"].map((x) => Inprocess.fromJson(x))),
        unsuccessful: List<Inprocess>.from(
            json["unsuccessful"].map((x) => Inprocess.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "waiting_for_approval":
            List<dynamic>.from(waitingForApproval.map((x) => x.toJson())),
        "inprocess": List<dynamic>.from(inprocess.map((x) => x.toJson())),
        "success": List<dynamic>.from(success.map((x) => x.toJson())),
        "unsuccessful": List<dynamic>.from(unsuccessful.map((x) => x.toJson())),
      };
}

class Inprocess {
  String orderSource;
  String ordshopId;
  String supplierCode;
  String supplierName;
  String orderId;
  String orderNo;
  String enduserId;
  String telnumber;
  String name;
  String repSeq;
  String repCode;
  String repName;
  String repTelnumber;
  String userType;
  String statusCode;
  String status;
  String billSeq;
  String orderCamp;
  String salesCamp;
  String invoice;
  String orderDate;
  String totalItem;
  String totalAmount;
  String note;
  String reciveTypeText;

  Inprocess({
    required this.orderSource,
    required this.ordshopId,
    required this.supplierCode,
    required this.supplierName,
    required this.orderId,
    required this.orderNo,
    required this.enduserId,
    required this.telnumber,
    required this.name,
    required this.repSeq,
    required this.repCode,
    required this.repName,
    required this.repTelnumber,
    required this.userType,
    required this.statusCode,
    required this.status,
    required this.billSeq,
    required this.orderCamp,
    required this.salesCamp,
    required this.invoice,
    required this.orderDate,
    required this.totalItem,
    required this.totalAmount,
    required this.note,
    required this.reciveTypeText,
  });

  factory Inprocess.fromJson(Map<String, dynamic> json) => Inprocess(
        orderSource: json["order_source"],
        ordshopId: json["ordshop_id"],
        supplierCode: json["supplier_code"],
        supplierName: json["supplier_name"],
        orderId: json["order_id"],
        orderNo: json["order_no"],
        enduserId: json["enduserID"],
        telnumber: json["telnumber"],
        name: json["name"],
        repSeq: json["rep_seq"],
        repCode: json["rep_code"],
        repName: json["rep_name"],
        repTelnumber: json["rep_telnumber"],
        userType: json["user_type"],
        statusCode: json["status_code"],
        status: json["status"],
        billSeq: json["bill_seq"],
        orderCamp: json["order_camp"],
        salesCamp: json["sales_camp"],
        invoice: json["invoice"],
        orderDate: json["order_date"],
        totalItem: json["total_item"],
        totalAmount: json["total_amount"],
        note: json["note"],
        reciveTypeText: json["recive_type_text"],
      );

  Map<String, dynamic> toJson() => {
        "order_source": orderSource,
        "ordshop_id": ordshopId,
        "supplier_code": supplierCode,
        "supplier_name": supplierName,
        "order_id": orderId,
        "order_no": orderNo,
        "enduserID": enduserId,
        "telnumber": telnumber,
        "name": name,
        "rep_seq": repSeq,
        "rep_code": repCode,
        "rep_name": repName,
        "rep_telnumber": repTelnumber,
        "user_type": userType,
        "status_code": statusCode,
        "status": status,
        "bill_seq": billSeq,
        "order_camp": orderCamp,
        "sales_camp": salesCamp,
        "invoice": invoice,
        "order_date": orderDate,
        "total_item": totalItem,
        "total_amount": totalAmount,
        "note": note,
        "recive_type_text": reciveTypeText,
      };
}
