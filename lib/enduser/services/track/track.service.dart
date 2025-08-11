import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/track/track.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/homepage/globals_variable.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<TracksResponse?> setTrackPageViewServices(
    String action, String page, int timeSpent, int referrerId,
    {int? sellerId}) async {
  SetData data = SetData();
  var repType = await data.repType;
  if (repType == '2') {
    return null;
  }
  var url = Uri.parse("${b2c_api_url}logs/behaviors/track");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(
          {
            "customer_id": await data.b2cCustID,
            "session_id": await data.sessionId,
            "action": action,
            "channel": "app",
            "context": {
              "page": page,
              "shop_id": sellerId ?? 0,
              "referrer": referrerId,
              "time_spent": timeSpent,
              "user_agent": await generateUserAgent('agent'),
              "platform": await data.device,
              "location": {"city": "", "country": "", "ip": ""},
              "app_version": versionApp,
              "connection_type": await checkNetworkType(),
              "device_model": await generateUserAgent('device_model'),
              "os_version": await generateUserAgent('os_version'),
              "tags": [],
            },
          },
        ));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final tracksResponse = tracksResponseFromJson(utf8.decode(jsonResponse));
      printWhite(
          'PageView ✅ : \npage $page , \ntime :$timeSpent ,\nreferrer : $referrerId \ncusId : ${await data.b2cCustID} \nsellerId : $sellerId');
      return tracksResponse;
    }
    return Future.error('Error logs tracks page view: logs/behaviors/track');
  } catch (e) {
    return Future.error('Error : setTrackPageViewServices $e');
  }
}

Future<TracksResponse?> setTrackContentViewServices(
    int contentId, String contentTitle, String contentType, int timeSpent,
    {int? sellerId}) async {
  SetData data = SetData();
  var repType = await data.repType;
  if (repType == '2') {
    return null;
  }
  var url = Uri.parse("${b2c_api_url}logs/behaviors/track");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(
          {
            "action": 'content_view',
            "channel": "app",
            "context": {
              "seller_id": sellerId ?? 0,
              "content_id": contentId,
              "content_title": contentTitle,
              "content_type": contentType,
              "scroll_depth": 0,
              "tags": [],
              "time_spent": timeSpent
            },
            "customer_id": await data.b2cCustID,
            "session_id": await data.sessionId
          },
        ));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final tracksResponse = tracksResponseFromJson(utf8.decode(jsonResponse));
      printWhite(
          'ContentView ✅ : time :$timeSpent \ncontentId:$contentId \ncontentTitle:$contentTitle \ntype : $contentType');
      return tracksResponse;
    }
    return Future.error('Error logs tracks content view: logs/behaviors/track');
  } catch (e) {
    return Future.error('Error : setTrackContentViewServices $e');
  }
}

Future<TracksResponse?> setTrackProductViewServices(
  int shopId,
  int productId,
  String productName,
  int catId,
  String catName,
  int subcatId,
  double price,
  String page,
  String referrer,
  int timeSpent,
) async {
  SetData data = SetData();
  var repType = await data.repType;
  if (repType == '2') {
    return null;
  }
  var url = Uri.parse("${b2c_api_url}logs/behaviors/track");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "customer_id": await data.b2cCustID,
          "session_id": await data.sessionId,
          "action": "product_view",
          "channel": await data.device,
          "context": {
            "shop_id": shopId,
            "product_id": productId,
            "product_name": productName,
            "cat_id": catId,
            "cat_name": catName,
            "subcat_id": subcatId,
            "prodline_id": 0,
            "product_price": price,
            "currency": "THB",
            "page": page,
            "referrer": referrer,
            // "home_flashsale, home_recommend, shop_product, category_detail_page, product_detail_relate, search_product, top_products_page, mall_product, shop_content, mall_banner, shop_flashsale",
            "tags": [],
            "time_spent": timeSpent
          }
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final tracksResponse = tracksResponseFromJson(utf8.decode(jsonResponse));
      printWhite(
          'Product View ✅ : \ntime : $timeSpent \nproductId: $productId \npage: $page \nreferrer: $referrer');
      return tracksResponse;
    }
    return Future.error('Error logs tracks product view: logs/behaviors/track');
  } catch (e) {
    return Future.error('Error : setTrackProductViewServices $e');
  }
}

Future<String> generateUserAgent(String action) async {
  final deviceInfo = DeviceInfoPlugin();

  final packageInfo = await PackageInfo.fromPlatform();
  if (Platform.isAndroid) {
    final android = await deviceInfo.androidInfo;
    switch (action) {
      case "os_version":
        {
          return android.version.release;
        }
      case "device_model":
        {
          return android.brand;
        }
      default:
        {
          return 'Friday/${packageInfo.version} (${android.brand} ${android.model}; Android ${android.version.release})';
        }
    }
  } else {
    final ios = await deviceInfo.iosInfo;
    switch (action) {
      case "os_version":
        {
          return ios.systemVersion;
        }
      case "device_model":
        {
          return ios.name;
        }
      default:
        {
          return 'Friday/${packageInfo.version} (${ios.name} ${ios.model}; IOS ${ios.systemVersion})';
        }
    }
  }
}

Future<String> checkNetworkType() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    // Mobile network available.
    return 'mobile network';
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    // Wi-fi is available.
    return 'wifi';
  } else {
    return 'No available network';
  }
}
