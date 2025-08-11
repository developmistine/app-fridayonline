// To parse this JSON data, do
//
//     final ordersListCheckOut = ordersListCheckOutFromJson(jsonString);

import 'dart:convert';

OrdersListCheckOut ordersListCheckOutFromJson(String str) =>
    OrdersListCheckOut.fromJson(json.decode(str));

String ordersListCheckOutToJson(OrdersListCheckOut data) =>
    json.encode(data.toJson());

class OrdersListCheckOut {
  String code;
  List<Datum> data;
  String message;

  OrdersListCheckOut({
    required this.code,
    required this.data,
    required this.message,
  });

  factory OrdersListCheckOut.fromJson(Map<String, dynamic> json) =>
      OrdersListCheckOut(
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
  OrderStatus orderStatus;
  List<ShopList> shopList;
  PaymentMethod paymentMethod;
  Summary summary;

  Datum({
    required this.orderId,
    required this.orderStatus,
    required this.shopList,
    required this.paymentMethod,
    required this.summary,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderId: json["order_id"],
        orderStatus: OrderStatus.fromJson(json["order_status"]),
        shopList: List<ShopList>.from(
            json["shop_list"].map((x) => ShopList.fromJson(x))),
        paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
        summary: Summary.fromJson(json["summary"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_status": orderStatus.toJson(),
        "shop_list": List<dynamic>.from(shopList.map((x) => x.toJson())),
        "payment_method": paymentMethod.toJson(),
        "summary": summary.toJson(),
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

class PaymentMethod {
  int paymentMethod;
  String paymentChannelName;
  String paymentChargeId;
  String paymentOrderId;

  PaymentMethod({
    required this.paymentMethod,
    required this.paymentChannelName,
    required this.paymentChargeId,
    required this.paymentOrderId,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        paymentMethod: json["payment_method"],
        paymentChannelName: json["payment_channel_name"],
        paymentChargeId: json["payment_charge_id"],
        paymentOrderId: json["payment_order_id"],
      );

  Map<String, dynamic> toJson() => {
        "payment_method": paymentMethod,
        "payment_channel_name": paymentChannelName,
        "payment_charge_id": paymentChargeId,
        "payment_order_id": paymentOrderId,
      };
}

class ShopList {
  int ordshopId;
  ShopInfo shopInfo;
  List<ItemGroup> itemGroups;
  Summary summary;

  ShopList({
    required this.ordshopId,
    required this.shopInfo,
    required this.itemGroups,
    required this.summary,
  });

  factory ShopList.fromJson(Map<String, dynamic> json) => ShopList(
        ordshopId: json["ordshop_id"],
        shopInfo: ShopInfo.fromJson(json["shop_info"]),
        itemGroups: List<ItemGroup>.from(
            json["item_groups"].map((x) => ItemGroup.fromJson(x))),
        summary: Summary.fromJson(json["summary"]),
      );

  Map<String, dynamic> toJson() => {
        "ordshop_id": ordshopId,
        "shop_info": shopInfo.toJson(),
        "item_groups": List<dynamic>.from(itemGroups.map((x) => x.toJson())),
        "summary": summary.toJson(),
      };
}

class ItemGroup {
  int orddtlId;
  int productId;
  String productName;
  int itemId;
  String itemName;
  String image;
  int amount;
  bool haveDiscount;
  double price;
  double priceBeforeDiscount;
  double orderPrice;

  ItemGroup({
    required this.orddtlId,
    required this.productId,
    required this.productName,
    required this.itemId,
    required this.itemName,
    required this.image,
    required this.amount,
    required this.haveDiscount,
    required this.price,
    required this.priceBeforeDiscount,
    required this.orderPrice,
  });

  factory ItemGroup.fromJson(Map<String, dynamic> json) => ItemGroup(
        orddtlId: json["orddtl_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        itemId: json["item_id"],
        itemName: json["item_name"],
        image: json["image"],
        amount: json["amount"],
        haveDiscount: json["have_discount"],
        price: json["price"]?.toDouble(),
        priceBeforeDiscount: json["price_before_discount"]?.toDouble(),
        orderPrice: json["order_price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "orddtl_id": orddtlId,
        "product_id": productId,
        "product_name": productName,
        "item_id": itemId,
        "item_name": itemName,
        "image": image,
        "amount": amount,
        "have_discount": haveDiscount,
        "price": price,
        "price_before_discount": priceBeforeDiscount,
        "order_price": orderPrice,
      };
}

class ShopInfo {
  String icon;
  int shopId;
  String shopCode;
  String shopName;
  String shopAddress;

  ShopInfo({
    required this.icon,
    required this.shopId,
    required this.shopCode,
    required this.shopName,
    required this.shopAddress,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        icon: json["icon"],
        shopId: json["shop_id"],
        shopCode: json["shop_code"],
        shopName: json["shop_name"],
        shopAddress: json["shop_address"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "shop_id": shopId,
        "shop_code": shopCode,
        "shop_name": shopName,
        "shop_address": shopAddress,
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
