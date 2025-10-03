// To parse this JSON data, do
//
//     final endUserProductDetail = endUserProductDetailFromJson(jsonString);

import 'dart:convert';

EndUserProductDetail endUserProductDetailFromJson(String str) =>
    EndUserProductDetail.fromJson(json.decode(str));

String endUserProductDetailToJson(EndUserProductDetail data) =>
    json.encode(data.toJson());

class EndUserProductDetail {
  String code;
  Data data;
  String message;

  EndUserProductDetail({
    required this.code,
    required this.data,
    required this.message,
  });

  factory EndUserProductDetail.fromJson(Map<String, dynamic> json) =>
      EndUserProductDetail(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  int productId;
  String title;
  int shopId;
  String shopCode;
  String shopName;
  ShopDetailed shopDetailed;
  int catId;
  String catName;
  int brandId;
  String brandName;
  double ratingStar;
  String unitSales;
  String description;
  String shippingEstimated;
  List<dynamic> attributes;
  List<dynamic> categories;
  int promotionStock;
  int normalStock;
  int stock;
  List<TierVariation> tierVariations;
  ProductPrice productPrice;
  List<ProductDatail> productDatail;
  bool haveVideo;
  ProductImages productImages;
  List<String> optionImages;
  ProductReview productReview;
  OngoingFlashsale ongoingFlashsale;
  TeaserFlashsale teaserFlashsale;
  String icon;
  bool isImageOverlayed;
  String imageOverlay;
  String commission;
  bool canShare;

  Data({
    required this.productId,
    required this.title,
    required this.shopId,
    required this.shopCode,
    required this.shopName,
    required this.shopDetailed,
    required this.catId,
    required this.catName,
    required this.brandId,
    required this.brandName,
    required this.ratingStar,
    required this.unitSales,
    required this.description,
    required this.shippingEstimated,
    required this.attributes,
    required this.categories,
    required this.promotionStock,
    required this.normalStock,
    required this.stock,
    required this.tierVariations,
    required this.productPrice,
    required this.productDatail,
    required this.haveVideo,
    required this.productImages,
    required this.optionImages,
    required this.productReview,
    required this.ongoingFlashsale,
    required this.teaserFlashsale,
    required this.icon,
    required this.isImageOverlayed,
    required this.imageOverlay,
    required this.commission,
    required this.canShare,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      productId: json["product_id"],
      title: json["title"],
      shopId: json["shop_id"],
      shopCode: json["shop_code"],
      shopName: json["shop_name"],
      shopDetailed: ShopDetailed.fromJson(json["shop_detailed"]),
      catId: json["cat_id"],
      catName: json["cat_name"],
      brandId: json["brand_id"],
      brandName: json["brand_name"],
      ratingStar: json["rating_star"]?.toDouble(),
      unitSales: json["unit_sales"],
      description: json["description"],
      shippingEstimated: json["shipping_estimated"],
      attributes: List<dynamic>.from(json["attributes"].map((x) => x)),
      categories: List<dynamic>.from(json["categories"].map((x) => x)),
      promotionStock: json["promotion_stock"],
      normalStock: json["normal_stock"],
      stock: json["stock"],
      tierVariations: List<TierVariation>.from(
          json["tier_variations"].map((x) => TierVariation.fromJson(x))),
      productPrice: ProductPrice.fromJson(json["product_price"]),
      productDatail: List<ProductDatail>.from(
          json["product_datail"].map((x) => ProductDatail.fromJson(x))),
      haveVideo: json["have_video"],
      productImages: ProductImages.fromJson(json["product_images"]),
      optionImages: List<String>.from(json["option_images"].map((x) => x)),
      productReview: ProductReview.fromJson(json["product_review"]),
      ongoingFlashsale: OngoingFlashsale.fromJson(json["ongoing_flashsale"]),
      teaserFlashsale: TeaserFlashsale.fromJson(json["teaser_flashsale"]),
      icon: json["icon"],
      isImageOverlayed: json["is_image_overlayed"],
      imageOverlay: json["image_overlay"],
      commission: json["commission"] ?? '',
      canShare: json["can_share"] ?? false);

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "title": title,
        "shop_id": shopId,
        "shop_code": shopCode,
        "shop_name": shopName,
        "shop_detailed": shopDetailed.toJson(),
        "cat_id": catId,
        "cat_name": catName,
        "brand_id": brandId,
        "brand_name": brandName,
        "rating_star": ratingStar,
        "unit_sales": unitSales,
        "description": description,
        "shipping_estimated": shippingEstimated,
        "attributes": List<dynamic>.from(attributes.map((x) => x)),
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "promotion_stock": promotionStock,
        "stock": stock,
        "normal_stock": normalStock,
        "tier_variations":
            List<dynamic>.from(tierVariations.map((x) => x.toJson())),
        "product_price": productPrice.toJson(),
        "product_datail":
            List<dynamic>.from(productDatail.map((x) => x.toJson())),
        "have_video": haveVideo,
        "product_images": productImages.toJson(),
        "option_images": List<dynamic>.from(optionImages.map((x) => x)),
        "product_review": productReview.toJson(),
        "ongoing_flashsale": ongoingFlashsale.toJson(),
        "teaser_flashsale": teaserFlashsale.toJson(),
        "icon": icon,
        "is_image_overlayed": isImageOverlayed,
        "image_overlay": imageOverlay,
        "commission": commission,
        "can_share": canShare,
      };
}

class ProductDatail {
  String name;
  double discount;
  String keyImage;
  String image;
  bool haveDiscount;
  Price price;
  Price priceBeforeDiscount;

  ProductDatail({
    required this.name,
    required this.discount,
    required this.keyImage,
    required this.image,
    required this.haveDiscount,
    required this.price,
    required this.priceBeforeDiscount,
  });

  factory ProductDatail.fromJson(Map<String, dynamic> json) => ProductDatail(
        name: json["name"],
        discount: json["discount"]?.toDouble(),
        keyImage: json["key_image"],
        image: json["image"],
        haveDiscount: json["have_discount"],
        price: Price.fromJson(json["price"]),
        priceBeforeDiscount: Price.fromJson(json["price_before_discount"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "discount": discount,
        "key_image": keyImage,
        "image": image,
        "have_discount": haveDiscount,
        "price": price.toJson(),
        "price_before_discount": priceBeforeDiscount.toJson(),
      };
}

class Price {
  double singleValue;
  double rangeMin;
  double rangeMax;

  Price({
    required this.singleValue,
    required this.rangeMin,
    required this.rangeMax,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        singleValue: json["single_value"]?.toDouble(),
        rangeMin: json["range_min"]?.toDouble(),
        rangeMax: json["range_max"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "single_value": singleValue,
        "range_min": rangeMin,
        "range_max": rangeMax,
      };
}

class ProductImages {
  List<Image> video;
  List<Image> image;

  ProductImages({
    required this.video,
    required this.image,
  });

  factory ProductImages.fromJson(Map<String, dynamic> json) => ProductImages(
        video: List<Image>.from(json["video"].map((x) => Image.fromJson(x))),
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "video": List<dynamic>.from(video.map((x) => x.toJson())),
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
      };
}

class Image {
  String keyImage;
  String image;
  int defaultFlag;

  Image({
    required this.keyImage,
    required this.image,
    required this.defaultFlag,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        keyImage: json["key_image"],
        image: json["image"],
        defaultFlag: json["default_flag"],
      );

  Map<String, dynamic> toJson() => {
        "key_image": keyImage,
        "image": image,
        "default_flag": defaultFlag,
      };
}

class ProductPrice {
  bool haveDiscount;
  int discount;
  Price price;
  Price priceBeforeDiscount;

  ProductPrice({
    required this.haveDiscount,
    required this.discount,
    required this.price,
    required this.priceBeforeDiscount,
  });
  // Deep copy function
  ProductPrice copyWith({
    bool? haveDiscount,
    int? discount,
    Price? price,
    Price? priceBeforeDiscount,
  }) {
    return ProductPrice(
        haveDiscount: haveDiscount ?? this.haveDiscount,
        discount: discount ?? this.discount,
        price: price ?? this.price,
        priceBeforeDiscount: priceBeforeDiscount ?? this.priceBeforeDiscount);
  }

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
        haveDiscount: json["have_discount"],
        discount: json["discount"],
        price: Price.fromJson(json["price"]),
        priceBeforeDiscount: Price.fromJson(json["price_before_discount"]),
      );

  Map<String, dynamic> toJson() => {
        "have_discount": haveDiscount,
        "discount": discount,
        "price": price.toJson(),
        "price_before_discount": priceBeforeDiscount.toJson(),
      };
}

class ProductReview {
  double ratingStar;
  int totalRatingCount;
  List<int> ratingCount;

  ProductReview({
    required this.ratingStar,
    required this.totalRatingCount,
    required this.ratingCount,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
        ratingStar: json["rating_star"]?.toDouble(),
        totalRatingCount: json["total_rating_count"],
        ratingCount: List<int>.from(json["rating_count"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "rating_star": ratingStar,
        "total_rating_count": totalRatingCount,
        "rating_count": List<dynamic>.from(ratingCount.map((x) => x)),
      };
}

class TierVariation {
  String name;
  List<Option> options;

  TierVariation({
    required this.name,
    required this.options,
  });

  factory TierVariation.fromJson(Map<String, dynamic> json) => TierVariation(
        name: json["name"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  String optionValue;
  String image;
  int displayIndicators;

  Option({
    required this.optionValue,
    required this.image,
    required this.displayIndicators,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        optionValue: json["option_value"],
        image: json["image"],
        displayIndicators: json["display_indicators"],
      );

  Map<String, dynamic> toJson() => {
        "option_value": optionValue,
        "image": image,
        "display_indicators": displayIndicators,
      };
}

class OngoingFlashsale {
  int promotionId;
  String startTime;
  String endTime;

  OngoingFlashsale({
    required this.promotionId,
    required this.startTime,
    required this.endTime,
  });

  factory OngoingFlashsale.fromJson(Map<String, dynamic> json) =>
      OngoingFlashsale(
        promotionId: json["promotion_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "promotion_id": promotionId,
        "start_time": startTime,
        "end_time": endTime,
      };
}

class TeaserFlashsale {
  int promotionId;
  String startTime;

  TeaserFlashsale({
    required this.promotionId,
    required this.startTime,
  });

  factory TeaserFlashsale.fromJson(Map<String, dynamic> json) =>
      TeaserFlashsale(
        promotionId: json["promotion_id"],
        startTime: json["start_time"],
      );

  Map<String, dynamic> toJson() => {
        "promotion_id": promotionId,
        "start_time": startTime,
      };
}

class ShopDetailed {
  bool isShopOfficial;
  int shopId;
  String shopCode;
  String shopName;
  String cover;
  int itemCount;
  String itemCountDisplay;
  int follwerCount;
  Account account;
  bool followed;
  String ratingStar;
  int responseRate;
  String description;

  ShopDetailed({
    required this.isShopOfficial,
    required this.shopId,
    required this.shopCode,
    required this.shopName,
    required this.cover,
    required this.itemCount,
    required this.itemCountDisplay,
    required this.follwerCount,
    required this.account,
    required this.followed,
    required this.ratingStar,
    required this.responseRate,
    required this.description,
  });

  factory ShopDetailed.fromJson(Map<String, dynamic> json) => ShopDetailed(
        isShopOfficial: json["is_shop_official"],
        shopId: json["shop_id"],
        shopCode: json["shop_code"],
        shopName: json["shop_name"],
        cover: json["cover"],
        itemCount: json["item_count"],
        itemCountDisplay: json["item_count_display"],
        follwerCount: json["follwer_count"],
        account: Account.fromJson(json["account"]),
        followed: json["followed"],
        ratingStar: json["rating_star"],
        responseRate: json["response_rate"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "is_shop_official": isShopOfficial,
        "shop_id": shopId,
        "shop_code": shopCode,
        "shop_name": shopName,
        "cover": cover,
        "item_count": itemCount,
        "item_count_display": itemCountDisplay,
        "follwer_count": follwerCount,
        "account": account.toJson(),
        "followed": followed,
        "rating_star": ratingStar,
        "response_rate": responseRate,
        "description": description,
      };
}

class Account {
  String username;
  String image;
  int followingCount;
  String dateJoined;
  bool phoneVerified;
  bool emailVerified;
  String fbid;

  Account({
    required this.username,
    required this.image,
    required this.followingCount,
    required this.dateJoined,
    required this.phoneVerified,
    required this.emailVerified,
    required this.fbid,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        username: json["username"],
        image: json["image"],
        followingCount: json["following_count"],
        dateJoined: json["date_joined"],
        phoneVerified: json["phone_verified"],
        emailVerified: json["email_verified"],
        fbid: json["fbid"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "image": image,
        "following_count": followingCount,
        "date_joined": dateJoined,
        "phone_verified": phoneVerified,
        "email_verified": emailVerified,
        "fbid": fbid,
      };
}
