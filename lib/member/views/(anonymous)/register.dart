import 'dart:async';
import 'dart:io';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/models/authen/b2cregis.model.dart';
import 'package:fridayonline/member/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(anonymous)/otp.verify.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/member/views/(other)/instructions.dart';
import 'package:fridayonline/splashscreen.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'
    as facebook_auth;
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final EndUserSignInCtr endUserSignInCtr = Get.put(EndUserSignInCtr());

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.redirect});
  final String? redirect;

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
  final FacebookSignInProvider _facebookSignInProvider =
      FacebookSignInProvider();
  final AppleSigninProvider _appleSignInProvider = AppleSigninProvider();

  GoogleSignInAccount? _currentUser;

  final _formkey = GlobalKey<FormState>();
  final telController = TextEditingController();
  final otpController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _googleSignInProvider.initialize();
    lineSDKInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void lineSDKInit() async {
    await LineSDK.instance.setup("2007999835").then((_) {});
  }

  void loginAndRegister(
      userId, displayName, image, email, type, accessToken) async {
    final SharedPreferences prefs = await _prefs;
    String deepLinkSource = prefs.getString("deepLinkSource") ?? '';
    String deepLinkId = prefs.getString("deepLinkId") ?? '';
    SetData data = SetData();
    var payload = B2CRegister(
        otpCode: "",
        otpRef: "",
        registerId: userId ?? "",
        registerType: type ?? "",
        moblie: '',
        email: email ?? "",
        prefix: '',
        firstName: '',
        lastName: '',
        displayName: displayName ?? "",
        image: image,
        referringBrowser: deepLinkSource,
        referringId: deepLinkId,
        gender: '',
        birthDate: '',
        address: Address(
            firstName: '',
            lastName: '',
            address1: '',
            address2: '',
            tombonId: 0,
            amphurId: 0,
            provinceId: 0,
            postCode: '',
            mobile: ''),
        tokenApp: await data.tokenId,
        device: await data.device,
        sessionId: await data.sessionId,
        identityId: await data.deviceId,
        accessToken: accessToken);
    var res = await b2cRegisterService(payload);
    if (res!.code == "100") {
      prefs.remove("deepLinkSource");
      prefs.remove("deepLinkId");
      await prefs.setString("accessToken", res.data.accessToken);
      await prefs.setString("refreshToken", res.data.refreshToken);
      endUserSignInCtr.settingPreference('1', '', '5', res.data.custId,
          redirect: widget.redirect);
      Get.offAll(() => SplashScreen(redirect: widget.redirect));
    } else {
      if (!Get.isSnackbarOpen) {
        Get.snackbar('', '',
            titleText: Text('แจ้งเตือน',
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
            messageText: Text(res.message,
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
      return;
    }
  }

  Future<void> loginLine() async {
    try {
      final result = await LineSDK.instance.login(scopes: ["profile"]);
      loginAndRegister(
          result.userProfile?.userId,
          result.userProfile?.displayName,
          result.userProfile?.pictureUrl,
          "",
          "line",
          result.accessToken.value);
    } on PlatformException {
      if (!Get.isSnackbarOpen) {
        Get.snackbar('', '',
            titleText: Text('แจ้งเตือน',
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
            messageText: Text(
                "ขออภัย เกิดข้อผิดพลาดกรุณากด 'อนุญาต' เพื่อเข้าใช้งาน",
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
      return;
    }
  }

  Future<void> loginFacebook() async {
    try {
      final user = await _facebookSignInProvider.signInWithFacebook();
      if (user != null) {
        loginAndRegister(
            user['id'],
            user['name'],
            user['picture']['data']['url'],
            user['email'],
            "facebook",
            user['accessToken']);
      } else {
        if (!Get.isSnackbarOpen) {
          Get.snackbar('', '',
              titleText: Text('แจ้งเตือน',
                  style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
              messageText: Text(
                  "ขออภัย เกิดข้อผิดพลาดกรุณากด 'อนุญาต' เพื่อเข้าใช้งาน",
                  style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
              duration: const Duration(seconds: 2));
        }
        return;
      }
    } on PlatformException {
      if (!Get.isSnackbarOpen) {
        Get.snackbar('', '',
            titleText: Text('แจ้งเตือน',
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
            messageText: Text(
                "ขออภัย เกิดข้อผิดพลาดกรุณากด 'อนุญาต' เพื่อเข้าใช้งาน",
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
      return;
    }
  }

  Future<void> loginGoogle() async {
    loadingProductStock(context);
    final user = await _googleSignInProvider.signIn();
    Get.back();
    if (user == null) {
      return;
    }
    try {
      final GoogleSignInAuthentication auth = user.authentication;
      final String? accessToken = auth.idToken;
      print('Access Token: $accessToken');

      loginAndRegister(user.id, user.displayName, user.photoUrl, user.email,
          'google', accessToken);
    } on Exception catch (_) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar('', '',
            messageText: Text('เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง',
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
      return;
    }
  }

  Future<void> loginApple() async {
    loadingProductStock(context);
    final user = await _appleSignInProvider.signInApple();
    Get.back();
    if (user == null) {
      return;
    }
    try {
      loginAndRegister(
        user.userIdentifier ?? "",
        user.givenName ?? "",
        "",
        user.email ?? "",
        'apple',
        user.identityToken ?? "",
      );
    } on Exception catch (_) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar('', '',
            messageText: Text('เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง',
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white)),
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
      return;
    }
  }

  Future<void> loginPhone(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      if (telController.text.length < 12) {
        if (!Get.isSnackbarOpen) {
          Get.snackbar('', '',
              titleText: Text(
                'แจ้งเตือน',
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white),
              ),
              messageText: Text(
                'กรุณาระบุเบอร์โทรศัพท์ให้ครบ 10 หลัก',
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white),
              ),
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white);
        }
      } else {
        loadingProductStock(context);
        endUserSignInCtr.telNumber.value =
            telController.text.replaceAll('-', '');
        await b2cSentOtpService("register", endUserSignInCtr.telNumber.value)
            .then((value) {
          Get.back();
          if (value!.code == "100") {
            endUserSignInCtr.otpRef.value = value.otpRef ?? '';
            telController.clear();
            endUserSignInCtr.resetTimer();
            endUserSignInCtr.startTimer();
            Get.to(() => OtpVerify(redirect: widget.redirect));
          } else {
            Get.snackbar(
              '',
              '',
              titleText: Text(
                'แจ้งเตือน',
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white),
              ),
              messageText: Text(
                'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
                style: GoogleFonts.ibmPlexSansThai(color: Colors.white),
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  textStyle: GoogleFonts.ibmPlexSansThai())),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: Get.height,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Stack(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(34, 145, 245, 1),
                                  Color.fromRGBO(46, 169, 225, 1)
                                ]),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        child: Image.asset(
                          'assets/images/login/login_bg.png',
                          width: Get.width,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: Get.width >= 768
                            ? EdgeInsets.symmetric(
                                horizontal: Get.width / 5, vertical: 100)
                            : EdgeInsets.zero,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 60,
                              ),
                              Image.asset(
                                'assets/images/b2c/logo/f_fridayonline.png',
                                width: 200,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const SizedBox(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Divider(color: Colors.white)),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        'Friday Online ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ),
                                    Expanded(
                                        child: Divider(color: Colors.white)),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              // Text(
                              //   'แอปช้อปปิ้งออนไลน์ ครบทุกไลฟ์สไตล์คนไทย',
                              //   style: GoogleFonts.ibmPlexSansThai(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.w500),
                              // ),
                              const SizedBox(
                                height: 24,
                              ),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxWidth: 400, maxHeight: 620),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300
                                              .withOpacity(0.5),
                                          offset: const Offset(0, 6),
                                          blurRadius: 4,
                                          // spreadRadius: 1,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(18)),
                                  child: Form(
                                    key: _formkey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                            width: Get.width,
                                            child: Text('ลงทะเบียน',
                                                style:
                                                    GoogleFonts.ibmPlexSansThai(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                          ),
                                          const Center(
                                            child: Text(
                                              'กรุณากรอกเบอร์โทรศัพท์เพื่อลงทะเบียน',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Container(
                                              width: 80,
                                              height: 6,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: themeColorDefault,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          const Text(
                                            'เบอร์โทรศัพท์',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          TextFormField(
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              style:
                                                  GoogleFonts.ibmPlexSansThai(
                                                      fontSize: 14),
                                              controller: telController,
                                              inputFormatters: [
                                                maskFormatterPhone
                                              ],
                                              keyboardType: TextInputType.phone,
                                              validator: Validators.required(
                                                  'กรุณาระบุเบอร์โทรศัพท์ของคุณ'),
                                              decoration: textFieldstyle(
                                                  'กรอกเบอร์โทรศัพท์ของคุณ')),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          SizedBox(
                                            height: 45,
                                            width: Get.width,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  elevation: 0,
                                                  backgroundColor:
                                                      themeColorDefault,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                ),
                                                onPressed:
                                                    telController.text.isEmpty
                                                        ? null
                                                        : () async {
                                                            await loginPhone(
                                                                context);
                                                          },
                                                child: Text(
                                                  'ลงทะเบียน',
                                                  style: GoogleFonts
                                                      .ibmPlexSansThai(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                )),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(child: Divider()),
                                              const Text(
                                                'หรือ',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ).marginSymmetric(horizontal: 8),
                                              const Expanded(child: Divider()),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: loginGoogle,
                                                  child: blockBorder([
                                                    SignInWithProvider(
                                                      fn: loginGoogle,
                                                      child: Image.asset(
                                                        'assets/images/login/google-login.png',
                                                        width: 24,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                InkWell(
                                                  onTap: loginFacebook,
                                                  child: blockBorder([
                                                    SignInWithProvider(
                                                      fn: loginFacebook,
                                                      child: Image.asset(
                                                        'assets/images/login/facebook-login.png',
                                                        width: 24,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                if (Platform.isIOS)
                                                  InkWell(
                                                    onTap: loginApple,
                                                    child: blockBorder([
                                                      SignInWithProvider(
                                                        fn: loginApple,
                                                        child: Image.asset(
                                                          'assets/images/login/apple.png',
                                                          width: 24,
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                if (Platform.isIOS)
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                InkWell(
                                                  onTap: loginLine,
                                                  child: blockBorder([
                                                    SignInWithProvider(
                                                      fn: loginLine,
                                                      child: Image.asset(
                                                        'assets/images/login/line_icon.png',
                                                        width: 24,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade500,
                                                        fontSize: 13),
                                                    text:
                                                        'โดยการเปิดบัญชี Friday Online ท่านรับทราบและตกลงตามเงื่อนไขการให้บริการและ ',
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'นโยบายความเป็นส่วนตัว',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade700,
                                                            fontSize: 13),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                Get.to(() =>
                                                                    const Instructions());
                                                              },
                                                      ),
                                                    ])),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          SizedBox(
                                            width: Get.width,
                                            height: 40,
                                            child: OutlinedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                style: OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: Colors
                                                            .grey.shade200),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    foregroundColor:
                                                        Colors.grey.shade700),
                                                child: Text(
                                                  'ย้อนกลับ',
                                                  style: GoogleFonts
                                                      .ibmPlexSansThai(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInWithProvider extends StatelessWidget {
  final Future<void> Function() fn;
  final Widget child;
  const SignInWithProvider({super.key, required this.fn, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          fn();
        },
        child: child);
  }
}

class GoogleSignInProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  GoogleSignInAccount? _currentUser;

  // Stream สำหรับ listen การเปลี่ยนแปลง user state
  GoogleSignInAccount? get currentUser => _currentUser;

  Future<void> initialize() async {
    try {
      // Initialize Google Sign-In (clientId และ serverClientId จะอ่านจาก config files อัตโนมัติ)
      await _googleSignIn.initialize();

      // Listen authentication events
      _googleSignIn.authenticationEvents.listen(_handleAuthEvent);
    } catch (e) {
      print('Google Sign-In Initialize Error: $e');
    }
  }

  void _handleAuthEvent(GoogleSignInAuthenticationEvent event) {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    _currentUser = user;
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      await _googleSignIn.authenticate();
      await Future.delayed(Duration(milliseconds: 100));
      return _currentUser;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn
          .disconnect(); // หรือใช้ signOut() ถ้าไม่ต้องการ disconnect
    } catch (e) {
      print('Google Sign-Out Error: $e');
    }
  }
}

class FacebookSignInProvider {
  final facebook_auth.FacebookAuth _facebookAuth =
      facebook_auth.FacebookAuth.instance;

  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      final facebook_auth.LoginResult result = await _facebookAuth.login();
      if (result.status == facebook_auth.LoginStatus.success) {
        final userData = await _facebookAuth.getUserData();
        final facebook_auth.AccessToken? accessToken = result.accessToken;

        userData['accessToken'] = accessToken?.tokenString;

        return userData;
      }
    } catch (error) {
      print('เกิดข้อผิดพลาด: $error');
    }
    return null;
  }

  Future<void> signOut() async {
    await _facebookAuth.logOut();
  }
}

class AppleSigninProvider {
  Future<AuthorizationCredentialAppleID?> signInApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return credential;
    } on Exception catch (_) {
      return null;
    }
  }
}

InputDecoration textFieldstyle(String e) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 0.5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 0.5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 0.5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    isCollapsed: false,
    filled: true,
    fillColor: Colors.white,
    hintText: e,
    hintStyle: GoogleFonts.ibmPlexSansThai(fontSize: 14),
  );
}
