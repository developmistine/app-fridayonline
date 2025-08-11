import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/homepage/login/anonymous_login.dart';
// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../service/languages/multi_languages.dart';
// import '../dialogalert/modalAddtoCart.dart';
import '../theme/theme_color.dart';
import '../widget/error/error_page.dart';

Widget getErrorWidget(FlutterErrorDetails error) {
  return Center(
      child: ErrorPage(
    errorDetails: error,
  ));
}

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  var mChannel = Get.parameters['mchannel'] ?? "";

  var mChannelId = Get.parameters['mchannelId'] ?? "";

  var startUrl = '';
  WebViewController? controller;
  @override
  void initState() {
    super.initState();
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
    controller = WebViewController();
  }

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = getErrorWidget; //df error
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: appBarTitleCart(
              MultiLanguages.of(context)!.translate('header_title'), ""),
          body: GetX<CategoryProductDetailController>(
            builder: (DataWebview) => DataWebview.isDataLoading.value
                ? const Center(child: CircularProgressIndicator())
                : WebViewWidget(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer()
                          ..onDown = (tap) {
                            // getWebViewHeight();
                          },
                      ),
                    },
                    controller: controller!
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(Uri.parse(DataWebview
                          .listproduct!.descriptionProduct[0].pathUrl))
                      ..setNavigationDelegate(
                        NavigationDelegate(
                          onPageFinished: (url) async {
                            if (startUrl == url) {
                              // printWhite('url is $startUrl');
                            } else {
                              mChannel = '';
                              mChannelId = '';
                            }
                            var url2 = Uri.parse(url);
                            await Get.find<
                                    Category_getData_webview_controller>()
                                .bottomShowFN(
                                    url2); // call เพื่อเก็บข้อมูลสินค้าและเช็คแสดงปุ่มหยิบใส่ตระกร้า
                          },
                        ),
                      ),
                  ),
          ),
          bottomNavigationBar: GetX<Category_getData_webview_controller>(
              builder: (dataCart) => dataCart.bottomShow.value == 1 &&
                      dataCart.bottomShow.value != 0
                  ? Container(
                      height: 60,
                      color: theme_color_df,
                      child: InkWell(
                        onTap: () async {
                          // call เพื่อนำรูปและรายละเอียดมาโชว์
                          final Future<SharedPreferences> prefs0 =
                              SharedPreferences.getInstance();

                          final SharedPreferences prefs = await prefs0;
                          late String? lslogin;
                          lslogin = prefs.getString("login");

                          if (lslogin == null) {
                            Get.to(
                                transition: Transition.rightToLeft,
                                () => const Anonumouslogin());
                          } else {
                            Get.find<Category_getData_webview_controller>()
                                .fetchproductdetail(
                                    dataCart.campaign,
                                    dataCart.billcode,
                                    dataCart.brand,
                                    dataCart.fscode,
                                    '',
                                    '');
                            Get.find<Category_getData_webview_controller>()
                                .CountItems = 1.obs;
                            // เรียกใช้งาน modal ตระกร้า
                            // WidgetsBinding.instance.addPostFrameCallback((_) {
                            //   modalAddtoCart(context, mChannel, mChannelId);
                            // });
                          }
                        },
                        child: Center(
                            child: Text(
                          MultiLanguages.of(context)!
                              .translate('btn_add_to_cart'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'notoreg',
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  : Container(
                      height: 0.0,
                    )),
        ));
  }
}
