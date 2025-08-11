import 'dart:convert';

Listproduct listproductFromJson(String str) =>
    Listproduct.fromJson(json.decode(str));

String listproductToJson(Listproduct data) => json.encode(data.toJson());

class Listproduct {
  Listproduct({
    required this.skucode,
  });

  List<Skucode> skucode;

  factory Listproduct.fromJson(Map<String, dynamic> json) => Listproduct(
        skucode: json["skucode"] == null
            ? []
            : List<Skucode>.from(
                json["skucode"].map((x) => Skucode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "skucode": List<dynamic>.from(skucode.map((x) => x.toJson())),
      };
}

class Skucode {
  Skucode(
      {required this.campaign,
      required this.billCode,
      required this.brand,
      required this.mediaCode,
      required this.sku,
      required this.name,
      required this.position,
      required this.categoryId,
      required this.linkDetail,
      required this.linkReview,
      required this.linkInformation,
      required this.img,
      required this.price,
      required this.specialPrice,
      required this.billColor,
      required this.checkLimit,
      required this.userType,
      required this.saleLimit,
      required this.useLimit,
      required this.isInStock,
      required this.returnStatus,
      required this.returnMessage,
      required this.nameText,
      required this.pageNo,
      required this.fsName,
      required this.limitDescription,
      required this.imgAppend,
      required this.fsCodeTemp,
      required this.productCode,
      required this.billCodeB2C,
      required this.flagNetPrice,
      required this.flagHouseBrand,
      required this.imgNetPrice,
      required this.totalReview,
      required this.ratingProduct});

  String campaign;
  String billCode;
  String brand;
  String mediaCode;
  String sku;
  String name;
  int position;
  String categoryId;
  String linkDetail;
  String linkReview;
  String linkInformation;
  String img;
  String price;
  String specialPrice;
  String billColor;
  String checkLimit;
  String userType;
  String saleLimit;
  String useLimit;
  bool isInStock;
  String returnStatus;
  String returnMessage;
  String nameText;
  String pageNo;
  String fsName;
  String limitDescription;
  String imgAppend;
  String fsCodeTemp;
  String productCode;
  String billCodeB2C;
  String flagNetPrice;
  String flagHouseBrand;
  String imgNetPrice;
  int totalReview;
  double ratingProduct;

  factory Skucode.fromJson(Map<String, dynamic> json) => Skucode(
        campaign: json["Campaign"] ?? "",
        billCode: json["billCode"] ?? "",
        brand: json["brand"] ?? "",
        mediaCode: json["MediaCode"] ?? "",
        sku: json["sku"] ?? "",
        name: json["name"] ?? "",
        position: json["position"] ?? 0,
        categoryId: json["category_id"] ?? "",
        linkDetail: json["link_detail"] ?? "",
        linkReview: json["link_review"] ?? "",
        linkInformation: json["link_information"] ?? "",
        img: json["img"] ?? "",
        price: json["price"] ?? "",
        specialPrice: json["special_price"] ?? "",
        billColor: json["BillColor"] ?? "",
        checkLimit: json["CheckLimit"] ?? "",
        userType: json["UserType"] ?? "",
        saleLimit: json["SaleLimit"] ?? "",
        useLimit: json["UseLimit"] ?? "",
        isInStock: json["is_in_stock"],
        returnStatus: json["ReturnStatus"] ?? "",
        returnMessage: json["ReturnMessage"] ?? "",
        nameText: json["NameText"] ?? "",
        pageNo: json["PageNo"] ?? "",
        fsName: json["fs_name"] ?? "",
        limitDescription: json["LimitDescription"] ?? "",
        imgAppend: json["ImgAppend"] ?? "",
        fsCodeTemp: json["FsCode_temp"] ?? "",
        productCode: json["ProductCode"] ?? "",
        billCodeB2C: json["BillCodeB2C"] ?? "",
        flagNetPrice: json["flagNetPrice"] ?? "",
        flagHouseBrand: json["flagHouseBrand"] ?? "",
        imgNetPrice: json["imgNetPrice"] ?? "",
        totalReview: json["TotalReview"] ?? 0,
        ratingProduct: json["RatingProduct"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "Campaign": campaign,
        "billCode": billCode,
        "brand": brand,
        "MediaCode": mediaCode,
        "sku": sku,
        "name": name,
        "position": position,
        "category_id": categoryId,
        "link_detail": linkDetail,
        "link_review": linkReview,
        "link_information": linkInformation,
        "img": img,
        "price": price,
        "special_price": specialPrice,
        "BillColor": billColor,
        "CheckLimit": checkLimit,
        "UserType": userType,
        "SaleLimit": saleLimit,
        "UseLimit": useLimit,
        "is_in_stock": isInStock,
        "ReturnStatus": returnStatus,
        "ReturnMessage": returnMessage,
        "NameText": nameText,
        "PageNo": pageNo,
        "fs_name": fsName,
        "LimitDescription": limitDescription,
        "ImgAppend": imgAppend,
        "FsCode_temp": fsCodeTemp,
        "ProductCode": productCode,
        "BillCodeB2C": billCodeB2C,
        "flagNetPrice": flagNetPrice,
        "flagHouseBrand": flagHouseBrand,
        "imgNetPrice": imgNetPrice,
        "TotalReview": totalReview,
        "RatingProduct": ratingProduct,
      };
}
