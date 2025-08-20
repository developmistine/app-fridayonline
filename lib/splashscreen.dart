import 'dart:async';
import 'dart:io';

import 'package:fridayonline/member/components/error/error.page.dart';
import 'package:fridayonline/member/models/check_version/check_version_model.dart';
import 'package:fridayonline/member/utils/branch_manager_main.dart';
import 'package:fridayonline/member/utils/image_preloader.dart';
import 'package:fridayonline/global.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/services.dart';
// import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:fridayonline/controller/update_app_controller.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/enduser.main.dart';
import 'package:fridayonline/member/models/authen/b2cregis.model.dart';
import 'package:fridayonline/member/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/member/services/fair/fair.service.dart';
// import 'package:fridayonline/pam/notification_api.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
import '../service/check_version/check_version_service.dart';
import 'global.dart' as globals;
import 'package:pub_semver/pub_semver.dart' as semver;

// กรณีที่ทำการ Set ข้อมูล
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class AppChecker {
  static const MethodChannel _channel =
      MethodChannel('th.co.friday.fridayonline/check_apps');

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
        // await checkAppNewVersion();

        if (!mounted) return;

        if (BranchManagerMain.pendingData != null) {
          await BranchManagerMain.handlePendingData(context);
          await BranchManagerMain.disposePending();
        } else {
          await BranchManagerMain.disposePending();
        }
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
        iconTheme: IconThemeData(color: themeColorDefault),
        leading: const Icon(Icons.arrow_back),
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: themeColorDefault,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: themeColorDefault,
      ),
      backgroundColor: themeColorDefault,
      body: SafeArea(
        child: MediaQuery(
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
                          'assets/images/b2c/logo/friday_online_label_white.png',
                          width: 300,
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
                    'เวอร์ชัน: $_versionApp ($buildNumbers)',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: "IBM_Regular"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
