// To parse this JSON data, do
//
//     final getEnduserPayment = getEnduserPaymentFromJson(jsonString);

import 'dart:convert';

GetEnduserPayment getEnduserPaymentFromJson(String str) =>
    GetEnduserPayment.fromJson(json.decode(str));

String getEnduserPaymentToJson(GetEnduserPayment data) =>
    json.encode(data.toJson());

class GetEnduserPayment {
  String text;
  List<EndUserPayDatum> endUserPayData;

  GetEnduserPayment({
    required this.text,
    required this.endUserPayData,
  });

  factory GetEnduserPayment.fromJson(Map<String, dynamic> json) =>
      GetEnduserPayment(
        text: json["Text"],
        endUserPayData: List<EndUserPayDatum>.from(
            json["EndUserPayData"].map((x) => EndUserPayDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Text": text,
        "EndUserPayData":
            List<dynamic>.from(endUserPayData.map((x) => x.toJson())),
      };
}

class EndUserPayDatum {
  String campaign;
  String textCampaign;
  String totalProfitAmt;
  String totalSaleAmt;
  List<OrderList> orderList;

  EndUserPayDatum({
    required this.campaign,
    required this.textCampaign,
    required this.totalProfitAmt,
    required this.totalSaleAmt,
    required this.orderList,
  });

  factory EndUserPayDatum.fromJson(Map<String, dynamic> json) =>
      EndUserPayDatum(
        campaign: json["Campaign"],
        textCampaign: json["TextCampaign"],
        totalProfitAmt: json["TotalProfitAmt"],
        totalSaleAmt: json["TotalSaleAmt"],
        orderList: List<OrderList>.from(
            json["OrderList"].map((x) => OrderList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Campaign": campaign,
        "TextCampaign": textCampaign,
        "TotalProfitAmt": totalProfitAmt,
        "TotalSaleAmt": totalSaleAmt,
        "OrderList": List<dynamic>.from(orderList.map((x) => x.toJson())),
      };
}

class OrderList {
  String saleCampaign;
  String campaign;
  String repName;
  String transNo;
  bool isPay;
  String paymentType;
  String repCode;
  String enduserId;
  String profitAmt;
  String saleAmt;
  String status;

  OrderList({
    required this.saleCampaign,
    required this.campaign,
    required this.repName,
    required this.transNo,
    required this.isPay,
    required this.paymentType,
    required this.repCode,
    required this.enduserId,
    required this.profitAmt,
    required this.saleAmt,
    required this.status,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
        saleCampaign: json["SaleCampaign"],
        campaign: json["Campaign"],
        repName: json["RepName"],
        transNo: json["TransNo"],
        isPay: json["IsPay"],
        paymentType: json["PaymentType"],
        repCode: json["RepCode"],
        enduserId: json["EnduserId"],
        profitAmt: json["ProfitAmt"],
        saleAmt: json["SaleAmt"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "SaleCampaign": saleCampaign,
        "Campaign": campaign,
        "RepName": repName,
        "TransNo": transNo,
        "IsPay": isPay,
        "PaymentType": paymentType,
        "RepCode": repCode,
        "EnduserId": enduserId,
        "ProfitAmt": profitAmt,
        "SaleAmt": saleAmt,
        "Status": status,
      };
}
