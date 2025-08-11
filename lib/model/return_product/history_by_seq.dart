// To parse this JSON data, do
//
//     final historyReturnBySeq = historyReturnBySeqFromJson(jsonString);

import 'dart:convert';

HistoryReturnBySeq historyReturnBySeqFromJson(String str) =>
    HistoryReturnBySeq.fromJson(json.decode(str));

String historyReturnBySeqToJson(HistoryReturnBySeq data) =>
    json.encode(data.toJson());

class HistoryReturnBySeq {
  String creDate;
  String campDate;
  ReasonAll reasonAll;
  String note;
  String totalAll;
  int amount;
  List<ProductDetail> productDetail;

  HistoryReturnBySeq({
    required this.creDate,
    required this.campDate,
    required this.reasonAll,
    required this.note,
    required this.totalAll,
    required this.amount,
    required this.productDetail,
  });

  factory HistoryReturnBySeq.fromJson(Map<String, dynamic> json) =>
      HistoryReturnBySeq(
        creDate: json["cre_date"],
        campDate: json["camp_date"],
        reasonAll: ReasonAll.fromJson(json["reason_all"]),
        note: json["note"],
        totalAll: json["total_all"],
        amount: json["amount"],
        productDetail: List<ProductDetail>.from(
            json["product_detail"].map((x) => ProductDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cre_date": creDate,
        "camp_date": campDate,
        "reason_all": reasonAll.toJson(),
        "note": note,
        "total_all": totalAll,
        "amount": amount,
        "product_detail":
            List<dynamic>.from(productDetail.map((x) => x.toJson())),
      };
}

class ProductDetail {
  String billcode;
  String billdesc;
  double price;
  int qty;
  String image;

  ProductDetail({
    required this.billcode,
    required this.billdesc,
    required this.price,
    required this.qty,
    required this.image,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        billcode: json["billcode"],
        billdesc: json["billdesc"],
        price: json["price"]?.toDouble(),
        qty: json["qty"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "billcode": billcode,
        "billdesc": billdesc,
        "price": price,
        "qty": qty,
        "image": image,
      };
}

class ReasonAll {
  String code;
  String reason;
  String detail;

  ReasonAll({
    required this.code,
    required this.reason,
    required this.detail,
  });

  factory ReasonAll.fromJson(Map<String, dynamic> json) => ReasonAll(
        code: json["code"],
        reason: json["reason"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "reason": reason,
        "detail": detail,
      };
}
