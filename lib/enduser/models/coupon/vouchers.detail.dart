// To parse this JSON data, do
//
//     final voucherDetail = voucherDetailFromJson(jsonString);

import 'dart:convert';

VoucherDetail voucherDetailFromJson(String str) =>
    VoucherDetail.fromJson(json.decode(str));

String voucherDetailToJson(VoucherDetail data) => json.encode(data.toJson());

class VoucherDetail {
  String code;
  Data data;
  String message;

  VoucherDetail({
    required this.code,
    required this.data,
    required this.message,
  });

  factory VoucherDetail.fromJson(Map<String, dynamic> json) => VoucherDetail(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
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
  List<UsageTerm> usageTerm;

  Data({
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
    required this.usageTerm,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        usageTerm: List<UsageTerm>.from(
            json["usage_term"].map((x) => UsageTerm.fromJson(x))),
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
        "usage_term": List<dynamic>.from(usageTerm.map((x) => x.toJson())),
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

class UsageTerm {
  String key;
  List<String> value;

  UsageTerm({
    required this.key,
    required this.value,
  });

  factory UsageTerm.fromJson(Map<String, dynamic> json) => UsageTerm(
        key: json["key"],
        value: List<String>.from(json["value"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": List<dynamic>.from(value.map((x) => x)),
      };
}

class UserStatus {
  bool isClaimed;
  bool isUsed;

  UserStatus({
    required this.isClaimed,
    required this.isUsed,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) => UserStatus(
        isClaimed: json["is_claimed"],
        isUsed: json["is_used"],
      );

  Map<String, dynamic> toJson() => {
        "is_claimed": isClaimed,
        "is_used": isUsed,
      };
}
