// To parse this JSON data, do
//
//     final coinsTransaction = coinsTransactionFromJson(jsonString);

import 'dart:convert';

CoinsTransaction coinsTransactionFromJson(String str) =>
    CoinsTransaction.fromJson(json.decode(str));

String coinsTransactionToJson(CoinsTransaction data) =>
    json.encode(data.toJson());

class CoinsTransaction {
  String code;
  Data data;
  String message;

  CoinsTransaction({
    required this.code,
    required this.data,
    required this.message,
  });

  factory CoinsTransaction.fromJson(Map<String, dynamic> json) =>
      CoinsTransaction(
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
  int availableAmount;
  List<ExpiryInfo> expiryInfo;
  List<Item> items;

  Data({
    required this.availableAmount,
    required this.expiryInfo,
    required this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        availableAmount: json["available_amount"],
        expiryInfo: List<ExpiryInfo>.from(
            json["expiry_info"].map((x) => ExpiryInfo.fromJson(x))),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "available_amount": availableAmount,
        "expiry_info": List<dynamic>.from(expiryInfo.map((x) => x.toJson())),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ExpiryInfo {
  String displayText;
  int coinAmount;
  String expireDate;

  ExpiryInfo({
    required this.displayText,
    required this.coinAmount,
    required this.expireDate,
  });

  factory ExpiryInfo.fromJson(Map<String, dynamic> json) => ExpiryInfo(
        displayText: json["display_text"],
        coinAmount: json["coin_amount"],
        expireDate: json["expire_date"],
      );

  Map<String, dynamic> toJson() => {
        "display_text": displayText,
        "coin_amount": coinAmount,
        "expire_date": expireDate,
      };
}

class Item {
  int coinId;
  String coinName;
  String coinDesc;
  String image;
  int coinAmount;
  String coinAmountDisplay;
  String cDate;

  Item({
    required this.coinId,
    required this.coinName,
    required this.coinDesc,
    required this.image,
    required this.coinAmount,
    required this.coinAmountDisplay,
    required this.cDate,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        coinId: json["coin_id"],
        coinName: json["coin_name"],
        coinDesc: json["coin_desc"],
        image: json["image"],
        coinAmount: json["coin_amount"],
        coinAmountDisplay: json["coin_amount_display"],
        cDate: json["c_date"],
      );

  Map<String, dynamic> toJson() => {
        "coin_id": coinId,
        "coin_name": coinName,
        "coin_desc": coinDesc,
        "image": image,
        "coin_amount": coinAmount,
        "coin_amount_display": coinAmountDisplay,
        "c_date": cDate,
      };
}
