import 'package:fridayonline/homepage/register/register_srisawad.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/safearea.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';

class WebviewPdpaSrisawad extends StatefulWidget {
  const WebviewPdpaSrisawad({super.key});

  @override
  State<WebviewPdpaSrisawad> createState() => _LeadWebviewPDPAState();
}

class _LeadWebviewPDPAState extends State<WebviewPdpaSrisawad> {
  late WebViewController controller;
  bool buttonshow = false;
  String lsurl = "";
  final String isB2cRegis = Get.arguments ?? "";
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
          onProgress: (int progress) {},
          onPageStarted: (url) {
            lsurl = url;
            if (Get.height > 650) {
              setState(() {
                buttonshow = true;
              });
            }
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(
          '$baseurl_yclub/yclub/policyandcondition/pdpa.php?app_customer=1&app_mkt=1'));
  }

  void floatingButtonVisibility() async {
    Offset y = await controller.getScrollPosition();

    // log(y.toString());
    // log(height.toString());
    if (y.dy > 100 || Get.height > 600) {
      setState(() {
        buttonshow = true;
      });
    } else {
      setState(() {
        buttonshow = false;
      });
    }
  }

  void _myCallback() async {
    // log("กดยอมรับ");
    await controller.currentUrl().then((url) {
      var lscustomer = Uri.parse(url!).queryParameters["app_customer"];
      var lsappmkt = Uri.parse(url).queryParameters["app_mkt"];
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RegisterSrisawad(
                  urlCheckCustomer: lscustomer,
                  urlCheckappmkt: lsappmkt,
                  isB2c: isB2cRegis == "b2cRistMsl" ? true : false)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaProvider(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(50.0), // here the desired height
            child: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: theme_color_df,
              title: Text(
                MultiLanguages.of(context)!.translate('login_member_titles'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'notoreg',
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            )),
        body: WebViewWidget(
          controller: controller,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()
                ..onDown = (tap) {
                  //  log("This one prints");
                  floatingButtonVisibility();
                },
            ),
          },
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // ปุ่มเพื่อที่จะทำการต่อไปข้างหน้า
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            onPressed: !buttonshow == false ? _myCallback : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: theme_color_df,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 15, fontFamily: 'notoreg')),
            child: disabletext(buttonshow),
          ),
        ),
      ),
    );
  }

  // ทำการเปี่ยนข้อความก่อร
  Text disabletext(bool buttonshow) {
    if (buttonshow) {
      return const Text(
        'ถัดไป',
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'notoreg',
            fontWeight: FontWeight.bold),
      );
    } else {
      return const Text(
        "เลื่อนอ่านข้อมูล",
        style: TextStyle(
            color: Color(0xffc4c4c4),
            fontSize: 16,
            fontFamily: 'notoreg',
            fontWeight: FontWeight.bold),
      );
    }
  }
}
