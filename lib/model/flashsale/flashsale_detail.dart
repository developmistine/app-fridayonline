// To parse this JSON data, do
//
//     final flashSaleDetailRun = flashSaleDetailRunFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

FlashSaleDetailRun flashSaleDetailRunFromJson(String str) =>
    FlashSaleDetailRun.fromJson(json.decode(str));

String flashSaleDetailRunToJson(FlashSaleDetailRun data) =>
    json.encode(data.toJson());

class FlashSaleDetailRun {
  FlashSaleDetailRun({
    required this.banner,
    required this.flashSale,
  });

  String banner;
  List<FlashSale> flashSale;

  factory FlashSaleDetailRun.fromJson(Map<String, dynamic> json) =>
      FlashSaleDetailRun(
        banner: json["Banner"] ?? "",
        flashSale: json["FlashSale"] == null
            ? []
            : List<FlashSale>.from(
                json["FlashSale"].map((x) => FlashSale.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Banner": banner,
        "FlashSale": List<dynamic>.from(flashSale.map((x) => x.toJson())),
      };
}

class FlashSale {
  FlashSale({
    required this.systemDate,
    required this.systemTime,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.status,
    required this.showDate,
    required this.color,
    required this.countDown,
    required this.product,
  });

  String systemDate;
  String systemTime;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  String status;
  String showDate;
  String color;
  String countDown;
  List<Product> product;

  factory FlashSale.fromJson(Map<String, dynamic> json) => FlashSale(
        systemDate: json["SystemDate"] ?? "",
        systemTime: json["SystemTime"] ?? "",
        startDate: json["StartDate"] ?? "",
        startTime: json["StartTime"] ?? "",
        endDate: json["EndDate"] ?? "",
        endTime: json["EndTime"] ?? "",
        status: json["Status"] ?? "",
        showDate: json["ShowDate"] ?? "",
        color: json["Color"] ?? "",
        countDown: json["CountDown"] ?? "",
        product: json["Product"] == null
            ? []
            : List<Product>.from(
                json["Product"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "SystemDate": systemDate,
        "SystemTime": systemTime,
        "StartDate": startDate,
        "StartTime": startTime,
        "EndDate": endDate,
        "EndTime": endTime,
        "Status": status,
        "ShowDate": showDate,
        "Color": color,
        "CountDown": countDown,
        "Product": List<dynamic>.from(product.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    required this.sku,
    required this.campaign,
    required this.brand,
    required this.billCode,
    required this.name,
    required this.img,
    required this.linkDetail,
    required this.linkReview,
    required this.specialPrice,
    required this.billColor,
    required this.checkLimit,
    required this.userType,
    required this.saleLimit,
    required this.useLimit,
    required this.isInStock,
    required this.stockBalance,
    required this.saleBalance,
    required this.price,
    required this.percentSale,
    required this.percentDiscount,
    required this.percentNum,
    required this.mediaCode,
    required this.limitDescription,
    required this.imgAppend,
    required this.imgNetPrice,
    required this.flagNetPrice,
    required this.soldOutTime,
  });

  String sku;
  String campaign;
  String brand;
  String billCode;
  String name;
  String img;
  String linkDetail;
  String linkReview;
  String specialPrice;
  String billColor;
  String checkLimit;
  String userType;
  String saleLimit;
  String useLimit;
  bool isInStock;
  String stockBalance;
  String saleBalance;
  String price;
  String percentSale;
  String percentDiscount;
  int percentNum;
  String mediaCode;
  String limitDescription;
  String imgAppend;
  String imgNetPrice;
  String flagNetPrice;
  dynamic soldOutTime;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        sku: json["Sku"] ?? "",
        campaign: json["Campaign"] ?? "",
        brand: json["brand"] ?? "",
        billCode: json["BillCode"] ?? "",
        name: json["Name"] ?? "",
        img: json["Img"] ?? "",
        linkDetail: json["LinkDetail"] ?? "",
        linkReview: json["LinkReview"] ?? "",
        specialPrice: json["SpecialPrice"] ?? "",
        billColor: json["BillColor"] ?? "",
        checkLimit: json["CheckLimit"] ?? "",
        userType: json["UserType"] ?? "",
        saleLimit: json["SaleLimit"] ?? "",
        useLimit: json["UseLimit"] ?? "",
        isInStock: json["IsInStock"] ?? "",
        stockBalance: json["StockBalance"] ?? "",
        saleBalance: json["SaleBalance"] ?? "",
        price: json["Price"] ?? "",
        percentSale: json["PercentSale"] ?? "",
        percentDiscount: json["PercentDiscount"] ?? "",
        percentNum: json["PercentNum"] ?? 0,
        mediaCode: json["MediaCode"] ?? "",
        limitDescription: json["LimitDescription"] ?? "",
        imgAppend: json["ImgAppend"] ?? "",
        imgNetPrice: json["imgNetPrice"] ?? "",
        flagNetPrice: json["flagNetPrice"] ?? "",
        soldOutTime: json["SoldOutTime"],
      );

  Map<String, dynamic> toJson() => {
        "Sku": sku,
        "Campaign": campaign,
        "brand": brand,
        "BillCode": billCode,
        "Name": name,
        "Img": img,
        "LinkDetail": linkDetail,
        "LinkReview": linkReview,
        "SpecialPrice": specialPrice,
        "BillColor": billColor,
        "CheckLimit": checkLimit,
        "UserType": userType,
        "SaleLimit": saleLimit,
        "UseLimit": useLimit,
        "IsInStock": isInStock,
        "StockBalance": stockBalance,
        "SaleBalance": saleBalance,
        "Price": price,
        "PercentSale": percentSale,
        "PercentDiscount": percentDiscount,
        "PercentNum": percentNum,
        "MediaCode": mediaCode,
        "LimitDescription": limitDescription,
        "ImgAppend": imgAppend,
        "imgNetPrice": imgNetPrice,
        "flagNetPrice": flagNetPrice,
        "SoldOutTime": soldOutTime,
      };
}
