import 'dart:io';
import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/member/views/(profile)/myorder.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  const WebViewPage({super.key, required this.url, required this.title});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  UniqueKey key = UniqueKey();
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams();
    } else {
      params = AndroidWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          debugPrint("Page Loaded: $url");
          var lastUrl = url.split("/").last;
          if (lastUrl == "main-miss") {
            Get.back(result: 5);
            Get.back(result: 5);
            Get.back(result: 5);
            Get.find<OrderController>().fetchOrderList(5, 0);
            Get.find<OrderController>().fetchNotifyOrderTracking(10627, 0);
            Get.to(() => const MyOrderHistory(), arguments: 5);
          }
        },
        onWebResourceError: (error) {
          debugPrint("WebView Error: ${error.description}");
        },
      ))
      ..loadRequest(Uri.parse(widget.url));

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController androidController =
          _controller.platform as AndroidWebViewController;
      androidController.setOnShowFileSelector(_onShowFileSelector);
    }
  }

  Future<List<String>> _onShowFileSelector(FileSelectorParams params) async {
    if (Platform.isAndroid) {
      await _requestStoragePermission();
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result == null) return [];

    List<String> filePaths = result.files.map((file) => file.path!).toList();

    List<String> uriPaths = [];
    for (String path in filePaths) {
      File file = File(path);
      Uri? uri = await _getContentUri(file);
      if (uri != null) {
        uriPaths.add(uri.toString());
      }
    }

    debugPrint("Selected Files: $uriPaths");
    return uriPaths;
  }

  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<Uri?> _getContentUri(File file) async {
    try {
      if (!file.existsSync()) return null;

      final directory = await getApplicationDocumentsDirectory();
      final newFile = File('${directory.path}/${file.uri.pathSegments.last}');
      await file.copy(newFile.path);
      final Uri uri = Uri.parse('file://${newFile.path}');
      return uri;
    } catch (e) {
      debugPrint("Error converting file to URI: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back)),
              backgroundColor: themeColorDefault,
              title: Text(
                widget.title,
                style: const TextStyle(fontSize: 16),
              )),
          body: WebViewWidget(
              key: key,
              gestureRecognizers: gestureRecognizers,
              controller: _controller),
        ),
      ),
    );
  }
}
