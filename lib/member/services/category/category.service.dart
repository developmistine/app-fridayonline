import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/member/models/category/filter.model.dart';
import 'package:fridayonline/member/models/category/home.category.model.dart';
import 'package:fridayonline/member/models/category/sort.model.dart';
import 'package:fridayonline/member/models/category/subcategory.model.dart';
import 'package:fridayonline/member/utils/auth_fetch.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';

Future<HomeCategory?> fetchHomeCategoryService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/home/categories");

  try {
    var jsonCall = await AuthFetch.get(
      url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final homeCategory = homeCategoryFromJson(utf8.decode(jsonResponse));
      return homeCategory;
    }
    return Future.error('Error get home content : api/v1/home/categories');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<Sort?> fetchSortService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/products/sorts");

  try {
    var jsonCall = await AuthFetch.get(
      url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final sort = sortFromJson(utf8.decode(jsonResponse));
      return sort;
    }
    return Future.error('Error get home content : api/v1/products/sorts');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<SubCategorie?> fetchSubCategoryService(int catId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/home/sub_categories");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "cat_id": catId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final subCategorie = subCategorieFromJson(utf8.decode(jsonResponse));
      return subCategorie;
    }
    return Future.error('Error get home content : api/v1/home/sub_categorie');
  } catch (e) {
    return Future.error('Error: $e');
  }
}

Future<ProductsFilter?> fetchFilterProductCategoryService(int catId,
    int subCatId, String sortBy, String order, int limit, int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/products/filter");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "cat_id": catId,
          "subcat_id": subCatId,
          "sort_by": sortBy,
          "order": order,
          "limit": 40,
          "offset": offset
        }));

    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final productsFilter = productsFilterFromJson(utf8.decode(jsonResponse));
      return productsFilter;
    }
    return Future.error('Error get product filter : api/v1/products/filter');
  } catch (e) {
    return Future.error('Error: $e');
  }
}
