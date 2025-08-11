// ทำการประการ Class User ออกมาจากระบบ เพื่อที่จะให้ระบบทำงานตามปกติออกมา
class User {
  // ตัวแปรของ Class การทำงานของระบบ
  late String RepCode;
  late String Telnumber;
  late String Device;
  late String Token;
  late String OTP;
  // เป็น Function การทำงานของระบบ
  User(this.RepCode, this.Telnumber, this.Device, this.Token, this.OTP);
}

// ทำการประการ Class User ออกมาจากระบบ เพื่อที่จะให้ระบบทำงานตามปกติออกมา
class EndUserRegidter {
  // ตัวแปรของ Class การทำงานของระบบ
  late String enduserName;
  late String endusersurname;
  late String birthday;
  late String email;
  late String telnumber;
  late String flag;
  late String repCode;
  late String tokenOrder;
  late String imei;
  late String chanel;
  late String socialId;
  late String registrationId;
  late String userId;
  late String versionName;
  late String linkId;

  // เป็น Function การทำงานของระบบ
  EndUserRegidter(
      this.enduserName,
      this.endusersurname,
      this.birthday,
      this.email,
      this.telnumber,
      this.flag,
      this.repCode,
      this.tokenOrder,
      this.imei,
      this.chanel,
      this.socialId,
      this.registrationId,
      this.userId,
      this.versionName,
      this.linkId);
}
