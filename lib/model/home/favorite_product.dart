import 'dart:convert';

GetFavoriteProduct getFavoriteProductFromJson(String str) =>
    GetFavoriteProduct.fromJson(json.decode(str));

String getFavoriteProductToJson(GetFavoriteProduct data) =>
    json.encode(data.toJson());

class GetFavoriteProduct {
  GetFavoriteProduct({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.userId,
    required this.listProductDetail,
  });

  String repCode;
  String repType;
  String repSeq;
  String userId;
  List<ListProductDetail> listProductDetail;

  factory GetFavoriteProduct.fromJson(Map<String, dynamic> json) =>
      GetFavoriteProduct(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        userId: json["UserId"] ?? "",
        listProductDetail: json["ListProductDetail"] == null
            ? []
            : List<ListProductDetail>.from(json["ListProductDetail"]
                .map((x) => ListProductDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "UserId": userId,
        "ListProductDetail":
            List<dynamic>.from(listProductDetail.map((x) => x.toJson())),
      };
}

class ListProductDetail {
  ListProductDetail(
      {required this.campaign,
      required this.mediaCode,
      required this.brand,
      required this.billCode,
      required this.name,
      required this.sku,
      required this.fsName,
      required this.fsCodetemp,
      required this.specialPrice,
      required this.price,
      required this.img,
      required this.isInStock,
      required this.limitDescription,
      required this.imgAppend,
      required this.billColor,
      required this.productCode,
      required this.billCodeB2C,
      required this.imgNetPrice,
      required this.flagNetPrice,
      required this.flagHouseBrand,
      required this.totalReview,
      required this.ratingProduct});

  String campaign;
  String mediaCode;
  String brand;
  String billCode;
  String name;
  String sku;
  String fsName;
  String fsCodetemp;
  String specialPrice;
  String price;
  String img;
  bool isInStock;
  String limitDescription;
  String imgAppend;
  String billColor;
  String productCode;
  String billCodeB2C;
  String imgNetPrice;
  String flagNetPrice;
  String flagHouseBrand;
  int totalReview;
  double ratingProduct;

  factory ListProductDetail.fromJson(Map<String, dynamic> json) =>
      ListProductDetail(
        campaign: json["Campaign"] ?? "",
        mediaCode: json["MediaCode"] ?? "",
        brand: json["brand"] ?? "",
        billCode: json["billCode"] ?? "",
        name: json["name"] ?? "",
        sku: json["sku"] ?? "",
        fsName: json["FS_NAME"] ?? "",
        fsCodetemp: json["FS_CODETEMP"] ?? "",
        specialPrice: json["special_price"] ?? "",
        price: json["price"] ?? "",
        img: json["img"] ?? "",
        isInStock: json["is_in_stock"],
        limitDescription: json["LimitDescription"] ?? "",
        imgAppend: json["ImgAppend"] ?? "",
        billColor: json["BillColor"] ?? "",
        productCode: json["ProductCode"] ?? "",
        billCodeB2C: json["BillCodeB2C"] ?? "",
        imgNetPrice: json["imgNetPrice"] ?? "",
        flagNetPrice: json["flagNetPrice"] ?? "",
        flagHouseBrand: json["flagHouseBrand"] ?? "",
        totalReview: json["TotalReview"] ?? 0,
        ratingProduct: json["RatingProduct"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "Campaign": campaign,
        "MediaCode": mediaCode,
        "brand": brand,
        "billCode": billCode,
        "name": name,
        "sku": sku,
        "FS_NAME": fsName,
        "FS_CODETEMP": fsCodetemp,
        "special_price": specialPrice,
        "price": price,
        "img": img,
        "is_in_stock": isInStock,
        "LimitDescription": limitDescription,
        "ImgAppend": imgAppend,
        "BillColor": billColor,
        "ProductCode": productCode,
        "BillCodeB2C": billCodeB2C,
        "imgNetPrice": imgNetPrice,
        "flagNetPrice": flagNetPrice,
        "flagHouseBrand": flagHouseBrand,
        "TotalReview": totalReview,
        "RatingProduct": ratingProduct,
      };
}
