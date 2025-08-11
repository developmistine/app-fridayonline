// To parse this JSON data, do
//
//     final mainPayment = mainPaymentFromJson(jsonString);

import 'dart:convert';

MainPayment mainPaymentFromJson(String str) =>
    MainPayment.fromJson(json.decode(str));

String mainPaymentToJson(MainPayment data) => json.encode(data.toJson());

class MainPayment {
  Payment mslPayment;
  Payment enduserPayment;
  String text;
  String paymentUrl;

  MainPayment({
    required this.mslPayment,
    required this.enduserPayment,
    required this.text,
    required this.paymentUrl,
  });

  factory MainPayment.fromJson(Map<String, dynamic> json) => MainPayment(
        mslPayment: Payment.fromJson(json["MslPayment"]),
        enduserPayment: Payment.fromJson(json["EnduserPayment"]),
        text: json["Text"],
        paymentUrl: json["PaymentUrl"],
      );

  Map<String, dynamic> toJson() => {
        "MslPayment": mslPayment.toJson(),
        "EnduserPayment": enduserPayment.toJson(),
        "Text": text,
        "PaymentUrl": paymentUrl,
      };
}

class Payment {
  String textDetail;
  String totAmount;
  int orderQty;

  Payment({
    required this.textDetail,
    required this.totAmount,
    required this.orderQty,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        textDetail: json["TextDetail"],
        totAmount: json["TotAmount"],
        orderQty: json["OrderQty"],
      );

  Map<String, dynamic> toJson() => {
        "TextDetail": textDetail,
        "TotAmount": totAmount,
        "OrderQty": orderQty,
      };
}
