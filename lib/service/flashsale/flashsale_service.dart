import 'dart:convert';
// import 'dart:developer';
// import 'package:fridayonline/homepage/flashsale/flashsale_home.dart';
import 'package:fridayonline/model/set_data/set_data.dart';

import 'package:http/http.dart' as http;

import '../../model/flashsale/flashsale.dart';
import '../pathapi.dart';

// !call flashsale page home
Future<Flashsale?> FlashsaleHomeService() async {
  try {
    SetData data = SetData();
    var url = Uri.parse("${base_api_app}api/v1/contentinfo/GetFlashSale");

    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "language": await data.language,
      "UserID": await data.enduserId,
    });
    // mock json
    //? call จริง
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      final flashsaleHome = flashsaleFromJson(json);
      return flashsaleHome;
    }
    return null;

    //? call เพื่อโชว?เทส
  } catch (e) {
    var json = jsonEncode({
      "RepCode": "",
      "RepType": "2",
      "RepSeq": "5486041",
      "TextHeader": null,
      "Menu": null,
      "Announce": null,
      "Banner": null,
      "Favorite": null,
      "FlashSale": [],
      "SpecialPromotion": null,
      "NewProduct": null,
      "Content": null,
      "BestSeller": null,
      "HotItem": null
    });
    final flashsaleHome = flashsaleFromJson(json);
    // log(flashsaleHome.toJson().toString());
    return flashsaleHome;
  }
}
