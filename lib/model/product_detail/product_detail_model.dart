// To parse this JSON data, do
//
//     final productDetailModel = productDetailModelFromJson(jsonString);

import 'dart:convert';

ProductDetailModel productDetailModelFromJson(String str) =>
    ProductDetailModel.fromJson(json.decode(str));

String productDetailModelToJson(ProductDetailModel data) =>
    json.encode(data.toJson());

// catalog_camp
// catalog_id
// catalog_image
// catalog_name
// catalog_type
// category_name

class ProductDetailModel {
  ProductImages productImages;
  String fsCode;
  String fsCodeTemp;
  double specialPrice;
  String billCode;
  String billCamp;
  String billColor;
  String billName;
  String billnameEng;
  String billPage;
  String brandId;
  String brandCode;
  String category;
  String subCategory;
  String subCategoryName;
  String media;
  String description;
  String catalogCamp;
  String catalogId;
  String catalogImage;
  String catalogName;
  String catalogType;
  String categoryName;
  FlashSales flashSales;
  Reviews reviews;
  bool isInStock;
  bool isShareFlag;
  bool isHousebrand;
  bool isNetprice;
  String limitDesc;
  String imgNetPrice;
  String imgOutOfStock;
  List<ProductGroup> productGroups;
  List<RelatedProduct> relatedProducts;

  ProductDetailModel({
    required this.productImages,
    required this.fsCode,
    required this.fsCodeTemp,
    required this.specialPrice,
    required this.billCode,
    required this.billCamp,
    required this.billColor,
    required this.billName,
    required this.billnameEng,
    required this.billPage,
    required this.brandId,
    required this.brandCode,
    required this.category,
    required this.subCategory,
    required this.subCategoryName,
    required this.media,
    required this.description,
    required this.catalogCamp,
    required this.catalogId,
    required this.catalogImage,
    required this.catalogName,
    required this.catalogType,
    required this.categoryName,
    required this.flashSales,
    required this.reviews,
    required this.isInStock,
    required this.isShareFlag,
    required this.isHousebrand,
    required this.isNetprice,
    required this.limitDesc,
    required this.imgNetPrice,
    required this.imgOutOfStock,
    required this.productGroups,
    required this.relatedProducts,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        productImages: ProductImages.fromJson(json["product_images"]),
        fsCode: json["fs_code"],
        fsCodeTemp: json["fs_code_temp"],
        specialPrice: json["special_price"]?.toDouble(),
        billCode: json["bill_code"],
        billCamp: json["bill_camp"],
        billColor: json["bill_color"],
        billName: json["bill_name"],
        billnameEng: json["billname_eng"],
        billPage: json["bill_page"],
        brandId: json["brand_id"],
        brandCode: json["brand_code"],
        category: json["category"],
        subCategory: json["sub_category"],
        subCategoryName: json["sub_category_name"],
        media: json["media"],
        description: json["description"],
        catalogCamp: json['catalog_camp'],
        catalogId: json['catalog_id'],
        catalogImage: json['catalog_image'],
        catalogName: json['catalog_name'],
        catalogType: json['catalog_type'],
        categoryName: json['category_name'],
        flashSales: FlashSales.fromJson(json["flash_sales"]),
        reviews: Reviews.fromJson(json["reviews"]),
        isInStock: json["is_in_stock"],
        isShareFlag: json["is_share_flag"],
        isHousebrand: json["is_housebrand"],
        isNetprice: json["is_netprice"],
        limitDesc: json["limit_desc"],
        imgNetPrice: json["img_net_price"],
        imgOutOfStock: json["img_out_of_stock"],
        productGroups: List<ProductGroup>.from(
            json["product_groups"].map((x) => ProductGroup.fromJson(x))),
        relatedProducts: List<RelatedProduct>.from(
            json["related_products"].map((x) => RelatedProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_images": productImages.toJson(),
        "fs_code": fsCode,
        "fs_code_temp": fsCodeTemp,
        "special_price": specialPrice,
        "bill_code": billCode,
        "bill_camp": billCamp,
        "bill_color": billColor,
        "bill_name": billName,
        "billname_eng": billnameEng,
        "bill_page": billPage,
        "brand_id": brandId,
        "brand_code": brandCode,
        "category": category,
        "sub_category": subCategory,
        "sub_category_name": subCategoryName,
        "media": media,
        "description": description,
        "catalog_camp": catalogCamp,
        "catalog_id": catalogId,
        "catalog_image": catalogImage,
        "catalog_name": catalogName,
        "catalog_type": catalogType,
        "category_name": categoryName,
        "flash_sales": flashSales.toJson(),
        "reviews": reviews.toJson(),
        "is_in_stock": isInStock,
        "is_share_flag": isShareFlag,
        "is_housebrand": isHousebrand,
        "is_netprice": isNetprice,
        "limit_desc": limitDesc,
        "img_net_price": imgNetPrice,
        "img_out_of_stock": imgOutOfStock,
        "product_groups":
            List<dynamic>.from(productGroups.map((x) => x.toJson())),
        "related_products":
            List<dynamic>.from(relatedProducts.map((x) => x.toJson())),
      };
}

class FlashSales {
  String flashStart;
  String flashEnd;

  FlashSales({
    required this.flashStart,
    required this.flashEnd,
  });

  factory FlashSales.fromJson(Map<String, dynamic> json) => FlashSales(
        flashStart: json["flash_start"],
        flashEnd: json["flash_end"],
      );

  Map<String, dynamic> toJson() => {
        "flash_start": flashStart,
        "flash_end": flashEnd,
      };
}

class ProductGroup {
  ProductImages productImages;
  String fsCode;
  String fsCodeTemp;
  double specialPrice;
  String billCode;
  String billCamp;
  String billColor;
  String billName;
  String billnameEng;
  String billPage;
  String brandId;
  String brandCode;
  String category;
  String subCategory;
  String media;
  String description;
  Reviews reviews;
  bool isInStock;
  bool isShareFlag;
  bool isHousebrand;
  bool isNetprice;

  ProductGroup({
    required this.productImages,
    required this.fsCode,
    required this.fsCodeTemp,
    required this.specialPrice,
    required this.billCode,
    required this.billCamp,
    required this.billColor,
    required this.billName,
    required this.billnameEng,
    required this.billPage,
    required this.brandId,
    required this.brandCode,
    required this.category,
    required this.subCategory,
    required this.media,
    required this.description,
    required this.reviews,
    required this.isInStock,
    required this.isShareFlag,
    required this.isHousebrand,
    required this.isNetprice,
  });

  factory ProductGroup.fromJson(Map<String, dynamic> json) => ProductGroup(
        productImages: ProductImages.fromJson(json["product_images"]),
        fsCode: json["fs_code"],
        fsCodeTemp: json["fs_code_temp"],
        specialPrice: json["special_price"]?.toDouble(),
        billCode: json["bill_code"],
        billCamp: json["bill_camp"],
        billColor: json["bill_color"],
        billName: json["bill_name"],
        billnameEng: json["billname_eng"],
        billPage: json["bill_page"],
        brandId: json["brand_id"],
        brandCode: json["brand_code"],
        category: json["category"],
        subCategory: json["sub_category"],
        media: json["media"],
        description: json["description"],
        reviews: Reviews.fromJson(json["reviews"]),
        isInStock: json["is_in_stock"],
        isShareFlag: json["is_share_flag"],
        isHousebrand: json["is_housebrand"],
        isNetprice: json["is_netprice"],
      );

  Map<String, dynamic> toJson() => {
        "product_images": productImages.toJson(),
        "fs_code": fsCode,
        "fs_code_temp": fsCodeTemp,
        "special_price": specialPrice,
        "bill_code": billCode,
        "bill_camp": billCamp,
        "bill_color": billColor,
        "bill_name": billName,
        "billname_eng": billnameEng,
        "bill_page": billPage,
        "brand_id": brandId,
        "brand_code": brandCode,
        "category": category,
        "sub_category": subCategory,
        "media": media,
        "description": description,
        "reviews": reviews.toJson(),
        "is_in_stock": isInStock,
        "is_share_flag": isShareFlag,
        "is_housebrand": isHousebrand,
        "is_netprice": isNetprice,
      };
}

class Reviews {
  double ratingStar;
  int totalRatingCount;

  Reviews({
    required this.ratingStar,
    required this.totalRatingCount,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        ratingStar: json["rating_star"]?.toDouble(),
        totalRatingCount: json["total_rating_count"],
      );

  Map<String, dynamic> toJson() => {
        "rating_star": ratingStar,
        "total_rating_count": totalRatingCount,
      };
}

class ProductImages {
  List<dynamic> video;
  List<String> image;

  ProductImages({
    required this.video,
    required this.image,
  });

  factory ProductImages.fromJson(Map<String, dynamic> json) => ProductImages(
        video: json["video"] != null
            ? List<dynamic>.from(json["video"].map((x) => x))
            : [],
        image: List<String>.from(json["image"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "video": List<dynamic>.from(video.map((x) => x)),
        "image": List<dynamic>.from(image.map((x) => x)),
      };
}

class RelatedProduct {
  String fsCode;
  String billCode;
  String billCamp;
  String billName;
  String billnameEng;
  String image;
  String brandCode;
  String media;
  Reviews reviews;

  RelatedProduct({
    required this.fsCode,
    required this.billCode,
    required this.billCamp,
    required this.billName,
    required this.billnameEng,
    required this.image,
    required this.brandCode,
    required this.media,
    required this.reviews,
  });

  factory RelatedProduct.fromJson(Map<String, dynamic> json) => RelatedProduct(
        fsCode: json["fs_code"],
        billCode: json["bill_code"],
        billCamp: json["bill_camp"],
        billName: json["bill_name"],
        billnameEng: json["billname_eng"],
        image: json["image"],
        brandCode: json["brand_code"],
        media: json["media"],
        reviews: Reviews.fromJson(json["reviews"]),
      );

  Map<String, dynamic> toJson() => {
        "fs_code": fsCode,
        "bill_code": billCode,
        "bill_camp": billCamp,
        "bill_name": billName,
        "billname_eng": billnameEng,
        "image": image,
        "brand_code": brandCode,
        "media": media,
        "reviews": reviews.toJson(),
      };
}
