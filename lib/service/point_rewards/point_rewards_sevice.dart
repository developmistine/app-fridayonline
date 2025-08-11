import 'dart:convert';

import 'package:fridayonline/model/point_rewards/point_confirm_redeem_cash.dart';

import '../../model/point_rewards/check_otp_point.dart';
import '../../model/point_rewards/otp_point.dart';
import '../../model/point_rewards/point_return_confirm_point.dart';
import '../../model/point_rewards/point_rewards_category_detail_by_fscode.dart';
import '../../model/point_rewards/point_rewards_get_category.dart';
import '../../model/point_rewards/point_rewards_get_category_detail_list.dart';
import '../../model/point_rewards/point_rewards_get_couponlist.dart';
import '../../model/point_rewards/point_rewards_get_msl_info.dart';
import '../../model/point_rewards/point_rewards_menu.dart';
import '../../model/set_data/set_data.dart';
import 'package:http/http.dart' as http;

import '../pathapi.dart';

//
Future<GetMslinfo?> GetMslInfoSevice() async {
  SetData data = SetData(); //เรียกใช้ model
  // print(await data.language);
  var mrepCode = await data.repCode;
  var mrepSeq = await data.repSeq;
  var mrepType = await data.repType;
  var mtokenId = await data.tokenId;

  Uri url;
  http.Response response;
  try {
    url = Uri.parse("${base_api_app}api/v1/pointreward/GetMslInfo");
    var jsonInsert = jsonEncode({
      "RepCode": mrepCode,
      "RepSeq": mrepSeq,
      "RepType": mrepType,
      "TokenId": mtokenId,
    });

    response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;
      var jsonString = jsonDecode(result);
      var jsonStringEnd = jsonEncode(jsonString);

      var pgetmslinfo = getMslinfoFromJson(jsonStringEnd);
      return pgetmslinfo;
    } else {
      ///error
    }
  } catch (e) {
    return null;
  }
  return null;
}

Future<Menupoint?> GetPointRewardsMenuCall() async {
  SetData data = SetData(); //เรียกใช้ model
  var mlanguage = await data.language;
  Uri url;
  http.Response response;
  try {
    url = Uri.parse("${base_api_app}api/v1/pointreward/GetHomePoint");
    var jsonInsert = jsonEncode({"language": mlanguage, "id": ""});

    response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;

      var jsonString = jsonDecode(result);
      var jsonStringEndcode = jsonEncode(jsonString);

      // log(jsonStringEndcode);

      var pPointRewardsMenu = menupointFromJson(jsonStringEndcode);
      // print(pPointRewardsMenu.datamenu[0].img);

      return pPointRewardsMenu;
    } else {
      ///error
    }
  } catch (e) {
    return null;
  }
  return null;
}

Future<Pointcategory?> GetPointCategoryCall() async {
  SetData data = SetData(); //เรียกใช้ model
  var mlrepSeq = await data.repSeq;
  http.Response response;
  try {
    // var url = Uri.parse(
    //     "${baseurl_yupinmodern}api/yupininitial/GroupByMedia/$mlrepSeq/dataid/Mediacode");

    var url =
        Uri.parse("${base_api_app}api/v1/pointreward/Home/GetProductByPoint");
    var jsonInsert = jsonEncode({"RepSeq": mlrepSeq});

    response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;

      var jsonString = jsonDecode(result);
      var jsonStringEndcode = jsonEncode(jsonString);

      //print(jsonStringEndcode);

      var pPointcategory = pointcategoryFromJson(jsonStringEndcode);
      // print(pPointRewardsMenu.datamenu[0].img);

      return pPointcategory;
    } else {
      ///error
    }
  } catch (e) {
    return null;
  }
  return null;
}

Future<Rewardscouponlist?> GetcouponlistCall() async {
  SetData data = SetData(); //เรียกใช้ model
  var mlrepSeq = await data.repSeq;
  var mlrepcode = await data.repCode;
  Uri url;
  try {
    url = Uri.parse("${base_api_app}api/v1/pointreward/GetMyCoupon");
    var jsonInsert = jsonEncode({"RepSeq": mlrepSeq, "RepCode": mlrepcode});

    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;

      // print(jsonStringEndcode);

      var prewardscouponlist = rewardscouponlistFromJson(result);
      // print(pPointRewardsMenu.datamenu[0].img);

      return prewardscouponlist;
    } else {
      ///error
    }
  } catch (e) {
    print(e);
    return null;
  }
  return null;
}

Future<Rewardsgetcategory?> GetCategoryDetailListCall({
  required String mparmId,
  required String mparmProintStart,
  required String mparmProintEnd,
  required String mparmTypeList,
}) async {
  SetData data = SetData(); //เรียกใช้ model
  var mlrepSeq = await data.repSeq;
  Uri url;
  http.Response response;
  try {
    if (mparmTypeList == "point") {
      url = Uri.parse("${base_api_app}api/v1/pointreward/GetProductByPoint");
      // url = Uri.parse(
      //     "${baseurl_yupinmodern}api/yupininitial/ProducGroupPoint/Listpoint/dataid");
      var jsonInsert = jsonEncode({
        "CategoryID": mparmId,
        "RepSeq": mlrepSeq,
        "ProintStart": int.parse(mparmProintStart),
        "ProintEnd": int.parse(mparmProintEnd)
      });

      response = await http.post(url,
          headers: <String, String>{
            'Authorization': 'Bearer $apiToken',
            'Content-type': 'application/json; charset=utf-8'
          },
          body: jsonInsert);
    } else {
      url =
          Uri.parse("${base_api_app}api/v1/pointreward/GetProductByCategoryID");
      // url = Uri.parse(
      //     "${baseurl_yupinmodern}api/yupininitial/ProducGroupPoint/Listpoint/dataid");
      var jsonInsert = jsonEncode({"RepSeq": mlrepSeq, "CategoryID": mparmId});

      response = await http.post(url,
          headers: <String, String>{
            'Authorization': 'Bearer $apiToken',
            'Content-type': 'application/json; charset=utf-8'
          },
          body: jsonInsert);
    }

    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;

      var jsonString = jsonDecode(result);
      var jsonStringEndcode = jsonEncode(jsonString);

      // print(jsonStringEndcode);

      var pRewardsgetcategory = rewardsgetcategoryFromJson(jsonStringEndcode);
      // print(pPointRewardsMenu.datamenu[0].img);

      return pRewardsgetcategory;
    } else {
      ///error
    }
  } catch (e) {
    print(e);
    return null;
  }
  return null;
}

Future<String?> UpdateUsecouponCall({
  required String mCouponCode,
}) async {
  SetData data = SetData(); //เรียกใช้ model
  var mlrepSeq = await data.repSeq;
  Uri url;
  http.Response response;
  try {
    url = Uri.parse("${base_api_app}api/v1/pointreward/UseCoupon");
    // url = Uri.parse(
    //     "${baseurl_yupinmodern}api/yupininitial/UpdateUsecoupon/Listpoint/dataid");
    var jsonInsert =
        jsonEncode({"RepSeq": mlrepSeq, "CouponCode": mCouponCode});

    response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;
      return result;
    } else {
      ///error
    }
  } catch (e) {
    return null;
  }
  return null;
}

//

Future<Rewardsgetcategory?> GetProductByKeySearchCall(value) async {
  SetData data = SetData(); //เรียกใช้ model
  var mlrepSeq = await data.repSeq;
  Uri url;
  http.Response response;
  try {
    // url = Uri.parse(
    //     "${baseurl_yupinmodern}api/yupininitial/UpdateUsecoupon/Listpoint/dataid");
    url = Uri.parse("${base_api_app}api/v1/pointreward/GetProductBySearch");
    var jsonInsert = jsonEncode({"RepSeq": mlrepSeq, "Key": value});

    response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;

      var jsonString = jsonDecode(result);
      var jsonStringEndcode = jsonEncode(jsonString);

      var pRewardsgetcategory = rewardsgetcategoryFromJson(jsonStringEndcode);

      return pRewardsgetcategory;
    } else {
      ///error
    }
  } catch (e) {
    return null;
  }
  return null;
}

Future<ProductByFscode?> GetProductByFscodeCall({
  required String mparmId,
}) async {
  SetData data = SetData(); //เรียกใช้ model
  var mlrepCode = await data.repCode;
  Uri url;
  http.Response response;
  try {
    // url = Uri.parse(
    //     "${baseurl_yupinmodern}api/yupininitial/ProductByFscode/$mlrepCode/dataid/$mparmId");

    url = Uri.parse("${base_api_app}api/v1/pointreward/GetProductByFscode");
    var jsonInsert = jsonEncode({"RepCode": mlrepCode, "FsCode": mparmId});

    response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;

      ProductByFscode pProductByFscode = productByFscodeFromJson(result);

      return pProductByFscode;
    }
  } catch (e) {
    print(e);
    return null;
  }
  return null;
}

Future<PointReturnConfirmPoint?> UseProinQtyCall(json) async {
  try {
    var url = Uri.parse("${base_api_app}api/v1/pointreward/ExchangeCoupon");
    // ${baseurl_yupinmodern}api/yupininitial/UseProinQty/Type/dataid");
    var jsonData = jsonEncode(json);

    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    // var js = jsonEncode({
    //   "Code": "100",
    //   "Message1": "คุณแลกคะแนนรางวัลเพื่อรับคูปองเติมน้ำ 1 ใบ ",
    //   "Message2": "กดใช้คูปองหรือตรวจสอบได้ที่ 'คูปองของฉัน' ",
    //   "PointUse": 250,
    //   "PointBalance": 32800
    // });

    // var jsonResponse = jsonCall.body;

    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;

      PointReturnConfirmPoint updateDetailEnduserResponse =
          pointReturnConfirmPointFromJson(result);
      return updateDetailEnduserResponse;
    }
  } catch (e) {
    print('Error function >>UseProinQtyCall in service folder<< is $e');
  }
  return null;
}

Future<OtpPoint?> otpPoint(tel, otpType) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/SmsOtp/Sent");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "language": await data.language,
      "Token": await data.tokenId,
      "TelNumber": tel,
      "Device": await data.device,
      "Chanel": "App",
      "OtpType": otpType
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    OtpPoint? response = otpPointFromJson(jsonResponse);
    return response;
  } catch (e) {
    print('Error otp point $e');
  }
  return null;
}

Future<CheckotpPoint?> checkOtpPoint(tel, otp) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/SmsOtp/Check");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "language": await data.language,
      "Token": await data.tokenId,
      "TelNumber": tel,
      "OTP": otp,
      "Device": await data.device,
      "Chanel": "App"
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    CheckotpPoint? response = checkotpPointFromJson(jsonResponse);
    return response;
  } catch (e) {
    print('Error otp point $e');
  }
  return null;
}

Future<PointRedeemcash?> confirmRedeemCash(json) async {
  try {
    var url = Uri.parse("${base_api_app}api/v1/pointreward/ConfirmRedeemCash");
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(json));
    if (response.statusCode == 200) {
      var result = response.body;

      final pointRedeemcash = pointRedeemcashFromJson(result);
      return pointRedeemcash;
    }
  } catch (e) {
    print('Error function >>UseProinQtyCall in service folder<< is $e');
  }
  return null;
}
