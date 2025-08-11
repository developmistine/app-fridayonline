import 'dart:convert';

// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import '../../../controller/check_information/check_information_controller.dart';
// import '../../../controller/return_product_controller.dart';
import '../../../homepage/pageactivity/widget_appbar_title_only.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// import '../../return_product/return_product_details.dart';

class CheckInformationOrderHistoryDetail extends StatefulWidget {
  const CheckInformationOrderHistoryDetail({super.key});

  @override
  State<CheckInformationOrderHistoryDetail> createState() =>
      _CheckInformationOrderHistoryDetailState();
}

class _CheckInformationOrderHistoryDetailState
    extends State<CheckInformationOrderHistoryDetail> {
  CheckInformationOrderHistoryController dataController = Get.put(
      CheckInformationOrderHistoryController()); //เรียกข้อมูลที่ controller CheckInformationOrderHistoryController
  bool isLoading = true;
  // get argument
  final statusReturn = Get.arguments;
  late WebViewController controller;

  UniqueKey key = UniqueKey();
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  // get parameter
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
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(dataController.url_endcode!));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: header_title_only(context, 'title_order_detail_view'),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            WebViewWidget(
              key: key,
              gestureRecognizers: gestureRecognizers,
              controller: controller,
            ),
            if (isLoading)
              Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }
}

// class สำหรับเก็บค่า url ที่ส่งมาจาก api
UrlParams urlParamsFromJson(String str) => UrlParams.fromJson(json.decode(str));

String urlParamsToJson(UrlParams data) => json.encode(data.toJson());

class UrlParams {
  UrlParams({
    required this.repcode,
    required this.repseq,
    required this.reptype,
    required this.orderno,
    required this.enduserId,
    required this.transCamp,
    required this.device,
    required this.app,
  });

  String repcode;
  String repseq;
  String reptype;
  String orderno;
  String enduserId;
  String transCamp;
  String device;
  String app;

  factory UrlParams.fromJson(Map<String, dynamic> json) => UrlParams(
        repcode: json["repcode"],
        repseq: json["repseq"],
        reptype: json["reptype"],
        orderno: json["orderno"],
        enduserId: json["enduser_id"],
        transCamp: json["trans_camp"],
        device: json["device"],
        app: json["app"],
      );

  Map<String, dynamic> toJson() => {
        "repcode": repcode,
        "repseq": repseq,
        "reptype": reptype,
        "orderno": orderno,
        "enduser_id": enduserId,
        "trans_camp": transCamp,
        "device": device,
        "app": app,
      };
}
