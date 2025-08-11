// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, unused_field

import 'dart:async';
// import 'dart:io';
import 'package:fridayonline/analytics/analytics_engine.dart';
import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/controller/update_app_controller.dart';

import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/webview/webview_app.dart';
import 'package:fridayonline/homepage/widget/appbar_cart_share.dart';
import 'package:fridayonline/push/firebase_message_service.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:huawei_push/huawei_push.dart' as huawei;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:fridayonline/homepage/pageinitial/home.dart';
import 'package:fridayonline/homepage/pageinitial/profileenduser.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:fridayonline/homepage/widget/searchbar.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/languages/multi_languages.dart';
import '../controller/badger/badger_controller.dart';
import '../controller/category/category_controller.dart';
import '../controller/catelog/catelog_controller.dart';
import '../controller/flashsale/flash_controller.dart';
import '../controller/home/home_controller.dart';
import '../controller/app_controller.dart';
import '../controller/lead/lead_controller.dart';
import '../controller/notification/notification_controller.dart';
import '../controller/pro_filecontroller.dart';
import '../model/lead/check_status_lead.dart';
import '../model/register/mslregistermodel.dart';
import '../model/register/userlogin.dart';
import '../service/lead/check_status_lead.dart';
import '../service/logapp/logapp_service.dart';
import '../service/pathapi.dart';
import '../service/register_service.dart';
import 'home/home_popup.dart';
import 'page_showproduct/List_product.dart';
// import 'pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'pageinitial/profilelead.dart';
import 'register/register_customer_enduser_ios.dart';
// import 'widget/appbar_cart.dart';
import 'widget/cartbutton.dart';
import 'pageinitial/catalog.dart';
import 'pageinitial/category.dart';
import 'pageinitial/notification.dart';
import 'pageinitial/profile.dart';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

bool _initialURILinkHandled = false;

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, this.typeView, this.indexCatelog});
  var typeView;
  var indexCatelog;

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SetData data = SetData();
  UpdateAppController update = Get.put(UpdateAppController());
  BadgerController badger = Get.put(BadgerController());
  BadgerProfileController badgerProfile = Get.put(BadgerProfileController());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var typeUser;
  var mAppbarBackReload =
      int.parse(Get.parameters['changeView'] ?? '0'.toString());
  Widget? _body;
  String? lslogin;
  String? lsUserType;
  bool _islogin = true;
  Uri? _initialURI;
  // Uri? _initialURI;
  Object? _err;
  StreamSubscription? _streamSubscription;
  Timer? debounce;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // BranchContentMetaData metadata = BranchContentMetaData();
  // BranchUniversalObject? buo;
  // BranchLinkProperties lp = BranchLinkProperties();
  // BranchEvent? eventStandart;
  // BranchEvent? eventCustom;

  StreamSubscription<RemoteMessage>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  StreamController<String> controllerUrl = StreamController<String>();

  gotopageParam(usertype, refid, refcode, channelId, typeparam, valueparam,
      repCodeParam, parentId, linkId) async {
    switch (typeparam) {
      case "coupon":
        {
          var mChannel = '22';
          // LogApp
          LogAppTisCall(mChannel, channelId);
          // End

          Get.to(
            () => webview_app(
              mparamurl:
                  "${base_url_web_fridayth}bwpoint/product?billCode=$valueparam",
              mparamTitleName:
                  MultiLanguages.of(context)!.translate('point_titleView'),
              mparamType: 'rewards_detail',
              mparamValue: valueparam.toString(),
              type: 'deepLink',
            ),
          );
          break;
        }
      case "category":
        {
          var mChannel = '22';
          // LogApp
          LogAppTisCall(mChannel, channelId);

          Get.find<ProductFromBanner>().fetch_product_banner(valueparam, '');
          Get.to(() => Scaffold(
              appBar: appbarShare(
                  MultiLanguages.of(context)!
                      .translate('home_page_list_products'),
                  "",
                  mChannel,
                  channelId),
              body: Obx(() => Get.find<ProductFromBanner>().isDataLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : showList(
                      Get.find<ProductFromBanner>().BannerProduct!.skucode,
                      mChannel,
                      channelId,
                      ref: 'deeplink',
                      contentId: channelId ?? "",
                    ))));
          break;
        }
      case "sku":
        {
          var mChannel = '22';
          // LogApp
          LogAppTisCall(mChannel, channelId);

          Get.find<ProductDetailController>().productDetailController(
              '', valueparam, '', '', mChannel, channelId);

          Get.to(() => ProductDetailPage(
                ref: 'deeplink',
                contentId: channelId ?? "",
              ));

          break;
        }
      case "categoryGroup":
        {
          var mChannel = '22';
          var mParentValue = '$parentId,$valueparam';

          // LogApp
          LogAppTisCall(mChannel, mParentValue);

          // กดจาก url ใน App ถ้าเจอ ไฟล์นี้จะเข้าเงื่อนไข และนำ mvalueparam และ parent_id  ไปใช้งานใน CategoryProductlistController
          Get.find<CategoryProductlistController>()
              .fetch_list(parentId, valueparam);
          //จากนั้นไปที่ หมวดหมู่สินค้าใน App
          Get.toNamed('/my_list_category', parameters: {
            'mChannel': mChannel,
            'mChannelId': mParentValue,
            'mTypeBack': '',
            'mTypeGroup': 'categorygroup',
            'ref': 'deeplink',
            'contentId': channelId
          });

          break;
        }
      case "regisEnduser":
        {
          // final SharedPreferences prefs = await _prefs;
          // final repCodeShare = repCodeParam ?? "";
          //const flagBackToHome = "Y";
          Get.to(() => EndCustomerRegisterIos(
              repCode: repCodeParam ?? "",
              flagBackToHome: "Y",
              linkId: linkId));
          break;
        }
      case "promotion":
        {
          // Get.toNamed("/end_user_register");
          break;
        }
      case "notify":
        {
          String? urlContent =
              "${base_url_web_fridayth}bwpoint/product?billCode=$valueparam";
          Get.to(() => webview_app(
              mparamurl: urlContent,
              mparamTitleName: "รายการสินค้า",
              mparamType: "rewards_detail",
              mparamValue: "$valueparam"));

          break;
        }
      case "scanQrCode":
        {
          final SharedPreferences prefs = await _prefs;
          String? loginStatus = prefs.getString("login");
          if (loginStatus != '1') {
            prefs.setString("globalLinkId", linkId);
            Get.toNamed('/login');
          }
          break;
        }

      default:
        {
          break;
        }
    }
  }

  void initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await getInitialUri();
        // Use the initialURI and warn the user if it is not correct,
        // but keep in mind it could be `null`.
        if (initialURI != null) {
          debugPrint("Initial URI received : $initialURI");
          if (!mounted) {
            return;
          }

          var url = initialURI.queryParameters;
          String? repCodeParam = url["parent_id"];
          String? usertype = url["usertype"];
          String? refid = url["refid"];
          String? refcode = url["refcode"];
          String? channelId = url["channel"];
          String? typeparam = url["typeparam"];
          String? valueparam = url["valueparam"];
          String? parentId = url["parent_id"];
          String? linkId = url["linkId"];

          setState(() {
            _initialURI = initialURI;
          });
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (_initialURI != null) {
              gotopageParam(usertype, refid, refcode, channelId, typeparam,
                  valueparam, repCodeParam, parentId, linkId);
            }
          });
        } else {
          // _initialURILinkHandled = false;
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // Platform messages may fail, so we use a try/catch PlatformException.
        // Handle exception by warning the user their action did not succeed
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  // Handle incoming deeplink. while app open.
  void incomingLinkHandler() {
    if (!foundation.kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }

        debugPrint('URL Full: $uri');

        var url = uri?.queryParameters;
        String? repCodeParam = url!["parent_id"];
        String? usertype = url["usertype"];
        String? refid = url["refid"];
        String? refcode = url["refCode"];
        String? channel = url["channel"];
        String? typeparam = url["typeparam"];
        String? valueparam = url["valueparam"];
        String? parentId = url["parent_id"];
        String? linkId = url["linkId"];

        setState(() {
          _initialURI = uri;
          _err = null;
        });
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (_initialURI != null) {
            gotopageParam(usertype, refid, refcode, channel, typeparam,
                valueparam, repCodeParam, parentId, linkId);
          }
        });
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _initialURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  // Huawei push notificaiton
  void backgroundMessageCallback(huawei.RemoteMessage remoteMessage) async {
    String data = remoteMessage.data as String;
    huawei.Push.localNotification({
      huawei.HMSLocalNotificationAttr.TITLE: '[Headless] DataMessage Received',
      huawei.HMSLocalNotificationAttr.MESSAGE: data
    });
  }

  // on message received push huawei.
  void _onMessageReceived(huawei.RemoteMessage remoteMessage) {
    String? data = remoteMessage.data;
    if (data != null) {
      huawei.Push.localNotification(
        <String, String>{
          huawei.HMSLocalNotificationAttr.TITLE: 'DataMessage Received',
          huawei.HMSLocalNotificationAttr.MESSAGE: data,
        },
      );
      //showResult('onMessageReceived', 'Data: $data');
    } else {
      //showResult('onMessageReceived', 'No data is present.');
    }
  }

  void showResult(
    String name, [
    String? msg = 'Button pressed.',
  ]) {
    msg ??= '';
    debugPrint('[$name]: $msg');
    huawei.Push.showToast('[$name]: $msg');
  }

  // void _onMessageReceiveError(Object error) {
  //   //showResult('onMessageReceiveError', error.toString());
  // }

  // void _onRemoteMessageSendError(Object error) {
  //   PlatformException e = error as PlatformException;
  //   debugPrint('Error on remote message stream:  $e.toString()');
  //   //showResult('RemoteMessageSendError', 'Error: $e');
  // }

  void _onRemoteMessageSendStatus(String event) {
    //showResult('RemoteMessageSendStatus', 'Status: $event');
  }

  void _onNewIntent(String? intentString) {
    // For navigating to the custom intent page (deep link) the custom
    // intent that sent from the push kit console is:
    // app://app2
    intentString = intentString ?? '';
    if (intentString != '') {
      // showResult('CustomIntentEvent: ', intentString);
      //   List<String> parsedString = intentString.split('://');
    }
  }

  void _onIntentError(Object err) {
    PlatformException e = err as PlatformException;
    debugPrint('Error on intent stream:  $e.toString()');
  }

  // Received message push huawei
  Future<void> initPlatformState() async {
    SetData data = SetData();
    var mdevice = await data.device;

    if (mdevice != "ios") {
      if (!mounted) return;
      try {
        await huawei.Push.setAutoInitEnabled(true);

        huawei.Push.onNotificationOpenedApp.listen(_onNotificationOpenedApp);
        dynamic initialNotification =
            await huawei.Push.getInitialNotification();

        huawei.Push.getIntentStream
            .listen(_onNewIntent, onError: _onIntentError);
        String? intent = await huawei.Push.getInitialIntent();
        _onNewIntent(intent);
        _onNotificationOpenedApp(initialNotification);

        huawei.Push.onMessageReceivedStream.listen(
          _onMessageReceived,
          //onError: _onMessageReceiveError,
        );

        huawei.Push.getRemoteMsgSendStatusStream.listen(
          _onRemoteMessageSendStatus,
          //onError: _onRemoteMessageSendError,
        );
      } catch (e) {
        debugPrint('catch huawei.Push');
      }
    }
  }

  _onNotificationOpenedApp(dynamic initalNotification) {
    if (initalNotification != null) {
      //showResult('onNotificationOpenedApp', initalNotification.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseMessageService.handlePendingMessage();
    });
    getType();

    initPlatformState();

    if (update.statusUpdate == true) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        showPopUpUpdateApp(context, update);
      });
    }
    loadgetSettings();
    if (widget.typeView == 'fromLead') {
      changeView(4);
    } else if (widget.typeView == 'catelog') {
      changeView(1);
    } else {
      changeView(mAppbarBackReload);
    }

    // getFirebaseMessage();

    // Future.delayed(const Duration(milliseconds: 2000), () {
    incomingLinkHandler();
    initURIHandler();
    // });

    //listenDynamicLinks();

    //goToPageByShareCatalog();
  }

  //  void listenDynamicLinks() async {
  //   streamSubscription = FlutterBranchSdk.initSession().listen((data) {
  //     print('listenDynamicLinks - DeepLink Data: $data');
  //     controllerData.sink.add((data.toString()));
  //     if (data.containsKey('+clicked_branch_link') &&
  //         data['+clicked_branch_link'] == true) {
  //       print(
  //           '------------------------------------Link clicked----------------------------------------------');
  //       print('Custom browser: ${data['~referring_browser']}');
  //       print('Custom string: ${data['custom_string']}');
  //       print('Custom number: ${data['custom_number']}');
  //       print('Custom bool: ${data['custom_bool']}');
  //       print('Custom list number: ${data['custom_list_number']}');
  //       print(
  //           '------------------------------------------------------------------------------------------------');
  //       // showSnackBar(
  //       //     context: context,
  //       //     message: 'Link clicked: Custom string - ${data['custom_string']}',
  //       //     duration: 10);
  //     }
  //   }, onError: (error) {
  //     PlatformException platformException = error as PlatformException;
  //     print(
  //         'InitSession error: ${platformException.code} - ${platformException.message}');
  //     controllerInitSession.add(
  //         'InitSession error: ${platformException.code} - ${platformException.message}');
  //   });
  // }

  getType() async {
    typeUser = await data.repType;
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
    controllerData.close();
    controllerUrl.close();
    controllerInitSession.close();
    streamSubscription?.cancel();
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

  void changeView(indexmenu) async {
    SetData data = SetData();
    if (await data.repType == '3') {
      CheckStatusLead? leadStatus = await call_check_status_lead();
      if (leadStatus.leadStatus == 'msl') {
        User user = User(leadStatus.repcode, leadStatus.phoneNo,
            await data.device, await data.tokenId, '9999');
        callDataRegisterlogin(user);
      } else if (leadStatus.leadStatus == 'cancel') {
        Get.find<ProfileLeadController>().check_status_lead();
        PopUpStatusController popup = Get.put(PopUpStatusController());
        if (popup.isViewPopupLeadRegis != true) {
          // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(10),
                  titlePadding: const EdgeInsets.only(top: 20, bottom: 0),
                  actionsPadding: const EdgeInsets.only(top: 0, bottom: 0),
                  actionsAlignment: MainAxisAlignment.end,
                  title: Text(
                    textAlign: TextAlign.center,
                    "แจ้งเตือน",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme_color_df),
                  ),
                  content: const Text(
                      textAlign: TextAlign.center,
                      "ขออภัยค่ะ\nการสมัครสมาชิกของท่านไม่สำเร็จ\nกรุณาติดต่อผู้จัดการเขต\nหรือ Call Center 02-118-5111"),
                  actions: [
                    const Divider(
                      color: Color(0XFFD9D9D9),
                      thickness: 1,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.find<PopUpStatusController>()
                            .ChangeStatusViewPopupLeadRegis();
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                            textAlign: TextAlign.center,
                            'ปิด',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme_color_df)),
                      ),
                    )
                  ],
                );
              });
        }
      } else {
        Get.find<ProfileLeadController>().check_status_lead();
      }
    }

    setState(() {});
    switch (indexmenu) {
      // กรณีที่ทำการตาม From

      case 0:
        {
          Future.delayed(const Duration(seconds: 0), () {
            Get.find<ProductHotIutemLoadmoreController>().resetItem();
          });
          _body = const Home();
          // _body = const HomeReDesign();
          break;
        }
      // กรณีที่ทำการเปิดที่ List
      case 1:
        {
          Get.find<AppController>().setCurrentNavInget(1);
          _body = Catalog(
            index: widget.indexCatelog,
          );
          widget.indexCatelog = 0;
          break;
        }
      case 2:
        {
          Get.find<AppController>().setCurrentNavInget(2);
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
            Get.find<AppController>().setCurrentNavInget(3);
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
          var typeuser = await data.repType;
          if (lslogin == "0") {
            Get.toNamed('/login');
          } else {
            Get.find<AppController>().setCurrentNavInget(4);
            if (lsUserType == '2' || typeuser == '2') {
              _body = const Profile();
            } else if (lsUserType == '1' || typeuser == '1') {
              _body = const ProfileEndUser();
            } else if (lsUserType == '3' || typeuser == '3') {
              _body = const ProfileLead();
            }
          }

          break;
        }
    }
  }

  /// *******login lead กรณีที่ได้รับการอนุมัติแล้ว*******
  callDataRegisterlogin(User user) async {
    Mslregist mslregist = await MslReGiaterAppliction(user);
    if (mslregist.value.success == "1") {
      settingsPreferences(mslregist.value.success, mslregist.value.repSeq,
          mslregist.value.repCode, mslregist.value.repName, "2");
    }
  }

  settingsPreferences(String lsSuccess, String lsRepSeq, String lsRepCode,
      String lsRepName, String lsTypeUser) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("login", lsSuccess);
    prefs.setString("RepSeq", lsRepSeq);
    prefs.setString("RepCode", lsRepCode);
    prefs.setString("RepName", lsRepName);
    prefs.setString("UserType", lsTypeUser);
    Get.find<AppController>().setCurrentNavInget(4);
    Get.find<DraggableFabController>().draggable_Fab();
    Get.find<BannerController>().get_banner_data();
    Get.find<FavoriteController>().get_favorite_data();
    Get.find<SpecialPromotionController>().get_promotion_data();
    // Get.find<SpecialDiscountController>().fetch_special_discount();
    Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
    Get.find<ProductHotIutemLoadmoreController>().resetItem();
    Get.find<CatelogController>().get_catelog();
    Get.find<NotificationController>().get_notification_data();
    Get.find<FlashsaleTimerCount>().flashSaleHome();
    Get.find<BadgerController>().get_badger();
    Get.find<BadgerProfileController>().get_badger_profile();
    Get.find<BadgerController>().getBadgerMarket();
    Get.find<FetchCartDropshipController>().fetchCartDropship();
    SetData data = SetData();
    if (await data.repType == '2') {
      Get.find<ProfileController>().get_profile_data();
      Get.find<ProfileSpecialProjectController>().get_special_project_data();
    }

    if (await data.repType == '2') {
      _body = const Profile();
    } else if (await data.repType == '1') {
      _body = const ProfileEndUser();
    } else if (await data.repType == '3') {
      _body = const ProfileLead();
    }
  }

  /// *******login lead กรณีที่ได้รับการอนุมัติแล้ว*******

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GetBuilder<AppController>(builder: (controller) {
        return Scaffold(
          appBar: _body.runtimeType == Profile
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: AppBar(
                    titleSpacing: -1,
                    automaticallyImplyLeading: false,
                    backgroundColor: theme_color_df,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CartIconButton(),
                      )
                    ],
                    title: MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Imaglogo,
                          Searchbar(),
                        ],
                      ),
                    ),
                  )),
          body: _body,

          // ทำการตรวจสอบข้อมูลก่อนว่ามีการ Login เข้ามาก่อนหน้านี้หรือไม่
          floatingActionButton: Visibility(
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
                                  MultiLanguages.of(context)!
                                          .translate('tv_login_promotion_b') +
                                      MultiLanguages.of(context)!
                                          .translate('login_to_friday'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: 'notoreg',
                                  )),
                            ),
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
                                  MultiLanguages.of(context)!
                                      .translate('login_to_friday'),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: const TextStyle(fontFamily: 'notobold'),
            unselectedLabelStyle: const TextStyle(fontFamily: 'notoreg'),
            backgroundColor: Colors.grey.shade50,
            selectedItemColor: theme_color_df,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  activeIcon: ImageActive,
                  icon: ImageHome,
                  label: MultiLanguages.of(context)!.translate('menu_home')),
              BottomNavigationBarItem(
                  activeIcon: CatalogActive,
                  icon: Catalogs,
                  label: MultiLanguages.of(context)!.translate('menu_catalog')),
              BottomNavigationBarItem(
                  activeIcon: CategoryActive,
                  icon: Categorys,
                  label:
                      MultiLanguages.of(context)!.translate('menu_category')),
              if (typeUser == '2')
                BottomNavigationBarItem(
                    activeIcon: Obx(() {
                      if (!badger.isDataLoading.value) {
                        if (int.parse(badger.badgerNotify!
                                .countBadgerPushNotify[0].countBadger) >
                            0) {
                          return Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
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
                                          badger
                                              .badgerNotify!
                                              .countBadgerPushNotify[0]
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
                          countBadger = int.parse(badger.badgerNotify!
                              .countBadgerPushNotify[0].countBadger);
                        } catch (e) {
                          countBadger = 0;
                        }
                        if (countBadger > 0) {
                          return Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
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
                                          badger
                                              .badgerNotify!
                                              .countBadgerPushNotify[0]
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
                    label: MultiLanguages.of(context)!.translate('menu_notify'))
              else
                BottomNavigationBarItem(
                    activeIcon: NotificationActive,
                    icon: Notifications,
                    label:
                        MultiLanguages.of(context)!.translate('menu_notify')),
              if (typeUser == '2')
                BottomNavigationBarItem(
                    activeIcon: Obx(() {
                      if (!badgerProfile.isDataLoading.value) {
                        if ((badgerProfile.badgerProfile!.configFile.badger
                                    .orderMsl.newMessage !=
                                "0") ||
                            (badgerProfile.badgerProfile!.configFile.badger
                                    .customerList.newMessage !=
                                "0")) {
                          return Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
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
                        if ((badgerProfile.badgerProfile!.configFile.badger
                                    .orderMsl.newMessage !=
                                "0") ||
                            (badgerProfile.badgerProfile!.configFile.badger
                                    .customerList.newMessage !=
                                "0")) {
                          return Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
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
                    label: MultiLanguages.of(context)!.translate('menu_me'))
              else
                BottomNavigationBarItem(
                    activeIcon: ProfileActive,
                    icon: Profiles,
                    label: MultiLanguages.of(context)!.translate('menu_me')),
            ],
            // เอาค่าจาก Control มาใช้ในการทำงาน
            currentIndex: controller.GetCurrentNavInget(),
            onTap: (value) async {
              // Change current
              if (value == 1) {
                AnalyticsEngine.sendAnalyticsEvent('click_catalog_menu',
                    await data.repCode, await data.repSeq, await data.repType);
              } else if (value == 2) {
                AnalyticsEngine.sendAnalyticsEvent('click_catagory_menu',
                    await data.repCode, await data.repSeq, await data.repType);
              } else if (value == 3) {
                AnalyticsEngine.sendAnalyticsEvent('click_notifications_menu',
                    await data.repCode, await data.repSeq, await data.repType);
              } else if (value == 4) {
                AnalyticsEngine.sendAnalyticsEvent('click_profile_menu',
                    await data.repCode, await data.repSeq, await data.repType);
              } else {
                AnalyticsEngine.sendAnalyticsEvent('click_home_menu',
                    await data.repCode, await data.repSeq, await data.repType);
              }
              controller.setCurrentNavInget(value);
              changeView(value);
            },
          ),
        );
      }),
    );
  }
}
