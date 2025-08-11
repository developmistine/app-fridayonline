import 'dart:convert';

import 'package:fridayonline/model/category/Catagory_group.dart';
import 'package:fridayonline/model/category/Category_Product.dart';
import 'package:fridayonline/model/category/Product_detail.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';

import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// !call group menu Category
Future<List<Groupcatelogy>?> Category_group_menu() async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/category/CategoryGroup");
    // var url =
    //     Uri.parse("${baseurl_home}api/GetCategory/GetCategoryGroup/type/value");

    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "language": await data.language
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final jsonString = jsonEncode(json['Menu'][0]['ChildrenData']);
      final catagoryGroup = groupcatelogyFromJson(jsonString);
      return catagoryGroup;
    }
  } catch (e) {
    print('Error Category_group_menu => $e');
    var json = jsonEncode([]);
    final catagoryGroup = groupcatelogyFromJson(json);
    return catagoryGroup;
  }
  return null;
}

// ! call product in group

Future<Listproduct?> Category_product_list(String id, String parent) async {
  try {
    SetData data = SetData();

    // isDataLoading(true);
    final url =
        Uri.parse("${base_api_app}api/v1/product/GetProductGroupCategory");
    // final url = Uri.parse(
    //     "${baseurl_home}api/GetCategory/GetProductGroupByCategory/type/value");
    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "language": await data.language,
      "UserID": "",
      "CategoryID": id,
      "SubCategoryID": parent,
    });
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;
      // log(result);
      var listproduct = listproductFromJson(result);
      return listproduct;
    } else {
      ///error
    }
  } catch (e) {
    print('Error while getting data is $e');
  } finally {
    // isDataLoading(false);
  }
  return null;
}

// !Call product detail
Future<ProductDetail?> Category_product_detail(
    campaign, billCode, brand, fsCode, channel, channelId, stock) async {
  try {
    SetData data = SetData();
    var extraType = "";
    var extraFlashStock = stock;
    var extraChannelid = channelId;
    var extraChannel = channel;

    var mUserType = await data.repType;
    var mrepSeq = await data.repSeq;
    var mrepCode = await data.repCode;
    var menduserId = await data.enduserId;
    var mlanguage = await data.language;
    var mdevice = await data.device;

    if (extraChannel == "3") {
      extraType = "FlashSale";
    } else {
      extraType = "";
    }

    final url = Uri.parse(
        // "${baseurl_home}api/ProductDetail/GetProductDetail/type/value");
        "${baseurl_home}api/ProductDetail/GetProductDetail/type/value");
    var jsonInsert = jsonEncode({
      'RepCode': mrepCode,
      'RepType': mUserType,
      'RepSeq': mUserType == '2' || mUserType == '3' ? mrepSeq : menduserId,
      "language": mlanguage,
      "campaign": campaign,
      "billCode": billCode,
      "brand": brand,
      "fsCode": fsCode,
      "typePage": extraType,
      "FlashStock": extraFlashStock,
      "Channel": extraChannel,
      "ChannelId": extraChannelid,
      "Device": mdevice
    });
    var response = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (response.statusCode == 200) {
      ///data successfully
      var result = response.body;
      var listproduct = productDetailFromJson(result);
      return listproduct;
    } else {
      ///error
    }
  } catch (e) {
    print('Error Category_product_detail is $e');
  }
  return null;
}
