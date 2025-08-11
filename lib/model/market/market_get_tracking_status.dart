// To parse this JSON data, do
//
//     final marketGetTracking = marketGetTrackingFromJson(jsonString);

import 'dart:convert';

MarketGetTracking marketGetTrackingFromJson(String str) =>
    MarketGetTracking.fromJson(json.decode(str));

String marketGetTrackingToJson(MarketGetTracking data) =>
    json.encode(data.toJson());

class MarketGetTracking {
  MarketGetTracking({
    required this.displayName,
    required this.profileImg,
    required this.followstore,
    required this.trackingStatus,
  });

  String displayName;
  String profileImg;
  String followstore;
  TrackingStatus trackingStatus;

  factory MarketGetTracking.fromJson(Map<String, dynamic> json) =>
      MarketGetTracking(
        displayName: json["DisplayName"] ?? "",
        profileImg: json["ProfileImg"] ?? "",
        followstore: json["Followstore"] ?? "",
        trackingStatus: TrackingStatus.fromJson(json["TrackingStatus"]),
      );

  Map<String, dynamic> toJson() => {
        "DisplayName": displayName,
        "ProfileImg": profileImg,
        "Followstore": followstore,
        "TrackingStatus": trackingStatus.toJson(),
      };
}

class TrackingStatus {
  TrackingStatus({
    required this.payMent,
    required this.shipping,
    required this.reciveOrder,
    required this.review,
  });

  String payMent;
  String shipping;
  String reciveOrder;
  String review;

  factory TrackingStatus.fromJson(Map<String, dynamic> json) => TrackingStatus(
        payMent: json["PayMent"] ?? "",
        shipping: json["Shipping"] ?? "",
        reciveOrder: json["ReciveOrder"] ?? "",
        review: json["Review"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "PayMent": payMent,
        "Shipping": shipping,
        "ReciveOrder": reciveOrder,
        "Review": review,
      };
}
