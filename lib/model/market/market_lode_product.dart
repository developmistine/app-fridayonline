// To parse this JSON data, do
//
//     final marketLoadmore = marketLoadmoreFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

MarketLoadmore marketLoadmoreFromJson(String str) =>
    MarketLoadmore.fromJson(json.decode(str));

String marketLoadmoreToJson(MarketLoadmore data) => json.encode(data.toJson());

class MarketLoadmore {
  MarketLoadmore({
    required this.token,
    required this.device,
    required this.customerId,
    required this.userType,
    required this.contentId,
    required this.datetime,
    required this.productRecommend,
  });

  String token;
  String device;
  String customerId;
  String userType;
  String contentId;
  dynamic datetime;
  List<ProductRecommend> productRecommend;

  factory MarketLoadmore.fromJson(Map<String, dynamic> json) => MarketLoadmore(
        token: json["Token"] ?? "",
        device: json["Device"] ?? "",
        customerId: json["CustomerID"] ?? "",
        userType: json["UserType"] ?? "",
        contentId: json["ContentID"] ?? "",
        datetime: json["Datetime"],
        productRecommend: json["ProductRecommend"] == null
            ? []
            : List<ProductRecommend>.from(json["ProductRecommend"]
                .map((x) => ProductRecommend.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Token": token,
        "Device": device,
        "CustomerID": customerId,
        "UserType": userType,
        "ContentID": contentId,
        "Datetime": datetime,
        "ProductRecommend":
            List<dynamic>.from(productRecommend.map((x) => x.toJson())),
      };
}

class ProductRecommend {
  ProductRecommend({
    required this.productRecommendIndex,
    required this.billCode,
    required this.billNameThai,
    required this.billNameEng,
    required this.reqularprice,
    required this.specialprice,
    required this.scoreStar,
    required this.scoreLike,
    required this.urlImg,
    required this.profitPerPcs,
    required this.isInStore,
  });

  String productRecommendIndex;
  String billCode;
  String billNameThai;
  String billNameEng;
  String reqularprice;
  String specialprice;
  dynamic scoreStar;
  dynamic scoreLike;
  String urlImg;
  String profitPerPcs;
  String isInStore;

  factory ProductRecommend.fromJson(Map<String, dynamic> json) =>
      ProductRecommend(
        productRecommendIndex: json["ProductRecommendIndex"] ?? "",
        billCode: json["BillCode"] ?? "",
        billNameThai: json["BillNameThai"] ?? "",
        billNameEng: json["BillNameEng"] ?? "",
        reqularprice: json["Reqularprice"] ?? "",
        specialprice: json["Specialprice"] ?? "",
        scoreStar: json["ScoreStar"],
        scoreLike: json["ScoreLike"],
        urlImg: json["UrlImg"] ?? "",
        profitPerPcs: json["ProfitPerPcs"] ?? "",
        isInStore: json["IsInStore"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ProductRecommendIndex": productRecommendIndex,
        "BillCode": billCode,
        "BillNameThai": billNameThai,
        "BillNameEng": billNameEng,
        "Reqularprice": reqularprice,
        "Specialprice": specialprice,
        "ScoreStar": scoreStar,
        "ScoreLike": scoreLike,
        "UrlImg": urlImg,
        "ProfitPerPcs": profitPerPcs,
        "IsInStore": isInStore,
      };
}
