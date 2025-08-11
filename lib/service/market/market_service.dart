import 'dart:convert';
// import 'dart:developer';

import 'package:http/http.dart' as http;
import '../../model/market/market_cart_badger.dart';
import '../../model/market/market_get_favorite_product.dart';
import '../../model/market/market_get_tracking_status.dart';
import '../../model/market/market_home_model.dart';
import '../../model/market/market_lode_product.dart';
import '../../model/market/market_login_supplier.dart';
import '../../model/market/market_retun_login.dart';
import '../../model/set_data/set_data.dart';
import '../pathapi.dart';

Future<MarketMainPageModel> fetchMarketMainPage() async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;

  var url = Uri.parse("${base_api_app}api/v1/Market/GetInfoMainPage");
  // Uri.parse("${baseurl_market}api/InitialHome/InitialHome/type/value");
  var json = jsonEncode({'Device': device});
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;

  MarketMainPageModel response = marketMainPageModelFromJson(jsonResponse);
  return response;
}

Future<MarketLoadmore> getMarketlodeProductCall() async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var tokenId = await data.tokenId;
  var userTypeMarket = await data.userTypeMarket;
  var CustomerID = await data.customerId;
  // var url =
  //     Uri.parse("${baseurl_market}api/Product/GetProDuctLoadMore/type/value");
  var url = Uri.parse("${base_api_app}api/v1/Market/GetProductLoadMore");

  var json = jsonEncode({
    "Token": tokenId,
    "Device": device,
    "CustomerID": CustomerID,
    "StoreId": "",
    "UserType": userTypeMarket,
    "TagID": "",
    "TagCode": "",
    "CustId": CustomerID,
    "ContentId": "0",
    "ContentType": "LoadMore"
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;

  MarketLoadmore response = marketLoadmoreFromJson(jsonResponse);
  return response;
}

// get จำนวน สินค้าถูกใจในการแสดงหน้าฉันของ ตลาดนัด
Future<MarketGetFavoriteProduct> GetMarketFavoriteProductCall() async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var tokenId = await data.tokenId;
  var CustomerID = await data.customerId;
  var userTypeMarket = await data.userTypeMarket;

  var url = Uri.parse("${base_api_app}api/v1/Market/GetFavoriteProduct");
  // "${baseurl_market}api/FavoriteProduct/FavoriteProduct/type/value");
  var json = jsonEncode({
    "Token": tokenId,
    "Device": device,
    "CustomerID": CustomerID,
    "UserType": userTypeMarket,
    "TagID": "",
    "TagCode": ""
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;

  MarketGetFavoriteProduct response =
      marketGetFavoriteProductFromJson(jsonResponse);
  return response;
}

// get จำนวน GetTrackingStatus ต่างๆ เพื่อที่จะโชว์ที่ หน้าฉันตลาดนัด
Future<MarketGetTracking> GetTrackingStatusCall() async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var tokenId = await data.tokenId;
  var CustomerID = await data.customerId;
  var userTypeMarket = await data.userTypeMarket;

  var url = Uri.parse(
      // "${base_api_app}api/v1/Market/GetOrderTracking");
      "${baseurl_market}api/ordertracking/GetTrackingStatus/type/value");
  var json = jsonEncode({
    "Token": tokenId,
    "Device": device,
    "CustomerID": CustomerID,
    "UserType": userTypeMarket,
    "TagID": "",
    "TagCode": ""
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;

  MarketGetTracking response = marketGetTrackingFromJson(jsonResponse);
  return response;
}

// login เข้าสู่ระบบ ตลาดนัดช่องทาง Line Facbook
Future<MarketRetunLogin> MarketLoginSystemsCall() async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var tokenId = await data.tokenId;
  var Chanelsignin = await data.chanelSignin;
  var AccessToken = await data.accessToken;
  var AccessID = await data.accessId;
  var Displayname = await data.displayname;
  var ProfileImg = await data.profileImg;
  var url = Uri.parse("${base_api_app}api/v1/Market/Login");
  // {baseurl_market}api/SignOnSystems/loginSystems/type/value");
  var json = jsonEncode({
    "Token": tokenId,
    "Device": device,
    "Model": "mobile",
    "CustomerID": "",
    "UserType": "",
    "TagID": "",
    "TagCode": "",
    "Chanelsignin": Chanelsignin,
    "AccessToken": AccessToken,
    "AccessID": AccessID,
    "Name": Displayname,
    "Email": "",
    "Status": "1",
    "MobileNo": "",
    "ProfileImg": ProfileImg,
    "TagApp": "mobile"
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;

  MarketRetunLogin response = marketRetunLoginFromJson(jsonResponse);
  return response;
}

Future<LoginCheckSupplier?> LoginCheckSupplierCall(
    {required musername, required mpassword}) async {
  //var url = Uri.parse("${baseurl_market}api/Login/LoginCheck/type/value");
  var url = Uri.parse("${base_api_app}api/v1/Market/LoginSupplier");
  var json = jsonEncode({"username": musername, "password": mpassword});
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;

  LoginCheckSupplier response = loginCheckSupplierFromJson(jsonResponse);

  return response;
}

Future<MarketCartBadger?> GetBadgerCall() async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var tokenId = await data.tokenId;
  var CustomerID = await data.customerId;
  var userTypeMarket = await data.userTypeMarket;

  try {
    //var url = Uri.parse("${baseurl_market}api/AddToCart/GetToCart/type/value");
    var url = Uri.parse("${base_api_app}api/v1/Market/GetBadgerCart");
    var json = jsonEncode({
      "Token": tokenId,
      "Device": device,
      "CustomerID": CustomerID,
      "UserType": userTypeMarket,
      "TagID": "",
      "TagCode": ""
    });
    var apiResponse = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: json);
    var jsonResponse = apiResponse.body;
    MarketCartBadger response = marketCartBadgerFromJson(jsonResponse);
    return response;
  } catch (e) {
    print("error => $e");
    var json = jsonEncode({
      "Token": "",
      "Device": "",
      "CustomerID": "",
      "UserType": "",
      "TagCode": "",
      "TagID": "",
      "Badger": "1",
      "TotalItem": null,
      "OrderCartList": [],
      "JustForYou": []
    });
    MarketCartBadger response = marketCartBadgerFromJson(json);
    return response;
  }
}
