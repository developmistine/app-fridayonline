// To parse this JSON data, do
//
//     final endUserSaveOrder = endUserSaveOrderFromJson(jsonString);

import 'dart:convert';

EndUserSaveOrder endUserSaveOrderFromJson(String str) =>
    EndUserSaveOrder.fromJson(json.decode(str));

String endUserSaveOrderToJson(EndUserSaveOrder data) =>
    json.encode(data.toJson());

class EndUserSaveOrder {
  OrderEndUser orderEndUser;

  EndUserSaveOrder({
    required this.orderEndUser,
  });

  factory EndUserSaveOrder.fromJson(Map<String, dynamic> json) =>
      EndUserSaveOrder(
        orderEndUser: OrderEndUser.fromJson(json["OrderEndUser"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderEndUser": orderEndUser.toJson(),
      };
}

class OrderEndUser {
  List<OrderHeader> orderHeader;
  List<Orderdetail> orderdetail;
  List<OrderdetailB2C> orderdetailB2C;
  List<DataAddress> dataAddress;

  OrderEndUser({
    required this.orderHeader,
    required this.orderdetail,
    required this.orderdetailB2C,
    required this.dataAddress,
  });

  factory OrderEndUser.fromJson(Map<String, dynamic> json) => OrderEndUser(
        orderHeader: List<OrderHeader>.from(
            json["OrderHeader"].map((x) => OrderHeader.fromJson(x))),
        orderdetail: List<Orderdetail>.from(
            json["Orderdetail"].map((x) => Orderdetail.fromJson(x))),
        orderdetailB2C: List<OrderdetailB2C>.from(
            json["OrderdetailB2C"].map((x) => OrderdetailB2C.fromJson(x))),
        dataAddress: List<DataAddress>.from(
            json["DataAddress"].map((x) => DataAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "OrderHeader": List<dynamic>.from(orderHeader.map((x) => x.toJson())),
        "Orderdetail": List<dynamic>.from(orderdetail.map((x) => x.toJson())),
        "OrderdetailB2C":
            List<dynamic>.from(orderdetailB2C.map((x) => x.toJson())),
        "DataAddress": List<dynamic>.from(dataAddress.map((x) => x.toJson())),
      };
}

class DataAddress {
  String customerName;
  String telNumber;
  String address1;
  String address2;
  String provinceId;
  String amphurId;
  String tumbonId;
  String provinceName;
  String amphurName;
  String tumbonName;
  String postalCode;
  String note;

  DataAddress({
    required this.customerName,
    required this.telNumber,
    required this.address1,
    required this.address2,
    required this.provinceId,
    required this.amphurId,
    required this.tumbonId,
    required this.provinceName,
    required this.amphurName,
    required this.tumbonName,
    required this.postalCode,
    required this.note,
  });

  factory DataAddress.fromJson(Map<String, dynamic> json) => DataAddress(
        customerName: json["CustomerName"],
        telNumber: json["Telnumber"],
        address1: json["Address1"],
        address2: json["Address2"],
        provinceId: json["ProvinceId"],
        amphurId: json["AmphurId"],
        tumbonId: json["TumbonId"],
        provinceName: json["ProvinceName"],
        amphurName: json["AmphurName"],
        tumbonName: json["TumbonName"],
        postalCode: json["PostalCode"],
        note: json["Note"],
      );

  Map<String, dynamic> toJson() => {
        "CustomerName": customerName,
        "Telnumber": telNumber,
        "Address1": address1,
        "Address2": address2,
        "ProvinceId": provinceId,
        "AmphurId": amphurId,
        "TumbonId": tumbonId,
        "ProvinceName": provinceName,
        "AmphurName": amphurName,
        "TumbonName": tumbonName,
        "PostalCode": postalCode,
        "Note": note,
      };
}

class OrderHeader {
  String sessionId;
  String orderNo;
  int repSeq;
  String repCode;
  int userType;
  int enduserId;
  String enduserTel;
  String orderDate;
  String orderTime;
  String customerName;
  String customerSurName;
  String totalItems;
  String totalDiscount;
  String totalAmount;
  String device;
  String imei;
  String useStar;
  String language;
  String starDiscount;
  String orderType;
  String deliveryType;
  String shipFee;
  String usePoint;
  String pointDiscount;
  List<dynamic> couponDiscount;
  String autoRun;
  String paymentType;

  OrderHeader({
    required this.sessionId,
    required this.orderNo,
    required this.repSeq,
    required this.repCode,
    required this.userType,
    required this.enduserId,
    required this.enduserTel,
    required this.orderDate,
    required this.orderTime,
    required this.customerName,
    required this.customerSurName,
    required this.totalItems,
    required this.totalDiscount,
    required this.totalAmount,
    required this.device,
    required this.imei,
    required this.useStar,
    required this.language,
    required this.starDiscount,
    required this.orderType,
    required this.deliveryType,
    required this.shipFee,
    required this.usePoint,
    required this.pointDiscount,
    required this.couponDiscount,
    required this.autoRun,
    required this.paymentType,
  });

  factory OrderHeader.fromJson(Map<String, dynamic> json) => OrderHeader(
        sessionId: json["SessionId"],
        orderNo: json["OrderNo"],
        repSeq: json["RepSeq"],
        repCode: json["RepCode"],
        userType: json["UserType"],
        enduserId: json["EnduserID"],
        enduserTel: json["EnduserTel"],
        orderDate: json["OrderDate"],
        orderTime: json["OrderTime"],
        customerName: json["CustomerName"],
        customerSurName: json["CustomerSurName"],
        totalItems: json["TotalItems"],
        totalDiscount: json["TotalDiscount"],
        totalAmount: json["TotalAmount"],
        device: json["Device"],
        imei: json["IMEI"],
        useStar: json["UseStar"],
        language: json["language"],
        starDiscount: json["StarDiscount"],
        orderType: json["OrderType"],
        deliveryType: json["DeliveryType"],
        shipFee: json["ShipFee"],
        usePoint: json["UsePoint"],
        pointDiscount: json["PointDiscount"],
        couponDiscount:
            List<dynamic>.from(json["CouponDiscount"].map((x) => x)),
        autoRun: json["AutoRun"],
        paymentType: json["PaymentType"],
      );

  Map<String, dynamic> toJson() => {
        "SessionId": sessionId,
        "OrderNo": orderNo,
        "RepSeq": repSeq,
        "RepCode": repCode,
        "UserType": userType,
        "EnduserID": enduserId,
        "EnduserTel": enduserTel,
        "OrderDate": orderDate,
        "OrderTime": orderTime,
        "CustomerName": customerName,
        "CustomerSurName": customerSurName,
        "TotalItems": totalItems,
        "TotalDiscount": totalDiscount,
        "TotalAmount": totalAmount,
        "Device": device,
        "IMEI": imei,
        "UseStar": useStar,
        "language": language,
        "StarDiscount": starDiscount,
        "OrderType": orderType,
        "DeliveryType": deliveryType,
        "ShipFee": shipFee,
        "UsePoint": usePoint,
        "PointDiscount": pointDiscount,
        "CouponDiscount": List<dynamic>.from(couponDiscount.map((x) => x)),
        "AutoRun": autoRun,
        "PaymentType": paymentType,
      };
}

class Orderdetail {
  String orderNo;
  String listno;
  String billCode;
  String billDesc;
  String media;
  String billcamp;
  String qty;
  String price;
  int discount;
  String amount;
  String brand;

  Orderdetail({
    required this.orderNo,
    required this.listno,
    required this.billCode,
    required this.billDesc,
    required this.media,
    required this.billcamp,
    required this.qty,
    required this.price,
    required this.discount,
    required this.amount,
    required this.brand,
  });

  factory Orderdetail.fromJson(Map<String, dynamic> json) => Orderdetail(
        orderNo: json["OrderNo"],
        listno: json["Listno"],
        billCode: json["BillCode"],
        billDesc: json["BillDesc"],
        media: json["Media"],
        billcamp: json["Billcamp"],
        qty: json["Qty"],
        price: json["Price"],
        discount: json["Discount"],
        amount: json["Amount"],
        brand: json["Brand"],
      );

  Map<String, dynamic> toJson() => {
        "OrderNo": orderNo,
        "Listno": listno,
        "BillCode": billCode,
        "BillDesc": billDesc,
        "Media": media,
        "Billcamp": billcamp,
        "Qty": qty,
        "Price": price,
        "Discount": discount,
        "Amount": amount,
        "Brand": brand,
      };
}

class OrderdetailB2C {
  String supplierCode;
  String supplierName;
  int shipFee;
  List<Orderdetail> orderdetail;

  OrderdetailB2C({
    required this.supplierCode,
    required this.supplierName,
    required this.shipFee,
    required this.orderdetail,
  });

  factory OrderdetailB2C.fromJson(Map<String, dynamic> json) => OrderdetailB2C(
        supplierCode: json["SupplierCode"],
        supplierName: json["SupplierName"],
        shipFee: json["ShipFee"]?.toDouble(),
        orderdetail: List<Orderdetail>.from(
            json["Orderdetail"].map((x) => Orderdetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "SupplierCode": supplierCode,
        "SupplierName": supplierName,
        "ShipFee": shipFee,
        "Orderdetail": List<dynamic>.from(orderdetail.map((x) => x.toJson())),
      };
}
