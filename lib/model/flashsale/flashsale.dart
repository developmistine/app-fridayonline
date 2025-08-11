// To parse this JSON data, do
//
//     final flashsale = flashsaleFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Flashsale flashsaleFromJson(String str) => Flashsale.fromJson(json.decode(str));

String flashsaleToJson(Flashsale data) => json.encode(data.toJson());

class Flashsale {
  Flashsale({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.textHeader,
    required this.menu,
    required this.announce,
    required this.banner,
    required this.favorite,
    required this.flashSale,
    required this.specialPromotion,
    required this.newProduct,
    required this.content,
    required this.bestSeller,
    required this.hotItem,
  });

  String repCode;
  String repType;
  String repSeq;
  dynamic textHeader;
  dynamic menu;
  dynamic announce;
  dynamic banner;
  dynamic favorite;
  List<FlashsaleFlashSale> flashSale;
  dynamic specialPromotion;
  dynamic newProduct;
  dynamic content;
  dynamic bestSeller;
  dynamic hotItem;

  factory Flashsale.fromJson(Map<String, dynamic> json) => Flashsale(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        textHeader: json["TextHeader"],
        menu: json["Menu"],
        announce: json["Announce"],
        banner: json["Banner"],
        favorite: json["Favorite"],
        flashSale: json["FlashSale"] == null
            ? []
            : List<FlashsaleFlashSale>.from(
                json["FlashSale"].map((x) => FlashsaleFlashSale.fromJson(x))),
        specialPromotion: json["SpecialPromotion"],
        newProduct: json["NewProduct"],
        content: json["Content"],
        bestSeller: json["BestSeller"],
        hotItem: json["HotItem"],
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "TextHeader": textHeader,
        "Menu": menu,
        "Announce": announce,
        "Banner": banner,
        "Favorite": favorite,
        "FlashSale": List<dynamic>.from(flashSale.map((x) => x.toJson())),
        "SpecialPromotion": specialPromotion,
        "NewProduct": newProduct,
        "Content": content,
        "BestSeller": bestSeller,
        "HotItem": hotItem,
      };
}

class FlashsaleFlashSale {
  FlashsaleFlashSale({
    required this.id,
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
    required this.flashSale,
  });

  String id;
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
  List<FlashSaleFlashSale> flashSale;

  factory FlashsaleFlashSale.fromJson(Map<String, dynamic> json) =>
      FlashsaleFlashSale(
        id: json["ID"] ?? "",
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
        flashSale: json["FlashSale"] == null
            ? []
            : List<FlashSaleFlashSale>.from(
                json["FlashSale"].map((x) => FlashSaleFlashSale.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
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
        "FlashSale": List<dynamic>.from(flashSale.map((x) => x.toJson())),
      };
}

class FlashSaleFlashSale {
  FlashSaleFlashSale({
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
    required this.mediaCode,
    required this.percentnum,
    required this.limitDescription,
    required this.imgAppend,
    required this.imgNetPrice,
    required this.flagNetPrice,
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
  String mediaCode;
  int percentnum;
  String limitDescription;
  String imgAppend;
  String imgNetPrice;
  String flagNetPrice;

  factory FlashSaleFlashSale.fromJson(Map<String, dynamic> json) =>
      FlashSaleFlashSale(
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
        mediaCode: json["MediaCode"] ?? "",
        percentnum: json["percentnum"] ?? 0,
        limitDescription: json["LimitDescription"] ?? "",
        imgAppend: json["ImgAppend"] ?? "",
        imgNetPrice: json["imgNetPrice"] ?? "",
        flagNetPrice: json["flagNetPrice"] ?? "",
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
        "MediaCode": mediaCode,
        "percentnum": percentnum,
        "LimitDescription": limitDescription,
        "ImgAppend": imgAppend,
        "imgNetPrice": imgNetPrice,
        "flagNetPrice": flagNetPrice,
      };
}
