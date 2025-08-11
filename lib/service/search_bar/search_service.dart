// ignore: file_names
// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names, unused_element

import 'dart:convert';
// import 'dart:developer';

import 'package:fridayonline/model/search_bar/getkeyword.dart';
import 'package:fridayonline/model/search_bar/product_search.dart';
import 'package:fridayonline/model/search_bar/poppular_keys.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';

import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// !Call Search for Product
Future<List<KeySearch>?> SearchKeywords(text) async {
  try {
    SetData data = SetData();
    final url = Uri.parse("${base_api_app}api/v2/memberinfo/Search");
    // final url =
    //     Uri.parse("${baseurl_home}api/yupininitial/GetKeyWord/type/value");
    var jsonInsert = jsonEncode({
      "KeyWord": text,
      "UserType": await data.repType,
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "UserID": "",
      "language": await data.language,
    });
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (response.statusCode == 200) {
      ///data successfully
      final result = jsonDecode(response.body);

      final jsonString = jsonEncode(result['KeySearch']['KeySearchs']);
      if (result['KeySearch']['KeySearchs'] == null) {
        List<KeySearch> getKeyWord = KeySearchFromJson(jsonEncode([]));
        return getKeyWord;
      } else {
        List<KeySearch> getKeyWord = KeySearchFromJson(jsonString);
        return getKeyWord;
      }
    } else {
      ///error
    }
  } catch (e) {
    print('Error while getting data is xxx $e');
  }
}

// !Call Change to product
Future<ProductSearch?> Product_search(text) async {
  try {
    SetData data = SetData();
    if (text.toString().isNotEmpty) {
      final url = Uri.parse("${base_api_app}api/v2/memberinfo/SearchByKey");
      // final url = Uri.parse(
      //     "${baseurl_home}api/GetCategory/GetProductGroupByKeySearch/type/value");
      var jsonInsert = jsonEncode({
        "SessionId": await data.sessionId,
        "RepName": await data.repName,
        "Channel": "app",
        "DeviceType": await data.device,
        "DeviceToken": await data.tokenId,
        "KeyWord": text,
        "UserType": await data.repType,
        "RepSeq": await data.repSeq,
        "RepCode": await data.repCode,
        "UserID": "",
        "language": await data.language,
        "Device": await data.device,
      });
      var response = await http.post(url,
          headers: <String, String>{
            'Authorization': 'Bearer $apiToken',
            'Content-type': 'application/json; charset=utf-8'
          },
          body: jsonInsert);

      if (response.statusCode == 200) {
        ///data successfully
        final result = response.body;

        ProductSearch DataSearch = productSearchFromJson(result);
        return DataSearch;
      } else {
        ///error
      }
    }
  } catch (e) {
    print('Error while getting data sssss is $e');
  }
}

// !Call Popular Search
Future<PoppularKeys?> SearchPopular() async {
  // bool isDataLoading;

  try {
    SetData data = SetData();
    // isDataLoading = false;
    final url =
        Uri.parse("${base_api_app}api/v1/memberinfo/Search/PopularWords");
    // final url = Uri.parse(
    //     "${baseurl_home}api/yupininitial/GetKeyPopularlist/type/value");
    var jsonInsert = jsonEncode({
      "RepType": await data.repType,
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "language": await data.language,
    });
    var response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (response.statusCode == 200) {
      ///data successfully
      final result = response.body;

      PoppularKeys getKeyWord = poppularKeysFromJson(result);
      return getKeyWord;
    } else {
      ///error
    }
  } catch (e) {
    print('Error while getting data is $e');
  } finally {
    // isDataLoading = true;
  }
}
