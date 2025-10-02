import "dart:async";
import "package:fridayonline/controller/update_app_controller.dart";
import "package:fridayonline/member/components/appbar/appbar.enduser.dart";
import "package:fridayonline/member/components/appbar/appbar.nosearch.dart";
import "package:fridayonline/member/controller/enduser.home.ctr.dart";
import "package:fridayonline/member/controller/notify.ctr.dart";
import "package:fridayonline/member/popup.dart";
import "package:fridayonline/member/services/track/track.service.dart";
import "package:fridayonline/member/utils/branch_manager.dart";
import "package:fridayonline/member/utils/image_preloader.dart";
import "package:fridayonline/member/views/(anonymous)/signin.dart";
import "package:fridayonline/member/views/(initials)/brand/brand.view.dart";
import "package:fridayonline/member/views/(initials)/home/home.view.dart";
import "package:fridayonline/member/views/(initials)/notify/notify.view.dart";
import "package:fridayonline/member/views/(initials)/profile/enduser.profile.dart";
import "package:fridayonline/member/views/(initials)/fair/fair.view.dart";
import "package:fridayonline/preferrence.dart";
import "package:fridayonline/push/firebase_message_service.dart";
import "package:fridayonline/theme.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
// import "package:flutter/scheduler.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
// import "package:flutter/foundation.dart" as foundation;
import "package:google_fonts/google_fonts.dart";
// import "package:huawei_push/huawei_push.dart" as huawei;
// import "package:uni_links/uni_links.dart";
import "package:badges/badges.dart" as badges;
// import "package:shared_preferences/shared_preferences.dart";

// bool _initialURILinkHandled = false;

class EndUserHome extends StatefulWidget {
  EndUserHome({super.key});

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  State<EndUserHome> createState() => _EndUserHomeState();
}

class _EndUserHomeState extends State<EndUserHome>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  SetData data = SetData();
  UpdateAppController update = Get.put(UpdateAppController());
  final homeCtr = Get.find<EndUserHomeCtr>();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  String typeUser = "";
  int mAppbarBackReload = int.parse(Get.parameters["changeView"] ?? "0");

  List<Widget>? _pages;
  String lslogin = "0";

  // Uri? _initialURI;
  StreamSubscription? _streamSubscription;
  String mChannel = "";

  StreamSubscription<RemoteMessage>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  StreamController<String> controllerUrl = StreamController<String>();
  // String arrg = Get.arguments ?? "";
  Timer? debounce;

  late BranchManager _branchManager;

  Future<void> gotopageParam(usertype, refid, refcode, channelId, typeparam,
      valueparam, repCodeParam, parentId, linkId) async {
    switch (typeparam) {
      case "coupon":
        {
          break;
        }
      case "category":
        {
          break;
        }

      default:
        {
          break;
        }
    }
  }

  // void initURIHandler() async {
  //   if (!_initialURILinkHandled) {
  //     _initialURILinkHandled = true;
  //     try {
  //       final initialURI = await getInitialUri();
  //       // Use the initialURI and warn the user if it is not correct,
  //       // but keep in mind it could be `null`.
  //       if (initialURI != null) {
  //         debugPrint("Initial URI received : $initialURI");
  //         if (!mounted) {
  //           return;
  //         }

  //         var url = initialURI.queryParameters;
  //         String? repCodeParam = url["parent_id"];
  //         String? usertype = url["usertype"];
  //         String? refid = url["refid"];
  //         String? refcode = url["refcode"];
  //         String? channelId = url["channel"];
  //         String? typeparam = url["typeparam"];
  //         String? valueparam = url["valueparam"];
  //         String? parentId = url["parent_id"];
  //         String? linkId = url["linkId"];

  //         setState(() {
  //           _initialURI = initialURI;
  //         });
  //         SchedulerBinding.instance.addPostFrameCallback((_) {
  //           if (_initialURI != null) {
  //             gotopageParam(usertype, refid, refcode, channelId, typeparam,
  //                 valueparam, repCodeParam, parentId, linkId);
  //           }
  //         });
  //       } else {
  //         // _initialURILinkHandled = false;
  //         debugPrint("Null Initial URI received");
  //       }
  //     } on PlatformException {
  //       // Platform messages may fail, so we use a try/catch PlatformException.
  //       // Handle exception by warning the user their action did not succeed
  //       debugPrint("Failed to receive initial uri");
  //     } on FormatException {
  //       if (!mounted) {
  //         return;
  //       }
  //       debugPrint("Malformed Initial URI received");
  //     }
  //   }
  // }

  // Handle incoming deeplink. while app open.
  // void incomingLinkHandler() {
  //   if (!foundation.kIsWeb) {
  //     _streamSubscription = uriLinkStream.listen((Uri? uri) {
  //       if (!mounted) {
  //         return;
  //       }
  //       // FlutterBranchSdk.handleDeepLink("$uri");
  //     }, onError: (Object err) {
  //       if (!mounted) {
  //         return;
  //       }
  //       debugPrint("Error occurred: $err");
  //       setState(() {
  //         _initialURI = null;
  //         if (err is FormatException) {
  //         } else {}
  //       });
  //     });
  //   }
  // }

  // Huawei push notificaiton
  // void backgroundMessageCallback(huawei.RemoteMessage remoteMessage) async {
  //   String data = remoteMessage.data as String;
  //   huawei.Push.localNotification({
  //     huawei.HMSLocalNotificationAttr.TITLE: "[Headless] DataMessage Received",
  //     huawei.HMSLocalNotificationAttr.MESSAGE: data
  //   });
  // }

  // on message received push huawei.
  // void _onMessageReceived(huawei.RemoteMessage remoteMessage) {
  //   String? data = remoteMessage.data;
  //   if (data != null) {
  //     huawei.Push.localNotification(
  //       <String, String>{
  //         huawei.HMSLocalNotificationAttr.TITLE: "DataMessage Received",
  //         huawei.HMSLocalNotificationAttr.MESSAGE: data,
  //       },
  //     );
  //     //showResult("onMessageReceived", "Data: $data");
  //   } else {
  //     //showResult("onMessageReceived", "No data is present.");
  //   }
  // }

  void showResult(
    String name, [
    String? msg = "Button pressed.",
  ]) {
    msg ??= "";
    debugPrint("[$name]: $msg");
    // huawei.Push.showToast("[$name]: $msg");
  }

  // void _onRemoteMessageSendStatus(String event) {
  //   // showResult("RemoteMessageSendStatus", "Status: $event");
  // }

  // void _onNewIntent(String? intentString) {
  //   intentString = intentString ?? "";
  //   if (intentString != "") {}
  // }

  // void _onIntentError(Object err) {
  //   PlatformException e = err as PlatformException;
  //   debugPrint("Error on intent stream:  $e.toString()");
  // }

  // Received message push huawei
  Future<void> initPlatformState() async {
    SetData data = SetData();
    var mdevice = await data.device;

    if (mdevice != "ios") {
      if (!mounted) return;
      try {
        // await huawei.Push.setAutoInitEnabled(true);

        // huawei.Push.onNotificationOpenedApp.listen(_onNotificationOpenedApp);
        // dynamic initialNotification =
        //     await huawei.Push.getInitialNotification();

        // huawei.Push.getIntentStream
        //     .listen(_onNewIntent, onError: _onIntentError);
        // String? intent = await huawei.Push.getInitialIntent();
        // _onNewIntent(intent);
        // _onNotificationOpenedApp(initialNotification);

        // huawei.Push.onMessageReceivedStream.listen(
        //   _onMessageReceived,
        //   //onError: _onMessageReceiveError,
        // );

        // huawei.Push.getRemoteMsgSendStatusStream.listen(
        //   _onRemoteMessageSendStatus,
        //   //onError: _onRemoteMessageSendError,
        // );
      } catch (e) {
        debugPrint("catch huawei.Push");
      }
    }
  }

  // _onNotificationOpenedApp(dynamic initalNotification) {
  //   if (initalNotification != null) {
  //     //showResult("onNotificationOpenedApp", initalNotification.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getType();
    initPlatformState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseMessageService.handlePendingMessage();
    });
    if (update.statusUpdate == true) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        showPopUpUpdateApp(context, update);
      });
    }
    checkShowFair();
    _onItemTapped(mAppbarBackReload);
    // getFirebaseMessage();
    // incomingLinkHandler();
    // initURIHandler();
    //new dynamiclink
    _branchManager = BranchManager();
    // เริ่ม listen dynamic links
    _branchManager.listenDynamicLinks(context);
    // ตรวจสอบและประมวลผล first install
    // _checkAndProcessFirstInstall();
  }

  // void _checkAndProcessFirstInstall() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   bool isFirstLaunch = prefs.getBool("is_first_launch") ?? true;

  //   if (isFirstLaunch) {
  //     // ประมวลผล Branch data ครั้งแรก
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _branchManager.getBranchData(context);
  //     });
  //     await prefs.setBool("is_first_launch", false);
  //   }
  // }

  @override
  void dispose() {
    _branchManager.dispose();
    _streamSubscription?.cancel();
    super.dispose();
    controllerData.close();
    controllerUrl.close();
    controllerInitSession.close();
    streamSubscription?.cancel();
  }

  Future<void> getType() async {
    typeUser = await data.repType;
  }

  DateTime? _activeViewStartTime;
  String currentViewName = "EndUserHomePage";

  void sendManualPageViewLog(String pageName) {
    if (_activeViewStartTime == null) return;
    print(pageName);

    final duration = DateTime.now().difference(_activeViewStartTime!).inSeconds;
    // ส่ง log ไปที่ backend ผ่าน HTTP
    setTrackPageViewServices("page_view", pageName, duration, 0);
  }

  int _selectedIndex = 0;

  void changeView(index) async {
    int custId = await data.b2cCustID;
    // เก็บ log ก่อนเปลี่ยน view
    sendManualPageViewLog(currentViewName);

    // เปลี่ยนหน้าใหม่ และรีเซ็ตเวลา
    _activeViewStartTime = DateTime.now();

    // setState(() {});
    // เก็บเวลาเข้า route ใหม่

    switch (index) {
      case 0:
        {
          setState(() {
            _selectedIndex = index;
            _visitedPages.add(index);
          });
          currentViewName = "home_page";
          break;
        }
      case 1:
        {
          setState(() {
            _selectedIndex = index;
            _visitedPages.add(index);
          });
          currentViewName = "brand_page";
          break;
        }
      case 2:
        {
          if (homeCtr.isVisibilityFair.value) {
            setState(() {
              _selectedIndex = index;
              _visitedPages.add(index);
            });
            currentViewName = "fair_page";
          } else {
            if (custId == 0) {
              Get.to(() => const SignInScreen());
              currentViewName = "signin_page";
            } else {
              setState(() {
                _selectedIndex = index;
                _visitedPages.add(index);
              });
              currentViewName = "notify_page";
            }
          }
          break;
        }
      case 3:
        {
          if (homeCtr.isVisibilityFair.value) {
            {
              if (custId == 0) {
                Get.to(() => const SignInScreen());
                currentViewName = "signin_page";
              } else {
                setState(() {
                  _selectedIndex = index;
                  _visitedPages.add(index);
                });
                currentViewName = "notify_page";
              }
            }
          } else {
            {
              if (custId == 0) {
                Get.to(() => const SignInScreen());
                currentViewName = "signin_page";
              } else {
                setState(() {
                  _selectedIndex = index;
                  _visitedPages.add(index);
                });
                currentViewName = "profile_page";
              }
            }
          }
          break;
        }
      case 4:
        {
          if (custId == 0) {
            Get.to(() => const SignInScreen());
            currentViewName = "signin_page";
          } else {
            setState(() {
              _selectedIndex = index;
              _visitedPages.add(index);
            });
            currentViewName = "profile_page";
          }
        }
    }
  }

  final List<String> _labels = [
    "หน้าแรก",
    "แบรนด์",
    "",
    "แจ้งเตือน",
    "ฉัน",
  ];

  final List<Widget?> _imageIconsActive = [
    const PreloadedImageWidget(
      assetPath: "assets/images/b2c/menu/home_active.png",
      width: 24,
      height: 24,
    ),
    const PreloadedImageWidget(
      assetPath: "assets/images/b2c/menu/brand_active.png",
      width: 24,
      height: 24,
    ),
    null,
    const PreloadedImageWidget(
      assetPath: "assets/images/b2c/menu/noti_active.png",
      width: 24,
      height: 24,
    ),
    const PreloadedImageWidget(
      assetPath: "assets/images/b2c/menu/profile_active.png",
      width: 24,
      height: 24,
    ),
  ];
  final List<Widget?> _imageIconsInactive = [
    const PreloadedImageWidget(
      assetPath: "assets/images/b2c/menu/home_inactive.png",
      width: 24,
      height: 24,
    ),
    const PreloadedImageWidget(
      assetPath: "assets/images/b2c/menu/brand_inactive.png",
      width: 24,
      height: 24,
    ),
    null,
    const PreloadedImageWidget(
      assetPath: "assets/images/b2c/menu/noti_inactive.png",
      width: 24,
      height: 24,
    ),
    const PreloadedImageWidget(
      assetPath: "assets/images/b2c/menu/profile_inactive.png",
      width: 24,
      height: 24,
    ),
  ];

  final Set<int> _visitedPages = {0};

  Future<void> _onItemTapped(int index) async {
    int custId = await data.b2cCustID;
    if (!homeCtr.isVisibilityFair.value) {
      if (custId == 0 && (index == 2 || index == 3 || index == 4)) {
        Get.to(() => const SignInScreen());
        return;
      }
    } else {
      if (custId == 0 && (index == 3 || index == 4)) {
        Get.to(() => const SignInScreen());
        return;
      }
    }

    // เรียก fetchLoadmore เฉพาะหน้าที่ต้องการ
    if (index == 1 || index == 3 || index == 4) {
      homeCtr.fetchLoadmore(0);
    }

    changeView(index);
  }

  void checkShowFair() {
    if (!homeCtr.isVisibilityFair.value) {
      _labels.removeWhere((e) => e == "");
      _imageIconsActive.removeWhere((e) => e == null);
      _imageIconsInactive.removeWhere((e) => e == null);
    }
    if (!homeCtr.isVisibilityFair.value) {
      _pages = [
        const EndUserHomePage(),
        const BrandB2C(),
        const EndUserNotify(),
        const EndUserProfile(),
      ];
    } else {
      _pages = [
        const EndUserHomePage(),
        const BrandB2C(),
        const SwipeScreen(),
        const EndUserNotify(),
        const EndUserProfile(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
          data: Theme.of(context).copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textStyle: GoogleFonts.ibmPlexSansThai())),
              textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
                Theme.of(context).textTheme,
              )),
          child: Scaffold(
            appBar: _pages![_selectedIndex].runtimeType == EndUserHomePage ||
                    _pages![_selectedIndex].runtimeType == EndUserProfile
                ? null
                : _pages![_selectedIndex].runtimeType == EndUserNotify
                    ? appBarNoSearchEndUser("การแจ้งเตือน", page: "home")
                    : appbarEnduser(
                        ctx: context,
                        isSetAppbar: true,
                      ),
            body: IndexedStack(
              index: _selectedIndex,
              children: List.generate(5, (index) {
                // โหลดหน้าเฉพาะที่ถูกเข้าชมแล้ว
                if (_visitedPages.contains(index)) {
                  return _buildPage(index);
                } else {
                  // แสดง loading placeholder สำหรับหน้าที่ยังไม่ได้เข้าชม
                  return const SizedBox();
                }
              }),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: homeCtr.isVisibilityFair.value
                ? bottomBarFair()
                : bottomBarNoFair(),
          )),
    );
  }

  Widget _buildPage(int index) {
    return _pages![index];
  }

  Stack bottomBarFair() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        BottomAppBar(
          child: SizedBox(
            height: 58,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_labels.length, (index) {
                if (index == 2) {
                  // เว้นช่องว่างไว้สำหรับโลโก้ตรงกลาง
                  return const SizedBox(width: 70);
                }
                Color textColor = index == _selectedIndex
                    ? themeColorDefault
                    : Colors.grey.shade500;

                if (index == 3) {
                  return notifyBadges(InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => _onItemTapped(index),
                    child: SizedBox(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          index == _selectedIndex
                              ? _imageIconsActive[index] ?? const SizedBox()
                              : _imageIconsInactive[index] ?? const SizedBox(),
                          const SizedBox(height: 2),
                          Text(
                            _labels[index],
                            style: GoogleFonts.ibmPlexSansThai(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: index == _selectedIndex
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
                }

                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => _onItemTapped(index),
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        index == _selectedIndex
                            ? _imageIconsActive[index] ?? const SizedBox()
                            : _imageIconsInactive[index] ?? const SizedBox(),
                        const SizedBox(height: 2),
                        Text(
                          _labels[index],
                          style: GoogleFonts.ibmPlexSansThai(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: index == _selectedIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        // วางโลโก้วงกลมลอยเหนือ BottomAppBar
        Positioned(
          top: -10,
          child: InkWell(
            onTap: () {
              _onItemTapped(2);
            },
            child: Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFF1C9AD6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300.withOpacity(0.5),
                      offset: const Offset(0, 6),
                      blurRadius: 4,
                      // spreadRadius: 1,
                    )
                  ]),
              child: Image.asset(
                  "assets/images/b2c/logo/friday_online_logo_white.png"),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomBarNoFair() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 24,
            offset: Offset(0, -4),
            spreadRadius: 0,
          )
        ],
      ),
      child: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_labels.length, (index) {
              Color textColor = index == _selectedIndex
                  ? themeColorDefault
                  : Colors.grey.shade500;

              if (index == 2) {
                return notifyBadges(InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => _onItemTapped(index),
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        index == _selectedIndex
                            ? _imageIconsActive[index] ?? const SizedBox()
                            : _imageIconsInactive[index] ?? const SizedBox(),
                        const SizedBox(height: 2),
                        Text(
                          _labels[index],
                          style: GoogleFonts.ibmPlexSansThai(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: index == _selectedIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
              }

              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => _onItemTapped(index),
                child: SizedBox(
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      index == _selectedIndex
                          ? _imageIconsActive[index] ?? const SizedBox()
                          : _imageIconsInactive[index] ?? const SizedBox(),
                      const SizedBox(height: 2),
                      Text(
                        _labels[index],
                        style: GoogleFonts.ibmPlexSansThai(
                          color: textColor,
                          fontSize: 12,
                          fontWeight: index == _selectedIndex
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget notifyBadges(Widget child_) {
    return GetX<NotifyController>(builder: (notiCtr) {
      if (notiCtr.isLoadingCount.value) {
        return Image.asset(
          "assets/images/b2c/menu/noti_inactive.png",
          width: 24,
        );
      }
      if (notiCtr.countNoti!.code == "-9") {
        return Image.asset(
          "assets/images/b2c/menu/noti_inactive.png",
          width: 24,
        );
      }
      return badges.Badge(
          showBadge: notiCtr.countNoti!.data.totalNotifications > 0,
          position: badges.BadgePosition.topEnd(top: 1, end: 10),
          badgeAnimation:
              const badges.BadgeAnimation.slide(loopAnimation: false),
          badgeContent: Text(
            notiCtr.countNoti!.data.totalNotifications.toString(),
            style: GoogleFonts.ibmPlexSansThai(
                height: 1, color: Colors.white, fontSize: 10),
          ),
          child: child_);
    });
  }
}
