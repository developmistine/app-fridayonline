// To parse this JSON data, do
//
//     final cartCheckOutInput = cartCheckOutInputFromJson(jsonString);

import 'dart:convert';

import 'package:fridayonline/member/models/coupon/vouchers.recommend.model.dart';

CartCheckOut cartCheckOutFromJson(String str) =>
    CartCheckOut.fromJson(json.decode(str));

String cartCheckOutToJson(CartCheckOut data) => json.encode(data.toJson());

class CartCheckOut {
  String code;
  Data data;
  String message;

  CartCheckOut({
    required this.code,
    required this.data,
    required this.message,
  });

  factory CartCheckOut.fromJson(Map<String, dynamic> json) => CartCheckOut(
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
  double totalPayable;
  List<PriceBreakdown> priceBreakdown;
  DiscountDisplay discountDisplay;
  PromotionData promotionData;
  List<Shoporder> shoporders;

  Data({
    required this.totalPayable,
    required this.priceBreakdown,
    required this.discountDisplay,
    required this.promotionData,
    required this.shoporders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalPayable: json["total_payable"]?.toDouble(),
        priceBreakdown: List<PriceBreakdown>.from(
            json["price_breakdown"].map((x) => PriceBreakdown.fromJson(x))),
        discountDisplay: DiscountDisplay.fromJson(json["discount_display"]),
        promotionData: PromotionData.fromJson(json["promotion_data"]),
        shoporders: List<Shoporder>.from(
            json["shoporders"].map((x) => Shoporder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_payable": totalPayable,
        "price_breakdown":
            List<dynamic>.from(priceBreakdown.map((x) => x.toJson())),
        "discount_display": discountDisplay.toJson(),
        "promotion_data": promotionData.toJson(),
        "shoporders": List<dynamic>.from(shoporders.map((x) => x.toJson())),
      };
}

class DiscountDisplay {
  String code;
  String text;

  DiscountDisplay({
    required this.code,
    required this.text,
  });

  factory DiscountDisplay.fromJson(Map<String, dynamic> json) =>
      DiscountDisplay(
        code: json["code"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "text": text,
      };
}

class PriceBreakdown {
  String name;
  double value;
  String displayValue;

  PriceBreakdown({
    required this.name,
    required this.value,
    required this.displayValue,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) => PriceBreakdown(
        name: json["name"],
        value: json["value"]?.toDouble(),
        displayValue: json["display_value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "display_value": displayValue,
      };
}

class PromotionData {
  List<ShopVouchers> shopVouchers;
  List<PlatformVoucher> platformVouchers;

  PromotionData({
    required this.shopVouchers,
    required this.platformVouchers,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json) => PromotionData(
        shopVouchers: List<ShopVouchers>.from(
            json["shop_vouchers"].map((x) => ShopVouchers.fromJson(x))),
        platformVouchers: List<PlatformVoucher>.from(
            json["platform_vouchers"].map((x) => PlatformVoucher.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shop_vouchers":
            List<dynamic>.from(shopVouchers.map((x) => x.toJson())),
        "platform_vouchers":
            List<dynamic>.from(platformVouchers.map((x) => x.toJson())),
      };
}

class PlatformVoucher {
  int voucherType;
  String voucherTypeText;
  List<ShopVoucher> vouchers;

  PlatformVoucher({
    required this.voucherType,
    required this.voucherTypeText,
    required this.vouchers,
  });

  factory PlatformVoucher.fromJson(Map<String, dynamic> json) =>
      PlatformVoucher(
        voucherType: json["voucher_type"],
        voucherTypeText: json["voucher_type_text"],
        vouchers: List<ShopVoucher>.from(
            json["vouchers"].map((x) => ShopVoucher.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "voucher_type": voucherType,
        "voucher_type_text": voucherTypeText,
        "vouchers": List<dynamic>.from(vouchers.map((x) => x.toJson())),
      };
}

class QuotaInfo {
  double percentageClaimed;
  double percentageUsed;
  int quotaType;
  bool fullyClaimed;
  bool fullyUsed;

  QuotaInfo({
    required this.percentageClaimed,
    required this.percentageUsed,
    required this.quotaType,
    required this.fullyClaimed,
    required this.fullyUsed,
  });

  factory QuotaInfo.fromJson(Map<String, dynamic> json) => QuotaInfo(
        percentageClaimed: json["percentage_claimed"]?.toDouble(),
        percentageUsed: json["percentage_used"]?.toDouble(),
        quotaType: json["quota_type"],
        fullyClaimed: json["fully_claimed"],
        fullyUsed: json["fully_used"],
      );

  Map<String, dynamic> toJson() => {
        "percentage_claimed": percentageClaimed,
        "percentage_used": percentageUsed,
        "quota_type": quotaType,
        "fully_claimed": fullyClaimed,
        "fully_used": fullyUsed,
      };
}

class RewardInfo {
  int minSpend;
  int discountValue;
  int discountPercentage;
  int discountCap;
  int currentSpend;

  RewardInfo({
    required this.minSpend,
    required this.discountValue,
    required this.discountPercentage,
    required this.discountCap,
    required this.currentSpend,
  });

  factory RewardInfo.fromJson(Map<String, dynamic> json) => RewardInfo(
        minSpend: json["min_spend"],
        discountValue: json["discount_value"],
        discountPercentage: json["discount_percentage"],
        discountCap: json["discount_cap"],
        currentSpend: json["current_spend"],
      );

  Map<String, dynamic> toJson() => {
        "min_spend": minSpend,
        "discount_value": discountValue,
        "discount_percentage": discountPercentage,
        "discount_cap": discountCap,
        "current_spend": currentSpend,
      };
}

class TimeInfo {
  String startTime;
  String endTime;
  String claimStartTime;
  String claimEndTime;
  int validDays;
  String timeFormat;
  bool hasExpired;

  TimeInfo({
    required this.startTime,
    required this.endTime,
    required this.claimStartTime,
    required this.claimEndTime,
    required this.validDays,
    required this.timeFormat,
    required this.hasExpired,
  });

  factory TimeInfo.fromJson(Map<String, dynamic> json) => TimeInfo(
        startTime: json["start_time"],
        endTime: json["end_time"],
        claimStartTime: json["claim_start_time"],
        claimEndTime: json["claim_end_time"],
        validDays: json["valid_days"],
        timeFormat: json["time_format"],
        hasExpired: json["has_expired"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "end_time": endTime,
        "claim_start_time": claimStartTime,
        "claim_end_time": claimEndTime,
        "valid_days": validDays,
        "time_format": timeFormat,
        "has_expired": hasExpired,
      };
}

class UserStatus {
  bool isClaimed;
  bool isUsed;
  bool isSelected;

  UserStatus({
    required this.isClaimed,
    required this.isUsed,
    required this.isSelected,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) => UserStatus(
        isClaimed: json["is_claimed"],
        isUsed: json["is_used"],
        isSelected: json["is_selected"],
      );

  Map<String, dynamic> toJson() => {
        "is_claimed": isClaimed,
        "is_used": isUsed,
        "is_selected": isSelected,
      };
}

class ShopVouchers {
  int shopId;
  String shopName;
  List<ShopVoucher> shopVouchers;

  ShopVouchers({
    required this.shopId,
    required this.shopName,
    required this.shopVouchers,
  });

  factory ShopVouchers.fromJson(Map<String, dynamic> json) => ShopVouchers(
        shopId: json["shop_id"],
        shopName: json["shop_name"],
        shopVouchers: List<ShopVoucher>.from(
            json["shop_vouchers"].map((x) => ShopVoucher.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "shop_name": shopName,
        "shop_vouchers":
            List<dynamic>.from(shopVouchers.map((x) => x.toJson())),
      };
}

class Shoporder {
  String code;
  String description;
  Shop shop;
  String discountVoucher;
  List<Carton> carton;

  Shoporder({
    required this.code,
    required this.description,
    required this.shop,
    required this.discountVoucher,
    required this.carton,
  });

  factory Shoporder.fromJson(Map<String, dynamic> json) => Shoporder(
        code: json["code"],
        description: json["description"],
        shop: Shop.fromJson(json["shop"]),
        discountVoucher: json["discount_voucher"],
        carton:
            List<Carton>.from(json["carton"].map((x) => Carton.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "shop": shop.toJson(),
        "discount_voucher": discountVoucher,
        "carton": List<dynamic>.from(carton.map((x) => x.toJson())),
      };
}

class Carton {
  bool onlyOne;
  String cartonDesc;
  List<ItemCheckout> itemCheckout;
  List<LogisticChannel> logisticChannels;

  Carton({
    required this.onlyOne,
    required this.cartonDesc,
    required this.itemCheckout,
    required this.logisticChannels,
  });

  factory Carton.fromJson(Map<String, dynamic> json) => Carton(
        onlyOne: json["only_one"],
        cartonDesc: json["carton_desc"],
        itemCheckout: List<ItemCheckout>.from(
            json["item_checkout"].map((x) => ItemCheckout.fromJson(x))),
        logisticChannels: List<LogisticChannel>.from(
            json["logistic_channels"].map((x) => LogisticChannel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "only_one": onlyOne,
        "carton_desc": cartonDesc,
        "item_checkout":
            List<dynamic>.from(itemCheckout.map((x) => x.toJson())),
        "logistic_channels":
            List<dynamic>.from(logisticChannels.map((x) => x.toJson())),
      };
}

class ItemCheckout {
  int cartId;
  int productId;
  String productName;
  String productImage;
  int itemId;
  String selectItem;
  int quantity;
  int promotionId;
  bool haveDiscount;
  double discount;
  double price;
  double priceBeforeDiscount;

  ItemCheckout({
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.itemId,
    required this.selectItem,
    required this.quantity,
    required this.promotionId,
    required this.haveDiscount,
    required this.discount,
    required this.price,
    required this.priceBeforeDiscount,
  });

  factory ItemCheckout.fromJson(Map<String, dynamic> json) => ItemCheckout(
        cartId: json["cart_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        productImage: json["product_image"],
        itemId: json["item_id"],
        selectItem: json["select_item"],
        quantity: json["quantity"],
        promotionId: json["promotion_id"],
        haveDiscount: json["have_discount"],
        discount: json["discount"]?.toDouble(),
        price: json["price"]?.toDouble(),
        priceBeforeDiscount: json["price_before_discount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "product_id": productId,
        "product_name": productName,
        "product_image": productImage,
        "item_id": itemId,
        "select_item": selectItem,
        "quantity": quantity,
        "promotion_id": promotionId,
        "have_discount": haveDiscount,
        "discount": discount,
        "price": price,
        "price_before_discount": priceBeforeDiscount,
      };
}

class LogisticChannel {
  String code;
  String description;
  int logisticId;
  String name;
  int couponId;
  int chargeableShippingFee;
  int shippingFeeBeforeDiscount;
  String estimatedDeliveryTime;

  LogisticChannel({
    required this.code,
    required this.description,
    required this.logisticId,
    required this.name,
    required this.couponId,
    required this.chargeableShippingFee,
    required this.shippingFeeBeforeDiscount,
    required this.estimatedDeliveryTime,
  });

  factory LogisticChannel.fromJson(Map<String, dynamic> json) =>
      LogisticChannel(
        code: json["code"],
        description: json["description"],
        logisticId: json["logistic_id"],
        name: json["name"],
        couponId: json["coupon_id"],
        chargeableShippingFee: json["chargeable_shipping_fee"],
        shippingFeeBeforeDiscount: json["shipping_fee_before_discount"],
        estimatedDeliveryTime: json["estimated_delivery_time"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "logistic_id": logisticId,
        "name": name,
        "coupon_id": couponId,
        "chargeable_shipping_fee": chargeableShippingFee,
        "shipping_fee_before_discount": shippingFeeBeforeDiscount,
        "estimated_delivery_time": estimatedDeliveryTime,
      };
}

class Shop {
  String icon;
  int shopId;
  String shopCode;
  String shopName;
  int productCount;
  double total;

  Shop({
    required this.icon,
    required this.shopId,
    required this.shopCode,
    required this.shopName,
    required this.productCount,
    required this.total,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        icon: json["icon"],
        shopId: json["shop_id"],
        shopCode: json["shop_code"],
        shopName: json["shop_name"],
        productCount: json["product_count"],
        total: json["total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "shop_id": shopId,
        "shop_code": shopCode,
        "shop_name": shopName,
        "product_count": productCount,
        "total": total,
      };
}
