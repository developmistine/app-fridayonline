import 'dart:async';

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/point_rewards/point_rewards_category_list_confirm.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../controller/badger/badger_controller.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/category/category_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../model/set_data/set_data.dart';
import '../../service/logapp/logapp_service.dart';
import '../theme/theme_color.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// by_jukkapun  02/09/2022
class WebViewFullScreen extends StatefulWidget {
  const WebViewFullScreen({super.key, required this.mparamurl});
  final String mparamurl;

  @override
  State<WebViewFullScreen> createState() => WebviewFullScreenState(mparamurl);
}

class WebviewFullScreenState extends State<WebViewFullScreen> {
  UniqueKey key = UniqueKey();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  late WebViewController controller;

  WebviewFullScreenState(this.mparamurl);
  String mparamurl;

  _logout() async {
    await FacebookAuth.instance.logOut();
    setState(() {});
  }

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  int count = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent(
          'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15')
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            var url = change.url ?? "";
            var lastUrl = url.split('/').last;
            if (lastUrl == 'close') {
              Get.back(result: false);
            }
          },
          onNavigationRequest: (request) async {
            var url = request.url;
            var uri = Uri.parse(url);
            var queryParameters = uri.queryParameters;
            var status = queryParameters["status"];
            var lastUrl = url.split('/').last;

            if (lastUrl == 'close') {
              Get.back(result: false);
              return NavigationDecision.navigate;
            } else if (status == 'true') {
              Get.back(result: true);
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) async {
            var uri = Uri.parse(url);
            final backUrl =
                uri.pathSegments.isEmpty ? "" : uri.pathSegments.last;
            // final flagment = uri.path.split('/');
            // {typeparam: categorygroup, valueparam: 07, parent_id: 19}
            var queryParameters = uri.queryParameters;
            // var mtypeparam = queryParameters["typeparam"];
            var mvalueparam = queryParameters["valueparam"];
            var mvalueFscode = queryParameters["fscode"];
            var parent = queryParameters["parent_id"];
            var parentstatus = queryParameters["status"];
            var backPage = queryParameters["back_page"];
            var lastUrl = url.split('/').last;
            if (lastUrl == 'close') {
              Get.back(result: false);
              return;
            }
            if (backUrl == 'main-miss') {
              Get.back();
            } else if (backUrl == 'deeplink_category.php') {
              Navigator.pop(context);
              if (backPage!.toLowerCase() == 'home') {
                // LogApp
                LogAppTisCall('14', mvalueparam);
                // End
                await Get.put(ProductFromBanner())
                    .fetch_product_banner(mvalueparam, "");
                await Get.find<FetchCartItemsController>().fetch_cart_items();
                Get.find<CategoryProductlistController>()
                    .fetch_product_category_byperson(mvalueparam, "");
                Get.offNamed('/my_list_category', parameters: {
                  'mChannel': '14',
                  'mChannelId': '$mvalueparam',
                  'mTypeBack': 'home',
                  'mTypeGroup': 'category',
                  'ref': 'product',
                  'contentId': ''
                });
              } else {
                // LogApp
                LogAppTisCall('14', mvalueparam);
                // End
                await Get.find<CategoryProductlistController>()
                    .fetch_product_category_byperson(mvalueparam, "");
                await Get.put(ProductFromBanner())
                    .fetch_product_banner(mvalueparam, "");
                Get.toNamed('/my_list_category', parameters: {
                  'mChannel': '14',
                  'mChannelId': '$mvalueparam',
                  'mTypeBack': 'noti',
                  'mTypeGroup': 'category',
                  'ref': 'product',
                  'contentId': ''
                });
              }
            } else if (backUrl == 'deeplink_sku.php') {
              Navigator.pop(context);
              // LogApp
              LogAppTisCall('15', mvalueparam);
              Get.find<ProductDetailController>().productDetailController(
                  "", mvalueparam, "", mvalueparam, '15', mvalueparam);
              Get.to(() => const ProductDetailPage(
                    ref: 'product',
                    contentId: '',
                  ));
            } else if (backUrl == 'deeplink_categorygroup.php') {
              Navigator.pop(context);
              var parentValue = '$parent,$mvalueparam';

              // LogApp
              await LogAppTisCall('16', parentValue);
              // End

              // กดจาก url ใน App ถ้าเจอ ไฟล์นี้จะเข้าเงื่อนไข และนำ mvalueparam และ parent_id  ไปใช้งานใน CategoryProductlistController
              await Get.find<CategoryProductlistController>()
                  .fetch_list(parent, mvalueparam);
              //จากนั้นไปที่ หมวดหมู่สินค้าใน App
              await Get.put(ProductFromBanner())
                  .fetch_product_banner(mvalueparam, "");
              Get.toNamed('/my_list_category', parameters: {
                'mChannel': '16',
                'mChannelId': parentValue,
                'mTypeBack': 'noti',
                'mTypeGroup': 'categorygroup',
                'ref': 'product',
                'contentId': ''
              });
            } else if (backUrl == 'yup_close_menu') {
              Get.back();
            } else if (backUrl == 'close.php') {
              Get.back();
            } else if (parentstatus == 'close') {
              Get.back();
            } else if (parentstatus == 'successBank') {
              // mvalueparam
              Get.back();
              Get.to(() => point_rewards_category_list_confirm(
                    mparamurl: mvalueFscode,
                    type: 'webview',
                  ));
            } else if (backUrl == 'main-home') {
              Get.find<BadgerController>().getBadgerMarket();
              Get.toNamed(
                '/market',
              );
            } else if (backUrl == 'gotologin') {
              SetData data = SetData(); //เรียกใช้ model
              var mdevice = await data.device;
              // ตลาดนัดไม่ได้ Login
              // Get.toNamed(
              //   '/market_login',
              // );
              Get.toNamed("/market_login", parameters: {'mdevice': mdevice});
            } else if (backUrl == 'logout-app') {
              // print('log out app : ' + backUrl);
              final SharedPreferences prefs = await _prefs;
              prefs.remove("CustomerID");
              prefs.remove("login_market");
              // logout Facbook
              _logout();

              // ตลาดนัดไม่ได้ Login
              Get.toNamed(
                '/market',
              );
            }
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(mparamurl));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(mparamurl);
    return Scaffold(
        backgroundColor: isLoading ? Colors.white : theme_color_df,
        body: isLoading
            ? Center(
                child: theme_loading_df,
              )
            : SafeArea(
                child: WebViewWidget(
                  key: key,
                  gestureRecognizers: gestureRecognizers,
                  controller: controller,
                ),
              ));
  }
}
