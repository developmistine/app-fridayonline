// import 'dart:developer';
// import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/login/witgetlogin.dart';
// import 'package:fridayonline/homepage/register/regiscustomerenduser.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/safearea.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
import '../register/register_customer_enduser_ios.dart';

class CustomerWebviewPDPA extends StatefulWidget {
  const CustomerWebviewPDPA({super.key});

  @override
  State<CustomerWebviewPDPA> createState() => _CustomerWebviewPDPAState();
}

class _CustomerWebviewPDPAState extends State<CustomerWebviewPDPA> {
  SetData data = SetData();
  late WebViewController controller;
  bool buttonshow = false;
  String lsurl = "";

  void floatingButtonVisibility() async {
    Offset y = await controller.getScrollPosition();
    // double height = MediaQuery.of(context).size.height;

    // log(y.toString());
    // log('height $height.toString()');
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
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => EndCustomerRegisterIos()));
  }

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

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SafeAreaProvider(
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
            // Get URL CHANG
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()
                    ..onDown = (tap) {
                      //  log("This one prints");
                      floatingButtonVisibility();
                    }),
            },
          ),

          // floatingActionButton: Stack(
          //   children: [
          //     FloatingActionButton.extended(
          //       // label cannot be null, but it's a widget
          //       // so it can be an empty container or something else
          //       label: const Text(
          //         "เลื่อนขึ้นลง เพื่ออ่านข้อความ",
          //         style: TextStyle(fontFamily: 'notoreg', fontSize: 12),
          //       ),
          //       icon: Icon(
          //         Icons.document_scanner,
          //         color: Colors.white,
          //       ),
          //       onPressed: () {
          //         scrollToTop();
          //       },
          //       elevation: 40.0,
          //       backgroundColor: Color(0xFF2EA9E1).withOpacity(0.2),
          //     ),
          //   ],
          // ),

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
              child: disabletextxxxx(buttonshow),
            ),
          ),
        ),
      ),
    );
  }

  // ทำการเปี่ยนข้อความก่อร
  Text disabletext(bool buttonshow) {
    if (buttonshow) {
      return const Text(
        'ยอมรับเงื่อนไข',
        style:
            TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'notoreg'),
      );
    } else {
      return const Text(
        "เลื่อนอ่านข้อมูล",
        style: TextStyle(
            color: Color(0xffc4c4c4), fontSize: 15, fontFamily: 'notoreg'),
      );
    }
  }
}
