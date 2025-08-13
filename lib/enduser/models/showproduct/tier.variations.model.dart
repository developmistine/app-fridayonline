// To parse this JSON data, do
//
//     final tierVariations = tierVariationsFromJson(jsonString);

import 'dart:convert';

import 'package:appfridayecommerce/enduser/models/showproduct/product.sku.model.dart';

TierVariations tierVariationsFromJson(String str) =>
    TierVariations.fromJson(json.decode(str));

String tierVariationsToJson(TierVariations data) => json.encode(data.toJson());

class TierVariations {
  String code;
  Data data;
  String message;

  TierVariations({
    required this.code,
    required this.data,
    required this.message,
  });

  factory TierVariations.fromJson(Map<String, dynamic> json) => TierVariations(
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
  int itemId;
  int promotionId;
  ProductPrice productPrice;
  List<TierVariation> tierVariations;
  int stock;
  SelectedVariation selectedVariation;

  Data({
    required this.itemId,
    required this.promotionId,
    required this.productPrice,
    required this.tierVariations,
    required this.stock,
    required this.selectedVariation,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        itemId: json["item_id"],
        promotionId: json["promotion_id"],
        productPrice: ProductPrice.fromJson(json["product_price"]),
        tierVariations: List<TierVariation>.from(
            json["tier_variations"].map((x) => TierVariation.fromJson(x))),
        stock: json["stock"],
        selectedVariation:
            SelectedVariation.fromJson(json["selected_variation"]),
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "promotion_id": promotionId,
        "product_price": productPrice.toJson(),
        "tier_variations":
            List<dynamic>.from(tierVariations.map((x) => x.toJson())),
        "stock": stock,
        "selected_variation": selectedVariation.toJson(),
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

class Price {
  int singleValue;
  int rangeMin;
  int rangeMax;

  Price({
    required this.singleValue,
    required this.rangeMin,
    required this.rangeMax,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        singleValue: json["single_value"],
        rangeMin: json["range_min"],
        rangeMax: json["range_max"],
      );

  Map<String, dynamic> toJson() => {
        "single_value": singleValue,
        "range_min": rangeMin,
        "range_max": rangeMax,
      };
}

class SelectedVariation {
  String reminderText;
  PromotionLabels promotionLabels;

  SelectedVariation({
    required this.reminderText,
    required this.promotionLabels,
  });

  factory SelectedVariation.fromJson(Map<String, dynamic> json) =>
      SelectedVariation(
        reminderText: json["reminder_text"],
        promotionLabels: PromotionLabels.fromJson(json["promotion_labels"]),
      );

  Map<String, dynamic> toJson() => {
        "reminder_text": reminderText,
        "promotion_labels": promotionLabels.toJson(),
      };
}

class PromotionLabels {
  PromotionLabels();

  factory PromotionLabels.fromJson(Map<String, dynamic> json) =>
      PromotionLabels();

  Map<String, dynamic> toJson() => {};
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
