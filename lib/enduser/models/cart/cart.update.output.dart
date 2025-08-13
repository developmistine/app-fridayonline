// To parse this JSON data, do
//
//     final updateCartOutput = updateCartOutputFromJson(jsonString);

import 'dart:convert';

import 'package:fridayonline/enduser/models/cart/getcart.model.dart';
import 'package:fridayonline/enduser/models/coupon/vouchers.recommend.model.dart';

UpdateCartOutput updateCartOutputFromJson(String str) =>
    UpdateCartOutput.fromJson(json.decode(str));

String updateCartOutputToJson(UpdateCartOutput data) =>
    json.encode(data.toJson());

class UpdateCartOutput {
  String code;
  Data data;
  String message;

  UpdateCartOutput({
    required this.code,
    required this.data,
    required this.message,
  });

  factory UpdateCartOutput.fromJson(Map<String, dynamic> json) =>
      UpdateCartOutput(
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
  List<CartDetail> cartDetail;
  DiscountBreakdown discountBreakdown;
  List<DataShopVoucher> shopVouchers;
  List<VoucherRecommend> voucherRecommend;
  double totalPayment;

  Data({
    required this.cartDetail,
    required this.discountBreakdown,
    required this.shopVouchers,
    required this.voucherRecommend,
    required this.totalPayment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cartDetail: List<CartDetail>.from(
            json["cart_detail"].map((x) => CartDetail.fromJson(x))),
        discountBreakdown:
            DiscountBreakdown.fromJson(json["discount_breakdown"]),
        shopVouchers: List<DataShopVoucher>.from(
            json["shop_vouchers"].map((x) => DataShopVoucher.fromJson(x))),
        voucherRecommend: List<VoucherRecommend>.from(
            json["voucher_recommend"].map((x) => VoucherRecommend.fromJson(x))),
        totalPayment: json["total_payment"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "cart_detail": List<dynamic>.from(cartDetail.map((x) => x.toJson())),
        "discount_breakdown": discountBreakdown.toJson(),
        "shop_vouchers":
            List<dynamic>.from(shopVouchers.map((x) => x.toJson())),
        "voucher_recommend":
            List<dynamic>.from(voucherRecommend.map((x) => x.toJson())),
        "total_payment": totalPayment,
      };
}

class CartDetail {
  String icon;
  int shopId;
  String shopName;
  bool showOfficialShop;
  List<Item> items;
  String discountVoucher;
  List<ShippingVoucher> shippingVoucher;
  List<DrawerEntry> drawerEntries;
  List<PackagedBundleInfo> packagedBundleInfo;

  CartDetail({
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

  factory CartDetail.fromJson(Map<String, dynamic> json) => CartDetail(
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
  int minSpend;
  String discountFormatted;
  int shippingDiscount;
  List<String> shippingOptions;

  DrawerEntry({
    required this.minSpend,
    required this.discountFormatted,
    required this.shippingDiscount,
    required this.shippingOptions,
  });

  factory DrawerEntry.fromJson(Map<String, dynamic> json) => DrawerEntry(
        minSpend: json["min_spend"],
        discountFormatted: json["discount_formatted"],
        shippingDiscount: json["shipping_discount"],
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

// class Item {
//   int cartId;
//   int productId;
//   String productName;
//   String productImage;
//   bool haveDiscount;
//   double discount;
//   double price;
//   double priceBeforeDiscount;
//   int productQty;
//   int stock;
//   int normalStock;
//   int promotionStock;
//   String conditionPromotionStock;
//   int status;
//   bool isInPreview;
//   bool isPreOrder;
//   bool isFreeGift;
//   int totalCanBuyQuantity;
//   String selectItem;
//   int selectItemId;
//   List<int> tierVariationsIndex;
//   List<TierVariation> tierVariations;
//   List<dynamic> cartContent;

//   Item({
//     required this.cartId,
//     required this.productId,
//     required this.productName,
//     required this.productImage,
//     required this.haveDiscount,
//     required this.discount,
//     required this.price,
//     required this.priceBeforeDiscount,
//     required this.productQty,
//     required this.stock,
//     required this.normalStock,
//     required this.promotionStock,
//     required this.conditionPromotionStock,
//     required this.status,
//     required this.isInPreview,
//     required this.isPreOrder,
//     required this.isFreeGift,
//     required this.totalCanBuyQuantity,
//     required this.selectItem,
//     required this.selectItemId,
//     required this.tierVariationsIndex,
//     required this.tierVariations,
//     required this.cartContent,
//   });

//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//         cartId: json["cart_id"],
//         productId: json["product_id"],
//         productName: json["product_name"],
//         productImage: json["product_image"],
//         haveDiscount: json["have_discount"],
//         discount: json["discount"]?.toDouble(),
//         price: json["price"]?.toDouble(),
//         priceBeforeDiscount: json["price_before_discount"]?.toDouble(),
//         productQty: json["product_qty"],
//         stock: json["stock"],
//         normalStock: json["normal_stock"],
//         promotionStock: json["promotion_stock"],
//         conditionPromotionStock: json["condition_promotion_stock"],
//         status: json["status"],
//         isInPreview: json["is_in_preview"],
//         isPreOrder: json["is_pre_order"],
//         isFreeGift: json["is_free_gift"],
//         totalCanBuyQuantity: json["total_can_buy_quantity"],
//         selectItem: json["select_item"],
//         selectItemId: json["select_item_id"],
//         tierVariationsIndex:
//             List<int>.from(json["tier_variations_index"].map((x) => x)),
//         tierVariations: List<TierVariation>.from(
//             json["tier_variations"].map((x) => TierVariation.fromJson(x))),
//         cartContent: List<dynamic>.from(json["cart_content"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "cart_id": cartId,
//         "product_id": productId,
//         "product_name": productName,
//         "product_image": productImage,
//         "have_discount": haveDiscount,
//         "discount": discount,
//         "price": price,
//         "price_before_discount": priceBeforeDiscount,
//         "product_qty": productQty,
//         "stock": stock,
//         "normal_stock": normalStock,
//         "promotion_stock": promotionStock,
//         "condition_promotion_stock": conditionPromotionStock,
//         "status": status,
//         "is_in_preview": isInPreview,
//         "is_pre_order": isPreOrder,
//         "is_free_gift": isFreeGift,
//         "total_can_buy_quantity": totalCanBuyQuantity,
//         "select_item": selectItem,
//         "select_item_id": selectItemId,
//         "tier_variations_index":
//             List<dynamic>.from(tierVariationsIndex.map((x) => x)),
//         "tier_variations":
//             List<dynamic>.from(tierVariations.map((x) => x.toJson())),
//         "cart_content": List<dynamic>.from(cartContent.map((x) => x)),
//       };
// }

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

class DiscountBreakdown {
  Subtotal subtotal;
  Subtotal totalSaved;
  Subtotal total;
  List<Subtotal> breakdown;
  DiscountDisplay discountDisplay;

  DiscountBreakdown({
    required this.subtotal,
    required this.totalSaved,
    required this.total,
    required this.breakdown,
    required this.discountDisplay,
  });

  factory DiscountBreakdown.fromJson(Map<String, dynamic> json) =>
      DiscountBreakdown(
        subtotal: Subtotal.fromJson(json["subtotal"]),
        totalSaved: Subtotal.fromJson(json["total_saved"]),
        total: Subtotal.fromJson(json["total"]),
        breakdown: json["breakdown"] == null
            ? []
            : List<Subtotal>.from(
                json["breakdown"].map((x) => Subtotal.fromJson(x))),
        discountDisplay: DiscountDisplay.fromJson(json["discount_display"]),
      );

  Map<String, dynamic> toJson() => {
        "subtotal": subtotal.toJson(),
        "total_saved": totalSaved.toJson(),
        "total": total.toJson(),
        "breakdown": List<dynamic>.from(breakdown.map((x) => x.toJson())),
        "discount_display": discountDisplay.toJson(),
      };
}

class Subtotal {
  String label;
  double value;
  double coinValue;
  String format;

  Subtotal({
    required this.label,
    required this.value,
    required this.coinValue,
    required this.format,
  });

  factory Subtotal.fromJson(Map<String, dynamic> json) => Subtotal(
        label: json["label"],
        value: json["value"]?.toDouble(),
        coinValue: json["coin_value"]?.toDouble(),
        format: json["format"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "coin_value": coinValue,
        "format": format,
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

class DataShopVoucher {
  int shopId;
  String shopName;
  List<ShopVoucher> shopVouchers;

  DataShopVoucher({
    required this.shopId,
    required this.shopName,
    required this.shopVouchers,
  });

  factory DataShopVoucher.fromJson(Map<String, dynamic> json) =>
      DataShopVoucher(
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

class VoucherRecommend {
  int voucherType;
  String voucherTypeText;
  List<Voucher> vouchers;

  VoucherRecommend({
    required this.voucherType,
    required this.voucherTypeText,
    required this.vouchers,
  });

  factory VoucherRecommend.fromJson(Map<String, dynamic> json) =>
      VoucherRecommend(
        voucherType: json["voucher_type"],
        voucherTypeText: json["voucher_type_text"],
        vouchers: List<Voucher>.from(
            json["vouchers"].map((x) => Voucher.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "voucher_type": voucherType,
        "voucher_type_text": voucherTypeText,
        "vouchers": List<dynamic>.from(vouchers.map((x) => x.toJson())),
      };
}

class Voucher {
  int couponId;
  String couponCode;
  int shopId;
  bool isShopOfficial;
  String title;
  String image;
  RewardInfo rewardInfo;
  TimeInfo timeInfo;
  QuotaInfo quotaInfo;
  List<dynamic> labels;
  List<dynamic> scopeTags;
  UserStatus userStatus;
  bool canUse;

  Voucher({
    required this.couponId,
    required this.couponCode,
    required this.shopId,
    required this.isShopOfficial,
    required this.title,
    required this.image,
    required this.rewardInfo,
    required this.timeInfo,
    required this.quotaInfo,
    required this.labels,
    required this.scopeTags,
    required this.userStatus,
    required this.canUse,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        couponId: json["coupon_id"],
        couponCode: json["coupon_code"],
        shopId: json["shop_id"],
        isShopOfficial: json["is_shop_official"],
        title: json["title"],
        image: json["image"],
        rewardInfo: RewardInfo.fromJson(json["reward_info"]),
        timeInfo: TimeInfo.fromJson(json["time_info"]),
        quotaInfo: QuotaInfo.fromJson(json["quota_info"]),
        labels: List<dynamic>.from(json["labels"].map((x) => x)),
        scopeTags: List<dynamic>.from(json["scope_tags"].map((x) => x)),
        userStatus: UserStatus.fromJson(json["user_status"]),
        canUse: json["can_use"],
      );

  Map<String, dynamic> toJson() => {
        "coupon_id": couponId,
        "coupon_code": couponCode,
        "shop_id": shopId,
        "is_shop_official": isShopOfficial,
        "title": title,
        "image": image,
        "reward_info": rewardInfo.toJson(),
        "time_info": timeInfo.toJson(),
        "quota_info": quotaInfo.toJson(),
        "labels": List<dynamic>.from(labels.map((x) => x)),
        "scope_tags": List<dynamic>.from(scopeTags.map((x) => x)),
        "user_status": userStatus.toJson(),
        "can_use": canUse,
      };
}

class QuotaInfo {
  int percentageClaimed;
  int percentageUsed;
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
        percentageClaimed: json["percentage_claimed"],
        percentageUsed: json["percentage_used"],
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
