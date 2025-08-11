// To parse this JSON data, do
//
//     final itemCartEdit = itemCartEditFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

ItemCartEdit itemCartEditFromJson(String str) =>
    ItemCartEdit.fromJson(json.decode(str));

String itemCartEditToJson(ItemCartEdit data) => json.encode(data.toJson());

class ItemCartEdit {
  ItemCartEdit({
    required this.brand,
    required this.tokenApp,
    required this.mediaCode,
    required this.tokenOrder,
    required this.repcode,
    required this.repseq,
    required this.reptype,
    required this.campaign,
    required this.billCode,
    required this.action,
    required this.qty,
    required this.status,
    required this.billType,
    required this.message,
    required this.protype,
    required this.enduserid,
    required this.totalitem,
    required this.device,
    required this.channel,
    required this.channelId,
  });

  String brand;
  String tokenApp;
  String mediaCode;
  String tokenOrder;
  String repcode;
  String repseq;
  String reptype;
  String campaign;
  String billCode;
  String action;
  String qty;
  String status;
  String billType;
  String message;
  String protype;
  dynamic enduserid;
  int totalitem;
  dynamic device;
  dynamic channel;
  dynamic channelId;

  factory ItemCartEdit.fromJson(Map<String, dynamic> json) => ItemCartEdit(
        brand: json["Brand"] ?? "",
        tokenApp: json["TokenApp"] ?? "",
        mediaCode: json["MediaCode"] ?? "",
        tokenOrder: json["TokenOrder"] ?? "",
        repcode: json["Repcode"] ?? "",
        repseq: json["Repseq"] ?? "",
        reptype: json["Reptype"] ?? "",
        campaign: json["Campaign"] ?? "",
        billCode: json["BillCode"] ?? "",
        action: json["Action"] ?? "",
        qty: json["Qty"] ?? "",
        status: json["Status"] ?? "",
        billType: json["BillType"] ?? "",
        message: json["Message"] ?? "",
        protype: json["Protype"] ?? "",
        enduserid: json["Enduserid"] ?? "",
        totalitem: json["Totalitem"] ?? 0,
        device: json["Device"] ?? "",
        channel: json["channel"] ?? "",
        channelId: json["channelId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Brand": brand,
        "TokenApp": tokenApp,
        "MediaCode": mediaCode,
        "TokenOrder": tokenOrder,
        "Repcode": repcode,
        "Repseq": repseq,
        "Reptype": reptype,
        "Campaign": campaign,
        "BillCode": billCode,
        "Action": action,
        "Qty": qty,
        "Status": status,
        "BillType": billType,
        "Message": message,
        "Protype": protype,
        "Enduserid": enduserid,
        "Totalitem": totalitem,
        "Device": device,
        "channel": channel,
        "channelId": channelId,
      };
}
