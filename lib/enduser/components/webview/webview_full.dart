import 'dart:async';
import 'package:appfridayecommerce/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
            var parentstatus = queryParameters["status"];
            var lastUrl = url.split('/').last;
            if (lastUrl == 'close') {
              Get.back(result: false);
              return;
            }
            if (backUrl == 'main-miss') {
              Get.back();
            } else if (backUrl == 'yup_close_menu') {
              Get.back();
            } else if (backUrl == 'close.php') {
              Get.back();
            } else if (parentstatus == 'close') {
              Get.back();
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
        backgroundColor: isLoading ? Colors.white : themeColorDefault,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
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
