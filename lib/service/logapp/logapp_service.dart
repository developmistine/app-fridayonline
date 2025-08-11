import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../model/set_data/set_data.dart';
import '../pathapi.dart';
import 'package:http/http.dart' as http;

// log TIS
Future<String?> LogAppTisCall(mChannel, mChannelId) async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var mrepSeq = await data.repSeq;
  var mrepCode = await data.repCode;
  var mUserType = await data.repType;
  var menduserId = await data.enduserId;
  // LogAppTisCall('1', mChannelId);
  print("Channel" + mChannel);
  print("ChannelId" + mChannelId);
  // ความหมายของ Channel
  // 1	แบนเนอร์
  // 2	Favorite Icon
  // 3	แฟลชเซลล์
  // 4	โครงการพิเศษ
  // 5	คอนเทนท์
  // 6	รายการสินค้า // Product
  // 7	แค็ตตาล็อก API เก็บ log ให้เอง
  // 8	ลดพิเศษ   API เก็บ log ให้เอง
  // 9	หมวดหมู่ / _parent 01,11 ขึ้นก่อน
  // 10	ค้นหา
  // 11	Category (App-App) --> ยังไม่ติด
  // 12	SKU (App-App) --> ยังไม่ติด
  // 13	Category Group (App-App) --> ยังไม่ติด
  // 14	Category (External-App)
  // 15	SKU (External-App)
  // 16	Category Group (External-App)
  // 27 log เชียร์ขาย

  var url = Uri.parse("${apibackfriday}log/v1/tis/InsertLogViewContent");
  // "${baseurl_home}api/YupinTrackEvent/InsertViewContent/type/value");
  var json = jsonEncode({
    "Channel": mChannel,
    "ChannelId": mChannelId,
    "Device": device,
    "UserType": mUserType,
    "RepSeq": mUserType == '2' || mUserType == '3' ? mrepSeq : menduserId,
    "RepCode": mrepCode
  });
  try {
    var apiResponse = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: json);
    var jsonResponse = apiResponse.body;
    return jsonResponse;
  } catch (e) {
    return null;
  }
}

// log TIS  Search
Future<String?> LogAppSearchCall(mEventName, mKeySearch) async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var mrepSeq = await data.repSeq;
  var mrepCode = await data.repCode;
  var mUserType = await data.repType;
  var menduserId = await data.enduserId;
  var mlanguage = await data.language;

  var url = Uri.parse(
      "${baseurl_home}api/YupinTrackEvent/InsertSearchProduct/type/value");
  var json = jsonEncode({
    "RepSeq": mrepSeq,
    "KeySearch": mKeySearch,
    "RepType": mUserType,
    "RepCode": mrepCode,
    "language": mlanguage,
    "UserID": menduserId,
    "Device": device
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;
  print(jsonResponse.toString());
  return jsonResponse;
}

// log TIS  ShareCatalog
Future<String?> LogAppShareCatalogCall(mEventName) async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var mrepSeq = await data.repSeq;
  var mrepCode = await data.repCode;
  var mUserType = await data.repType;

  var url = Uri.parse("${apibackfriday}log/v1/tis/InsertLogShareCatalog");
  // "${baseurl_home}api/YupinTrackEvent/InsertShareCatalog/type/value");
  var json = jsonEncode({
    "RepCode": mrepCode,
    "RepSeq": mrepSeq,
    "UserType": mUserType,
    "Device": device
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;
  print(jsonResponse.toString());
  return jsonResponse;
}

Future<String?> LogAppLanguageCall(mEventName, mLanguage) async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var mrepSeq = await data.repSeq;
  var mrepCode = await data.repCode;
  var mUserType = await data.repType;
  var mToken = await data.tokenId;

  var url = Uri.parse("${base_api_app}api/v1/config/UpdateMemberLanguage");
  // "${baseurl_home}api/Translation/UpdateMemberLanguage/type/value");
  var json = jsonEncode({
    "RepCode": mrepCode,
    "RepSeq": mrepSeq,
    "RepType": mUserType,
    "Device": device,
    "TokenID": mToken,
    "Lang": mLanguage
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;
  // print(jsonResponse.toString());
  return jsonResponse;
}

// log Event
Future<String?> LogAppEventCall(
    String EventName,
    String paramBrand,
    String paramCampaign,
    String paramMedia,
    String paramPage,
    String paramBillCode,
    String paramBillName) async {
  SetData data = SetData(); //เรียกใช้ model
  var url;
  var device = await data.device;
  var mrepSeq = await data.repSeq;
  var mrepCode = await data.repCode;
  var mUserType = await data.repType;
  var menduserId = await data.enduserId;
  var mTokenApp = await data.tokenId;
  var mIMEI = await data.imei;

  // ตัวอย่าง
  // LogAppEventCall(EventName, paramBrand, paramCampaign, paramMedia, paramPage,
  //     paramBillCode, paramBillName);

  var json = jsonEncode({
    "Device": device,
    "UserType": mUserType,
    "UserId": mUserType == '2' || mUserType == '3' ? mrepSeq : menduserId,
    "RepCode": mrepCode,
    "RepSeq": mrepSeq,
    "Brand": paramBrand,
    "Campaign": paramCampaign,
    "Media": paramMedia,
    "Page": paramPage,
    "BillCode": paramBillCode,
    "BillName": paramBillName,
    "TokenApp": mTokenApp,
    "IMEI": mIMEI,
  });

  switch (EventName) {
    case "App_Open":
      url = Uri.parse("${apibackfriday}log/v1/friday/InsertLogAppOpen");
      // "${baseurl_home}api/YupinTrackEvent/InsertAppOpenController/type/value");
      break;
    case "Download_Catalog":
      url = Uri.parse("${apibackfriday}log/v1/friday/InsertLogDownloadCatalog");
      // "${baseurl_home}api/YupinTrackEvent/InsertDownloadCatalogController/type/value");
      break;
    case "view_list":
      url = Uri.parse("${apibackfriday}log/v1/friday/InsertLogViewList");
      // "${baseurl_home}api/YupinTrackEvent/InsertViewListController/type/value");
      break;
    // case "view_catalog":
    //   url = Uri.parse(
    //       "${baseurl_home}api/YupinTrackEvent/InsertViewCatalogController/type/value");
    //
    //   break;
    // case "View_Page":
    //   url = Uri.parse(
    //       "${baseurl_home}api/YupinTrackEvent/InsertViewPageController/type/value");
    //   break;
    // case "View_Product":
    //   url = Uri.parse(
    //       "${baseurl_home}api/YupinTrackEvent/InsertViewProductController/type/value");
    //   break;
  }

  try {
    var apiResponse = await http.post(url,
        headers: <String, String>{
          // 'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: json);
    var jsonResponse = apiResponse.body;
    print(jsonResponse.toString());
    print("Insert Log");
    return json;
  } catch (e) {
    print("Error Log " + e.toString());
  }
  return null;
}

// log cheer
Future logAppCheer(camp, status) async {
  SetData data = SetData(); //เรียกใช้ model
  var device = await data.device;
  var mrepSeq = await data.repSeq;
  var mrepCode = await data.repCode;
  var mUserType = await data.repType;
  var menduserId = await data.enduserId;
  var mlanguage = await data.language;

  var url = Uri.parse("${base_api_app}api/v1/salescheering/Logs");
  var json = jsonEncode({
    "rep_seq": mrepSeq,
    "order_campaign": camp,
    "status": status,
    "reptype": mUserType,
    "rep_code": mrepCode,
    "language": mlanguage,
    "UserID": menduserId,
    "Device": device
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;
  debugPrint(jsonResponse.toString());
  return jsonResponse;
}

// log cattalog view
Future insertLogViewPageSessions(
    channel, chanelId, camp, media, brand, page, duration) async {
  SetData data = SetData();
  var url = Uri.parse("${apibackfriday}log/v1/tis/InsertLogViewPageSessions");
  var json = jsonEncode({
    "Channel": channel,
    "ChannelId": chanelId,
    "CatalogCampaign": camp,
    "CatalogMedia": media,
    "Device": await data.device,
    "UserType": await data.repType,
    "RepSeq": await data.repSeq,
    "RepCode": await data.repCode,
    "Brand": brand,
    "Page": page,
    "Duration": duration
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;
  debugPrint(jsonResponse.toString());
  return jsonResponse;
}

//
Future insertClickLinkB2C(referringBrowser, referringId, deviceId) async {
  SetData data = SetData();

  var url = Uri.parse("https://app.friday.co.th/b2c/api/log/branch_referring");
  var json = jsonEncode({
    "cust_id": await data.b2cCustID,
    "referring_browser": referringBrowser,
    "referring_id": referringId,
    "identity_id": deviceId
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;
  return jsonResponse;
}
