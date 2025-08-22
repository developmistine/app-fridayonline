import 'dart:async';
import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/safearea.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp(
      {super.key, this.mparamurl, this.mparamTitleName, this.mparamValue});
  final String? mparamurl, mparamTitleName, mparamValue;

  @override
  State<WebViewApp> createState() => _WebViewAppState(mparamValue);
}

final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
  Factory(() => EagerGestureRecognizer())
};

class _WebViewAppState extends State<WebViewApp> {
  final String? mparamValue;
  var isWebViewLoading = true;
  _WebViewAppState(this.mparamValue);
  late WebViewController controller;
  final UniqueKey _key = UniqueKey();

  final signInController = Get.put(EndUserSignInCtr());

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
          onUrlChange: (change) {
            var url = change.url ?? "";
            var lastUrl = url.split('/').last;
            if (lastUrl == 'close') {
              if (signInController.custId == 0) {
                Get.back(result: 'signIn');
                Get.to(() => const SignInScreen());
                return;
              } else {
                Get.back(result: 'closed');
              }
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
      ..loadRequest(Uri.parse(widget.mparamurl!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaProvider(
      child: Scaffold(
        appBar: appBarMasterEndUser(widget.mparamTitleName!),
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
      ),
    );
  }
}
