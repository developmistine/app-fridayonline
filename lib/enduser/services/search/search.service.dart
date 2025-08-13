import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/search/search.suggest.model.dart';
import 'package:fridayonline/enduser/models/search/serach.hint.model.dart';
import 'package:fridayonline/enduser/models/showproduct/product.category.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';

import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SearchHint?> searchHintService(String keyword) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/products/search_hint");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "keyword": keyword,
          "device": await data.device,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final searchHint = searchHintFromJson(utf8.decode(jsonResponse));
      return searchHint;
    }
    return Future.error('Error search : api/v1/products/search_hint');
  } catch (e) {
    return Future.error('Error searchHintService : $e');
  }
}

Future<ProductContent?> searchItemService(
    String keyword, int offset, String order, String sortBy) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/products/search_item");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "keyword": keyword,
          "device": await data.device,
          "offset": offset,
          "limit": 20,
          "order": order,
          "sort_by": sortBy,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final searchItem = productContentFromJson(utf8.decode(jsonResponse));
      return searchItem;
    }
    return Future.error('Error search : api/v1/products/search_item');
  } catch (e) {
    return Future.error('Error searchItemService : $e');
  }
}

Future<SearchSuggest?> searchSuggestService(int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/products/search_suggest");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "offset": offset,
          "limit": 20,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final searchSuggest = searchSuggestFromJson(utf8.decode(jsonResponse));
      return searchSuggest;
    }
    return Future.error('Error search : api/v1/products/search_suggest');
  } catch (e) {
    return Future.error('Error searchItemService : $e');
  }
}

Future<void> saveSearchHistoryService(String newSearch) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // ดึงประวัติการค้นหาปัจจุบันออกมา
  List<String> currentHistory = prefs.getStringList('search_history') ?? [];

  // ลบคำเดิมออกก่อน (เพื่อให้คำใหม่อยู่ด้านบนสุด)
  currentHistory.remove(newSearch);

  // เพิ่มคำค้นหาล่าสุดเข้าไปที่ตำแหน่งแรก
  currentHistory.insert(0, newSearch);

  // ตัดให้เหลือ 10 รายการล่าสุด
  List<String> latest10 = currentHistory.length > 10
      ? currentHistory.sublist(0, 10)
      : currentHistory;
  // บันทึกประวัติใหม่ลงไป
  await prefs.setStringList('search_history', latest10);
}

Future<List<String>> getSearchHistoryService() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // ดึงข้อมูลที่เก็บไว้และแปลงจาก String กลับเป็น List<String>
  List<String>? historyString = prefs.getStringList('search_history');
  if (historyString != null && historyString.isNotEmpty) {
    return historyString;
  }
  return []; // ถ้าไม่มีข้อมูล
}
