// To parse this JSON data, do
//
//     final dropshipDeliveryStatusDetail = dropshipDeliveryStatusDetailFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

DropshipDeliveryStatusDetail dropshipDeliveryStatusDetailFromJson(String str) =>
    DropshipDeliveryStatusDetail.fromJson(json.decode(str));

String dropshipDeliveryStatusDetailToJson(DropshipDeliveryStatusDetail data) =>
    json.encode(data.toJson());

class DropshipDeliveryStatusDetail {
  DropshipDeliveryStatusDetail({
    required this.trackingNo,
    required this.supProvince,
    required this.shipProvince,
    required this.description,
    required this.desTel,
    required this.tracking,
  });

  String trackingNo;
  String supProvince;
  String shipProvince;
  String description;
  String desTel;
  List<Tracking> tracking;

  factory DropshipDeliveryStatusDetail.fromJson(Map<String, dynamic> json) =>
      DropshipDeliveryStatusDetail(
        trackingNo: json["TrackingNo"] ?? "",
        supProvince: json["SupProvince"] ?? "",
        shipProvince: json["ShipProvince"] ?? "",
        description: json["Description"] ?? "",
        desTel: json["DesTel"] ?? "",
        tracking: json["Tracking"] == null
            ? []
            : List<Tracking>.from(
                json["Tracking"].map((x) => Tracking.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TrackingNo": trackingNo,
        "SupProvince": supProvince,
        "ShipProvince": shipProvince,
        "Description": description,
        "DesTel": desTel,
        "Tracking": List<dynamic>.from(tracking.map((x) => x.toJson())),
      };
}

class Tracking {
  Tracking({
    required this.trackingDate,
    required this.trackingNote,
  });

  String trackingDate;
  String trackingNote;

  factory Tracking.fromJson(Map<String, dynamic> json) => Tracking(
        trackingDate: json["TrackingDate"] ?? "",
        trackingNote: json["TrackingNote"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "TrackingDate": trackingDate,
        "TrackingNote": trackingNote,
      };
}
