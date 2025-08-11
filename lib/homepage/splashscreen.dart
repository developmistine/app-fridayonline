import 'dart:async';
import 'dart:io';

import 'package:fridayonline/enduser/utils/branch_manager_main.dart';
import 'package:fridayonline/enduser/utils/image_preloader.dart';
import 'package:flutter/services.dart';
// import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:fridayonline/controller/update_app_controller.dart';
import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
import 'package:fridayonline/enduser/enduser.main.dart';
import 'package:fridayonline/enduser/models/authen/b2cregis.model.dart';
import 'package:fridayonline/enduser/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/enduser/services/fair/fair.service.dart';
import 'package:fridayonline/homepage/globals_variable.dart';
import 'package:fridayonline/homepage/home/home_popup.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/srisawad/onboarding.dart';
// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/widget/error/error_page.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
// import 'package:fridayonline/pam/notification_api.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:huawei_push/huawei_push.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:uuid/uuid.dart';
import '../controller/app_controller.dart';
import '../controller/badger/badger_controller.dart';
import '../controller/cart/cart_controller.dart';
import '../controller/cart/dropship_controller.dart';
import '../controller/catelog/catelog_controller.dart';
import '../controller/flashsale/flash_controller.dart';
import '../controller/home/home_controller.dart';
import '../controller/notification/notification_controller.dart';
import '../controller/pro_filecontroller.dart';
import '../model/check_goldclub/check_goclub.dart';
import '../model/check_version/check_version_model.dart';
import '../model/register/mslregistermodel.dart';
import '../model/register/userlogin.dart';
import '../service/check_popup/popup_splash.dart';
import '../service/check_version/check_version_service.dart';
import '../service/languages/multi_languages.dart';
import '../service/logapp/interaction.dart';
import '../service/logapp/logapp_service.dart';
import '../service/register_service.dart';
import 'globals_variable.dart' as globals;
import 'package:pub_semver/pub_semver.dart' as semver;

// กรณีที่ทำการ Set ข้อมูล
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class AppChecker {
  static const MethodChannel _channel =
      MethodChannel('th.co.mistine.mistinecatalog/check_apps');

  static Future<bool> isAppInstalled(String packageName) async {
    try {
      final bool isInstalled = await _channel
          .invokeMethod('isAppInstalled', {"package": packageName});
      return isInstalled;
    } catch (e) {
      return false;
    }
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PopUpStatusController popup = Get.put(PopUpStatusController());
  final EndUserHomeCtr endUserHomeCtr = Get.find();

  // ทำการประกาศตัวแปลนั้น
  String statusLoadApp = '';
  String _deviceIMEINumber = '';
  String _versionApp = "";
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String _tokenApp = '';

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      globals.buildNumbers = _packageInfo.buildNumber;
      globals.versionApp = _packageInfo.version;
      _versionApp = globals.versionApp;
    });
  }

  //Set Session Id
  Future<void> setNewSessionId() async {
    const uuid = Uuid();
    uuid.v4();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("sessionId", uuid.v4());
  }

  Future<void> saveLastDragTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastActiveTime', time.toIso8601String());
  }

  Future<void> loadLastDragTime() async {
    SetData loadData = SetData();
    final currentTime = DateTime.now();

    var loadLastActiveTime = await loadData.lastActiveTime;
    if (loadLastActiveTime == "") {
      await saveLastDragTime(DateTime.now());
    }
    final difference =
        currentTime.difference(DateTime.parse(loadLastActiveTime));
    debugPrint(
        'splash screen user active ล่าสุด ${difference.inHours} ชั่วโมง ${difference.inMinutes} นาที ${difference.inSeconds} วินาที');
    if (difference.inHours >= 1) {
      setNewSessionId();
    }
  }

  //Get Device Details
  Future<void> _deviceDetails() async {
    final SharedPreferences prefs = await _prefs;
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = "${build.brand} ${build.model}";
          deviceVersion = build.version.toString();
          identifier = build.brand;
          prefs.setString("deviceNameMobile", deviceName);
        });
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = data.name;
          deviceVersion = data.systemVersion;
          identifier = data.identifierForVendor!;
          prefs.setString("deviceNameMobile", deviceName);
        });
      } else {
        deviceName = "No PlatForm";
        prefs.setString("deviceNameMobile", deviceName);
      }
      debugPrint(deviceName);
      debugPrint(deviceVersion);
      debugPrint(identifier);
    } on PlatformException {
      debugPrint('Failed to get platform version');
    }
  }

  @override
  void initState() {
    super.initState();
    checkNetworkConnection();
  }

  @override
  void dispose() {
    super.dispose();
    BranchManagerMain.disposePending();
  }

  checkGoldClub() async {
    Popupchecktypeg status = await callPopupSpashScreen();
    if (status.code != "100") {
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          elevation: 0,
          backgroundColor: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Image.asset(
                'assets/images/error/warning.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  status.message1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'notoreg', color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme_red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            onPressed: () {
                              Get.back(result: "0");
                            },
                            child: Text('ยกเลิก',
                                style: TextStyle(
                                    color: theme_red,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'notoreg')))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme_color_df,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            onPressed: () {
                              Get.back(result: "1");
                            },
                            child: const Text('ยืนยัน',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'notoreg'))))
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                height: 1,
              ),
            ],
          ),
        ),
      ).then((value) async {
        if (value == '0') {
          Get.dialog(
            barrierDismissible: false,
            Dialog(
              elevation: 0,
              backgroundColor: const Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  Image.asset(
                    'assets/images/error/cancle.png',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      status.message2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'notoreg', color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: Get.width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme_color_df,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            onPressed: () {
                              exit(0);
                            },
                            child: const Text('ปิด',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'notoreg'))),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),
            ),
          );
          return true;
        } else {
          final SharedPreferences prefs = await _prefs;
          prefs.remove("login");
          prefs.remove("RepSeq");
          prefs.remove("RepCode");
          prefs.remove("RepName");
          prefs.remove("UserType");

          Get.find<FetchCartItemsController>().fetch_cart_items();
          Get.find<FetchCartDropshipController>().fetchCartDropship();
          User user = User('', '', '', '', '');
          user.OTP = '';
          user.RepCode = status.repCodeNew;
          user.Device = Platform.isAndroid ? 'ANDROID' : 'IOS';
          user.Telnumber = status.mobileNo;
          user.Token = _tokenApp;
          Mslregist mslregist = await MslReGiaterAppliction(user);
          if (mslregist.value.success == '1') {
            settingsPreferences(
                mslregist.value.success.toString(),
                mslregist.value.repSeq.toString(),
                mslregist.value.repCode.toString(),
                mslregist.value.repName.toString(),
                "2");
          }
        }
      });
      return true;
    } else {
      return false;
    }
  }

  checkAppNewVersion() async {
    CheckVersionModel? checkversion = await call_check_version();

    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final isHuawei = androidInfo.manufacturer.toLowerCase() == "huawei";

      int androidNewVersion = int.parse(isHuawei
          ? checkversion!.version.huaweiVersion.versionCode
          : checkversion!.version.androidVersion.versionCode
              .replaceAll(RegExp(r'[^0-9]'), ''));
      int androidOldVersion =
          int.parse(_packageInfo.buildNumber.replaceAll(RegExp(r'[^0-9]'), ''));
      debugPrint('Android Old Version : $androidNewVersion');
      debugPrint('Android New Version : $androidOldVersion');
      //! > production , < dev
      if (androidNewVersion > androidOldVersion) {
        debugPrint('required update version');
        // เช็คว่า Play Store ติดตั้งอยู่หรือไม่ (ใช้ ?? false เพื่อป้องกัน null)
        final hasPlayStore = isHuawei
            ? (await AppChecker.isAppInstalled('com.android.vending'))
            : true;
        final versionInfo = hasPlayStore
            ? checkversion.version.androidVersion
            : checkversion.version.huaweiVersion;
        Get.find<UpdateAppController>().setStatusupdate(
            versionInfo.alertShowTitle,
            versionInfo.alertShowDetail,
            versionInfo.uriPlayStore);
      }
    } else {
      var iosNewVersion =
          semver.Version.parse(checkversion!.version.iosVersion.versionCode);
      var iosOldVersion = semver.Version.parse(_packageInfo.version);

      debugPrint('IOS Old Version : $iosNewVersion');
      debugPrint('IOS New Version : $iosOldVersion');
      //! > production , < dev
      if (iosNewVersion > iosOldVersion) {
        debugPrint('required update version');
        Get.find<UpdateAppController>().setStatusupdate(
            checkversion.version.iosVersion.alertShowTitle,
            checkversion.version.iosVersion.alertShowDetail,
            checkversion.version.iosVersion.uriItunes);
      }
    }
  }

  checkShowFair() async {
    bool isVisibility = await fetchFairVisibilityService();
    endUserHomeCtr.isVisibilityFair.value = isVisibility;
  }

  checkNetworkConnection() async {
    SetData data = SetData();
    printWhite("refresh token is : ${await data.refreshToken}");
    String repType = await data.repType;
    String sessionId = await data.sessionId;
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        initPlatformState();
        _initPackageInfo();
        _deviceDetails();
        await loadImageSignIn();
        await loadImageMenu();
        if (sessionId == "null" || sessionId == "") {
          await setNewSessionId();
        } else {
          loadLastDragTime();
        }
        bool isGoldClub = await checkGoldClub();
        if (isGoldClub) {
          return;
        }
        await checkAppNewVersion();
        // if (statusLoadApp == '1') {
        // กรณีที่่ login แล้ว
        if (await data.loginStatus == '1') {
          if (repType == '2' || repType == '1') {
            Get.find<NotificationController>().get_notification_data();
            Get.find<ProfileController>().get_profile_data();
            Get.find<ProfileSpecialProjectController>()
                .get_special_project_data();
            Get.find<DraggableFabController>().draggable_Fab();
            Get.find<BadgerController>().get_badger();
            Get.find<BadgerProfileController>().get_badger_profile();
            Get.find<BadgerController>().getBadgerMarket();
            Get.find<BannerController>().get_banner_data();
            Get.find<FavoriteController>().get_favorite_data();
            Get.find<SpecialPromotionController>().get_promotion_data();
            Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
            Get.find<CatelogController>().get_catelog();
            Get.find<HomePointController>().get_home_point_data(false);
            Get.find<HomeContentSpecialListController>()
                .get_home_content_data("");
            Get.find<KeyIconController>().get_keyIcon_data();
          }
        }

        var loginStatus = await data.loginStatus;
        var userType = await data.repType;
        var tranferDist = await call_check_transfer_dist();
        // print(' type user page home $userType');
        Get.find<PopUpStatusController>().changeStatusViewPopupTranfer(true);
        if (tranferDist!.flagTransfer.toLowerCase() == 'y' &&
            (loginStatus == "1") &&
            userType == '2' &&
            (popup.isViewPopupTranfer.value)) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (!mounted) {
              return;
            } else {
              showpopUptranfer(context, tranferDist);
            }
          });
        } else {
          if (!mounted) return;

          if (BranchManagerMain.pendingData != null) {
            if (BranchManagerMain.pendingData!['content_type'] ==
                'regis_srisawad') {
              // print('เข้า pending data');
              final SharedPreferences prefs = await _prefs;
              var reffer = BranchManagerMain.pendingData!['Ref'] ?? '';
              await prefs.setString("refferSrisawad", reffer);
              await loadImageOnboarding();
              await BranchManagerMain.disposePending();
              await Get.offAll(() => const OnBoarding());
              // print('pending data = : $reffer');
              return;
            } else if (BranchManagerMain.pendingData!['content_type'] !=
                'regis_srisawad') {
              await BranchManagerMain.handlePendingData(context);
              await BranchManagerMain.disposePending();
            }
          } else {
            await BranchManagerMain.disposePending();
          }
          SetData data = SetData();
          var refId = await data.refferId;
          if (refId != "") {
            await loadImageOnboarding();
            await Get.offAll(() => const OnBoarding());
            await BranchManagerMain.disposePending();
            return;
          }

          // กรณีที่่ login แล้วเป็น สมาชิก หรือ ลูกค้าสมาชิก
          if (repType == '2' || repType == '1') {
            await InteractionLogger.initialize(
                sessionId: sessionId,
                customerId: int.tryParse(await data.repSeq) ?? 0,
                customerCode: await data.repCode,
                customerType: repType,
                customerName: repType == '1'
                    ? await data.nameEndUsers
                    : await data.repName,
                channel: "app",
                deviceType: await data.device,
                deviceToken:
                    await data.tokenId == "null" ? "" : await data.tokenId);
            Get.offAll(() => MyHomePage());
          } else {
            // กรณีทีเป็น b2c
            var accToken = await data.accessToken;
            bool isGuest = (repType == '0' || repType == 'null');
            bool tokenInvalid = (accToken == "null" || accToken == "");

            if (isGuest) {
              if (accToken != "" && accToken != "null") {
                await checkShowFair();
                endUserHomeCtr.endUserGetAllHomePage();
                if (mounted) {
                  Get.offAll(() => EndUserHome(), routeName: "/EndUserHome");
                }
              } else {
                await handleGuestFlow();
              }
            } else if (tokenInvalid) {
              await handleGuestFlow();
            } else {
              await checkShowFair();
              endUserHomeCtr.endUserGetAllHomePage();
              if (mounted) {
                Get.offAll(() => EndUserHome(), routeName: "/EndUserHome");
              }
            }
          }
        }
      }
    } on SocketException catch (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ErrorPageFullPage()));
      });
    }
  }

  Future<void> handleGuestFlow() async {
    final SharedPreferences prefs = await _prefs;

    bool alreadyProcessed = prefs.getBool('branch_first_processed') ?? false;
    String? lastProcessedTimestamp =
        prefs.getString('last_processed_click_timestamp');
    await prefs.clear();
    // tokenId
    SetData data = SetData();
    String sessionId = await data.sessionId;
    if (sessionId == "null" || sessionId == "") {
      await setNewSessionId();
    }
    await _deviceDetails();
    await initPlatformState();
    prefs.setString(
        'last_processed_click_timestamp', lastProcessedTimestamp.toString());
    prefs.setBool('branch_first_processed', alreadyProcessed);

    var payload = B2CRegister(
      registerId: "",
      registerType: "guest",
      moblie: '',
      email: "",
      prefix: '',
      firstName: '',
      lastName: '',
      displayName: "",
      image: "",
      referringBrowser: '',
      referringId: '',
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
        mobile: '',
      ),
      tokenApp: await data.tokenId == "null" ? "" : await data.tokenId,
      device: await data.device,
      sessionId: await data.sessionId,
      identityId: await data.deviceId,
    );

    var res = await b2cRegisterService(payload);
    if (res != null) {
      await prefs.setString("accessToken", res.data.accessToken);
      await prefs.setString("refreshToken", res.data.refreshToken);
      String deviceId = await getDeviceId();
      await prefs.setString("deviceId", deviceId);
    }
    await checkShowFair();
    endUserHomeCtr.endUserGetAllHomePage();
    if (mounted) {
      Get.offAll(() => EndUserHome(), routeName: "/EndUserHome");
    }
  }

  // ตั้งค่าเริ่มต้น
  settingsPreferences(String lsSuccess, String lsRepSeq, String lsRepCode,
      String lsRepName, String lsTypeUser) async {
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;
    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน

    // กรณีที่ทำการ Set Data
    prefs.setString("login", lsSuccess);
    prefs.setString("RepSeq", lsRepSeq);
    prefs.setString("RepCode", lsRepCode);
    prefs.setString("RepName", lsRepName);
    prefs.setString("UserType", lsTypeUser);

    // String? lslogin1 = prefs.getString("login");

    Get.find<AppController>().setCurrentNavInget(0);
    Get.find<DraggableFabController>().draggable_Fab();
    Get.find<BannerController>().get_banner_data();
    Get.find<FavoriteController>().get_favorite_data();
    Get.find<SpecialPromotionController>().get_promotion_data();
    //Get.find<SpecialDiscountController>().fetch_special_discount();
    Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
    Get.find<ProductHotIutemLoadmoreController>().resetItem();
    Get.find<CatelogController>().get_catelog();
    Get.find<NotificationController>().get_notification_data();
    Get.find<ProfileController>().get_profile_data();
    Get.find<ProfileSpecialProjectController>().get_special_project_data();
    Get.find<FetchCartItemsController>().fetch_cart_items();
    Get.find<FetchCartDropshipController>().fetchCartDropship();
    Get.find<FlashsaleTimerCount>().flashSaleHome();
    Get.find<BadgerController>().get_badger();
    Get.find<BadgerProfileController>().get_badger_profile();
    Get.find<BadgerController>().getBadgerMarket();
    Get.find<PopUpStatusController>().ChangeStatusViewPopupFalse();
    Get.find<KeyIconController>().get_keyIcon_data();

    Get.find<HomePointController>().get_home_point_data(false);
    Get.find<HomeContentSpecialListController>().get_home_content_data("");
    Get.find<AppController>().setCurrentNavInget(4);
    Get.offAllNamed('/backAppbarnotify', parameters: {'changeView': '4'});
  }

  Future<void> initPlatformState() async {
    final SharedPreferences prefs = await _prefs;
    statusLoadApp = prefs.getString("StatusLoadApp").toString();

    String deviceId = await getDeviceId();
    prefs.setString("deviceId", deviceId);

    try {
      if (Platform.isAndroid) {
        await prefs.setString("deviceName", "android");
        await prefs.setString("IMEI", "");
      } else if (Platform.isIOS) {
        _deviceIMEINumber = await DeviceInformation.deviceIMEINumber;
        await prefs.setString("IMEI", _deviceIMEINumber);
        await prefs.setString("deviceName", "ios");
      }
    } on PlatformException {
      // deviceId = 'Failed to get platform version.';
    }

    LogAppEventCall("App_Open", "", "", "", "", "", "");
    try {
      await FirebaseMessaging.instance.requestPermission();
      String? tokenApp = await FirebaseMessaging.instance.getToken();
      await prefs.setString("Token", tokenApp!);
      debugPrint('=token= : $tokenApp');
    } catch (e) {
      if (Platform.isAndroid) {
        debugPrint('Error get Token $e');
        Push.getToken('');
        Push.getTokenStream.listen(_onTokenEvent);
      }
    }
  }

  Future<String> getDeviceId() async {
    String? identifier = await UniqueIdentifier.serial;
    return identifier ?? 'unknown';
  }

  void _onTokenEvent(String event) async {
    final SharedPreferences prefs = await _prefs;
    _tokenApp = event;
    prefs.setString("Token", _tokenApp);
    prefs.setBool("huawei", true);
    debugPrint('=token= : $_tokenApp');
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: theme_color_df),
        leading: const Icon(Icons.arrow_back),
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: theme_color_df,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: theme_color_df,
      ),
      backgroundColor: theme_color_df,
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/b2c/logo/f_fair2.png',
                        width: 200,
                        // height: 180,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${MultiLanguages.of(context)!.translate('me_version')}: $_versionApp ($buildNumbers)',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontFamily: "notoreg"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
