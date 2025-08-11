import 'dart:convert';

BadgerProfileMsl badgerProfileMslFromJson(String str) =>
    BadgerProfileMsl.fromJson(json.decode(str));

String badgerProfileMslToJson(BadgerProfileMsl data) =>
    json.encode(data.toJson());

class BadgerProfileMsl {
  BadgerProfileMsl({
    required this.configFile,
  });

  ConfigFile configFile;

  factory BadgerProfileMsl.fromJson(Map<String, dynamic> json) =>
      BadgerProfileMsl(
        configFile: ConfigFile.fromJson(json["ConfigFile"]),
      );

  Map<String, dynamic> toJson() => {
        "ConfigFile": configFile.toJson(),
      };
}

class ConfigFile {
  ConfigFile({
    required this.badger,
  });

  Badger badger;

  factory ConfigFile.fromJson(Map<String, dynamic> json) => ConfigFile(
        badger: Badger.fromJson(json["Badger"]),
      );

  Map<String, dynamic> toJson() => {
        "Badger": badger.toJson(),
      };
}

class Badger {
  Badger({
    required this.orderManage,
    required this.customerList,
    required this.customerBundle,
    required this.promotion,
    required this.orderMsl,
    required this.proDed,
    required this.review,
  });

  CustomerBundle orderManage;
  CustomerBundle customerList;
  CustomerBundle customerBundle;
  CustomerBundle promotion;
  CustomerBundle orderMsl;
  CustomerBundle proDed;
  CustomerBundle review;

  factory Badger.fromJson(Map<String, dynamic> json) => Badger(
        orderManage: CustomerBundle.fromJson(json["OrderManage"]),
        customerList: CustomerBundle.fromJson(json["CustomerList"]),
        customerBundle: CustomerBundle.fromJson(json["CustomerBundle"]),
        promotion: CustomerBundle.fromJson(json["Promotion"]),
        orderMsl: CustomerBundle.fromJson(json["OrderMSL"]),
        proDed: CustomerBundle.fromJson(json["ProDed"]),
        review: CustomerBundle.fromJson(json["Review"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderManage": orderManage.toJson(),
        "CustomerList": customerList.toJson(),
        "CustomerBundle": customerBundle.toJson(),
        "Promotion": promotion.toJson(),
        "OrderMSL": orderMsl.toJson(),
        "ProDed": proDed.toJson(),
        "Review": review.toJson(),
      };
}

class CustomerBundle {
  CustomerBundle({
    required this.newMessage,
  });

  String newMessage;

  factory CustomerBundle.fromJson(Map<String, dynamic> json) => CustomerBundle(
        newMessage: json["NewMessage"] == "" ? "0" : json["NewMessage"],
      );

  Map<String, dynamic> toJson() => {
        "NewMessage": newMessage,
      };
}
