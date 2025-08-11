// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import '../../model/catelog/catelog_detail.dart';
import '../../model/catelog/catelog_ecatalog.dart';
import '../../model/catelog/catelog_hand_bill.dart';
import '../../model/catelog/catelog_list_product_by_page.dart';
import '../../model/set_data/set_data.dart';
import '../../service/pathapi.dart';
import 'package:http/http.dart' as http;

Future<CatelogEcatalogDetail> get_catelog_EcatalogDetail() async {
  SetData data = SetData(); //เรียกใช้ model

  try {
    var url = Uri.parse("${base_api_app}api/v1/catalogs/ViewCatalog");
    //var url = Uri.parse("${baseurl_home}api/ecatalog/ViewEcatalog/type/value");
    var jsonData = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "language": await data.language,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;

    CatelogEcatalogDetail catelog = catelogEcatalogDetailFromJson(jsonResponse);
    return catelog;
  } catch (e) {
    print('Error get_catelog_EcatalogDetail => $e');
    var json = jsonEncode({"EcatalogDetail": []});
    CatelogEcatalogDetail catelog = catelogEcatalogDetailFromJson(json);
    return catelog;
  }
}

Future<CatelogHandBillDetail> get_catelog_HendBillDetail() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/catalogs/ViewCatalog");
    //var url = Uri.parse("${baseurl_home}api/ecatalog/ViewEcatalog/type/value");
    var jsonData = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "language": await data.language,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;

    CatelogHandBillDetail catelog = catelogHandBillDetailFromJson(jsonResponse);
    return catelog;
  } catch (e) {
    print('Error get_catelog_HendBillDetail => $e');
    var json = jsonEncode({"HandBillDetail": []});
    CatelogHandBillDetail catelog = catelogHandBillDetailFromJson(json);
    return catelog;
  }
}

Future<CatelogDetail?> call_catelog_detail(
    CatalogCampaign, CatalogBrand, CatalogMedia) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/catalogs/ViewListPage");
    // var url =
    //     Uri.parse("$baseurl_home/api/ecatalog/ViewEcatalogDetail/type/value");
    var jsonData = jsonEncode({
      "RepCode": await data.repCode,
      "RepSeq": await data.repSeq,
      "Campaign": CatalogCampaign,
      "Brand": CatalogBrand,
      "RepType": await data.repType,
      "MediaCode": CatalogMedia,
      "language": await data.language,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    var catelogDetail = catelogDetailFromJson(jsonResponse);
    return catelogDetail;
  } catch (e) {
    print('Error >>call_catelog_detail<< is $e');
  }
  return null;
}

Future<CatalogListProductByPage?> call_catelog_list_product_by_page(
    PageDetail, Campaign, Brand, MediaCode) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/catalogs/ViewProductbyPage");
    // var url = Uri.parse(
    //     "$baseurl_home/api/ecatalog/ViewProductByPageECatalog/type/value");
    var jsonData = jsonEncode({
      "RepCode": await data.repCode,
      "RepSeq": await data.repSeq,
      "PageDetail": PageDetail,
      "Campaign": Campaign,
      "Brand": Brand,
      "RepType": await data.repType,
      "MediaCode": MediaCode,
      "language": await data.language,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    var catelogListProduct = catalogListProductByPageFromJson(jsonResponse);
    return catelogListProduct;
  } catch (e) {
    print('Error >>call_catelog_list_product_by_page<< is $e');
  }
  return null;
}
