// To parse this JSON data, do
//
//     final marketGetFavoriteProduct = marketGetFavoriteProductFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

MarketGetFavoriteProduct marketGetFavoriteProductFromJson(String str) =>
    MarketGetFavoriteProduct.fromJson(json.decode(str));

String marketGetFavoriteProductToJson(MarketGetFavoriteProduct data) =>
    json.encode(data.toJson());

class MarketGetFavoriteProduct {
  MarketGetFavoriteProduct({
    required this.token,
    required this.device,
    required this.customerId,
    required this.userType,
    required this.countBadge,
    required this.favoriteProduct,
  });

  String token;
  String device;
  String customerId;
  String userType;
  String countBadge;
  List<FavoriteProduct> favoriteProduct;

  factory MarketGetFavoriteProduct.fromJson(Map<String, dynamic> json) =>
      MarketGetFavoriteProduct(
        token: json["Token"] ?? "",
        device: json["Device"] ?? "",
        customerId: json["CustomerID"] ?? "",
        userType: json["UserType"] ?? "",
        countBadge: json["CountBadge"] ?? "",
        favoriteProduct: json["FavoriteProduct"] == null
            ? []
            : List<FavoriteProduct>.from(json["FavoriteProduct"]
                .map((x) => FavoriteProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Token": token,
        "Device": device,
        "CustomerID": customerId,
        "UserType": userType,
        "CountBadge": countBadge,
        "FavoriteProduct":
            List<dynamic>.from(favoriteProduct.map((x) => x.toJson())),
      };
}

class FavoriteProduct {
  FavoriteProduct({
    required this.productName,
    required this.productImg,
    required this.productCode,
    required this.regularPrice,
    required this.spacialprice,
    required this.statusFlag,
    required this.isInStore,
    required this.profitPerPcs,
  });

  String productName;
  String productImg;
  String productCode;
  String regularPrice;
  String spacialprice;
  dynamic statusFlag;
  String isInStore;
  String profitPerPcs;

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) =>
      FavoriteProduct(
        productName: json["ProductName"] ?? "",
        productImg: json["ProductImg"] ?? "",
        productCode: json["ProductCode"] ?? "",
        regularPrice: json["RegularPrice"] ?? "",
        spacialprice: json["Spacialprice"] ?? "",
        statusFlag: json["StatusFlag"],
        isInStore: json["IsInStore"] ?? "",
        profitPerPcs: json["ProfitPerPcs"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ProductName": productName,
        "ProductImg": productImg,
        "ProductCode": productCode,
        "RegularPrice": regularPrice,
        "Spacialprice": spacialprice,
        "StatusFlag": statusFlag,
        "IsInStore": isInStore,
        "ProfitPerPcs": profitPerPcs,
      };
}
