import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/pageactivity/widget_appbar_title_only.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class CheckInformationDeliveryStatusDetail extends StatefulWidget {
  const CheckInformationDeliveryStatusDetail({Key? key}) : super(key: key);

  @override
  State<CheckInformationDeliveryStatusDetail> createState() =>
      _CheckInformationDeliveryStatusDetailState();
}

class _CheckInformationDeliveryStatusDetailState
    extends State<CheckInformationDeliveryStatusDetail> {
  CheckInformationDeliveryStatusController dataController = Get.put(
      CheckInformationDeliveryStatusController()); //เรียกข้อมูลที่ controller CheckInformationDeliveryStatusController
  bool isLoading = true;
  late WebViewController controller;

  UniqueKey key = UniqueKey();
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
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
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            var uri = Uri.parse(url);
            final backUrl = uri.pathSegments.last;
            if (backUrl == 'main-miss') {
              Get.back();
              Get.find<EndUserOrderCtr>().call_enduser_order();
            }
            print(url);

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
          children: <Widget>[
            WebViewWidget(
              key: key,
              gestureRecognizers: gestureRecognizers,
              controller: controller,
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Stack(),
          ],
        ),
      ),
    );
  }
}
