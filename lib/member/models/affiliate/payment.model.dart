// To parse this JSON data, do
//
//     final paymentInfo = paymentInfoFromJson(jsonString);

import 'dart:convert';

PaymentInfo paymentInfoFromJson(String str) =>
    PaymentInfo.fromJson(json.decode(str));

String paymentInfoToJson(PaymentInfo data) => json.encode(data.toJson());

class PaymentInfo {
  String code;
  Data data;
  String message;

  PaymentInfo({
    required this.code,
    required this.data,
    required this.message,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
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
  String statusCode;
  String statusMessage;
  String description;
  AccountInfo accountInfo;
  BankInfo bankInfo;
  TaxInfo taxInfo;

  Data({
    required this.statusCode,
    required this.statusMessage,
    required this.description,
    required this.accountInfo,
    required this.bankInfo,
    required this.taxInfo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        description: json["description"],
        accountInfo: AccountInfo.fromJson(json["account_info"]),
        bankInfo: BankInfo.fromJson(json["bank_info"]),
        taxInfo: TaxInfo.fromJson(json["tax_info"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "description": description,
        "account_info": accountInfo.toJson(),
        "bank_info": bankInfo.toJson(),
        "tax_info": taxInfo.toJson(),
      };
}

class AccountInfo {
  String accountType;
  int prenameId;
  String prename;
  String firstName;
  String lastName;
  String phone;
  String address1;
  String address2;
  int tumbonId;
  String tumbon;
  int amphurId;
  String amphur;
  int provinceId;
  String province;
  String postCode;

  AccountInfo({
    required this.accountType,
    required this.prenameId,
    required this.prename,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address1,
    required this.address2,
    required this.tumbonId,
    required this.tumbon,
    required this.amphurId,
    required this.amphur,
    required this.provinceId,
    required this.province,
    required this.postCode,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) => AccountInfo(
        accountType: json["account_type"],
        prenameId: json["prename_id"],
        prename: json["prename"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        address1: json["address1"],
        address2: json["address2"],
        tumbonId: json["tumbon_id"],
        tumbon: json["tumbon"],
        amphurId: json["amphur_id"],
        amphur: json["amphur"],
        provinceId: json["province_id"],
        province: json["province"],
        postCode: json["post_code"],
      );

  Map<String, dynamic> toJson() => {
        "account_type": accountType,
        "prename_id": prenameId,
        "prename": prename,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "address1": address1,
        "address2": address2,
        "tumbon_id": tumbonId,
        "tumbon": tumbon,
        "amphur_id": amphurId,
        "amphur": amphur,
        "province_id": provinceId,
        "province": province,
        "post_code": postCode,
      };
}

class BankInfo {
  int bankId;
  String bank;
  String bankBranchAddress;
  String bankAccountNumber;
  String bankAccountName;
  String bankBookImage;

  BankInfo({
    required this.bankId,
    required this.bank,
    required this.bankBranchAddress,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.bankBookImage,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) => BankInfo(
        bankId: json["bank_id"],
        bank: json["bank"],
        bankBranchAddress: json["bank_branch_address"],
        bankAccountNumber: json["bank_account_number"],
        bankAccountName: json["bank_account_name"],
        bankBookImage: json["bank_book_image"],
      );

  Map<String, dynamic> toJson() => {
        "bank_id": bankId,
        "bank": bank,
        "bank_branch_address": bankBranchAddress,
        "bank_account_number": bankAccountNumber,
        "bank_account_name": bankAccountName,
        "bank_book_image": bankBookImage,
      };
}

class TaxInfo {
  String taxId;
  String idCardImage;

  TaxInfo({
    required this.taxId,
    required this.idCardImage,
  });

  factory TaxInfo.fromJson(Map<String, dynamic> json) => TaxInfo(
        taxId: json["tax_id"],
        idCardImage: json["id_card_image"],
      );

  Map<String, dynamic> toJson() => {
        "tax_id": taxId,
        "id_card_image": idCardImage,
      };
}
