// To parse this JSON data, do
//
//     final orderDetail = orderDetailFromJson(jsonString);

import 'dart:convert';

OrderDetail orderDetailFromJson(String str) =>
    OrderDetail.fromJson(json.decode(str));

String orderDetailToJson(OrderDetail data) => json.encode(data.toJson());

class OrderDetail {
  String code;
  Data data;
  String message;

  OrderDetail({
    required this.code,
    required this.data,
    required this.message,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
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
  String orderNo;
  OrderStatus orderStatus;
  List<ShippingInfo> shippingInfo;
  Address address;
  ShopInfo shopInfo;
  List<ItemGroup> itemGroups;
  PaymentInfo paymentInfo;
  bool canCancel;
  bool canReturn;
  ReturnInfo returnInfo;

  Data({
    required this.orderId,
    required this.orderNo,
    required this.orderStatus,
    required this.shippingInfo,
    required this.address,
    required this.shopInfo,
    required this.itemGroups,
    required this.paymentInfo,
    required this.canCancel,
    required this.canReturn,
    required this.returnInfo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        orderId: json["order_id"],
        orderNo: json["order_no"],
        orderStatus: OrderStatus.fromJson(json["order_status"]),
        shippingInfo: List<ShippingInfo>.from(
            json["shipping_info"].map((x) => ShippingInfo.fromJson(x))),
        address: Address.fromJson(json["address"]),
        shopInfo: ShopInfo.fromJson(json["shop_info"]),
        itemGroups: json["item_groups"] == null
            ? []
            : List<ItemGroup>.from(
                json["item_groups"].map((x) => ItemGroup.fromJson(x))),
        paymentInfo: PaymentInfo.fromJson(json["payment_info"]),
        canCancel: json["can_cancel"],
        canReturn: json["can_return"],
        returnInfo: ReturnInfo.fromJson(json["return_info"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_no": orderNo,
        "order_status": orderStatus.toJson(),
        "shipping_info":
            List<dynamic>.from(shippingInfo.map((x) => x.toJson())),
        "address": address.toJson(),
        "shop_info": shopInfo.toJson(),
        "item_groups": List<dynamic>.from(itemGroups.map((x) => x.toJson())),
        "payment_info": paymentInfo.toJson(),
        "can_cancel": canCancel,
        "can_return": canReturn,
        "return_info": returnInfo.toJson(),
      };
}

class Address {
  String shippingName;
  String shippingPhone;
  String shippingAddress;

  Address({
    required this.shippingName,
    required this.shippingPhone,
    required this.shippingAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        shippingName: json["shipping_name"],
        shippingPhone: json["shipping_phone"],
        shippingAddress: json["shipping_address"],
      );

  Map<String, dynamic> toJson() => {
        "shipping_name": shippingName,
        "shipping_phone": shippingPhone,
        "shipping_address": shippingAddress,
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
  bool isSeleted;
  int qty;
  double refundAmountPerItem;

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
    required this.isSeleted,
    required this.qty,
    required this.refundAmountPerItem,
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
        price: json["price"].toDouble(),
        priceBeforeDiscount: json["price_before_discount"].toDouble(),
        orderPrice: json["order_price"].toDouble(),
        isSeleted: false,
        qty: 0,
        refundAmountPerItem: json["refund_amount_per_item"].toDouble(),
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
        "isSeleted": isSeleted,
        "qty": qty,
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

class PaymentInfo {
  double finalTotal;
  double amountPaid;
  List<Info> info;
  PaymentMethod paymentMethod;

  PaymentInfo({
    required this.finalTotal,
    required this.amountPaid,
    required this.info,
    required this.paymentMethod,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        finalTotal: json["final_total"].toDouble(),
        amountPaid: json["amount_paid"].toDouble(),
        info: json["info"] == null
            ? []
            : List<Info>.from(json["info"].map((x) => Info.fromJson(x))),
        paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
      );

  Map<String, dynamic> toJson() => {
        "final_total": finalTotal,
        "amount_paid": amountPaid,
        "info": List<dynamic>.from(info.map((x) => x.toJson())),
        "payment_method": paymentMethod.toJson(),
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
        value: json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}

class PaymentMethod {
  int paymentMethod;
  String paymentChannelName;

  PaymentMethod({
    required this.paymentMethod,
    required this.paymentChannelName,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        paymentMethod: json["payment_method"],
        paymentChannelName: json["payment_channel_name"],
      );

  Map<String, dynamic> toJson() => {
        "payment_method": paymentMethod,
        "payment_channel_name": paymentChannelName,
      };
}

class ReturnInfo {
  bool showRefundSteps;
  String returnDate;
  int returnStatus;
  int returnType;
  String returnTypeDesc;
  String returnInfoDesc;
  double refundAmount;
  String returnReason;
  ReturnDelivery returnDelivery;
  ReturnPayment returnPayment;
  String comment;
  List<String> images;
  List<String> videos;
  List<String> imagesTracking;
  String returnAddress;
  String returnPickupCondition;

  ReturnInfo({
    required this.showRefundSteps,
    required this.returnDate,
    required this.returnStatus,
    required this.returnType,
    required this.returnTypeDesc,
    required this.returnInfoDesc,
    required this.refundAmount,
    required this.returnReason,
    required this.returnDelivery,
    required this.returnPayment,
    required this.comment,
    required this.images,
    required this.videos,
    required this.imagesTracking,
    required this.returnAddress,
    required this.returnPickupCondition,
  });

  factory ReturnInfo.fromJson(Map<String, dynamic> json) => ReturnInfo(
        showRefundSteps: json["show_refund_steps"],
        returnDate: json["return_date"],
        returnStatus: json["return_status"],
        returnType: json["return_type"],
        returnTypeDesc: json["return_type_desc"],
        returnInfoDesc: json["return_info_desc"],
        refundAmount: json["refund_amount"]?.toDouble(),
        returnReason: json["return_reason"],
        returnDelivery: ReturnDelivery.fromJson(json["return_delivery"]),
        returnPayment: ReturnPayment.fromJson(json["return_payment"]),
        comment: json["comment"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"].map((x) => x)),
        videos: List<String>.from(
            json["videos"] == null ? [] : json["videos"].map((x) => x)),
        imagesTracking: json["images_tracking"] == null
            ? []
            : List<String>.from(json["images_tracking"].map((x) => x)),
        returnAddress: json["return_address"],
        returnPickupCondition: json["return_pickup_condition"],
      );

  Map<String, dynamic> toJson() => {
        "show_refund_steps": showRefundSteps,
        "return_date": returnDate,
        "return_status": returnStatus,
        "return_type": returnType,
        "return_type_desc": returnTypeDesc,
        "return_info_desc": returnInfoDesc,
        "refund_amount": refundAmount,
        "return_reason": returnReason,
        "return_delivery": returnDelivery.toJson(),
        "return_payment": returnPayment.toJson(),
        "comment": comment,
        "images": List<dynamic>.from(images.map((x) => x)),
        "videos": List<dynamic>.from(videos.map((x) => x)),
        "images_tracking": List<dynamic>.from(imagesTracking.map((x) => x)),
        "return_address": returnAddress,
        "return_pickup_condition": returnPickupCondition,
      };
}

class ReturnDelivery {
  int courierId;
  String courierDesc;
  String trackingNo;
  double shippingFee;

  ReturnDelivery({
    required this.courierId,
    required this.courierDesc,
    required this.trackingNo,
    required this.shippingFee,
  });

  factory ReturnDelivery.fromJson(Map<String, dynamic> json) => ReturnDelivery(
        courierId: json["courier_id"],
        courierDesc: json["courier_desc"],
        trackingNo: json["tracking_no"],
        shippingFee: json["shipping_fee"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "courier_id": courierId,
        "courier_desc": courierDesc,
        "tracking_no": trackingNo,
        "shipping_fee": shippingFee,
      };
}

class ReturnPayment {
  int bankId;
  String bankDesc;
  String accountName;
  String accountNo;

  ReturnPayment({
    required this.bankId,
    required this.bankDesc,
    required this.accountName,
    required this.accountNo,
  });

  factory ReturnPayment.fromJson(Map<String, dynamic> json) => ReturnPayment(
        bankId: json["bank_id"],
        bankDesc: json["bank_desc"],
        accountName: json["account_name"],
        accountNo: json["account_no"],
      );

  Map<String, dynamic> toJson() => {
        "bank_id": bankId,
        "bank_desc": bankDesc,
        "account_name": accountName,
        "account_no": accountNo,
      };
}

class ShippingInfo {
  String deliveryBy;
  String trackingNo;
  List<Step> step;
  List<TrackingInfo> trackingInfo;

  ShippingInfo({
    required this.deliveryBy,
    required this.trackingNo,
    required this.step,
    required this.trackingInfo,
  });

  factory ShippingInfo.fromJson(Map<String, dynamic> json) => ShippingInfo(
        deliveryBy: json["delivery_by"],
        trackingNo: json["tracking_no"],
        step: json["step"] == null
            ? []
            : List<Step>.from(json["step"].map((x) => Step.fromJson(x))),
        trackingInfo: json["tracking_info"] == null
            ? []
            : List<TrackingInfo>.from(
                json["tracking_info"].map((x) => TrackingInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "delivery_by": deliveryBy,
        "tracking_no": trackingNo,
        "step": List<dynamic>.from(step.map((x) => x.toJson())),
        "tracking_info":
            List<dynamic>.from(trackingInfo.map((x) => x.toJson())),
      };
}

class Step {
  String image;
  String text;
  String color;
  bool? isCurrent;

  Step({
    required this.image,
    required this.text,
    required this.color,
    this.isCurrent,
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

class TrackingInfo {
  String driverPhone;
  String driverName;
  String description;
  String receiverName;
  String dateTime;
  Step milestone;

  TrackingInfo({
    required this.driverPhone,
    required this.driverName,
    required this.description,
    required this.receiverName,
    required this.dateTime,
    required this.milestone,
  });

  factory TrackingInfo.fromJson(Map<String, dynamic> json) => TrackingInfo(
        driverPhone: json["driver_phone"],
        driverName: json["driver_name"],
        description: json["description"],
        receiverName: json["receiver_name"],
        dateTime: json["date_time"],
        milestone: Step.fromJson(json["milestone"]),
      );

  Map<String, dynamic> toJson() => {
        "driver_phone": driverPhone,
        "driver_name": driverName,
        "description": description,
        "receiver_name": receiverName,
        "date_time": dateTime,
        "milestone": milestone.toJson(),
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
