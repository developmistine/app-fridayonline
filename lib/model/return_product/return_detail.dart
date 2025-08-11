import 'dart:convert';

ReturnProductJson returnProductJsonFromJson(String str) =>
    ReturnProductJson.fromJson(json.decode(str));

String returnProductJsonToJson(ReturnProductJson data) =>
    json.encode(data.toJson());

class ReturnProductJson {
  String device;
  String repseq;
  String repcode;
  String invoice;
  String campDate;
  String receivedDate;
  List<ProductDetail> productDetail;
  ReasonAll reasonAll;

  ReturnProductJson({
    required this.device,
    required this.repseq,
    required this.repcode,
    required this.invoice,
    required this.campDate,
    required this.receivedDate,
    required this.productDetail,
    required this.reasonAll,
  });

  factory ReturnProductJson.fromJson(Map<String, dynamic> json) =>
      ReturnProductJson(
        device: json["device"],
        repseq: json["repseq"],
        repcode: json["repcode"],
        invoice: json["invoice"],
        campDate: json["camp_date"],
        receivedDate: json["received_date"],
        productDetail: List<ProductDetail>.from(
            json["product_detail"].map((x) => ProductDetail.fromJson(x))),
        reasonAll: ReasonAll.fromJson(json["reason_all"]),
      );

  Map<String, dynamic> toJson() => {
        "device": device,
        "repseq": repseq,
        "repcode": repcode,
        "invoice": invoice,
        "camp_date": campDate,
        "received_date": receivedDate,
        "product_detail":
            List<dynamic>.from(productDetail.map((x) => x.toJson())),
        "reason_all": reasonAll.toJson(),
      };
}

class ProductDetail {
  String billcode;
  String billdesc;
  double price;
  int qty;

  ProductDetail({
    required this.billcode,
    required this.billdesc,
    required this.price,
    required this.qty,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        billcode: json["billcode"],
        billdesc: json["billdesc"],
        price: json["price"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "billcode": billcode,
        "billdesc": billdesc,
        "price": price,
        "qty": qty,
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
