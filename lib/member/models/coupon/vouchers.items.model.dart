// To parse this JSON data, do
//
//     final vouchersitems = vouchersitemsFromJson(jsonString);

import 'dart:convert';

Vouchersitems vouchersitemsFromJson(String str) =>
    Vouchersitems.fromJson(json.decode(str));

String vouchersitemsToJson(Vouchersitems data) => json.encode(data.toJson());

class Vouchersitems {
  String code;
  Data data;
  String message;

  Vouchersitems({
    required this.code,
    required this.data,
    required this.message,
  });

  factory Vouchersitems.fromJson(Map<String, dynamic> json) => Vouchersitems(
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
  String groupName;
  String image;
  List<VoucherType> voucherType;

  Data({
    required this.groupName,
    required this.image,
    required this.voucherType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        groupName: json["group_name"],
        image: json["image"],
        voucherType: List<VoucherType>.from(
            json["voucher_type"].map((x) => VoucherType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "group_name": groupName,
        "image": image,
        "voucher_type": List<dynamic>.from(voucherType.map((x) => x.toJson())),
      };
}

class VoucherType {
  int groupType;
  String groupTypeText;
  List<Voucher> vouchers;
  int totalCount;

  VoucherType({
    required this.groupType,
    required this.groupTypeText,
    required this.vouchers,
    required this.totalCount,
  });

  factory VoucherType.fromJson(Map<String, dynamic> json) => VoucherType(
        groupType: json["group_type"],
        groupTypeText: json["group_type_text"],
        vouchers: List<Voucher>.from(
            json["vouchers"].map((x) => Voucher.fromJson(x))),
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "group_type": groupType,
        "group_type_text": groupTypeText,
        "vouchers": List<dynamic>.from(vouchers.map((x) => x.toJson())),
        "total_count": totalCount,
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
  String timeFormat;
  String endTime;
  String claimStartTime;
  String claimEndTime;
  int validDays;
  bool hasExpired;

  TimeInfo({
    required this.startTime,
    required this.timeFormat,
    required this.endTime,
    required this.claimStartTime,
    required this.claimEndTime,
    required this.validDays,
    required this.hasExpired,
  });

  factory TimeInfo.fromJson(Map<String, dynamic> json) => TimeInfo(
        startTime: json["start_time"],
        timeFormat: json["time_format"],
        endTime: json["end_time"],
        claimStartTime: json["claim_start_time"],
        claimEndTime: json["claim_end_time"],
        validDays: json["valid_days"],
        hasExpired: json["has_expired"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "time_format": timeFormat,
        "end_time": endTime,
        "claim_start_time": claimStartTime,
        "claim_end_time": claimEndTime,
        "valid_days": validDays,
        "has_expired": hasExpired,
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
