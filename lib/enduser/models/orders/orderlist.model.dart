// To parse this JSON data, do
//
//     final ordersList = ordersListFromJson(jsonString);

import 'dart:convert';

OrdersList ordersListFromJson(String str) =>
    OrdersList.fromJson(json.decode(str));

String ordersListToJson(OrdersList data) => json.encode(data.toJson());

class OrdersList {
  String code;
  List<Datum> data;
  String message;

  OrdersList({
    required this.code,
    required this.data,
    required this.message,
  });

  factory OrdersList.fromJson(Map<String, dynamic> json) => OrdersList(
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
  int orderId;
  String orderNo;
  OrderStatus orderStatus;
  ShopInfo shopInfo;
  List<ItemGroup> itemGroups;
  Summary summary;
  int reviewStatus;

  Datum({
    required this.orderId,
    required this.orderNo,
    required this.orderStatus,
    required this.shopInfo,
    required this.itemGroups,
    required this.summary,
    required this.reviewStatus,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderId: json["order_id"],
        orderNo: json["order_no"],
        orderStatus: OrderStatus.fromJson(json["order_status"]),
        shopInfo: ShopInfo.fromJson(json["shop_info"]),
        itemGroups: List<ItemGroup>.from(
            json["item_groups"].map((x) => ItemGroup.fromJson(x))),
        summary: Summary.fromJson(json["summary"]),
        reviewStatus: json["review_status"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_nƒo": orderNo,
        "order_status": orderStatus.toJson(),
        "shop_info": shopInfo.toJson(),
        "item_groups": List<dynamic>.from(itemGroups.map((x) => x.toJson())),
        "summary": summary.toJson(),
        "review_status": reviewStatus,
      };
}

class ItemGroup {
  int productId;
  String productName;
  int itemId;
  String itemName;
  bool haveDisCount;
  String image;
  int amount;
  double price;
  double priceBeforeDiscount;
  double orderPrice;
  double refundAmountPerItem;

  ItemGroup({
    required this.productId,
    required this.productName,
    required this.itemId,
    required this.itemName,
    required this.haveDisCount,
    required this.image,
    required this.amount,
    required this.price,
    required this.priceBeforeDiscount,
    required this.orderPrice,
    required this.refundAmountPerItem,
  });

  factory ItemGroup.fromJson(Map<String, dynamic> json) => ItemGroup(
        productId: json["product_id"],
        productName: json["product_name"],
        itemId: json["item_id"],
        itemName: json["item_name"],
        haveDisCount: json["have_discount"],
        image: json["image"],
        amount: json["amount"],
        price: json["price"]?.toDouble(),
        priceBeforeDiscount: json["price_before_discount"]?.toDouble(),
        orderPrice: json["order_price"]?.toDouble(),
        refundAmountPerItem: json["refund_amount_per_item"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "item_id": itemId,
        "item_name": itemName,
        "have_discount": haveDisCount,
        "image": image,
        "amount": amount,
        "price": price,
        "price_before_discount": priceBeforeDiscount,
        "order_price": orderPrice,
        "refund_amount_per_item": refundAmountPerItem,
      };
}

class OrderStatus {
  int orderStatus;
  String colorCode;
  String description;

  OrderStatus({
    required this.orderStatus,
    required this.colorCode,
    required this.description,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
        orderStatus: json["order_status"],
        colorCode: json["color_code"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "order_status": orderStatus,
        "color_code": colorCode,
        "description": description,
      };
}

class ShopInfo {
  String icon;
  int shopId;
  String shopCode;
  String shopName;

  ShopInfo({
    required this.icon,
    required this.shopId,
    required this.shopCode,
    required this.shopName,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        icon: json["icon"],
        shopId: json["shop_id"],
        shopCode: json["shop_code"],
        shopName: json["shop_name"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "shop_id": shopId,
        "shop_code": shopCode,
        "shop_name": shopName,
      };
}

class Summary {
  int productCount;
  double subtotal;
  double finalTotal;

  Summary({
    required this.productCount,
    required this.subtotal,
    required this.finalTotal,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        productCount: json["product_count"],
        subtotal: json["subtotal"]?.toDouble(),
        finalTotal: json["final_total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "product_count": productCount,
        "subtotal": subtotal,
        "final_total": finalTotal,
      };
}
