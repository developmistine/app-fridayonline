// To parse this JSON data, do
//
//     final checkInformationOrderOrderDetailB2C = checkInformationOrderOrderDetailB2CFromJson(jsonString);

import 'dart:convert';

CheckInformationOrderOrderDetailB2C checkInformationOrderOrderDetailB2CFromJson(
        String str) =>
    CheckInformationOrderOrderDetailB2C.fromJson(json.decode(str));

String checkInformationOrderOrderDetailB2CToJson(
        CheckInformationOrderOrderDetailB2C data) =>
    json.encode(data.toJson());

class CheckInformationOrderOrderDetailB2C {
  String repSeq;
  String repCode;
  String repName;
  String repTel;
  int orderId;
  String orderNo;
  String orderDate;
  String orderTime;
  String campaign;
  PaymentInfo paymentInfo;
  bool cancelFlag;
  bool returnFlag;
  Address address;
  OrderStatus orderStatus;
  ShippingInfo shippingInfo;
  ShopInfo shopInfo;
  List<ItemGroup> itemGroups;

  CheckInformationOrderOrderDetailB2C({
    required this.repSeq,
    required this.repCode,
    required this.repName,
    required this.repTel,
    required this.orderId,
    required this.orderNo,
    required this.orderDate,
    required this.orderTime,
    required this.campaign,
    required this.paymentInfo,
    required this.cancelFlag,
    required this.returnFlag,
    required this.address,
    required this.orderStatus,
    required this.shippingInfo,
    required this.shopInfo,
    required this.itemGroups,
  });

  factory CheckInformationOrderOrderDetailB2C.fromJson(
          Map<String, dynamic> json) =>
      CheckInformationOrderOrderDetailB2C(
        repSeq: json["rep_seq"],
        repCode: json["rep_code"],
        repName: json["rep_name"],
        repTel: json["rep_tel"],
        orderId: json["order_id"],
        orderNo: json["order_no"],
        orderDate: json["order_date"],
        orderTime: json["order_time"],
        campaign: json["campaign"],
        paymentInfo: PaymentInfo.fromJson(json["payment_info"]),
        cancelFlag: json["cancel_flag"],
        returnFlag: json["return_flag"],
        address: Address.fromJson(json["address"]),
        orderStatus: OrderStatus.fromJson(json["order_status"]),
        shippingInfo: ShippingInfo.fromJson(json["shipping_info"]),
        shopInfo: ShopInfo.fromJson(json["shop_info"]),
        itemGroups: List<ItemGroup>.from(
            json["item_groups"].map((x) => ItemGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rep_seq": repSeq,
        "rep_code": repCode,
        "rep_name": repName,
        "rep_tel": repTel,
        "order_id": orderId,
        "order_no": orderNo,
        "order_date": orderDate,
        "order_time": orderTime,
        "campaign": campaign,
        "payment_info": paymentInfo.toJson(),
        "cancel_flag": cancelFlag,
        "return_flag": returnFlag,
        "address": address.toJson(),
        "order_status": orderStatus.toJson(),
        "shipping_info": shippingInfo.toJson(),
        "shop_info": shopInfo.toJson(),
        "item_groups": List<dynamic>.from(itemGroups.map((x) => x.toJson())),
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
  String billCode;
  String billName;
  String image;
  int amount;
  int price;
  int priceBeforeDiscount;
  int orderPrice;

  ItemGroup({
    required this.billCode,
    required this.billName,
    required this.image,
    required this.amount,
    required this.price,
    required this.priceBeforeDiscount,
    required this.orderPrice,
  });

  factory ItemGroup.fromJson(Map<String, dynamic> json) => ItemGroup(
        billCode: json["bill_code"],
        billName: json["bill_name"],
        image: json["image"],
        amount: json["amount"],
        price: json["price"],
        priceBeforeDiscount: json["price_before_discount"],
        orderPrice: json["order_price"],
      );

  Map<String, dynamic> toJson() => {
        "bill_code": billCode,
        "bill_name": billName,
        "image": image,
        "amount": amount,
        "price": price,
        "price_before_discount": priceBeforeDiscount,
        "order_price": orderPrice,
      };
}

class OrderStatus {
  String colorCode;
  String description;

  OrderStatus({
    required this.colorCode,
    required this.description,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
        colorCode: json["color_code"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "color_code": colorCode,
        "description": description,
      };
}

class PaymentInfo {
  int finalTotal;
  int amountPaid;
  List<Info> info;
  PaymentMethod paymentMethod;

  PaymentInfo({
    required this.finalTotal,
    required this.amountPaid,
    required this.info,
    required this.paymentMethod,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        finalTotal: json["final_total"],
        amountPaid: json["amount_paid"],
        info: List<Info>.from(json["info"].map((x) => Info.fromJson(x))),
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
  int value;

  Info({
    required this.text,
    required this.value,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        text: json["text"],
        value: json["value"],
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

class ShippingInfo {
  String trackingNo;
  String carrier;
  String trackingUrl;

  ShippingInfo({
    required this.trackingNo,
    required this.carrier,
    required this.trackingUrl,
  });

  factory ShippingInfo.fromJson(Map<String, dynamic> json) => ShippingInfo(
        trackingNo: json["tracking_no"],
        carrier: json["carrier"],
        trackingUrl: json["tracking_url"],
      );

  Map<String, dynamic> toJson() => {
        "tracking_no": trackingNo,
        "carrier": carrier,
        "tracking_url": trackingUrl,
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
