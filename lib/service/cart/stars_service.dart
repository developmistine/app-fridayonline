import 'dart:convert';
// import 'dart:developer';

// import 'package:fridayonline/model/cart/point_member.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cart/star_model.dart';
import '../../model/set_data/set_data.dart';

// ? controller for call point or starrewards
Future<StarReward?> GetStar() async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/cart/EnduserUsePoint");
    var jsonInsert = jsonEncode({
      "RepSeq": await data.enduserId,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
    });
    // log(jsonInsert);
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      // log(json);
      StarReward startMember = starRewardFromJson(json);
      return startMember;
    }
  } catch (e) {
    print("erroor point is $e");
  }
  return null;
}
