import 'package:shared_preferences/shared_preferences.dart';

class SetData {
  Future<String> repCode = setRepCode();
  Future<String> repSeq = setRepSeq();
  Future<String> repType = setRepType();
  Future<String> repName = setRepName();
  Future<String> repTel = setRepTel();
  Future<String> tokenId = setTokenId();
  Future<String> deviceId = setDeviceId();
  Future<String> language = setLanguage();
  Future<String> device = setDevice();
  Future<String> enduserId = setEnduserId();
  Future<String> loginStatus = setLoginStatus();
  // Future<String> imei = setImei();
  Future<String> deviceNameMobile = setDeviceNameMobile();
  Future<String> tokenChat = setTokenChat();

  //market
  Future<String> customerId = setCustID();
  Future<String> loginMarket = setLoginMarket();
  Future<String> chanelSignin = setChanelsignin();
  Future<String> accessToken = setAccessToken();
  Future<String> refreshToken = setRefreshToken();
  Future<String> accessId = setAccessId();
  Future<String> displayname = setDisplayname();
  Future<String> profileImg = setProfileImg();
  Future<String> userTypeMarket = setuserTypeMarket();
  //cart
  Future<String> nameEndUsers = setEnduserName();
  Future<String> surNameEndUsers = setEndUserSur();
  Future<String> telEndUsers = setEndUserTel();

  // b2c
  Future<String> b2cUserMobile = getMobileB2C();
  Future<int> b2cCustID = getCustId();
  Future<String> sessionId = setSessionId();
  Future<String> lastActiveTime = loadlastActiveTime();
  Future<String> firstSwipe = loadFirstSwipe();

  // srisawad
  Future<String> refferId = getRefferSrisawad();
}

Future<String> setRepCode() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String repCode = '';
  if (prefs.getString("login").toString() == '1') {
    repCode = prefs.getString("RepCode").toString();
  } else {
    repCode = '';
  }
  return repCode;
}

Future<String> setRepSeq() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String repSeq = '';
  if (prefs.getString("login").toString() == '1') {
    repSeq = prefs.getString("RepSeq").toString();
  } else {
    repSeq = '';
  }
  return repSeq;
}

Future<String> setRepType() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String repType = '';
  if (prefs.getString("login").toString() == '1') {
    repType = prefs.getString("UserType").toString();
  } else {
    repType = '0';
  }
  return repType;
}

Future<String> setTokenId() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String tokenId = '';
  tokenId = prefs.getString("Token").toString();
  return tokenId;
}

Future<String> setDeviceId() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String deviceId = '';
  deviceId = prefs.getString("deviceId").toString();
  return deviceId;
}

Future<String> setLanguage() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String language = prefs.getString("localeKey") ?? 'th'.toString();
  return language;
}

Future<String> setDevice() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String device = prefs.getString("deviceName").toString();
  return device;
}

Future<String> setEnduserId() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String enduserId = '';
  enduserId = prefs.getString("EndUserID").toString();
  return enduserId;
}

Future<String> setLoginStatus() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String loginStatus = '';
  loginStatus = prefs.getString("login").toString();
  return loginStatus;
}

Future<String> setCustID() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String custId = '';
  if (prefs.getString("loginMarket").toString() == '1') {
    custId = prefs.getString("CustomerID").toString();
  } else {
    custId = '';
  }
  return custId;
}

Future<String> setLoginMarket() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String loginMarket = prefs.getString("loginMarket").toString();
  return loginMarket;
}

Future<String> setChanelsignin() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String chanelSignIn = prefs.getString("chanelSignIn").toString();
  return chanelSignIn;
}

Future<String> setAccessToken() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String accessToken = prefs.getString("accessToken").toString();
  return accessToken;
}

Future<String> setRefreshToken() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String refreshToken = prefs.getString("refreshToken").toString();
  return refreshToken;
}

Future<String> setAccessId() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String accessId = prefs.getString("accessId").toString();
  return accessId;
}

Future<String> setDisplayname() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String displayname = prefs.getString("Name").toString();
  return displayname;
}

Future<String> setProfileImg() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String profileImg = prefs.getString("profileImg").toString();
  return profileImg;
}

Future<String> setuserTypeMarket() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String userTypeMarket = prefs.getString("userTypeMarket").toString();
  return userTypeMarket;
}

// Future<String> setImei() async {
//   final Future<SharedPreferences> pref = SharedPreferences.getInstance();
//   final SharedPreferences prefs = await pref;
//   String mIMEI = prefs.getString("IMEI").toString();
//   return mIMEI;
// }

Future<String> setEnduserName() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String enduserName = prefs.getString("EnduserName").toString();
  return enduserName;
}

Future<String> setEndUserSur() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String enduserName = prefs.getString("Endusersurname").toString();
  return enduserName;
}

Future<String> setEndUserTel() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String telEndUsers = prefs.getString("EnduserTel").toString();
  return telEndUsers;
}

Future<String> getMobileB2C() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String b2cMobile = prefs.getString("B2cMobile").toString();
  return b2cMobile;
}

Future<int> getCustId() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  int b2cCustId = prefs.getInt("B2cCustId") ?? 0;
  return b2cCustId;
}

Future<String> setRepName() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String repName = prefs.getString("RepName").toString();
  return repName;
}

Future<String> setRepTel() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String repTel = prefs.getString("RepTel").toString();
  return repTel;
}

Future<String> setDeviceNameMobile() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String deviceNameMobile = prefs.getString("deviceNameMobile").toString();
  return deviceNameMobile;
}

Future<String> setTokenChat() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String token = prefs.getString("tokenChat").toString();
  return token;
}

Future<String> setSessionId() async {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  String sessionId = prefs.getString("sessionId").toString();
  return sessionId;
}

Future<String> loadlastActiveTime() async {
  final prefs = await SharedPreferences.getInstance();
  final savedTime = prefs.getString('lastActiveTime') ?? "";
  return savedTime;
}

Future<String> loadFirstSwipe() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('firstSwipe') ?? "";
}

Future<String> getRefferSrisawad() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('refferSrisawad') ?? "";
}
