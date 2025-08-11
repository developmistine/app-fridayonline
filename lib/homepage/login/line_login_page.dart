// // import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // import '../../model/market/market_login_systems.dart';
// import '../../model/market/market_retun_login.dart';
// import '../../service/market/market_service.dart';
// import '../market/market_main.dart';

// class LineLoginPage extends StatefulWidget {
//   const LineLoginPage({Key? key}) : super(key: key);

//   @override
//   State<LineLoginPage> createState() => _LineLoginPageState();
// }

// class _LineLoginPageState extends State<LineLoginPage> {
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//   @override
//   void initState() {
//     super.initState();
//     lineSDKInit();
//     getAccessToken();
//     startLineLogin();
//   }

//   void lineSDKInit() async {
//     await LineSDK.instance.setup("1653934842").then((_) {
//       print("LineSDK is Prepared");
//     });
//   }

//   void startLineLogin() async {
//     // เรียกใช้งาน SharedPreferences ที่เป็น future
//     final SharedPreferences prefs = await _prefs;
//     // ทำการ Get Data ออกมาทำการตรวจสอบก่อน

//     try {
//       final result = await LineSDK.instance.login(scopes: ["profile"]);
//       print(result.toString());
//       var accesstoken = await getAccessToken();
//       var displayname = result.userProfile?.displayName ?? '';
//       // var statusmessage = result.userProfile?.statusMessage ?? '';
//       var imgUrl = result.userProfile?.pictureUrl ?? 'profile_null';
//       var userId = result.userProfile?.userId ?? '';

//       prefs.setString("AccessToken", accesstoken);
//       prefs.setString("AccessID", userId);
//       prefs.setString("Chanelsignin", 'Line');
//       prefs.setString("ProfileImg", imgUrl);

//       // print("AccessToken> " + accesstoken);
//       // print("DisplayName> " + displayname);
//       // print("StatusMessage> " + statusmessage);
//       // print("ProfileURL> " + imgUrl);
//       // print("userId> " + userId);

//       // กรณีที่ทำการ Set Data

//       MarketRetunLogin dataLoginRetun = await MarketLoginSystemsCall();

//       if (dataLoginRetun.code == "100") {
//         prefs.setString("login_market", '1');
//         prefs.setString("CustomerID", dataLoginRetun.userId);
//         prefs.setString("Name", displayname);
//         prefs.setString("UserTypeMarket", dataLoginRetun.userType);

//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => MarketMainPage()));
//       } else {
//         prefs.remove("AccessToken");
//         prefs.remove("AccessID");
//         prefs.remove("Chanelsignin");
//         prefs.remove("ProfileImg");
//       }
//     } on PlatformException catch (e) {
//       print(e);
//       switch (e.code.toString()) {
//         case "CANCEL":
//           showDialogBox("คุณยกเลิกการเข้าสู่ระบบ",
//               "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
//           print("User Cancel the login");
//           break;
//         case "AUTHENTICATION_AGENT_ERROR":
//           showDialogBox("คุณไม่อนุญาติการเข้าสู่ระบบด้วย LINE",
//               "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
//           print("User decline the login");
//           break;
//         default:
//           showDialogBox("เกิดข้อผิดพลาด",
//               "เกิดข้อผิดพลาดไม่ทราบสาเหตุ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
//           print("Unknown but failed to login");
//           break;
//       }
//     }
//   }

//   Future getAccessToken() async {
//     try {
//       final result = await LineSDK.instance.currentAccessToken;
//       return result?.value;
//     } on PlatformException catch (e) {
//       print(e.message);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: (Container(
//       child: Text(''),
//     )));
//   }

//   void showDialogBox(String s, String t) {}
// }
