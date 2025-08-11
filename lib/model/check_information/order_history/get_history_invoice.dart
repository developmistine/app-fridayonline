// To parse this JSON data, do
//
//     final getProductByInvioce = getProductByInvioceFromJson(jsonString);

import 'dart:convert';

GetProductByInvioce getProductByInvioceFromJson(String str) =>
    GetProductByInvioce.fromJson(json.decode(str));

String getProductByInvioceToJson(GetProductByInvioce data) =>
    json.encode(data.toJson());

class GetProductByInvioce {
  String campDate;
  String receivedDate;
  List<ProductDetail>? productDetail;
  List<ReasonAll> reasonAll;

  GetProductByInvioce({
    required this.campDate,
    required this.receivedDate,
    required this.productDetail,
    required this.reasonAll,
  });

  factory GetProductByInvioce.fromJson(Map<String, dynamic> json) =>
      GetProductByInvioce(
        campDate: json["camp_date"],
        receivedDate: json["received_date"],
        productDetail: List<ProductDetail>.from(
            json["product_detail"].map((x) => ProductDetail.fromJson(x))),
        reasonAll: List<ReasonAll>.from(
            json["reason_all"].map((x) => ReasonAll.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "camp_date": campDate,
        "received_date": receivedDate,
        "product_detail":
            List<dynamic>.from(productDetail!.map((x) => x.toJson())),
        "reason_all": List<dynamic>.from(reasonAll.map((x) => x.toJson())),
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

  ReasonAll({
    required this.code,
    required this.reason,
  });

  factory ReasonAll.fromJson(Map<String, dynamic> json) => ReasonAll(
        code: json["code"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "reason": reason,
      };
}
