// To parse this JSON data, do
//
//     final affiliateEarningDetail = affiliateEarningDetailFromJson(jsonString);

import 'dart:convert';

AffiliateEarningDetail affiliateEarningDetailFromJson(String str) =>
    AffiliateEarningDetail.fromJson(json.decode(str));

String affiliateEarningDetailToJson(AffiliateEarningDetail data) =>
    json.encode(data.toJson());

class AffiliateEarningDetail {
  String code;
  Data data;
  String message;

  AffiliateEarningDetail({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateEarningDetail.fromJson(Map<String, dynamic> json) =>
      AffiliateEarningDetail(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Status status;
  String commissionAmount;
  String transactionFee;
  String netAmount;
  PaymentSummary paymentSummary;

  Data({
    required this.status,
    required this.commissionAmount,
    required this.transactionFee,
    required this.netAmount,
    required this.paymentSummary,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: Status.fromJson(json["status"]),
        commissionAmount: json["commission_amount"],
        transactionFee: json["transaction_fee"],
        netAmount: json["net_amount"],
        paymentSummary: PaymentSummary.fromJson(json["payment_summary"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "commission_amount": commissionAmount,
        "transaction_fee": transactionFee,
        "net_amount": netAmount,
        "payment_summary": paymentSummary.toJson(),
      };
}

class PaymentSummary {
  String paymentId;
  String bank;
  String bankAccountNumber;
  String bankAccountName;
  String createdAt;

  PaymentSummary({
    required this.paymentId,
    required this.bank,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.createdAt,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) => PaymentSummary(
        paymentId: json["payment_id"],
        bank: json["bank"],
        bankAccountNumber: json["bank_account_number"],
        bankAccountName: json["bank_account_name"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "bank": bank,
        "bank_account_number": bankAccountNumber,
        "bank_account_name": bankAccountName,
        "created_at": createdAt,
      };
}

class Status {
  String colorCode;
  String label;
  String description;
  String name;

  Status({
    required this.colorCode,
    required this.label,
    required this.description,
    required this.name,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        colorCode: json["color_code"],
        label: json["label"],
        description: json["description"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "color_code": colorCode,
        "label": label,
        "description": description,
        "name": name
      };
}
