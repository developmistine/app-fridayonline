// To parse this JSON data, do
//
//     final getCartItems = getCartItemsFromJson(jsonString);

import 'dart:convert';

GetCartItems getCartItemsFromJson(String str) =>
    GetCartItems.fromJson(json.decode(str));

String getCartItemsToJson(GetCartItems data) => json.encode(data.toJson());

class GetCartItems {
  String code;
  List<Datum> data;
  String message;

  GetCartItems({
    required this.code,
    required this.data,
    required this.message,
  });

  factory GetCartItems.fromJson(Map<String, dynamic> json) => GetCartItems(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  String icon;
  int shopId;
  String shopName;
  bool showOfficialShop;
  List<Item> items;
  String discountVoucher;
  List<ShippingVoucher> shippingVoucher;
  List<DrawerEntry> drawerEntries;
  List<PackagedBundleInfo> packagedBundleInfo;

  Datum({
    required this.icon,
    required this.shopId,
    required this.shopName,
    required this.showOfficialShop,
    required this.items,
    required this.discountVoucher,
    required this.shippingVoucher,
    required this.drawerEntries,
    required this.packagedBundleInfo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        icon: json["icon"],
        shopId: json["shop_id"],
        shopName: json["shop_name"],
        showOfficialShop: json["show_official_shop"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        discountVoucher: json["discount_voucher"],
        shippingVoucher: List<ShippingVoucher>.from(
            json["shipping_voucher"].map((x) => ShippingVoucher.fromJson(x))),
        drawerEntries: List<DrawerEntry>.from(
            json["drawer_entries"].map((x) => DrawerEntry.fromJson(x))),
        packagedBundleInfo: List<PackagedBundleInfo>.from(
            json["packaged_bundle_infos"]
                .map((x) => PackagedBundleInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "shop_id": shopId,
        "shop_name": shopName,
        "show_official_shop": showOfficialShop,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "discount_voucher": discountVoucher,
        "shipping_voucher":
            List<dynamic>.from(shippingVoucher.map((x) => x.toJson())),
        "drawer_entries":
            List<dynamic>.from(drawerEntries.map((x) => x.toJson())),
        "packaged_bundle_infos":
            List<dynamic>.from(packagedBundleInfo.map((x) => x.toJson())),
      };
}

class DrawerEntry {
  double minSpend;
  String discountFormatted;
  double shippingDiscount;
  List<String> shippingOptions;

  DrawerEntry({
    required this.minSpend,
    required this.discountFormatted,
    required this.shippingDiscount,
    required this.shippingOptions,
  });

  factory DrawerEntry.fromJson(Map<String, dynamic> json) => DrawerEntry(
        minSpend: json["min_spend"]?.toDouble(),
        discountFormatted: json["discount_formatted"],
        shippingDiscount: json["shipping_discount"]?.toDouble(),
        shippingOptions:
            List<String>.from(json["shipping_options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "min_spend": minSpend,
        "discount_formatted": discountFormatted,
        "shipping_discount": shippingDiscount,
        "shipping_options": List<dynamic>.from(shippingOptions.map((x) => x)),
      };
}

class PackagedBundleInfo {
  int bundleId;
  String bannerText;
  int bannerType;

  PackagedBundleInfo({
    required this.bundleId,
    required this.bannerText,
    required this.bannerType,
  });

  factory PackagedBundleInfo.fromJson(Map<String, dynamic> json) =>
      PackagedBundleInfo(
        bundleId: json["bundle_id"],
        bannerText: json["banner_text"],
        bannerType: json["banner_type"],
      );

  Map<String, dynamic> toJson() => {
        "bundle_id": bundleId,
        "banner_text": bannerText,
        "banner_type": bannerType,
      };
}

class Item {
  int cartId;
  int productId;
  String productName;
  String productImage;
  bool haveDiscount;
  double discount;
  double price;
  double priceBeforeDiscount;
  int productQty;
  int stock;
  int normalStock;
  int promotionStock;
  int status;
  bool isInPreview;
  bool isPreOrder;
  bool isFreeGift;
  int totalCanBuyQuantity;
  String selectItem;
  int selectItemId;
  int addOnId;
  int bundleId;
  bool isAddOnItem;
  List<int> tierVariationsIndex;
  List<TierVariation> tierVariations;
  List<CartContent> cartContent;

  Item({
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.haveDiscount,
    required this.discount,
    required this.price,
    required this.priceBeforeDiscount,
    required this.productQty,
    required this.stock,
    required this.normalStock,
    required this.promotionStock,
    required this.status,
    required this.isInPreview,
    required this.isPreOrder,
    required this.isFreeGift,
    required this.totalCanBuyQuantity,
    required this.selectItem,
    required this.selectItemId,
    required this.addOnId,
    required this.bundleId,
    required this.isAddOnItem,
    required this.tierVariationsIndex,
    required this.tierVariations,
    required this.cartContent,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        cartId: json["cart_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        productImage: json["product_image"],
        haveDiscount: json["have_discount"],
        discount: json["discount"]?.toDouble(),
        price: json["price"]?.toDouble(),
        priceBeforeDiscount: json["price_before_discount"]?.toDouble(),
        productQty: json["product_qty"],
        stock: json["stock"],
        normalStock: json["normal_stock"],
        promotionStock: json["promotion_stock"],
        status: json["status"],
        isInPreview: json["is_in_preview"],
        isPreOrder: json["is_pre_order"],
        isFreeGift: json["is_free_gift"],
        totalCanBuyQuantity: json["total_can_buy_quantity"],
        selectItem: json["select_item"],
        selectItemId: json["select_item_id"],
        addOnId: json["add_on_id"],
        bundleId: json["bundle_id"],
        isAddOnItem: json["is_add_on_item"],
        tierVariationsIndex:
            List<int>.from(json["tier_variations_index"].map((x) => x)),
        tierVariations: List<TierVariation>.from(
            json["tier_variations"].map((x) => TierVariation.fromJson(x))),
        cartContent: List<CartContent>.from(
            json["cart_content"].map((x) => CartContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "product_id": productId,
        "product_name": productName,
        "product_image": productImage,
        "have_discount": haveDiscount,
        "discount": discount,
        "price": price,
        "price_before_discount": priceBeforeDiscount,
        "product_qty": productQty,
        "stock": stock,
        "normal_stock": normalStock,
        "promotion_stock": promotionStock,
        "status": status,
        "is_in_preview": isInPreview,
        "is_pre_order": isPreOrder,
        "is_free_gift": isFreeGift,
        "total_can_buy_quantity": totalCanBuyQuantity,
        "select_item": selectItem,
        "select_item_id": selectItemId,
        "add_on_id": addOnId,
        "bundle_id": bundleId,
        "is_add_on_item": isAddOnItem,
        "tier_variations_index":
            List<dynamic>.from(tierVariationsIndex.map((x) => x)),
        "tier_variations":
            List<dynamic>.from(tierVariations.map((x) => x.toJson())),
        "cart_content": List<dynamic>.from(cartContent.map((x) => x.toJson())),
      };
}

class CartContent {
  int id;
  String content;

  CartContent({
    required this.id,
    required this.content,
  });

  factory CartContent.fromJson(Map<String, dynamic> json) => CartContent(
        id: json["id"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
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

class ShippingVoucher {
  String description;

  ShippingVoucher({
    required this.description,
  });

  factory ShippingVoucher.fromJson(Map<String, dynamic> json) =>
      ShippingVoucher(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}
