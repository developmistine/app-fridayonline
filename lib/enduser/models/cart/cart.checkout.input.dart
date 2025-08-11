// To parse this JSON data, do
//
//     final cartCheckOutInput = cartCheckOutInputFromJson(jsonString);

import 'dart:convert';

import 'package:fridayonline/enduser/models/cart/cart.update.input.dart';

CartCheckOutInput cartCheckOutInputFromJson(String str) =>
    CartCheckOutInput.fromJson(json.decode(str));

String cartCheckOutInputToJson(CartCheckOutInput data) =>
    json.encode(data.toJson());

class CartCheckOutInput {
  int custId;
  List<CheckoutShopOrder> checkoutShopOrders;
  PromotionData promotionData;

  CartCheckOutInput({
    required this.custId,
    required this.checkoutShopOrders,
    required this.promotionData,
  });

  factory CartCheckOutInput.fromJson(Map<String, dynamic> json) =>
      CartCheckOutInput(
        custId: json["cust_id"],
        checkoutShopOrders: List<CheckoutShopOrder>.from(
            json["checkout_shop_orders"]
                .map((x) => CheckoutShopOrder.fromJson(x))),
        promotionData: PromotionData.fromJson(json["promotion_data"]),
      );

  Map<String, dynamic> toJson() => {
        "cust_id": custId,
        "checkout_shop_orders":
            List<dynamic>.from(checkoutShopOrders.map((x) => x.toJson())),
        "promotion_data": promotionData.toJson(),
      };
}

class CheckoutShopOrder {
  int shopId;
  List<ProductBrief> productBriefs;

  CheckoutShopOrder({
    required this.shopId,
    required this.productBriefs,
  });

  factory CheckoutShopOrder.fromJson(Map<String, dynamic> json) =>
      CheckoutShopOrder(
        shopId: json["shop_id"],
        productBriefs: List<ProductBrief>.from(
            json["product_briefs"].map((x) => ProductBrief.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "product_briefs":
            List<dynamic>.from(productBriefs.map((x) => x.toJson())),
      };
}

class PromotionData {
  bool unusedPlatformVoucher;
  List<int> platformVouchers;
  List<ShopVoucher> shopVouchers;
  List<dynamic> freeShipping;

  PromotionData({
    required this.unusedPlatformVoucher,
    required this.platformVouchers,
    required this.shopVouchers,
    required this.freeShipping,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json) => PromotionData(
        unusedPlatformVoucher: json["unused_platform_voucher"],
        platformVouchers:
            List<int>.from(json["platform_vouchers"].map((x) => x)),
        shopVouchers: List<ShopVoucher>.from(
            json["shop_vouchers"].map((x) => ShopVoucher.fromJson(x))),
        freeShipping: List<dynamic>.from(json["free_shipping"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "unused_platform_voucher": unusedPlatformVoucher,
        "platform_vouchers": List<dynamic>.from(platformVouchers.map((x) => x)),
        "shop_vouchers":
            List<dynamic>.from(shopVouchers.map((x) => x.toJson())),
        "free_shipping": List<dynamic>.from(freeShipping.map((x) => x)),
      };
}
