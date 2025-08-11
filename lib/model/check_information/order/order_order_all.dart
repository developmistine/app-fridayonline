// To parse this JSON data, do
//
//     final checkInformationOrderOrderAll = checkInformationOrderOrderAllFromJson(jsonString);

import 'dart:convert';

CheckInformationOrderOrderAll checkInformationOrderOrderAllFromJson(
        String str) =>
    CheckInformationOrderOrderAll.fromJson(json.decode(str));

String checkInformationOrderOrderAllToJson(
        CheckInformationOrderOrderAll data) =>
    json.encode(data.toJson());

class CheckInformationOrderOrderAll {
  CheckInformationOrderOrderAll({
    required this.customerOrderHistory,
  });

  CustomerOrderHistory customerOrderHistory;

  factory CheckInformationOrderOrderAll.fromJson(Map<String, dynamic> json) =>
      CheckInformationOrderOrderAll(
        customerOrderHistory:
            CustomerOrderHistory.fromJson(json["CustomerOrderHistory"]),
      );

  Map<String, dynamic> toJson() => {
        "CustomerOrderHistory": customerOrderHistory.toJson(),
      };
}

class CustomerOrderHistory {
  CustomerOrderHistory({
    required this.customerMslOrderDetail,
    required this.customerEndUserOrderDetail,
  });

  List<CustomerOrderDetail> customerMslOrderDetail;
  List<CustomerOrderDetail> customerEndUserOrderDetail;

  factory CustomerOrderHistory.fromJson(Map<String, dynamic> json) =>
      CustomerOrderHistory(
        customerMslOrderDetail: json["CustomerMSLOrderDetail"] == null
            ? []
            : List<CustomerOrderDetail>.from(json["CustomerMSLOrderDetail"]
                .map((x) => CustomerOrderDetail.fromJson(x))),
        customerEndUserOrderDetail: json["CustomerEndUserOrderDetail"] == null
            ? []
            : List<CustomerOrderDetail>.from(json["CustomerEndUserOrderDetail"]
                .map((x) => CustomerOrderDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CustomerMSLOrderDetail":
            List<dynamic>.from(customerMslOrderDetail.map((x) => x.toJson())),
        "CustomerEndUserOrderDetail": List<dynamic>.from(
            customerEndUserOrderDetail.map((x) => x.toJson())),
      };
}

class CustomerOrderDetail {
  CustomerOrderDetail({
    required this.orderSource,
    required this.ordshopId,
    required this.supplierCode,
    required this.supplierName,
    required this.headerStatus,
    required this.orderList,
    required this.ordercamp,
    required this.userId,
    required this.userTel,
    required this.name,
    required this.repCode,
    required this.orderNo,
    required this.orderDate,
    required this.orderDateTemp,
    required this.orderTime,
    required this.orderType,
    required this.item,
    required this.qty,
    required this.qtyconfirm,
    required this.totalAmount,
    required this.statusOrder,
    required this.statusDiscription,
    required this.downloadFlag,
    required this.reciveTypeText,
  });

  String orderSource;
  String ordshopId;
  String supplierCode;
  String supplierName;
  String headerStatus;
  String orderList;
  String ordercamp;
  String userId;
  String userTel;
  String name;
  String repCode;
  String orderNo;
  String orderDate;
  String orderDateTemp;
  String orderTime;
  String orderType;
  String item;
  String qty;
  String qtyconfirm;
  String totalAmount;
  String statusOrder;
  String statusDiscription;
  String downloadFlag;
  String reciveTypeText;

  factory CustomerOrderDetail.fromJson(Map<String, dynamic> json) =>
      CustomerOrderDetail(
        orderSource: json["OrderSource"] ?? "",
        ordshopId: json["OrdshopId"] ?? "",
        supplierCode: json["SupplierCode"] ?? "",
        supplierName: json["SupplierName"] ?? "",
        headerStatus: json["HeaderStatus"] ?? "",
        orderList: json["OrderList"] ?? "",
        ordercamp: json["Ordercamp"] ?? "",
        userId: json["UserID"] ?? "",
        userTel: json["UserTel"] ?? "",
        name: json["Name"] ?? "",
        repCode: json["RepCode"] ?? "",
        orderNo: json["OrderNo"] ?? "",
        orderDate: json["OrderDate"] ?? "",
        orderDateTemp: json["OrderDateTemp"] ?? "",
        orderTime: json["OrderTime"] ?? "",
        orderType: json["OrderType"] ?? "",
        item: json["Item"] ?? "",
        qty: json["Qty"] ?? "",
        qtyconfirm: json["Qtyconfirm"] ?? "",
        totalAmount: json["TotalAmount"] ?? "",
        statusOrder: json["StatusOrder"] ?? "",
        statusDiscription: json["StatusDiscription"] ?? "",
        downloadFlag: json["DownloadFlag"] ?? "",
        reciveTypeText: json["ReciveTypeText"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "OrderSource": orderSource,
        "OrdshopId": ordshopId,
        "SupplierCode": supplierCode,
        "SupplierName": supplierName,
        "HeaderStatus": headerStatus,
        "OrderList": orderList,
        "Ordercamp": ordercamp,
        "UserID": userId,
        "UserTel": userTel,
        "Name": name,
        "RepCode": repCode,
        "OrderNo": orderNo,
        "OrderDate": orderDate,
        "OrderDateTemp": orderDateTemp,
        "OrderTime": orderTime,
        "OrderType": orderType,
        "Item": item,
        "Qty": qty,
        "Qtyconfirm": qtyconfirm,
        "TotalAmount": totalAmount,
        "StatusOrder": statusOrder,
        "StatusDiscription": statusDiscription,
        "DownloadFlag": downloadFlag,
        "ReciveTypeText": reciveTypeText,
      };
}
