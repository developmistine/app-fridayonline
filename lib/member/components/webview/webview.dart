import 'dart:async';
import 'dart:convert';
import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/safearea.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({
    super.key,
    this.mparamurl,
    this.mparamTitleName,
    this.mparamValue,
  });
  final String? mparamurl, mparamTitleName, mparamValue;

  @override
  State<WebViewApp> createState() => _WebViewAppState(mparamValue);
}

final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
  Factory(() => EagerGestureRecognizer())
};

class _WebViewAppState extends State<WebViewApp> {
  final String? mparamValue;
  _WebViewAppState(this.mparamValue);

  // Controllers / state
  late final WebViewController _controller;
  final UniqueKey _key = UniqueKey();
  bool _controllerReady = false;

  // Loading overlay
  bool isWebViewLoading = true;

  // Token
  bool _tokenInjected = false;
  String _token = '';
  bool _hasToken = false;
  String _status = '';

  // App state / deps
  final SetData data = SetData();
  final signInController = Get.put(EndUserSignInCtr());

  // Optional utils
  bool _isTrustedHost(String host) {
    host = host.toLowerCase();
    return host == 'friday.co.th' || host.endsWith('.friday.co.th');
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<String> _resolveToken() async {
    try {
      final raw = await data.accessToken;
      return raw;
    } catch (_) {}
    return '';
  }

  Future<void> _bootstrap() async {
    _token = await _resolveToken();
    _hasToken = _token.isNotEmpty;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..addJavaScriptChannel(
        'AppBridge',
        onMessageReceived: (JavaScriptMessage m) {
          // message เป็นสตริง JSON จากหน้าเว็บ
          try {
            final Map<String, dynamic> evt = jsonDecode(m.message);
            switch (evt['type']) {
              case 'TOKEN_INJECTED':
                setState(() => _status = '✅ Token injected');
                break;
              case 'API_OK':
                setState(() => _status =
                    '✅ API OK (count: ${evt['count'] ?? '-'} status: ${evt['status'] ?? '-'})');
                break;
              case 'API_ERROR':
                setState(() => _status =
                    '❌ API ERROR (${evt['status'] ?? ''}) ${evt['error'] ?? ''}');
                break;

              default:
                setState(() => _status = 'ℹ️ ${evt['type']}');
            }
          } catch (_) {
            setState(() => _status = 'JS: ${m.message}');
          }
          printWhite(_status);
        },
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(0, 255, 255, 255))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (req) => NavigationDecision.navigate,
          onProgress: (_) {},
          onPageStarted: (url) {
            setState(() {
              isWebViewLoading = true;
              _tokenInjected = false;
            });

            final uri = Uri.parse(url);
            final segments = uri.pathSegments;
            final backUrl = segments.isNotEmpty ? segments.last : '';
            if (backUrl == 'main-miss' ||
                backUrl == 'yup_close_menu' ||
                backUrl == 'close.php') {
              Get.back();
            }
          },
          onUrlChange: (change) {
            final url = change.url ?? "";
            final parts = url.split('/');
            final lastUrl = parts.isNotEmpty ? parts.last : '';
            if (lastUrl == 'accept') {
              Get.back(result: 'accept');
              if (signInController.custId == 0) {
                Get.to(() => const SignInScreen(redirect: 'special_project'));
              }
            } else if (lastUrl == 'close') {
              Get.back();
            }
          },
          onPageFinished: (String url) async {
            setState(() => isWebViewLoading = false);

            if (!_hasToken) return;

            final host = Uri.parse(url).host.toLowerCase();
            if (_isTrustedHost(host) && !_tokenInjected) {
              final tokenJson = jsonEncode(_token); // escape ปลอดภัย
              await _controller.runJavaScriptReturningResult('''
                (function(){
                  // เก็บ in-memory เท่านั้น
                  window.__token = $tokenJson;
                  window.addEventListener('beforeunload', ()=>{ window.__token = null; });
                  // แจ้งฝั่งเว็บให้เริ่มยิง API ได้
                  window.dispatchEvent(new MessageEvent('message', { data: { type: 'TOKEN_READY' } }));
                  true;
                })();
              ''');
              _tokenInjected = true;
            }
          },
          onWebResourceError: (error) {
            // TODO: log/report if needed
          },
        ),
      );

    final startUrl = widget.mparamurl ?? '';
    _controller.loadRequest(Uri.parse(startUrl));

    setState(() {
      _controllerReady = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaProvider(
      child: Scaffold(
        appBar: appBarMasterEndUser(widget.mparamTitleName ?? ''),
        body: Container(
          color: Colors.grey.shade100,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (_controllerReady)
                WebViewWidget(
                  key: _key,
                  gestureRecognizers: gestureRecognizers,
                  controller: _controller,
                )
              else
                const SizedBox.shrink(),
              if (isWebViewLoading || !_controllerReady)
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
