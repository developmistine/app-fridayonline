// ignore_for_file: use_super_parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import '../../../homepage/pageactivity/widget_appbar_title_only.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class DeliveryStatusTrackingB2C extends StatefulWidget {
  const DeliveryStatusTrackingB2C({Key? key, required this.url})
      : super(key: key);

  final String url;

  @override
  State<DeliveryStatusTrackingB2C> createState() =>
      _DeliveryStatusTrackingB2CState();
}

class _DeliveryStatusTrackingB2CState extends State<DeliveryStatusTrackingB2C> {
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
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
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
