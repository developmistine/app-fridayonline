// To parse this JSON data, do
//
//     final getDropshipCategoryProduct = getDropshipCategoryProductFromJson(jsonString);

import 'dart:convert';

List<GetDropshipCategoryProduct> getDropshipCategoryProductFromJson(
        String str) =>
    List<GetDropshipCategoryProduct>.from(
        json.decode(str).map((x) => GetDropshipCategoryProduct.fromJson(x)));

String getDropshipCategoryProductToJson(
        List<GetDropshipCategoryProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetDropshipCategoryProduct {
  GetDropshipCategoryProduct({
    required this.category1,
    required this.cate1Desc,
    required this.product,
  });

  String category1;
  String cate1Desc;
  List<Product> product;

  factory GetDropshipCategoryProduct.fromJson(Map<String, dynamic> json) =>
      GetDropshipCategoryProduct(
        category1: json["Category1"] ?? "",
        cate1Desc: json["Cate1Desc"] ?? "",
        product: json["Product"] == null ? [] :
            List<Product>.from(json["Product"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Category1": category1,
        "Cate1Desc": cate1Desc,
        "Product": List<dynamic>.from(product.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    required this.category1,
    required this.cate1Desc,
    required this.billCode,
    required this.nameTh,
    required this.nameEn,
    required this.billDetail,
    required this.productCode,
    required this.sellerSku,
    required this.shortNameTh,
    required this.shortNameEn,
    required this.price,
    required this.priceRegular,
    required this.priceSpecial,
    required this.billCondition,
    required this.color,
    required this.size,
    required this.model,
    required this.isStatus,
    required this.priceMin,
    required this.priceMax,
    required this.jsonTag,
    required this.jsonPropertyId,
    required this.minAvalible,
    required this.avalibleQty,
    required this.stockQty,
    required this.cartPending,
    required this.isApproveStatus,
    required this.updateDate,
    required this.packageWeight,
    required this.packageLength,
    required this.packageWidth,
    required this.packageHeight,
    required this.imageSeq,
    required this.imageType,
    required this.imageUrl,
    required this.imageName,
    required this.isMainImgae,
    required this.forDevice,
    required this.keyCom,
    required this.keyWords,
    required this.campaign,
    required this.typeProject,
    required this.billYup,
    required this.supplierCode,
    required this.productDetail,
    required this.deliveryType,
    required this.paymentType,
  });

  String category1;
  String cate1Desc;
  String billCode;
  String nameTh;
  String nameEn;
  String billDetail;
  String productCode;
  String sellerSku;
  String shortNameTh;
  String shortNameEn;
  String price;
  String priceRegular;
  String priceSpecial;
  String billCondition;
  String color;
  String size;
  String model;
  String isStatus;
  String priceMin;
  String priceMax;
  String jsonTag;
  String jsonPropertyId;
  String minAvalible;
  String avalibleQty;
  String stockQty;
  String cartPending;
  String isApproveStatus;
  String updateDate;
  String packageWeight;
  String packageLength;
  String packageWidth;
  String packageHeight;
  String imageSeq;
  String imageType;
  String imageUrl;
  String imageName;
  String isMainImgae;
  String forDevice;
  String keyCom;
  String keyWords;
  String campaign;
  String typeProject;
  String billYup;
  String supplierCode;
  String productDetail;
  String deliveryType;
  String paymentType;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        category1: json["Category1"] ?? "",
        cate1Desc: json["Cate1Desc"] ?? "",
        billCode: json["BillCode"] ?? "",
        nameTh: json["NameTH"] ?? "",
        nameEn: json["NameEN"] ?? "",
        billDetail: json["BillDetail"] ?? "",
        productCode: json["ProductCode"] ?? "",
        sellerSku: json["SellerSku"] ?? "",
        shortNameTh: json["ShortNameTH"] ?? "",
        shortNameEn: json["ShortNameEN"] ?? "",
        price: json["Price"] ?? "",
        priceRegular: json["PriceRegular"] ?? "",
        priceSpecial: json["PriceSpecial"] ?? "",
        billCondition: json["BillCondition"] ?? "",
        color: json["Color"] ?? "",
        size: json["Size"] ?? "",
        model: json["Model"] ?? "",
        isStatus: json["IsStatus"] ?? "",
        priceMin: json["PriceMin"] ?? "",
        priceMax: json["PriceMax"] ?? "",
        jsonTag: json["JsonTag"] ?? "",
        jsonPropertyId: json["JsonPropertyId"] ?? "",
        minAvalible: json["MinAvalible"] ?? "",
        avalibleQty: json["AvalibleQty"] ?? "",
        stockQty: json["StockQty"] ?? "",
        cartPending: json["CartPending"] ?? "",
        isApproveStatus: json["IsApproveStatus"] ?? "",
        updateDate: json["UpdateDate"] ?? "",
        packageWeight: json["PackageWeight"] ?? "",
        packageLength: json["PackageLength"] ?? "",
        packageWidth: json["PackageWidth"] ?? "",
        packageHeight: json["PackageHeight"] ?? "",
        imageSeq: json["ImageSeq"] ?? "",
        imageType: json["ImageType"] ?? "",
        imageUrl: json["ImageUrl"] ?? "",
        imageName: json["ImageName"] ?? "",
        isMainImgae: json["IsMainImgae"] ?? "",
        forDevice: json["ForDevice"] ?? "",
        keyCom: json["KeyCom"] ?? "",
        keyWords: json["KeyWords"] ?? "",
        campaign: json["Campaign"] ?? "",
        typeProject: json["TypeProject"] ?? "",
        billYup: json["Bill_YUP"] ?? "",
        supplierCode: json["SupplierCode"] ?? "",
        productDetail: json["ProductDetail"] ?? "",
        deliveryType: json["DeliveryType"] ?? "",
        paymentType: json["PaymentType"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Category1": category1,
        "Cate1Desc": cate1Desc,
        "BillCode": billCode,
        "NameTH": nameTh,
        "NameEN": nameEn,
        "BillDetail": billDetail,
        "ProductCode": productCode,
        "SellerSku": sellerSku,
        "ShortNameTH": shortNameTh,
        "ShortNameEN": shortNameEn,
        "Price": price,
        "PriceRegular": priceRegular,
        "PriceSpecial": priceSpecial,
        "BillCondition": billCondition,
        "Color": color,
        "Size": size,
        "Model": model,
        "IsStatus": isStatus,
        "PriceMin": priceMin,
        "PriceMax": priceMax,
        "JsonTag": jsonTag,
        "JsonPropertyId": jsonPropertyId,
        "MinAvalible": minAvalible,
        "AvalibleQty": avalibleQty,
        "StockQty": stockQty,
        "CartPending": cartPending,
        "IsApproveStatus": isApproveStatus,
        "UpdateDate": updateDate,
        "PackageWeight": packageWeight,
        "PackageLength": packageLength,
        "PackageWidth": packageWidth,
        "PackageHeight": packageHeight,
        "ImageSeq": imageSeq,
        "ImageType": imageType,
        "ImageUrl": imageUrl,
        "ImageName": imageName,
        "IsMainImgae": isMainImgae,
        "ForDevice": forDevice,
        "KeyCom": keyCom,
        "KeyWords": keyWords,
        "Campaign": campaign,
        "TypeProject": typeProject,
        "Bill_YUP": billYup,
        "SupplierCode": supplierCode,
        "ProductDetail": productDetail,
        "DeliveryType": deliveryType,
        "PaymentType": paymentType,
      };
}
