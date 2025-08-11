// ignore_for_file: prefer_const_constructors

// import 'dart:convert';
// import 'dart:developer';

// import 'package:fridayonline/controller/point_rewards/point_rewards_controller.dart';
import 'dart:async';
import 'package:fridayonline/homepage/point_rewards/point_rewards_category_list_confirm.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/service/point_rewards/point_rewards_sevice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../service/languages/multi_languages.dart';
import '../theme/theme_color.dart';

class webview_app extends StatefulWidget {
  const webview_app(
      {super.key,
      this.mparamurl,
      this.mparamTitleName,
      this.mparamType,
      this.mparamValue,
      this.type});
  final type;
  final mparamurl, mparamTitleName, mparamType, mparamValue;

  @override
  State<webview_app> createState() =>
      _webview_appState(mparamType, mparamValue);
}

final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
  Factory(() => EagerGestureRecognizer())
};

class _webview_appState extends State<webview_app> {
  var mparamType;
  var mparamValue;
  var isWebViewLoading = true;
  _webview_appState(this.mparamType, this.mparamValue);
  late WebViewController controller;
  final UniqueKey _key = UniqueKey();

  int count = 0;
  Timer? timer;
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
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (url) async {
            setState(() {
              isWebViewLoading = true;
            });
            var uri = Uri.parse(url);
            final backUrl = uri.pathSegments.last;
            // var queryParameters = uri.queryParameters;
            // var mBillCode = queryParameters["BillCode"];
            // print(backUrl);
            // log(uri.toString());
            if (backUrl == 'main-miss') {
              Get.back();
            } else if (backUrl == 'yup_close_menu') {
              Get.back();
            } else if (backUrl == 'close.php') {
              Get.back();
            }
          },
          onPageFinished: (String url) {
            setState(() {
              isWebViewLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.mparamurl));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mparamType == "rewards_detail"
          ? appBarTitleCart(widget.mparamTitleName, "")
          : appBarTitleMaster(
              widget.mparamTitleName,
            ), // ตัวแปรในการเปลี่ยนภาษาที่รับค่า
      body: Container(
        color: Colors.grey.shade100,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            WebViewWidget(
              key: _key,
              gestureRecognizers: gestureRecognizers,
              controller: controller,
            ),
            if (isWebViewLoading)
              Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
          ],
        ),
      ),

      bottomNavigationBar: mparamType == "rewards_detail"
          ? Container(
              height: 60,
              color: theme_color_df,
              child: InkWell(
                onTap: () async {
                  SetData data = SetData();
                  String repCode = await data.repCode;
                  String repSeq = await data.repSeq;
                  var res = await GetProductByFscodeCall(mparmId: mparamValue);
                  // ! ดัก type v ส่วน c เป็น type test
                  if (res!.point[0].productType.toLowerCase() == "v") {
                    Get.to(() => WebViewFullScreen(
                        mparamurl: Uri.encodeFull(
                            "${baseurl_web_view}main-less/main_less_bk.php?repseq=$repSeq&repcode=$repCode&channel=app&typeOpen=app&billCode=${res.point[0].productCode}&fsCode=$mparamValue")));
                  } else {
                    Get.to(() => point_rewards_category_list_confirm(
                          mparamurl: mparamValue,
                          type: widget.type,
                        ));
                  }
                },
                child: Center(
                  child: Text(
                    MultiLanguages.of(context)!.translate('btn_next_guide'),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
