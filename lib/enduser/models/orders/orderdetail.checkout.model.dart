// To parse this JSON data, do
//
//     final orderDetailCheckOut = orderDetailCheckOutFromJson(jsonString);

import 'dart:convert';

OrderDetailCheckOut orderDetailCheckOutFromJson(String str) =>
    OrderDetailCheckOut.fromJson(json.decode(str));

String orderDetailCheckOutToJson(OrderDetailCheckOut data) =>
    json.encode(data.toJson());

class OrderDetailCheckOut {
  String code;
  Data data;
  String message;

  OrderDetailCheckOut({
    required this.code,
    required this.data,
    required this.message,
  });

  factory OrderDetailCheckOut.fromJson(Map<String, dynamic> json) =>
      OrderDetailCheckOut(
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
  int orderId;
  OrderStatus orderStatus;
  ShippingInfo shippingInfo;
  Address address;
  List<ShopList> shopList;
  PaymentMethod paymentMethod;
  Summary summary;
  bool canCancel;

  Data({
    required this.orderId,
    required this.orderStatus,
    required this.shippingInfo,
    required this.address,
    required this.shopList,
    required this.paymentMethod,
    required this.summary,
    required this.canCancel,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        orderId: json["order_id"],
        orderStatus: OrderStatus.fromJson(json["order_status"]),
        shippingInfo: ShippingInfo.fromJson(json["shipping_info"]),
        address: Address.fromJson(json["address"]),
        shopList: json["shop_list"] != null
            ? List<ShopList>.from(
                json["shop_list"].map((x) => ShopList.fromJson(x)))
            : [],
        paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
        summary: Summary.fromJson(json["summary"]),
        canCancel: json["can_cancel"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_status": orderStatus.toJson(),
        "shipping_info": shippingInfo.toJson(),
        "address": address.toJson(),
        "shop_list": List<dynamic>.from(shopList.map((x) => x.toJson())),
        "payment_method": paymentMethod.toJson(),
        "summary": summary.toJson(),
        "can_cancel": canCancel,
      };
}

class Address {
  String shippingName;
  String shippingPhone;
  String shippingAddress;
  bool canChangeAddress;

  Address({
    required this.shippingName,
    required this.shippingPhone,
    required this.shippingAddress,
    required this.canChangeAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        shippingName: json["shipping_name"],
        shippingPhone: json["shipping_phone"],
        shippingAddress: json["shipping_address"],
        canChangeAddress: json["can_change_address"],
      );

  Map<String, dynamic> toJson() => {
        "shipping_name": shippingName,
        "shipping_phone": shippingPhone,
        "shipping_address": shippingAddress,
        "can_change_address": canChangeAddress,
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

class ShippingInfo {
  String deliveryBy;
  String trackingNo;
  List<Step> step;
  List<dynamic> trackingInfo;

  ShippingInfo({
    required this.deliveryBy,
    required this.trackingNo,
    required this.step,
    required this.trackingInfo,
  });

  factory ShippingInfo.fromJson(Map<String, dynamic> json) => ShippingInfo(
        deliveryBy: json["delivery_by"],
        trackingNo: json["tracking_no"],
        step: json["step"] != null
            ? List<Step>.from(json["step"].map((x) => Step.fromJson(x)))
            : [],
        trackingInfo: json["tracking_info"] != null
            ? List<dynamic>.from(json["tracking_info"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "delivery_by": deliveryBy,
        "tracking_no": trackingNo,
        "step": List<dynamic>.from(step.map((x) => x.toJson())),
        "tracking_info": List<dynamic>.from(trackingInfo.map((x) => x)),
      };
}

class Step {
  String image;
  String text;
  String color;
  bool isCurrent;

  Step({
    required this.image,
    required this.text,
    required this.color,
    required this.isCurrent,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        image: json["image"],
        text: json["text"],
        color: json["color"],
        isCurrent: json["is_current"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "text": text,
        "color": color,
        "is_current": isCurrent,
      };
}

class ShopList {
  int ordshopId;
  ShopInfo shopInfo;
  List<ItemGroup> itemGroups;
  PaymentInfo paymentInfo;

  ShopList({
    required this.ordshopId,
    required this.shopInfo,
    required this.itemGroups,
    required this.paymentInfo,
  });

  factory ShopList.fromJson(Map<String, dynamic> json) => ShopList(
        ordshopId: json["ordshop_id"],
        shopInfo: ShopInfo.fromJson(json["shop_info"]),
        itemGroups: List<ItemGroup>.from(
            json["item_groups"].map((x) => ItemGroup.fromJson(x))),
        paymentInfo: PaymentInfo.fromJson(json["payment_info"]),
      );

  Map<String, dynamic> toJson() => {
        "ordshop_id": ordshopId,
        "shop_info": shopInfo.toJson(),
        "item_groups": List<dynamic>.from(itemGroups.map((x) => x.toJson())),
        "payment_info": paymentInfo.toJson(),
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

class PaymentInfo {
  double finalTotal;
  double amountPaid;
  List<Info> info;

  PaymentInfo({
    required this.finalTotal,
    required this.amountPaid,
    required this.info,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        finalTotal: json["final_total"]?.toDouble(),
        amountPaid: json["amount_paid"]?.toDouble(),
        info: List<Info>.from(json["info"].map((x) => Info.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "final_total": finalTotal,
        "amount_paid": amountPaid,
        "info": List<dynamic>.from(info.map((x) => x.toJson())),
      };
}

class Info {
  String text;
  double value;

  Info({
    required this.text,
    required this.value,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        text: json["text"],
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
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
