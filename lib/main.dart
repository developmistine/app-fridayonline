import 'dart:async';
import 'dart:io';
import 'package:fridayonline/enduser/controller/chat.ctr.dart';
import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/services/track/track.service.dart';
import 'package:fridayonline/enduser/utils/branch_manager_main.dart';
import 'package:fridayonline/enduser/utils/logger.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/splashscreen.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/push/firebase_message_service.dart';
import 'package:fridayonline/router.dart';
import 'package:fridayonline/theme.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:fridayonline/binding/root_binging.dart';
import 'package:fridayonline/service/languages/multi_languages.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:huawei_push/huawei_push.dart' as huawei;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'homepage/push_notification/huawei_notification.dart';
import 'homepage/push_notification/local_notification_service.dart';

// Firebase push notification
@pragma('vm:entry-point')
Future<void> _messagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print(
  //     "=onBackgroundMessage= ${message.notification!.title}/${message.notification!.body}");
}

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsBinding widgetBinding = WidgetsFlutterBinding.ensureInitialized();

  // Firebase initial
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Initialize Branch SDK
  await FlutterBranchSdk.init();

  // Initialize other services
  LocalNotificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(_messagingBackgroundHandler);
  await FirebaseMessageService.initialize();

  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  HttpOverrides.global = PostHttpOverrides();

  if (Platform.isAndroid) {
    huawei.Push.registerBackgroundMessageHandler(backgroundMessageCallback);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale _locale = const Locale.fromSubtags(languageCode: 'th');
  DateTime? lastActiveTime;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    var socketCtr = Get.find<WebSocketController>();
    var trackData = Get.find<TrackCtr>();
    SetData data = SetData();

    if (state == AppLifecycleState.resumed) {
      loadLastDragTime();
      SetData data = SetData();
      if (await data.b2cCustID != 0) {
        if (socketCtr.channel == null ||
            socketCtr.subscription == null ||
            !socketCtr.isConnected.value) {
          printWhite('conncet ใหม่');
          await socketCtr.connectWebSocket();
        }
      }
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
    } else if (state == AppLifecycleState.paused) {
      print('paused');
      if (trackData.trackContentId != null &&
          trackData.trackContentType != "" &&
          Get.currentRoute != 'top_products_page' &&
          Get.currentRoute != 'product_detail_page') {
        unawaited(setTrackContentViewServices(
                trackData.trackContentId!,
                trackData.trackContentTitle ?? "",
                trackData.trackContentType ?? "",
                0)
            .then((value) {
          Get.find<TrackCtr>().clearTrackData();
        }));
      }
      if (await data.b2cCustID != 0) {
        Get.find<WebSocketController>().onClose();
      }
    } else if (state == AppLifecycleState.detached) {
      if (trackData.trackContentId != null &&
          trackData.trackContentType != "" &&
          Get.currentRoute != 'top_products_page' &&
          Get.currentRoute != 'product_detail_page') {
        unawaited(setTrackContentViewServices(
                trackData.trackContentId!,
                trackData.trackContentTitle ?? "",
                trackData.trackContentType ?? "",
                0)
            .then((value) {
          Get.find<TrackCtr>().clearTrackData();
        }));
      }
    }
  }

  void _checkAndProcessFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool("is_first_launch") ?? true;

    if (isFirstLaunch) {
      // ประมวลผล Branch data ครั้งแรก
      WidgetsBinding.instance.addPostFrameCallback((_) {
        BranchManagerMain.getBranchData(context);
      });
      await prefs.setBool("is_first_launch", false);
    }
  }

  @override
  void initState() {
    super.initState();
    // Set navigator keys
    FirebaseMessageService.setNavigatorKey(navigatorKey);

    //new dynamiclink
    BranchManagerMain.initializePending();

    // เริ่ม listen dynamic links
    BranchManagerMain.listenDynamicLinksAndSetPendingData(context);
    // ตรวจสอบและประมวลผล first install
    // _checkAndProcessFirstInstall();

    WidgetsBinding.instance.addObserver(this);
    loadLastDragTime();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final multiLanguages = MultiLanguages();
    final localeKey = await multiLanguages.readLocaleKey();
    if (localeKey == 'my') {
      _locale = const Locale("my");
    } else if (localeKey == 'km') {
      _locale = const Locale("km");
    } else {
      _locale = const Locale.fromSubtags(languageCode: "th");
    }
    setState(() {});
  }

  @override
  void dispose() {
    BranchManagerMain.disposePending();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey, // เพิ่ม navigator key
      onDispose: () async {
        // Cleanup when app is disposed
      },
      onInit: () async {
        // App initialization logic
      },
      navigatorObservers: [GetRouteLogger()],
      supportedLocales: const [
        Locale("my"),
        Locale("km"),
        Locale.fromSubtags(languageCode: "th")
      ],
      localizationsDelegates: const [
        MultiLanguages.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale,
      localeListResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == _locale.languageCode &&
              supportedLocaleLanguage.countryCode == _locale.countryCode) {
            return supportedLocaleLanguage;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      title: 'ฟรายเดย์',
      theme: themeData(),
      initialBinding: RootBinging(),
      builder: (context, child) {
        return GestureDetector(
          onVerticalDragDown: (details) async {
            await loadLastDragTime();
            saveLastDragTime(DateTime.now());
          },
          child: child!,
        );
      },
      home: const SplashScreen(),
      getPages: router,
    );
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
      saveLastDragTime(DateTime.now());
      return;
    }
    final difference =
        currentTime.difference(DateTime.parse(loadLastActiveTime));

    if (difference.inHours >= 1) {
      setNewSessionId();
    }
  }

  Future<void> setNewSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    const uuid = Uuid();
    await prefs.setString("sessionId", uuid.v4());
    debugPrint("new session id : ${uuid.v4()}");
  }
}
