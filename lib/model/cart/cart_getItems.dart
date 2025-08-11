// To parse this JSON data, do
//
//     final itemsGetCart = itemsGetCartFromJson(jsonString);

import 'dart:convert';

ItemsGetCart itemsGetCartFromJson(String str) =>
    ItemsGetCart.fromJson(json.decode(str));

String itemsGetCartToJson(ItemsGetCart data) => json.encode(data.toJson());

class ItemsGetCart {
  CardHeader cardHeader;

  ItemsGetCart({
    required this.cardHeader,
  });

  factory ItemsGetCart.fromJson(Map<String, dynamic> json) => ItemsGetCart(
        cardHeader: CardHeader.fromJson(json["CardHeader"]),
      );

  Map<String, dynamic> toJson() => {
        "CardHeader": cardHeader.toJson(),
      };
}

class CardHeader {
  String repSeq;
  String repCode;
  String enduserid;
  String userType;
  int totalitem;
  double totalAmount;
  String campaign;
  String deliveryDate;
  List<Carddetail> carddetail;
  List<CarddetailB2C> carddetailB2C;

  CardHeader({
    required this.repSeq,
    required this.repCode,
    required this.enduserid,
    required this.userType,
    required this.totalitem,
    required this.totalAmount,
    required this.campaign,
    required this.deliveryDate,
    required this.carddetail,
    required this.carddetailB2C,
  });

  factory CardHeader.fromJson(Map<String, dynamic> json) => CardHeader(
        repSeq: json["RepSeq"],
        repCode: json["RepCode"],
        enduserid: json["enduserid"],
        userType: json["UserType"],
        totalitem: json["Totalitem"],
        totalAmount: json["TotalAmount"]?.toDouble(),
        campaign: json["Campaign"],
        deliveryDate: json["DeliveryDate"],
        carddetail: List<Carddetail>.from(
            json["Carddetail"].map((x) => Carddetail.fromJson(x))),
        carddetailB2C: List<CarddetailB2C>.from(
            json["CarddetailB2C"].map((x) => CarddetailB2C.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "RepCode": repCode,
        "enduserid": enduserid,
        "UserType": userType,
        "Totalitem": totalitem,
        "TotalAmount": totalAmount,
        "Campaign": campaign,
        "DeliveryDate": deliveryDate,
        "Carddetail": List<dynamic>.from(carddetail.map((x) => x.toJson())),
        "CarddetailB2C":
            List<dynamic>.from(carddetailB2C.map((x) => x.toJson())),
      };
}

class Carddetail {
  int listno;
  String tokenOrder;
  String billcamp;
  String billCode;
  String billCodeB2C;
  String billName;
  String billImg;
  int qty;
  int qtyConfirm;
  String billFlag;
  double price;
  double amount;
  String brand;
  String media;
  String fsCode;
  String billColor;
  bool isInStock;
  String imgAppend;
  String flagNetPrice;
  String imgNetPrice;
  String stockDescription;
  String packageProNameHeader;
  List<dynamic> packageProDetail;

  Carddetail({
    required this.listno,
    required this.tokenOrder,
    required this.billcamp,
    required this.billCode,
    required this.billCodeB2C,
    required this.billName,
    required this.billImg,
    required this.qty,
    required this.qtyConfirm,
    required this.billFlag,
    required this.price,
    required this.amount,
    required this.brand,
    required this.media,
    required this.fsCode,
    required this.billColor,
    required this.isInStock,
    required this.imgAppend,
    required this.flagNetPrice,
    required this.imgNetPrice,
    required this.stockDescription,
    required this.packageProNameHeader,
    required this.packageProDetail,
  });

  factory Carddetail.fromJson(Map<String, dynamic> json) => Carddetail(
        listno: json["Listno"],
        tokenOrder: json["TokenOrder"],
        billcamp: json["Billcamp"],
        billCode: json["BillCode"],
        billCodeB2C: json["BillCodeB2C"],
        billName: json["BillName"],
        billImg: json["BillImg"],
        qty: json["Qty"],
        qtyConfirm: json["QtyConfirm"],
        billFlag: json["BillFlag"],
        price: json["Price"]?.toDouble(),
        amount: json["Amount"]?.toDouble(),
        brand: json["Brand"],
        media: json["Media"],
        fsCode: json["FS_CODE"],
        billColor: json["BillColor"],
        isInStock: json["is_in_stock"],
        imgAppend: json["ImgAppend"],
        flagNetPrice: json["flagNetPrice"],
        imgNetPrice: json["imgNetPrice"],
        stockDescription: json["StockDescription"],
        packageProNameHeader: json["PackageProNameHeader"],
        packageProDetail:
            List<dynamic>.from(json["PackageProDetail"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Listno": listno,
        "TokenOrder": tokenOrder,
        "Billcamp": billcamp,
        "BillCode": billCode,
        "BillCodeB2C": billCodeB2C,
        "BillName": billName,
        "BillImg": billImg,
        "Qty": qty,
        "QtyConfirm": qtyConfirm,
        "BillFlag": billFlag,
        "Price": price,
        "Amount": amount,
        "Brand": brand,
        "Media": media,
        "FS_CODE": fsCode,
        "BillColor": billColor,
        "is_in_stock": isInStock,
        "ImgAppend": imgAppend,
        "flagNetPrice": flagNetPrice,
        "imgNetPrice": imgNetPrice,
        "StockDescription": stockDescription,
        "PackageProNameHeader": packageProNameHeader,
        "PackageProDetail": List<dynamic>.from(packageProDetail.map((x) => x)),
      };
}

class CarddetailB2C {
  String icon;
  String supplierCode;
  String supplierName;
  List<Carddetail> carddetail;

  CarddetailB2C({
    required this.icon,
    required this.supplierCode,
    required this.supplierName,
    required this.carddetail,
  });

  factory CarddetailB2C.fromJson(Map<String, dynamic> json) => CarddetailB2C(
        icon: json["icon"],
        supplierCode: json["supplier_code"],
        supplierName: json["supplier_name"],
        carddetail: List<Carddetail>.from(
            json["Carddetail"].map((x) => Carddetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "supplier_code": supplierCode,
        "supplier_name": supplierName,
        "Carddetail": List<dynamic>.from(carddetail.map((x) => x.toJson())),
      };
}
