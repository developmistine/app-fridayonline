// To parse this JSON data, do
//
//     final deleteDetailEnduser = deleteDetailEnduserFromJson(jsonString);

import 'dart:convert';

DeleteDetailEnduser deleteDetailEnduserFromJson(String str) => DeleteDetailEnduser.fromJson(json.decode(str));

String deleteDetailEnduserToJson(DeleteDetailEnduser data) => json.encode(data.toJson());

class DeleteDetailEnduser {
    DeleteDetailEnduser({
        required this.repSeq,
        required this.userId,
        required this.listdetail,
    });

    String repSeq;
    String userId;
    List<ListdetailDelete> listdetail;

    factory DeleteDetailEnduser.fromJson(Map<String, dynamic> json) => DeleteDetailEnduser(
        repSeq: json["RepSeq"] ?? "",
        userId: json["UserID"] ?? "",
        listdetail: json["Listdetail"] == null ? [] : List<ListdetailDelete>.from(json["Listdetail"].map((x) => ListdetailDelete.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "UserID": userId,
        "Listdetail": List<dynamic>.from(listdetail.map((x) => x.toJson())),
    };
}

class ListdetailDelete {
    ListdetailDelete({
        required this.orderNo,
        required this.billCode,
        required this.billCamp,
        required this.qtyConfirm,
        required this.billFlag,
    });

    String orderNo;
    String billCode;
    String billCamp;
    String qtyConfirm;
    String billFlag;

    factory ListdetailDelete.fromJson(Map<String, dynamic> json) => ListdetailDelete(
        orderNo: json["OrderNo"] ?? "",
        billCode: json["BillCode"] ?? "",
        billCamp: json["BillCamp"] ?? "",
        qtyConfirm: json["QtyConfirm"] ?? "",
        billFlag: json["BillFlag"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "OrderNo": orderNo,
        "BillCode": billCode,
        "BillCamp": billCamp,
        "QtyConfirm": qtyConfirm,
        "BillFlag": billFlag,
    };
}
