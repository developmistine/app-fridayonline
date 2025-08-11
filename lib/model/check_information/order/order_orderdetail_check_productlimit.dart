// To parse this JSON data, do
//
//     final checkInformationOrderOrderDetailCheckProductLimit = checkInformationOrderOrderDetailCheckProductLimitFromJson(jsonString);

import 'dart:convert';

CheckInformationOrderOrderDetailCheckProductLimit
    checkInformationOrderOrderDetailCheckProductLimitFromJson(String str) =>
        CheckInformationOrderOrderDetailCheckProductLimit.fromJson(
            json.decode(str));

String checkInformationOrderOrderDetailCheckProductLimitToJson(
        CheckInformationOrderOrderDetailCheckProductLimit data) =>
    json.encode(data.toJson());

class CheckInformationOrderOrderDetailCheckProductLimit {
  CheckInformationOrderOrderDetailCheckProductLimit({
    required this.repCode,
    required this.repSeq,
    required this.detailOrder,
  });

  String repCode;
  String repSeq;
  List<DetailOrder> detailOrder;

  factory CheckInformationOrderOrderDetailCheckProductLimit.fromJson(
          Map<String, dynamic> json) =>
      CheckInformationOrderOrderDetailCheckProductLimit(
        repCode: json["RepCode"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        detailOrder: json["DetailOrder"] == null ? [] : List<DetailOrder>.from(
            json["DetailOrder"].map((x) => DetailOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepSeq": repSeq,
        "DetailOrder": List<dynamic>.from(detailOrder.map((x) => x.toJson())),
      };
}

class DetailOrder {
  DetailOrder({
    required this.billCode,
    required this.billcamp,
    required this.qtyConfirm,
    required this.qtyAll,
    required this.saleLimt,
    required this.flagSlaeLimit,
    required this.description,
  });

  String billCode;
  String billcamp;
  int qtyConfirm;
  int qtyAll;
  int saleLimt;
  String flagSlaeLimit;
  String description;

  factory DetailOrder.fromJson(Map<String, dynamic> json) => DetailOrder(
        billCode: json["BillCode"] ?? "",
        billcamp: json["Billcamp"] ?? "",
        qtyConfirm: json["QtyConfirm"] ?? 0,
        qtyAll: json["QtyAll"] ?? 0,
        saleLimt: json["SaleLimt"] ?? 0,
        flagSlaeLimit: json["FlagSlaeLimit"] ?? "",
        description: json["Description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "BillCode": billCode,
        "Billcamp": billcamp,
        "QtyConfirm": qtyConfirm,
        "QtyAll": qtyAll,
        "SaleLimt": saleLimt,
        "FlagSlaeLimit": flagSlaeLimit,
        "Description": description,
      };
}
