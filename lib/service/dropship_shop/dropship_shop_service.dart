import 'dart:convert';
// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/model/set_data/set_data.dart';

import 'package:http/http.dart' as http;

import '../../model/cart/dropship/dropship_productdetail_model.dart';
import '../../model/dropship/dropship_banner_model.dart';
import '../../model/dropship/dropship_product_model.dart';
import '../../model/dropship/dropship_search_model.dart';
import '../../model/dropship/dropship_supplier_model.dart';
import '../pathapi.dart';

// dropship shop banner

Future<List<GetDropshipBanner>?> dropshipShop() async {
  try {
    SetData data = SetData();
    var url = Uri.parse('${base_api_app}api/v1/dropship/GetDropshipBanner');

    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "Deviec": await data.device,
      "Token": await data.tokenId,
      "Language": await data.language,
    });

    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      List<GetDropshipBanner> bannerDropship = getDropshipBannerFromJson(json);
      return bannerDropship;
    }

    //? call เพื่อโชว?เทส
  } catch (e) {
    return null;
  }
  return null;
}

//? dropship product
Future<List<GetDropshipCategoryProduct>?> dropshipProductbyCategory() async {
  try {
    SetData data = SetData();
    var url =
        Uri.parse('${base_api_app}api/v1/dropship/GetDropshipCategoryProduct');

    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "Deviec": await data.device,
      "Token": await data.tokenId,
      "Language": await data.language,
    });

    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      List<GetDropshipCategoryProduct> dropshipProduct =
          getDropshipCategoryProductFromJson(json);
      return dropshipProduct;
    }

    //? call เพื่อโชว?เทส
  } catch (e) {
    return null;
  }
  return null;
}

//? dropship product detail
Future<GetDropshipProductDetail?> getDropshipProductDetail(productCode) async {
  try {
    SetData data = SetData();
    var url =
        Uri.parse('${base_api_app}api/v1/dropship/GetDropshipProductDetail');

    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "Language": await data.language,
      "Deviec": await data.device,
      "Token": await data.tokenId,
      "ProductCode": productCode,
    });

    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);

    if (res.statusCode == 200) {
      final json = res.body;
      // printWhite(json);
      return getDropshipProductDetailFromJson(json);
      // return dropshipProduct;
    }

    //? call เพื่อโชว?เทส
  } catch (e) {
    return null;
  }
  return null;
  // return null;
}

//? dropship supplier
Future<GetDropshipProductBySupplier?> getDropshipProductSupplier(
    supplierCode) async {
  //GetDropshipProductBySupplier getDropshipProductBySupplierFromJson
  try {
    SetData data = SetData();
    var url = Uri.parse(
        '${base_api_app}api/v1/dropship/GetDropshipProductBySupplier');

    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "Language": await data.language,
      "Deviec": await data.device,
      "Token": await data.tokenId,
      "SupplierCode": supplierCode,
    });

    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      // printWhite(json);
      return getDropshipProductBySupplierFromJson(json);
      // return dropshipProduct;
    }
  } catch (e) {
    return null;
  }
  return null;
}

//? dropship search service
Future<List<GetDropshipSearchProduct>?> getDropshipSearchProduct(key) async {
  //GetDropshipProductBySupplier getDropshipProductBySupplierFromJson
  try {
    SetData data = SetData();
    var url =
        Uri.parse('${base_api_app}api/v1/dropship/GetDropshipSearchProduct');

    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "Language": await data.language,
      "Deviec": await data.device,
      "Token": await data.tokenId,
      "Keyword": key,
    });

    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      return getDropshipSearchProductFromJson(json);
      // return dropshipProduct;
    }
  } catch (e) {
    return null;
  }
  return null;
}
