// To parse this JSON data, do
//
//     final platformRecommend = platformRecommendFromJson(jsonString);

import 'dart:convert';

PlatformRecommend platformRecommendFromJson(String str) =>
    PlatformRecommend.fromJson(json.decode(str));

String platformRecommendToJson(PlatformRecommend data) =>
    json.encode(data.toJson());

class PlatformRecommend {
  String code;
  List<Datum> data;
  String message;

  PlatformRecommend({
    required this.code,
    required this.data,
    required this.message,
  });

  factory PlatformRecommend.fromJson(Map<String, dynamic> json) =>
      PlatformRecommend(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int voucherType;
  String voucherTypeText;
  List<Voucher> vouchers;

  Datum({
    required this.voucherType,
    required this.voucherTypeText,
    required this.vouchers,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        voucherType: json["voucher_type"],
        voucherTypeText: json["voucher_type_text"],
        vouchers: List<Voucher>.from(
            json["vouchers"].map((x) => Voucher.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "voucher_type": voucherType,
        "voucher_type_text": voucherTypeText,
        "vouchers": List<dynamic>.from(vouchers.map((x) => x.toJson())),
      };
}

class Voucher {
  int couponId;
  String couponCode;
  int shopId;
  bool isShopOfficial;
  String title;
  String image;
  RewardInfo rewardInfo;
  TimeInfo timeInfo;
  QuotaInfo quotaInfo;
  List<dynamic> labels;
  List<dynamic> scopeTags;
  UserStatus userStatus;
  bool canUse;

  Voucher({
    required this.couponId,
    required this.couponCode,
    required this.shopId,
    required this.isShopOfficial,
    required this.title,
    required this.image,
    required this.rewardInfo,
    required this.timeInfo,
    required this.quotaInfo,
    required this.labels,
    required this.scopeTags,
    required this.userStatus,
    required this.canUse,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        couponId: json["coupon_id"],
        couponCode: json["coupon_code"],
        shopId: json["shop_id"],
        isShopOfficial: json["is_shop_official"],
        title: json["title"],
        image: json["image"],
        rewardInfo: RewardInfo.fromJson(json["reward_info"]),
        timeInfo: TimeInfo.fromJson(json["time_info"]),
        quotaInfo: QuotaInfo.fromJson(json["quota_info"]),
        labels: List<dynamic>.from(json["labels"].map((x) => x)),
        scopeTags: List<dynamic>.from(json["scope_tags"].map((x) => x)),
        userStatus: UserStatus.fromJson(json["user_status"]),
        canUse: json["can_use"],
      );

  Map<String, dynamic> toJson() => {
        "coupon_id": couponId,
        "coupon_code": couponCode,
        "shop_id": shopId,
        "is_shop_official": isShopOfficial,
        "title": title,
        "image": image,
        "reward_info": rewardInfo.toJson(),
        "time_info": timeInfo.toJson(),
        "quota_info": quotaInfo.toJson(),
        "labels": List<dynamic>.from(labels.map((x) => x)),
        "scope_tags": List<dynamic>.from(scopeTags.map((x) => x)),
        "user_status": userStatus.toJson(),
        "can_use": canUse,
      };
}

class QuotaInfo {
  int percentageClaimed;
  int percentageUsed;
  int quotaType;
  bool fullyClaimed;
  bool fullyUsed;

  QuotaInfo({
    required this.percentageClaimed,
    required this.percentageUsed,
    required this.quotaType,
    required this.fullyClaimed,
    required this.fullyUsed,
  });

  factory QuotaInfo.fromJson(Map<String, dynamic> json) => QuotaInfo(
        percentageClaimed: json["percentage_claimed"],
        percentageUsed: json["percentage_used"],
        quotaType: json["quota_type"],
        fullyClaimed: json["fully_claimed"],
        fullyUsed: json["fully_used"],
      );

  Map<String, dynamic> toJson() => {
        "percentage_claimed": percentageClaimed,
        "percentage_used": percentageUsed,
        "quota_type": quotaType,
        "fully_claimed": fullyClaimed,
        "fully_used": fullyUsed,
      };
}

class RewardInfo {
  int minSpend;
  int discountValue;
  int discountPercentage;
  int discountCap;
  int currentSpend;

  RewardInfo({
    required this.minSpend,
    required this.discountValue,
    required this.discountPercentage,
    required this.discountCap,
    required this.currentSpend,
  });

  factory RewardInfo.fromJson(Map<String, dynamic> json) => RewardInfo(
        minSpend: json["min_spend"],
        discountValue: json["discount_value"],
        discountPercentage: json["discount_percentage"],
        discountCap: json["discount_cap"],
        currentSpend: json["current_spend"],
      );

  Map<String, dynamic> toJson() => {
        "min_spend": minSpend,
        "discount_value": discountValue,
        "discount_percentage": discountPercentage,
        "discount_cap": discountCap,
        "current_spend": currentSpend,
      };
}

class TimeInfo {
  String startTime;
  String endTime;
  String claimStartTime;
  String claimEndTime;
  int validDays;
  String timeFormat;
  bool hasExpired;

  TimeInfo({
    required this.startTime,
    required this.endTime,
    required this.claimStartTime,
    required this.claimEndTime,
    required this.validDays,
    required this.timeFormat,
    required this.hasExpired,
  });

  factory TimeInfo.fromJson(Map<String, dynamic> json) => TimeInfo(
        startTime: json["start_time"],
        endTime: json["end_time"],
        claimStartTime: json["claim_start_time"],
        claimEndTime: json["claim_end_time"],
        validDays: json["valid_days"],
        timeFormat: json["time_format"],
        hasExpired: json["has_expired"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "end_time": endTime,
        "claim_start_time": claimStartTime,
        "claim_end_time": claimEndTime,
        "valid_days": validDays,
        "time_format": timeFormat,
        "has_expired": hasExpired,
      };
}

class UserStatus {
  bool isClaimed;
  bool isUsed;
  bool isSelected;

  UserStatus({
    required this.isClaimed,
    required this.isUsed,
    required this.isSelected,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) => UserStatus(
        isClaimed: json["is_claimed"],
        isUsed: json["is_used"],
        isSelected: json["is_selected"],
      );

  Map<String, dynamic> toJson() => {
        "is_claimed": isClaimed,
        "is_used": isUsed,
        "is_selected": isSelected,
      };
}
