import 'dart:convert';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/model/shartcat/shorturl.dart';

import 'package:http/http.dart' as http;
import '../pathapi.dart';

Future<SharecatshortUrl?> shareCatShorUrlService() async {
  try {
    SetData data = SetData();
    var url = Uri.parse("${base_api_app}api/v1/sharecat/shorturl");

    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepSeq': await data.repSeq,
      "Channel": "app"
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      final sharecatshortUrl = sharecatshortUrlFromJson(json);

      return sharecatshortUrl;
    }
    return null;

    //? call เพื่อโชว?เทส
  } catch (e) {
    return null;
  }
}
