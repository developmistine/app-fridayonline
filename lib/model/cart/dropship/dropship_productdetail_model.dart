// To parse this JSON data, do
//
//     final getDropshipProductDetail = getDropshipProductDetailFromJson(jsonString);

import 'dart:convert';

GetDropshipProductDetail getDropshipProductDetailFromJson(String str) =>
    GetDropshipProductDetail.fromJson(json.decode(str));

String getDropshipProductDetailToJson(GetDropshipProductDetail data) =>
    json.encode(data.toJson());

class GetDropshipProductDetail {
  GetDropshipProductDetail({
    required this.billCode,
    required this.productCode,
    required this.productName,
    required this.productdetail,
    required this.price,
    required this.discount,
    required this.deliveryType,
    required this.paymentType,
    required this.supplierCode,
    required this.supplierName,
    required this.supplierType,
    required this.imageURL,
    required this.billYup,
    required this.imageList,
    required this.productRecom,
  });

  String billCode;
  String productCode;
  String productName;
  String productdetail;
  String price;
  String discount;
  String deliveryType;
  String paymentType;
  String supplierCode;
  String supplierName;
  String supplierType;
  String imageURL;
  String billYup;
  List<ImageList> imageList;
  List<ProductRecom> productRecom;

  factory GetDropshipProductDetail.fromJson(Map<String, dynamic> json) =>
      GetDropshipProductDetail(
        billCode: json["BillCode"] ?? "",
        productCode: json["ProductCode"] ?? "",
        productName: json["ProductName"] ?? "",
        productdetail: json["Productdetail"] ?? "",
        price: json["Price"] ?? "",
        discount: json["Discount"] ?? "",
        deliveryType: json["DeliveryType"] ?? "",
        paymentType: json["PaymentType"] ?? "",
        supplierCode: json["SupplierCode"] ?? "",
        supplierName: json["SupplierName"] ?? "",
        supplierType: json["SupplierType"] ?? "",
        imageURL: json["ImageURL"] ?? "",
        billYup: json["Bill_YUP"] ?? "",
        imageList: json["ImageList"] == null ? [] : List<ImageList>.from(
            json["ImageList"].map((x) => ImageList.fromJson(x))),
        productRecom: json["ProductRecom"] == null ? [] : List<ProductRecom>.from(
            json["ProductRecom"].map((x) => ProductRecom.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "BillCode": billCode,
        "ProductCode": productCode,
        "ProductName": productName,
        "Productdetail": productdetail,
        "Price": price,
        "Discount": discount,
        "DeliveryType": deliveryType,
        "PaymentType": paymentType,
        "SupplierCode": supplierCode,
        "SupplierName": supplierName,
        "SupplierType": supplierType,
        "ImageURL": imageURL,
        "Bill_YUP": billYup,
        "ImageList": List<dynamic>.from(imageList.map((x) => x.toJson())),
        "ProductRecom": List<dynamic>.from(productRecom.map((x) => x.toJson())),
      };
}

class ImageList {
  ImageList({
    required this.imageUrl,
    required this.imageType,
  });

  String imageUrl;
  String imageType;

  factory ImageList.fromJson(Map<String, dynamic> json) => ImageList(
        imageUrl: json["ImageUrl"] ?? "",
        imageType: json["ImageType"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ImageUrl": imageUrl,
        "ImageType": imageType,
      };
}

class ProductRecom {
  ProductRecom({
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

  factory ProductRecom.fromJson(Map<String, dynamic> json) => ProductRecom(
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
