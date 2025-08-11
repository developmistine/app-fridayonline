// To parse this JSON data, do
//
//     final leadCheckInformation = leadCheckInformationFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

LeadCheckInformation leadCheckInformationFromJson(String str) =>
    LeadCheckInformation.fromJson(json.decode(str));

String leadCheckInformationToJson(LeadCheckInformation data) =>
    json.encode(data.toJson());

class LeadCheckInformation {
  LeadCheckInformation({
    required this.orderEndUser,
  });

  OrderEndUser orderEndUser;

  factory LeadCheckInformation.fromJson(Map<String, dynamic> json) =>
      LeadCheckInformation(
        orderEndUser: OrderEndUser.fromJson(json["OrderEndUser"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderEndUser": orderEndUser.toJson(),
      };
}

class OrderEndUser {
  OrderEndUser({
    required this.orderHeader,
  });

  OrderHeader orderHeader;

  factory OrderEndUser.fromJson(Map<String, dynamic> json) => OrderEndUser(
        orderHeader: OrderHeader.fromJson(json["OrderHeader"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderHeader": orderHeader.toJson(),
      };
}

class OrderHeader {
  OrderHeader({
    required this.headerList,
  });

  HeaderList headerList;

  factory OrderHeader.fromJson(Map<String, dynamic> json) => OrderHeader(
        headerList: HeaderList.fromJson(json["HeaderList"]),
      );

  Map<String, dynamic> toJson() => {
        "HeaderList": headerList.toJson(),
      };
}

class HeaderList {
  HeaderList({
    required this.enduserId,
    required this.enduserTel,
    required this.enduserName,
    required this.repCode,
    required this.userType,
    required this.header,
  });

  String enduserId;
  String enduserTel;
  String enduserName;
  String repCode;
  String userType;
  List<Header> header;

  factory HeaderList.fromJson(Map<String, dynamic> json) => HeaderList(
        enduserId: json["EnduserID"] ?? "",
        enduserTel: json["EnduserTel"] ?? "",
        enduserName: json["EnduserName"] ?? "",
        repCode: json["RepCode"] ?? "",
        userType: json["UserType"] ?? "",
        header: json["Header"] == null
            ? []
            : List<Header>.from(json["Header"].map((x) => Header.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EnduserID": enduserId,
        "EnduserTel": enduserTel,
        "EnduserName": enduserName,
        "RepCode": repCode,
        "UserType": userType,
        "Header": List<dynamic>.from(header.map((x) => x.toJson())),
      };
}

class Header {
  Header({
    required this.orderNo,
    required this.orderDate,
    required this.orderTime,
    required this.totalItems,
    required this.totalDiscount,
    required this.totalAmount,
    required this.listdetail,
    required this.footer,
  });

  String orderNo;
  String orderDate;
  String orderTime;
  String totalItems;
  String totalDiscount;
  String totalAmount;
  List<Listdetail> listdetail;
  Footer footer;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        orderNo: json["OrderNo"] ?? "",
        orderDate: json["OrderDate"] ?? "",
        orderTime: json["OrderTime"] ?? "",
        totalItems: json["TotalItems"] ?? "",
        totalDiscount: json["TotalDiscount"] ?? "",
        totalAmount: json["TotalAmount"] ?? "",
        listdetail: json["Listdetail"] == null
            ? []
            : List<Listdetail>.from(
                json["Listdetail"].map((x) => Listdetail.fromJson(x))),
        footer: Footer.fromJson(json["footer"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderNo": orderNo,
        "OrderDate": orderDate,
        "OrderTime": orderTime,
        "TotalItems": totalItems,
        "TotalDiscount": totalDiscount,
        "TotalAmount": totalAmount,
        "Listdetail": List<dynamic>.from(listdetail.map((x) => x.toJson())),
        "footer": footer.toJson(),
      };
}

class Footer {
  Footer({
    required this.items,
    required this.totalall,
    required this.couponDiscount,
    required this.stradiscount,
    required this.totalbalance,
    required this.straRecive,
  });

  String items;
  String totalall;
  String couponDiscount;
  String stradiscount;
  String totalbalance;
  String straRecive;

  factory Footer.fromJson(Map<String, dynamic> json) => Footer(
        items: json["Items"] ?? "",
        totalall: json["Totalall"] ?? "",
        couponDiscount: json["CouponDiscount"] ?? "",
        stradiscount: json["Stradiscount"] ?? "",
        totalbalance: json["Totalbalance"] ?? "",
        straRecive: json["StraRecive"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Items": items,
        "Totalall": totalall,
        "CouponDiscount": couponDiscount,
        "Stradiscount": stradiscount,
        "Totalbalance": totalbalance,
        "StraRecive": straRecive,
      };
}

class Listdetail {
  Listdetail({
    required this.listno,
    required this.billCode,
    required this.billDesc,
    required this.pathImg,
    required this.qty,
    required this.price,
    required this.amount,
    required this.brand,
  });

  String listno;
  String billCode;
  String billDesc;
  String pathImg;
  String qty;
  String price;
  String amount;
  String brand;

  factory Listdetail.fromJson(Map<String, dynamic> json) => Listdetail(
        listno: json["Listno"],
        billCode: json["BillCode"],
        billDesc: json["BillDesc"],
        pathImg: json["PathImg"],
        qty: json["Qty"],
        price: json["Price"],
        amount: json["Amount"],
        brand: json["Brand"],
      );

  Map<String, dynamic> toJson() => {
        "Listno": listno,
        "BillCode": billCode,
        "BillDesc": billDesc,
        "PathImg": pathImg,
        "Qty": qty,
        "Price": price,
        "Amount": amount,
        "Brand": brand,
      };
}
