import 'dart:async';
import 'dart:io';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/models/authen/b2cregis.model.dart';
import 'package:fridayonline/member/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/utils/image_preloader.dart';
import 'package:fridayonline/member/views/(anonymous)/otp.verify.dart';
import 'package:fridayonline/member/views/(anonymous)/register.dart';
import 'package:fridayonline/member/views/(other)/instructions.dart';
import 'package:fridayonline/splashscreen.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/service/validators.dart';
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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.redirect});
  final String? redirect;

  @override
  _SignInScreen createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final EndUserSignInCtr endUserSignInCtr = Get.put(EndUserSignInCtr());

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
      loginAndRegister(user.userIdentifier ?? "", user.givenName ?? "", "",
          user.email ?? "", 'apple', "");
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
    super.build(context);
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;
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
                    textStyle: GoogleFonts.ibmPlexSansThai()))),
        child: SafeAreaProvider(
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
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
                          // child: Image.asset(
                          //   'assets/images/login/login_bg.png',
                          //   width: screenWidth,
                          //   height: screenHeight * 0.3,
                          //   fit: BoxFit.cover,
                          // ),
                          child: PreloadedImageWidget(
                            width: Get.width,
                            height: screenHeight * 0.3,
                            assetPath: 'assets/images/login/login_bg.png',
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
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                // Image.asset(
                                //   'assets/images/b2c/logo/f_fair2.png',
                                //   width: 200,
                                // ),
                                const PreloadedImageWidget(
                                  width: 200,
                                  assetPath:
                                      'assets/images/b2c/logo/f_fridayonline.png',
                                ),
                                const SizedBox(
                                  height: 8,
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
                                              color: Colors.white,
                                              fontSize: 13),
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
                                //   'ฟรายเดย์ ออนไลช้อปปิ้ง',
                                //   style: GoogleFonts.ibmPlexSansThai(
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.w500),
                                // ),
                                const SizedBox(
                                  height: 24,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: isTablet ? 600.0 : 400.0,
                                      maxHeight: isTablet ? 500.0 : 620.0),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300
                                                .withOpacity(0.5),
                                            offset: const Offset(0, 6),
                                            blurRadius: 4,
                                            // spreadRadius: 1,
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(18)),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                              width: Get.width,
                                              child: Text('เข้าสู่ระบบ',
                                                  style: GoogleFonts
                                                      .ibmPlexSansThai(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                            ),
                                            const Center(
                                                // child: Text(
                                                //   'สั่งซื้อสินค้า',
                                                //   style: TextStyle(
                                                //     color: Colors.black,
                                                //     fontSize: 16,
                                                //   ),
                                                // ),
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
                                                        BorderRadius.circular(
                                                            8)),
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
                                                keyboardType:
                                                    TextInputType.phone,
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    backgroundColor:
                                                        themeColorDefault,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                    'เข้าสู่ระบบ',
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
                                                const Expanded(
                                                    child: Divider()),
                                                const Text(
                                                  'หรือ',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ).marginSymmetric(
                                                    horizontal: 8),
                                                const Expanded(
                                                    child: Divider()),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                        // child: Image.asset(
                                                        //   'assets/images/login/google-login.png',
                                                        //   width: 24,
                                                        // ),
                                                        child:
                                                            const PreloadedImageWidget(
                                                          width: 24,
                                                          height: 24,
                                                          assetPath:
                                                              'assets/images/login/google-login.png',
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
                                                        // child: Image.asset(
                                                        //   'assets/images/login/facebook-login.png',
                                                        //   width: 24,
                                                        // ),
                                                        child:
                                                            const PreloadedImageWidget(
                                                          width: 24,
                                                          height: 24,
                                                          assetPath:
                                                              'assets/images/login/facebook-login.png',
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
                                                          // child: Image.asset(
                                                          //   'assets/images/login/apple.png',
                                                          //   width: 24,
                                                          // ),
                                                          child:
                                                              const PreloadedImageWidget(
                                                            width: 24,
                                                            height: 24,
                                                            assetPath:
                                                                'assets/images/login/apple.png',
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
                                                        // child: Image.asset(
                                                        //   'assets/images/login/line_icon.png',
                                                        //   width: 24,
                                                        // ),
                                                        child:
                                                            const PreloadedImageWidget(
                                                          width: 24,
                                                          height: 24,
                                                          assetPath:
                                                              'assets/images/login/line_icon.png',
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                    'ยังไม่มีบัญชีผู้ใช้ ?',
                                                    style: TextStyle(
                                                        fontSize: 13)),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    Get.to(() => RegisterScreen(
                                                          redirect:
                                                              widget.redirect,
                                                        ));
                                                  },
                                                  child: Text(
                                                    'ลงทะเบียน',
                                                    style: TextStyle(
                                                        color:
                                                            themeColorDefault,
                                                        fontSize: 13),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 18,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(
                                                    () => const Instructions());
                                              },
                                              child: Center(
                                                child: Text(
                                                  'นโยบายความเป็นส่วนตัว',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 11),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 80,
                                            ),
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
                  // Positioned(
                  //     bottom: 0,
                  //     left: 0,
                  //     right: 0,
                  //     child: Container(
                  //       // height: 184,
                  //       clipBehavior: Clip.antiAlias,
                  //       decoration: const BoxDecoration(
                  //           gradient: LinearGradient(
                  //               begin: Alignment.topLeft,
                  //               end: Alignment.bottomRight,
                  //               colors: [Color(0xFF0588CD), Color(0xff4FBBF3)]),
                  //           borderRadius: BorderRadius.only(
                  //               topLeft: Radius.circular(16),
                  //               topRight: Radius.circular(16))),
                  //       child: Column(
                  //         children: [
                  //           SizedBox(
                  //             height: (isTablet ? 40 : 18).toDouble(),
                  //           ),
                  //           Text(
                  //             'สมาชิกFriday Online',
                  //             style: GoogleFonts.ibmPlexSansThai(
                  //                 fontWeight: FontWeight.w600,
                  //                 fontSize: 18,
                  //                 color: Colors.white),
                  //           ),
                  //           Text(
                  //             'สำหรับสมาชิก และลูกค้าของสมาชิกFriday Online',
                  //             style: GoogleFonts.ibmPlexSansThai(
                  //                 fontSize: 14, color: Colors.white),
                  //           ),
                  //           SizedBox(
                  //             height: (isTablet ? 40 : 18).toDouble(),
                  //           ),
                  //           Container(
                  //             width: 74,
                  //             height: 6,
                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(8)),
                  //           ),
                  //           SizedBox(
                  //             height: (isTablet ? 40 : 18).toDouble(),
                  //           ),
                  //           InkWell(
                  //             splashColor: Colors.transparent,
                  //             highlightColor: Colors.transparent,
                  //             onTap: () {
                  //               Get.toNamed('/login');
                  //             },
                  //             child: Container(
                  //               width: Get.width,
                  //               margin: const EdgeInsets.symmetric(
                  //                   horizontal: 20, vertical: 8),
                  //               padding:
                  //                   const EdgeInsets.symmetric(vertical: 8),
                  //               decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                       color: Colors.white, width: 1),
                  //                   borderRadius: BorderRadius.circular(10)),
                  //               child: Center(
                  //                 child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Text('เข้าสู่ระบบสมาชิกFriday Online',
                  //                         style: GoogleFonts.ibmPlexSansThai(
                  //                             color: Colors.white,
                  //                             fontSize: 16,
                  //                             fontWeight: FontWeight.w500)),
                  //                     const SizedBox(
                  //                       width: 8,
                  //                     ),
                  //                     SvgPicture.asset(
                  //                       'assets/svg/signIn.svg',
                  //                       width: 24,
                  //                       height: 24,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             height: (isTablet ? 40 : 18),
                  //           ),
                  //         ],
                  //       ),
                  //     )),
                ],
              ),
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
      // เริ่มการล็อกอิน
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

Widget blockBorder(children) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.grey.shade400, width: 0.4)),
      child: Row(
        children: children,
      ));
}

InputDecoration textFieldstyle(String e) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
