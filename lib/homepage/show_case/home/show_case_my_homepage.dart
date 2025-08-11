// ignore_for_file: must_be_immutable, non_constant_identifier_names, unused_field

// import 'dart:developer';
import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/homepage/pageinitial/profileenduser.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:fridayonline/homepage/widget/searchbar.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/languages/multi_languages.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../controller/badger/badger_controller.dart';
import '../../../controller/home/home_controller.dart';
import '../../myhomepage.dart';
// import '../../pageinitial/catalog.dart';
import '../../pageinitial/category.dart';
import '../../pageinitial/notification.dart';
import '../../pageinitial/profile.dart';
import '../../pageinitial/profilelead.dart';
import '../../push_notification/local_notification_service.dart';
import '../../widget/cartbutton.dart';
import '../category/show_case_category.dart';
import '../catelog/show_case_catelog.dart';
import 'show_case_home_page.dart';

class ShowCaseMyHomePage extends StatefulWidget {
  ShowCaseMyHomePage({super.key, required this.ChangeLanguage});
  MultiLanguages ChangeLanguage;

  @override
  State<ShowCaseMyHomePage> createState() => _ShowCaseMyHomePageState();
}

class _ShowCaseMyHomePageState extends State<ShowCaseMyHomePage> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  final GlobalKey _saven = GlobalKey();
  final GlobalKey _eight = GlobalKey();
  final GlobalKey _nine = GlobalKey();

  BadgerController badger = Get.put(BadgerController());
  BadgerProfileController badgerProfile = Get.put(BadgerProfileController());

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Widget _body;
  String? lslogin;
  String? lsUserType;
  var pushType = "";
  String? _tokenApp;
  bool _islogin = true;

  //Get all firebase message
  Future<void> getFirebaseMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions();
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    //Handle foreground when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("===onMessage===");
      LocalNotificationService.createDisplayNotification(message);
    });

    // Handle any interaction when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("===onMessageOpenedApp===");
    pushType = message.data['notification_type'].toString().toLowerCase();
    switch (pushType) {
      case "category":
        {
          Get.toNamed("/my_list_category");
          break;
        }
      case "sku":
        {
          Get.toNamed("/change_languages");
          break;
        }
      case "customer_list":
        {
          Get.toNamed("/sharecatalog");
          break;
        }
      case "vieworderenduser":
        {
          Get.toNamed("/check_information_order", parameters: {'select': '1'});
          break;
        }
      case "promotion":
        {
          Get.find<AppController>().setCurrentNavInget(3);
          Get.toNamed("/backAppbarnotify", parameters: {'changeView': '3'});
          break;
        }
      default:
        {
          Get.toNamed("/");
          break;
        }
    }
  }

  //Get FCM (Firebase Cloud Messaging) Token
  getToken() async {
    try {
      String? tokenApp = await FirebaseMessaging.instance.getToken();
      print('TOKEN: $tokenApp');
    } catch (error) {
      // print("Can not get Token");
    }
  }

  var mAppbar_back_reload =
      int.parse(Get.parameters['changeView'] ?? '0'.toString());

  // เป็น Flag ที่ทำการตรวจสอบข้อมูลที่ระบบเอามาแสดงการทำงานก่อนหากมีข้อมูลก็ห้ระบบทำการแสดงเลย
  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 2500), () {
    //   showPopUp(context);

    // });

    super.initState();

    Future.delayed(const Duration(seconds: 0), () {
      ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([_one, _two, _three]),
      );
    });

    loadgetSettings();

    changeView(mAppbar_back_reload);

    getToken();
    getFirebaseMessage();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      Get.find<BadgerController>().get_badger();
    });
  }

  // ทำการ Get SharedPreferences มาทำการตรวจสอบก่อนว่าเมื่อกดที่ฉันควรจะไปที่หน้า LogIn หรือ ไม่
  void loadgetSettings() async {
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;
    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน
    SetData data = SetData();
    var typeuser = await data.repType;
    setState(() {
      lslogin = prefs.getString("login");
      lslogin ??= '0';
      lsUserType = typeuser;
      if (lslogin == '1') {
        _islogin = false;
      } else {
        _islogin = true;
      }
    });
  }

  void changeView(indexmenu) {
    setState(() {});

    switch (indexmenu) {
      // กรณีที่ทำการตาม From
      case 0:
        {
          Future.delayed(const Duration(seconds: 0), () {
            Get.find<ProductHotIutemLoadmoreController>().resetItem();
          });
          _body = ShowCaseHomePage(
            ChangeLanguage: widget.ChangeLanguage,
            keyThee: _three,
            keyFour: _four,
            keyFive: _five,
            keySix: _six,
          );
          break;
        }

      // กรณีที่ทำการเปิดที่ List
      case 1:
        {
          _body = ShowCaseCatalog(
            ChangeLanguage: widget.ChangeLanguage,
            keySaven: _saven,
            keyEight: _eight,
          );

          break;
        }
      case 2:
        {
          _body = const Category();

          break;
        }
      case 3:
        {
          if (lslogin == "0") {
            Get.toNamed('/login');
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => Anonumouslogin()));
          } else {
            _body = const PushNotification();
          }

          break;
        }
      case 4:
        {
          // ทำการตรวจสอบข้อมูลในส่วนนี้ก่อนว่าได้ทำการลงทะเบียนมาหรือไม่
          // ทำการตรวจสอบการลงทะเบียน
          // ทำการตรวจสอบว่าเป็น UserType แบบไหน
          // log("${lslogin} + " " +  ${lsUserType}");

          if (lslogin == "0") {
            Get.toNamed('/login');
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => Anonumouslogin()));
          } else {
            if (lsUserType == '2') {
              _body = const Profile();
            } else if (lsUserType == '1') {
              _body = const ProfileEndUser();
            } else if (lsUserType == '3') {
              _body = const ProfileLead();
            }
          }

          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<AppController>(builder: (controller) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              titleSpacing: -1,
              automaticallyImplyLeading: false,
              backgroundColor: theme_color_df,
              actions: [CartIconButton()],
              title: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Showcase.withWidget(
                  disableMovingAnimation: true,
                  width: width,
                  height: height / 1.4,
                  container: InkWell(
                    onTap: () {
                      setState(() {
                        ShowCaseWidget.of(context).startShowCase([_three]);
                      });
                    },
                    child: MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: SizedBox(
                        width: width + 20,
                        height: height / 1.4,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 60.0, top: 50),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                    color: theme_color_df,
                                    width: 250,
                                    height: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          widget.ChangeLanguage.translate(
                                              'search_guides'),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 220.0),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          WidgetStateProperty.all<Color>(
                                              theme_color_df),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.white),
                                      shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              side: BorderSide(
                                                  color: theme_color_df)))),
                                  onPressed: () {
                                    setState(() {
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_three]);
                                    });
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                          maxLines: 1,
                                          widget.ChangeLanguage.translate(
                                              'btn_next_guide'),
                                          style: const TextStyle(fontSize: 16)),
                                    ),
                                  )),
                            ),
                            Expanded(
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage()));
                                      })),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //overlayColor: theme_color_df,
                  targetPadding: const EdgeInsets.only(right: 4),
                  key: _two,
                  disposeOnTap: true,
                  onTargetClick: () {
                    setState(() {
                      ShowCaseWidget.of(context).startShowCase([_three]);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Imaglogo,
                      Searchbar(),
                    ],
                  ),
                ),
              ),
            )),
        body: _body,

        // ทำการตรวจสอบข้อมูลก่อนว่ามีการ Login เข้ามาก่อนหน้านี้หรือไม่
        floatingActionButton: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Visibility(
            visible: _islogin,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 58.0),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                    ),
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Row(
                      // ส่วนที่จะดำเนินการระ
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50,
                              child: Image.asset(
                                "assets/images/login/iconlogin.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 220,
                                child: Text(
                                    widget.ChangeLanguage.translate(
                                            'tv_login_promotion_b') +
                                        widget.ChangeLanguage.translate(
                                            'login_to_friday'),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'notoreg',
                                    ))),
                            // SizedBox(
                            //     width: 220,
                            //     child: Text("เข้าสู่ระบบ",
                            //         style: TextStyle(
                            //           fontSize: 14,
                            //           color: Colors.white,
                            //           fontFamily: 'notoreg',
                            //         ))),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.toNamed('/login');
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: theme_color_df,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    textStyle: const TextStyle(
                                        fontSize: 14, fontFamily: 'notoreg')),
                                child: Text(
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  widget.ChangeLanguage.translate(
                                      'login_to_friday'),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontFamily: 'notobold'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'notoreg'),
          backgroundColor: Colors.grey.shade50,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                activeIcon: Showcase.withWidget(
                    disableMovingAnimation: true,
                    width: width,
                    height: height / 1.4,
                    container: InkWell(
                      onTap: () {
                        setState(() {
                          ShowCaseWidget.of(context).startShowCase([_two]);
                        });
                      },
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: SizedBox(
                          width: width / 1.1,
                          height: height / 1.4,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Center(
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage()));
                                      })),
                              Expanded(
                                // <-- Use Expanded with SizedBox.expand
                                child: SizedBox.expand(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 170.0),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      WidgetStateProperty.all<Color>(
                                                          theme_color_df),
                                                  backgroundColor:
                                                      WidgetStateProperty.all<
                                                          Color>(Colors.white),
                                                  shape: WidgetStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  30.0),
                                                          side: BorderSide(color: theme_color_df)))),
                                              onPressed: () {
                                                setState(() {
                                                  ShowCaseWidget.of(context)
                                                      .startShowCase([_two]);
                                                });
                                              },
                                              child: SizedBox(
                                                width: 50,
                                                height: 40,
                                                child: Center(
                                                  child: Text(
                                                      maxLines: 1,
                                                      widget.ChangeLanguage
                                                          .translate(
                                                              'btn_next_guide'),
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ),
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Container(
                                              color: theme_color_df,
                                              width: 250,
                                              height: 80,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    widget.ChangeLanguage
                                                        .translate(
                                                            'txt_guide1'),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 75,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //overlayColor: theme_color_df,
                    targetPadding: const EdgeInsets.only(
                        left: 20, right: 20, top: 4, bottom: 20),
                    key: _one,
                    onTargetClick: () {
                      setState(() {
                        ShowCaseWidget.of(context).startShowCase([_two]);
                      });
                    },
                    child: ImageActive),

                // activeIcon: Showcase(
                //     //overlayColor: theme_color_df,
                //     overlayPadding: const EdgeInsets.only(
                //         left: 28, right: 28, bottom: 26, top: 8),
                //
                //     targetPadding: const EdgeInsets.all(20),
                //     descTextStyle:
                //         const TextStyle(fontSize: 16, color: Colors.white),
                //     key: _one,
                //     //title: 'Menu',
                //     description: widget.ChangeLanguage.translate('txt_guide1'),
                //     disposeOnTap: true,
                // onTargetClick: () {
                //   setState(() {
                //     ShowCaseWidget.of(context).startShowCase([_two]);
                //   });
                // },
                //     child: ImageActive),
                icon: ImageHome,
                label: widget.ChangeLanguage.translate('menu_home')),
            BottomNavigationBarItem(
                activeIcon: CatalogActive,
                icon: Showcase.withWidget(
                    disableMovingAnimation: true,
                    width: width,
                    height: height / 1.4,
                    container: InkWell(
                      onTap: () {
                        setState(() {
                          _body = ShowCaseCatalog(
                            ChangeLanguage: widget.ChangeLanguage,
                            keySaven: _saven,
                            keyEight: _eight,
                          );
                          controller.setCurrentNavInget(1);
                          ShowCaseWidget.of(context).startShowCase([_saven]);
                        });
                      },
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: SizedBox(
                          width: width / 1.1,
                          height: height / 1.4,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Center(
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        controller.setCurrentNavInget(0);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage()));
                                      })),
                              Expanded(
                                // <-- Use Expanded with SizedBox.expand
                                child: SizedBox.expand(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 170.0),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      WidgetStateProperty.all<Color>(
                                                          theme_color_df),
                                                  backgroundColor:
                                                      WidgetStateProperty.all<
                                                          Color>(Colors.white),
                                                  shape: WidgetStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  30.0),
                                                          side: BorderSide(color: theme_color_df)))),
                                              onPressed: () {
                                                setState(() {
                                                  _body = ShowCaseCatalog(
                                                    ChangeLanguage:
                                                        widget.ChangeLanguage,
                                                    keySaven: _saven,
                                                    keyEight: _eight,
                                                  );
                                                  controller
                                                      .setCurrentNavInget(1);
                                                  ShowCaseWidget.of(context)
                                                      .startShowCase([_saven]);
                                                });
                                              },
                                              child: SizedBox(
                                                width: 50,
                                                height: 40,
                                                child: Center(
                                                  child: Text(
                                                      maxLines: 1,
                                                      widget.ChangeLanguage
                                                          .translate(
                                                              'btn_next_guide'),
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ),
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Container(
                                              color: theme_color_df,
                                              width: 270,
                                              height: 90,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    widget.ChangeLanguage
                                                        .translate(
                                                            'cat_guide1'),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 75,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //overlayColor: theme_color_df,
                    targetPadding: const EdgeInsets.only(
                        left: 20, right: 20, top: 4, bottom: 20),
                    key: _six,
                    onTargetClick: () {
                      setState(() {
                        _body = ShowCaseCatalog(
                          ChangeLanguage: widget.ChangeLanguage,
                          keySaven: _saven,
                          keyEight: _eight,
                        );
                        controller.setCurrentNavInget(1);
                        ShowCaseWidget.of(context).startShowCase([_saven]);
                      });
                    },
                    child: Catalogs),
                label: widget.ChangeLanguage.translate('menu_catalog')),
            BottomNavigationBarItem(
                activeIcon: CategoryActive,
                icon: Showcase.withWidget(
                    disableMovingAnimation: true,
                    width: width,
                    height: height / 1.4,
                    container: InkWell(
                      onTap: () {
                        setState(() {
                          _body = ShowCaseCategory(
                            ChangeLanguage: widget.ChangeLanguage,
                            keyNine: _nine,
                          );
                          controller.setCurrentNavInget(2);
                          ShowCaseWidget.of(context).startShowCase([_nine]);
                        });
                      },
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: SizedBox(
                          width: width / 1.1,
                          height: height / 1.4,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Center(
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        controller.setCurrentNavInget(0);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage()));
                                      })),
                              Expanded(
                                // <-- Use Expanded with SizedBox.expand
                                child: SizedBox.expand(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 80.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 170.0),
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        WidgetStateProperty.all<Color>(
                                                            theme_color_df),
                                                    backgroundColor:
                                                        WidgetStateProperty.all<Color>(
                                                            Colors.white),
                                                    shape: WidgetStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(
                                                                30.0),
                                                            side: BorderSide(
                                                                color: theme_color_df)))),
                                                onPressed: () {
                                                  setState(() {
                                                    _body = ShowCaseCategory(
                                                      ChangeLanguage:
                                                          widget.ChangeLanguage,
                                                      keyNine: _nine,
                                                    );
                                                    controller
                                                        .setCurrentNavInget(2);
                                                    ShowCaseWidget.of(context)
                                                        .startShowCase([_nine]);
                                                  });
                                                },
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                        maxLines: 1,
                                                        widget.ChangeLanguage
                                                            .translate(
                                                                'btn_next_guide'),
                                                        style: const TextStyle(
                                                            fontSize: 16)),
                                                  ),
                                                )),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Container(
                                                color: theme_color_df,
                                                width: 250,
                                                height: 80,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      widget.ChangeLanguage
                                                          .translate(
                                                              'category_guides'),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(
                                            height: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //overlayColor: theme_color_df,
                    targetPadding: const EdgeInsets.only(
                        left: 20, right: 20, top: 4, bottom: 20),
                    key: _eight,
                    onTargetClick: () {
                      setState(() {
                        _body = ShowCaseCategory(
                          ChangeLanguage: widget.ChangeLanguage,
                          keyNine: _nine,
                        );
                        controller.setCurrentNavInget(2);
                        ShowCaseWidget.of(context).startShowCase([_nine]);
                      });
                    },
                    child: Categorys),
                // icon: Showcase(
                //     //overlayColor: theme_color_df,
                //     overlayPadding: const EdgeInsets.only(
                //         left: 28, right: 28, bottom: 26, top: 8),
                //
                //     targetPadding: const EdgeInsets.all(20),
                //     descTextStyle:
                //         const TextStyle(fontSize: 16, color: Colors.white),
                //     key: _eight,
                //     description:
                //         widget.ChangeLanguage.translate('category_guides'),
                //     disposeOnTap: true,
                //     onTargetClick: () {
                //       setState(() {
                //         _body = ShowCaseCategory(
                //           ChangeLanguage: widget.ChangeLanguage,
                //           keyNine: _nine,
                //         );
                //         controller.setCurrentNavInget(2);
                //         ShowCaseWidget.of(context).startShowCase([_nine]);
                //       });
                //     },
                //     child: Categorys),
                label: widget.ChangeLanguage.translate('menu_category')),
            BottomNavigationBarItem(
                activeIcon: Obx(() {
                  if (!badger.isDataLoading.value) {
                    if (int.parse(badger.badgerNotify!.countBadgerPushNotify[0]
                            .countBadger) >
                        0) {
                      return Stack(clipBehavior: Clip.none, children: <Widget>[
                        NotificationActive,
                        Positioned(
                          // draw a red marble
                          top: -10,
                          right: -8,
                          child: badges.Badge(
                              badgeStyle: const badges.BadgeStyle(
                                badgeColor: Colors.red,
                              ),
                              badgeContent: Text(
                                  badger.badgerNotify!.countBadgerPushNotify[0]
                                      .countBadger,
                                  style: const TextStyle(
                                      inherit: false,
                                      color: Colors.white,
                                      fontSize: 10))),
                        )
                      ]);
                    } else {
                      return NotificationActive;
                    }
                  } else {
                    return NotificationActive;
                  }
                }),
                icon: Obx(() {
                  if (!badger.isDataLoading.value) {
                    var countBadger = 0;
                    try {
                      countBadger = int.parse(badger
                          .badgerNotify!.countBadgerPushNotify[0].countBadger);
                    } catch (e) {
                      countBadger = 0;
                    }
                    if (countBadger > 0) {
                      return Stack(clipBehavior: Clip.none, children: <Widget>[
                        Notifications,
                        Positioned(
                          // draw a red marble
                          top: -10,
                          right: -8,
                          child: badges.Badge(
                              badgeStyle: const badges.BadgeStyle(
                                badgeColor: Colors.red,
                              ),
                              badgeContent: Text(
                                  badger.badgerNotify!.countBadgerPushNotify[0]
                                      .countBadger,
                                  style: const TextStyle(
                                      inherit: false,
                                      color: Colors.white,
                                      fontSize: 10))),
                        )
                      ]);
                    } else {
                      return Notifications;
                    }
                  } else {
                    return Notifications;
                  }
                }),
                label: widget.ChangeLanguage.translate('menu_notify')),
            BottomNavigationBarItem(
                activeIcon: Obx(() {
                  if (!badgerProfile.isDataLoading.value) {
                    if ((badgerProfile.badgerProfile!.configFile.badger.orderMsl
                                .newMessage !=
                            "0") ||
                        (badgerProfile.badgerProfile!.configFile.badger
                                .customerList.newMessage !=
                            "0")) {
                      return Stack(clipBehavior: Clip.none, children: <Widget>[
                        ProfileActive,
                        const Positioned(
                          // draw a red marble
                          top: -10,
                          right: -8,
                          child: badges.Badge(
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: Colors.red,
                              ),
                              badgeContent: Text('N',
                                  style: TextStyle(
                                      inherit: false,
                                      color: Colors.white,
                                      fontSize: 10))),
                        )
                      ]);
                    } else {
                      return ProfileActive;
                    }
                  } else {
                    return ProfileActive;
                  }
                }),
                icon: Obx(() {
                  if (!badgerProfile.isDataLoading.value) {
                    if ((badgerProfile.badgerProfile!.configFile.badger.orderMsl
                                .newMessage !=
                            "0") ||
                        (badgerProfile.badgerProfile!.configFile.badger
                                .customerList.newMessage !=
                            "0")) {
                      return Stack(clipBehavior: Clip.none, children: <Widget>[
                        Profiles,
                        const Positioned(
                          // draw a red marble
                          top: -10,
                          right: -8,
                          child: badges.Badge(
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: Colors.red,
                              ),
                              badgeContent: Text('N',
                                  style: TextStyle(
                                      inherit: false,
                                      color: Colors.white,
                                      fontSize: 10))),
                        )
                      ]);
                    } else {
                      return Profiles;
                    }
                  } else {
                    return Profiles;
                  }
                }),
                label: widget.ChangeLanguage.translate('menu_me')),
          ],
          // เอาค่าจาก Control มาใช้ในการทำงาน
          currentIndex: controller.GetCurrentNavInget(),
          onTap: (value) {
            // Change current
            controller.setCurrentNavInget(value);
            changeView(value);
          },
        ),
      );
    });
  }
}
