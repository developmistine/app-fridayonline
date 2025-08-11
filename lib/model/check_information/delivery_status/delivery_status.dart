import 'dart:convert';

CheckInformationDeliveryStatus checkInformationDeliveryStatusFromJson(
        String str) =>
    CheckInformationDeliveryStatus.fromJson(json.decode(str));

String checkInformationDeliveryStatusToJson(
        CheckInformationDeliveryStatus data) =>
    json.encode(data.toJson());

class CheckInformationDeliveryStatus {
  OrderMsl orderMsl;

  CheckInformationDeliveryStatus({
    required this.orderMsl,
  });

  factory CheckInformationDeliveryStatus.fromJson(Map<String, dynamic> json) =>
      CheckInformationDeliveryStatus(
        orderMsl: OrderMsl.fromJson(json["OrderMSL"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderMSL": orderMsl.toJson(),
      };
}

class OrderMsl {
  List<Header> header;

  OrderMsl({
    required this.header,
  });

  factory OrderMsl.fromJson(Map<String, dynamic> json) => OrderMsl(
        header:
            List<Header>.from(json["Header"].map((x) => Header.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Header": List<dynamic>.from(header.map((x) => x.toJson())),
      };
}

class Header {
  String orderNo;
  String orderSource;
  String ordshopId;
  String supplierCode;
  String supplierName;
  String billCampaign;
  String billSeq;
  String repSeq;
  String docType;
  String saleCampaign;
  String orderCampaign;
  String invNo;
  String invDate;
  String repCode;
  String repName;
  String totalItems;
  String totalAmount;
  String totalDiscount;
  String status;
  String address;
  String mobileNo;
  String statusColor;
  List<Listdetail> listdetail;

  Header({
    required this.orderNo,
    required this.orderSource,
    required this.ordshopId,
    required this.supplierCode,
    required this.supplierName,
    required this.billCampaign,
    required this.billSeq,
    required this.repSeq,
    required this.docType,
    required this.saleCampaign,
    required this.orderCampaign,
    required this.invNo,
    required this.invDate,
    required this.repCode,
    required this.repName,
    required this.totalItems,
    required this.totalAmount,
    required this.totalDiscount,
    required this.status,
    required this.address,
    required this.mobileNo,
    required this.statusColor,
    required this.listdetail,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        orderNo: json["OrderNo"] ?? "",
        orderSource: json["OrderSource"] ?? "",
        ordshopId: json["OrdshopId"] ?? "",
        supplierCode: json["SupplierCode"] ?? "",
        supplierName: json["SupplierName"] ?? "",
        billCampaign: json["BillCampaign"],
        billSeq: json["BillSeq"],
        repSeq: json["RepSeq"],
        docType: json["DocType"],
        saleCampaign: json["SaleCampaign"],
        orderCampaign: json["OrderCampaign"],
        invNo: json["InvNo"],
        invDate: json["InvDate"],
        repCode: json["RepCode"],
        repName: json["RepName"],
        totalItems: json["TotalItems"],
        totalAmount: json["TotalAmount"],
        totalDiscount: json["TotalDiscount"],
        status: json["Status"],
        address: json["Address"],
        mobileNo: json["MobileNo"],
        statusColor: json["StatusColor"],
        listdetail: List<Listdetail>.from(
            json["Listdetail"].map((x) => Listdetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "OrderNo": orderNo,
        "OrderSource": orderSource,
        "OrdshopId": ordshopId,
        "SupplierCode": supplierCode,
        "SupplierName": supplierName,
        "BillCampaign": billCampaign,
        "BillSeq": billSeq,
        "RepSeq": repSeq,
        "DocType": docType,
        "SaleCampaign": saleCampaign,
        "OrderCampaign": orderCampaign,
        "InvNo": invNo,
        "InvDate": invDate,
        "RepCode": repCode,
        "RepName": repName,
        "TotalItems": totalItems,
        "TotalAmount": totalAmount,
        "TotalDiscount": totalDiscount,
        "Status": status,
        "Address": address,
        "MobileNo": mobileNo,
        "StatusColor": statusColor,
        "Listdetail": List<dynamic>.from(listdetail.map((x) => x.toJson())),
      };
}

class Listdetail {
  String listno;
  String billCode;
  String billDesc;
  String pathImg;
  String billCamp;
  String qty;
  String price;
  String amount;

  Listdetail({
    required this.listno,
    required this.billCode,
    required this.billDesc,
    required this.pathImg,
    required this.billCamp,
    required this.qty,
    required this.price,
    required this.amount,
  });

  factory Listdetail.fromJson(Map<String, dynamic> json) => Listdetail(
        listno: json["Listno"],
        billCode: json["BillCode"],
        billDesc: json["BillDesc"],
        pathImg: json["PathImg"],
        billCamp: json["BillCamp"],
        qty: json["Qty"],
        price: json["Price"],
        amount: json["Amount"],
      );

  Map<String, dynamic> toJson() => {
        "Listno": listno,
        "BillCode": billCode,
        "BillDesc": billDesc,
        "PathImg": pathImg,
        "BillCamp": billCamp,
        "Qty": qty,
        "Price": price,
        "Amount": amount,
      };
}
