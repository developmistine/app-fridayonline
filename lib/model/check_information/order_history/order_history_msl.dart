// To parse this JSON data, do
//
//     final orderHistoryMsl = orderHistoryMslFromJson(jsonString);

import 'dart:convert';

List<OrderHistoryMsl> orderHistoryMslFromJson(String str) =>
    List<OrderHistoryMsl>.from(
        json.decode(str).map((x) => OrderHistoryMsl.fromJson(x)));

String orderHistoryMslToJson(List<OrderHistoryMsl> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderHistoryMsl {
  String orderNo;
  String orderSource;
  String ordshopId;
  String supplierCode;
  String supplierName;
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
  String note;

  OrderHistoryMsl({
    required this.orderNo,
    required this.orderSource,
    required this.ordshopId,
    required this.supplierCode,
    required this.supplierName,
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
    required this.note,
  });

  factory OrderHistoryMsl.fromJson(Map<String, dynamic> json) =>
      OrderHistoryMsl(
        orderNo: json["order_no"] ?? "",
        orderSource: json["order_source"] ?? "",
        ordshopId: json["ordshop_id"] ?? "",
        supplierCode: json["supplier_code"] ?? "",
        supplierName: json["supplier_name"] ?? "",
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
        totalAmount: json["total_amount"]?.toDouble(),
        grossAmount: json["gross_amount"]?.toDouble(),
        totalDiscount: json["total_discount"]?.toDouble(),
        statusCode: json["status_code"],
        status: json["status"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "order_no": orderNo,
        "order_source": orderSource,
        "ordshop_id": ordshopId,
        "supplier_code": supplierCode,
        "supplier_name": supplierName,
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
        "note": note,
      };
}
