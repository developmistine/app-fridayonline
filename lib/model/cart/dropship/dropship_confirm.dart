// To parse this JSON data, do
//
//     final dropshipConfirmOrder = dropshipConfirmOrderFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

DropshipConfirmOrder dropshipConfirmOrderFromJson(String str) =>
    DropshipConfirmOrder.fromJson(json.decode(str));

String dropshipConfirmOrderToJson(DropshipConfirmOrder data) =>
    json.encode(data.toJson());

class DropshipConfirmOrder {
  DropshipConfirmOrder({
    required this.repCode,
    required this.repSeq,
    required this.repType,
    required this.totItem,
    required this.totAmount,
    required this.orderCartList,
    required this.shipAddress,
  });

  String repCode;
  String repSeq;
  String repType;
  String totItem;
  String totAmount;
  List<OrderCartList> orderCartList;
  ShipAddress shipAddress;

  factory DropshipConfirmOrder.fromJson(Map<String, dynamic> json) =>
      DropshipConfirmOrder(
        repCode: json["RepCode"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        repType: json["RepType"] ?? "",
        totItem: json["TotItem"] ?? "",
        totAmount: json["TotAmount"] ?? "",
        orderCartList: json["OrderCartList"] == null
            ? []
            : List<OrderCartList>.from(
                json["OrderCartList"].map((x) => OrderCartList.fromJson(x))),
        shipAddress: ShipAddress.fromJson(json["ShipAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepSeq": repSeq,
        "RepType": repType,
        "TotItem": totItem,
        "TotAmount": totAmount,
        "OrderCartList":
            List<dynamic>.from(orderCartList.map((x) => x.toJson())),
        "ShipAddress": shipAddress.toJson(),
      };
}

class OrderCartList {
  OrderCartList({
    required this.billB2C,
    required this.billName,
    required this.supplierCode,
    required this.brand,
    required this.brandCode,
    required this.qty,
    required this.price,
    required this.priceRegular,
    required this.amount,
  });

  String billB2C;
  String billName;
  String supplierCode;
  String brand;
  String brandCode;
  String qty;
  String price;
  String priceRegular;
  String amount;

  factory OrderCartList.fromJson(Map<String, dynamic> json) => OrderCartList(
        billB2C: json["BillB2C"] ?? "",
        billName: json["BillName"] ?? "",
        supplierCode: json["SupplierCode"] ?? "",
        brand: json["Brand"] ?? "",
        brandCode: json["BrandCode"] ?? "",
        qty: json["Qty"] ?? "",
        price: json["Price"] ?? "",
        priceRegular: json["PriceRegular"] ?? "",
        amount: json["Amount"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "BillB2C": billB2C,
        "BillName": billName,
        "SupplierCode": supplierCode,
        "Brand": brand,
        "BrandCode": brandCode,
        "Qty": qty,
        "Price": price,
        "PriceRegular": priceRegular,
        "Amount": amount,
      };
}

class ShipAddress {
  ShipAddress({
    required this.nameReceive,
    required this.mobileNo,
    required this.addressLine1,
    required this.addressLine2,
    required this.nameTumbon,
    required this.nameAmphur,
    required this.nameProvince,
    required this.tumbonCode,
    required this.amphurCode,
    required this.provinceCode,
    required this.postCode,
    required this.areaType,
  });

  String nameReceive;
  String mobileNo;
  String addressLine1;
  String addressLine2;
  String nameTumbon;
  String nameAmphur;
  String nameProvince;
  String tumbonCode;
  String amphurCode;
  String provinceCode;
  String postCode;
  String areaType;

  factory ShipAddress.fromJson(Map<String, dynamic> json) => ShipAddress(
        nameReceive: json["NameReceive"] ?? "",
        mobileNo: json["MobileNo"] ?? "",
        addressLine1: json["AddressLine1"] ?? "",
        addressLine2: json["AddressLine2"] ?? "",
        nameTumbon: json["NameTumbon"] ?? "",
        nameAmphur: json["NameAmphur"] ?? "",
        nameProvince: json["NameProvince"] ?? "",
        tumbonCode: json["TumbonCode"] ?? "",
        amphurCode: json["AmphurCode"] ?? "",
        provinceCode: json["ProvinceCode"] ?? "",
        postCode: json["PostCode"] ?? "",
        areaType: json["AreaType"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "NameReceive": nameReceive,
        "MobileNo": mobileNo,
        "AddressLine1": addressLine1,
        "AddressLine2": addressLine2,
        "NameTumbon": nameTumbon,
        "NameAmphur": nameAmphur,
        "NameProvince": nameProvince,
        "TumbonCode": tumbonCode,
        "AmphurCode": amphurCode,
        "ProvinceCode": provinceCode,
        "PostCode": postCode,
        "AreaType": areaType,
      };
}
