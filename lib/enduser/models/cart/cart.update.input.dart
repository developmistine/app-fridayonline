// To parse this JSON data, do
//
//     final updateCartInput = updateCartInputFromJson(jsonString);

import 'dart:convert';

UpdateCartInput updateCartInputFromJson(String str) =>
    UpdateCartInput.fromJson(json.decode(str));

String updateCartInputToJson(UpdateCartInput data) =>
    json.encode(data.toJson());

class UpdateCartInput {
  int custId;
  int actionType;
  String sessionId;
  List<UpdatedShopOrder> updatedShopOrders;
  PromotionData? promotionData;

  UpdateCartInput({
    required this.custId,
    required this.actionType,
    required this.sessionId,
    required this.updatedShopOrders,
    this.promotionData,
  });

  factory UpdateCartInput.fromJson(Map<String, dynamic> json) =>
      UpdateCartInput(
        custId: json["cust_id"],
        actionType: json["action_type"],
        sessionId: json["session_id"],
        updatedShopOrders: List<UpdatedShopOrder>.from(
            json["updated_shop_orders"]
                .map((x) => UpdatedShopOrder.fromJson(x))),
        promotionData: json['promotion_data'] != null
            ? PromotionData.fromJson(json['promotion_data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "cust_id": custId,
        "action_type": actionType,
        "session_id": sessionId,
        "updated_shop_orders":
            List<dynamic>.from(updatedShopOrders.map((x) => x.toJson())),
        "promotion_data": promotionData?.toJson(),
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

class ShopVoucher {
  int shopId;
  bool unusedShopVoucher;
  List<dynamic> vouchers;

  ShopVoucher({
    required this.shopId,
    required this.unusedShopVoucher,
    required this.vouchers,
  });

  factory ShopVoucher.fromJson(Map<String, dynamic> json) => ShopVoucher(
        shopId: json["shop_id"],
        unusedShopVoucher: json["unused_shop_voucher"],
        vouchers: List<dynamic>.from(json["vouchers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "unused_shop_voucher": unusedShopVoucher,
        "vouchers": List<dynamic>.from(vouchers.map((x) => x)),
      };
}

class UpdatedShopOrder {
  int shopId;
  List<ProductBrief> productBriefs;

  UpdatedShopOrder({
    required this.shopId,
    required this.productBriefs,
  });

  factory UpdatedShopOrder.fromJson(Map<String, dynamic> json) =>
      UpdatedShopOrder(
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

class ProductBrief {
  int productId;
  int itemId;

  ProductBrief({
    required this.productId,
    required this.itemId,
  });

  factory ProductBrief.fromJson(Map<String, dynamic> json) => ProductBrief(
        productId: json["product_id"],
        itemId: json["item_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "item_id": itemId,
      };
}
