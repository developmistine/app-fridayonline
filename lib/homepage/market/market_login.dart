// import 'dart:developer';

// import 'package:fridayonline/homepage/login/apple_login_page.dart';
import 'package:fridayonline/homepage/login/facebook_login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import '../../controller/market/market_loadmore_controller.dart';
import '../../model/market/market_retun_login.dart';
// import '../../model/set_data/set_data.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/market/market_service.dart';
// import '../login/line_login_page.dart';
import '../theme/theme_color.dart';
import 'market_main.dart';

class MarketLogin extends StatefulWidget {
  const MarketLogin({super.key});

  @override
  State<MarketLogin> createState() => _MarketLoginState();
}

class _MarketLoginState extends State<MarketLogin> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var mdevice = Get.parameters['mdevice'];

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    print(mdevice);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            color: Colors.white,
            onPressed: () {
              //Get.find<MarketLoadmoreController>().resetItem();
              // Navigator.pop(context);
              Get.toNamed(
                '/market',
              );
            },
          ),
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: Text(
            MultiLanguages.of(context)!.translate('bt_register'),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'notoreg',
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 30),
            child: Center(
              child: Text(
                "ลงทะเบียนหรือเข้าสู่ระบบด้วย",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 10, bottom: 10, right: 40, left: 40),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                backgroundColor:
                    WidgetStateProperty.all(const Color.fromRGBO(0, 185, 0, 1)),
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const LineLoginPage(),
                //     ));
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/login/line_icon.png',
                          width: 45,
                          height: 45,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                            child: Text("ลงทะเบียนด้วย LINE",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 10, bottom: 10, right: 40, left: 40),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                backgroundColor: WidgetStateProperty.all(theme_color_facbook),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FacebookLoginPage(),
                    ));
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/login/facebook_icon.png',
                          width: 45,
                          height: 45,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                            child: Text("ลงทะเบียนด้วย Facebook",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (mdevice == "ios")
            Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 40, left: 40),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                ),
                onPressed: signInApple,
                // onPressed: () {
                //   signInApple;
                //   // Navigator.push(
                //   //     context,
                //   //     MaterialPageRoute(
                //   //       builder: (context) => const AppleLoginPage(),
                //   //     ));
                // },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/images/login/apple_icon.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                        const Expanded(
                          child: Center(
                              child: Text("ลงทะเบียนด้วย Apple",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ]));
  }

  void showDialogBox(String s, String t) {}

  // Appple ID
  Future<void> signInApple() async {
    final SharedPreferences prefs = await _prefs;
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential.email);
    print(credential.userIdentifier);
    print(credential.identityToken);
    print(credential.familyName);
    print(credential.givenName);
    var userappleid = credential.userIdentifier;
    var familyname = credential.familyName ?? "name_market";
    var profileNull = credential.familyName ?? 'profile_null';

    MarketRetunLogin dataLoginRetun = await MarketLoginSystemsCall();

    if (dataLoginRetun.code == "100") {
      prefs.setString("login_market", '1');
      prefs.setString("Chanelsignin", 'Apple');
      prefs.setString("CustomerID", dataLoginRetun.userId);
      prefs.setString("AccessToken", userappleid!);
      prefs.setString("AccessID", userappleid);
      prefs.setString("Name", familyname);
      prefs.setString("ProfileImg", profileNull);
      prefs.setString("UserTypeMarket", dataLoginRetun.userType);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MarketMainPage()));
    } else {}
  }
}
