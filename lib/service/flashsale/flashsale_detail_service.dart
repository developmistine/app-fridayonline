import 'dart:convert';

// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/model/set_data/set_data.dart';

import 'package:http/http.dart' as http;
import '../../model/flashsale/flashsale_detail.dart';
import '../pathapi.dart';

// !call flashsale page home
Future<FlashSaleDetailRun?> FlashsaleDetailService() async {
  try {
    SetData data = SetData();
    // var url = Uri.parse(
    //     "${baseurl_home}api/yupininitial/GetProductByflashsale/flashsale/dataid/3");
    var url = Uri.parse("${base_api_app}api/v1/product/GetProductFlashSale");
    var jsonInsert = jsonEncode({
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'RepSeq': await data.repSeq,
      "language": await data.language,
      "UserID": await data.enduserId,
      "Device": await data.device,
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
      final flashsaleDetail = flashSaleDetailRunFromJson(json);
      // log(flashsaleDetail.flashSale[0].product[0].percentnum.toString());
      return flashsaleDetail;
    }
  } catch (e) {
    return null;
  }
  return null;
}
