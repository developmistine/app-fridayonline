// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:convert';
import 'package:fridayonline/model/home/banner_image.dart';
import 'package:fridayonline/model/home/banner_product.dart';
import 'package:fridayonline/model/home/favorite.dart';
import 'package:fridayonline/model/home/favorite_product.dart';
import 'package:fridayonline/model/home/product_hot_item.dart';
import 'package:fridayonline/model/home/product_hot_item_loadmore.dart';
// import 'package:fridayonline/model/home/special_discount.dart';
import 'package:fridayonline/model/home/special_promotion.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

import '../../model/home/draggable_fab_model.dart';
import '../../model/home/hoem_get_point.dart';
import '../../model/home/home_new_content.dart';
import '../../model/home/home_special_project.dart';
import '../../model/home/keyIcon.dart';
import '../../model/home/popup_promotion_model.dart';
// import '../../model/home/special_discount_loadmore.dart';
import '../../model/set_data/set_data.dart';

Future<SpecialPromotion> call_special_promotion() async {
  SetData data = SetData(); //เรียกใช้ model

  try {
    var url = Uri.parse("${base_api_app}api/v1/contentinfo/Promotion");
    // var url =
    //     Uri.parse("${baseurl_home}api/Homepage/GetProccmotion/type/value");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'UserID': await data.enduserId,
      'language': await data.language,
      'Device': await data.device
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer ${apiToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    // print(jsonResponse);
    SpecialPromotion promotion = specialPromotionFromJson(jsonResponse);

    return promotion;
  } catch (e) {
    print('Error call_special_promotion => $e');
    var json = jsonEncode({"SpecialPromotion": []});
    SpecialPromotion promotion = specialPromotionFromJson(json);
    return promotion;
  }
}

// Future<SpecialDiscount> call_special_discount() async {
//   SetData data = SetData(); //เรียกใช้ model

//   try {
//     var url = Uri.parse("${baseurl_home}api/Homepage/GetContent/type/value");
//     var jsonData = jsonEncode({
//       'RepSeq': await data.repSeq,
//       'RepCode': await data.repCode,
//       'RepType': await data.repType,
//       'UserID': await data.enduserId,
//       'language': await data.language,
//       'Device': await data.device
//     });

//     var jsonCall = await http.post(url,
//         headers: <String, String>{
//           'Content-type': 'application/json; charset=utf-8'
//         },
//         body: jsonData);
//     var jsonResponse = jsonCall.body;
//     // log(jsonResponse);
//     SpecialDiscount content = specialDiscountFromJson(jsonResponse);
//     return content;
//   } catch (e) {
//     print('Error call_special_promotion => $e');
//     var json = jsonEncode({
//       "RepCode": "",
//       "RepType": "",
//       "RepSeq": "",
//       "TextHeader": "",
//       "Menu": null,
//       "Announce": null,
//       "Banner": null,
//       "Favorite": null,
//       "FlashSale": null,
//       "SpecialPromotion": null,
//       "NewProduct": null,
//       "Content": [],
//       "BestSeller": null,
//       "HotItem": null
//     });
//     SpecialDiscount content = specialDiscountFromJson(json);
//     return content;
//   }
// }

// Future<SpecialProductLoadMore> call_specialdiscount_loadmore() async {
//   print('3');
//   SetData data = SetData(); //เรียกใช้ model
//   var url = Uri.parse("${baseurl_home}api/Homepage/SeeMoreContent/type/value");
//   var jsonData = jsonEncode({
//     'RepSeq': await data.repSeq,
//     'RepCode': await data.repCode,
//     'RepType': await data.repType,
//     'UserID': await data.enduserId,
//     'language': await data.language,
//     'Device': await data.device
//   });
//   var jsonCall = await http.post(url,
//       headers: <String, String>{
//         'Content-type': 'application/json; charset=utf-8'
//       },
//       body: jsonData);
//   var jsonResponse = jsonCall.body;
//   SpecialProductLoadMore content = specialProductLoadMoreFromJson(jsonResponse);
//   return content;
// }

Future<HomeBanner> call_banner_image() async {
  SetData data = SetData(); //เรียกใช้ model

  try {
    var url = Uri.parse("${base_api_app}api/v1/contentinfo/Banner");
    //var url = Uri.parse("${baseurl_home}api/Homepage/GetBanner/type/value");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'UserID': await data.enduserId,
      'language': await data.language,
      'Device': await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer ${apiToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    HomeBanner banner = homeBannerFromJson(jsonResponse);
    return banner;
  } catch (e) {
    print('Error function >>call_banner_image<< is $e');
    var json = jsonEncode({"Banner": []});
    HomeBanner banner = homeBannerFromJson(json);
    return banner;
  }
}

Future<ProductHotItem> call_first_load_product_hotitem() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/contentinfo/Hotitem");
    //var url = Uri.parse("${baseurl_home}api/Homepage/GetHotItem/type/value");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'UserID': await data.enduserId,
      'language': await data.language,
      'Device': await data.device
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer ${apiToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    ProductHotItem hotItem = productHotItemFromJson(jsonResponse);
    return hotItem;
  } catch (e) {
    print('Error function >>call_banner_image<< is $e');
    var json = jsonEncode({"HotItem": []});
    ProductHotItem hotItem = productHotItemFromJson(json);
    return hotItem;
  }
}

Future<ProductHotItemLoadmore> call_load_more_product_hotitem() async {
  SetData data = SetData(); //เรียกใช้ model
  var url = Uri.parse("${base_api_app}api/v1/contentinfo/HotItemLoadMore");
  //var url = Uri.parse("${baseurl_home}api/Homepage/HotItemLoadMore/type/value");
  var jsonData = jsonEncode({
    'RepSeq': await data.repSeq,
    'RepCode': await data.repCode,
    'RepType': await data.repType,
    'UserID': await data.enduserId,
    'language': await data.language,
    'Device': await data.device
  });

  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer ${apiToken}',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  ProductHotItemLoadmore hotItemLoadmore =
      productHotItemLoadmoreFromJson(jsonResponse);
  return hotItemLoadmore;
  //log(hotItem!.hotItem[0].dataSqlHotitemsDetail[0].image.toString());
}

// ! banner product

Future<GetProductByCategoryBanner?> call_product_banner(
    categoryID, campaign) async {
  SetData data = SetData(); //เรียกใช้ model

  var url = Uri.parse("${base_api_app}api/v1/product/CategorybyId");

  try {
    var jsonData = jsonEncode({
      "TokenID": await data.tokenId,
      "Device": await data.device,
      "RefID": await data.repSeq,
      "RefType": await data.repType,
      "RefCode": await data.repCode,
      "CategoryID": categoryID,
      "campaign": campaign
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    // printWhite("is CategorybyId");
    GetProductByCategoryBanner bannerProduct =
        getProductByCategoryBannerFromJson(jsonResponse);
    // printWhite(jsonEncode(bannerProduct));
    return bannerProduct;
  } catch (e) {
    print("error is ${e.toString()}");
  }
  return null;
}

// ! favorite items
Future<GetFavorite?> call_favorite_items() async {
  SetData data = SetData(); //เรียกใช้ model
  var url = Uri.parse("${base_api_app}api/v1/contentinfo/Favorite");
  //var url = Uri.parse("${baseurl_home}api/Homepage/GetFavorite/type/value");
  try {
    var jsonData = jsonEncode({
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "UserID": await data.enduserId,
      "device": await data.device,
      "language": await data.language,
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer ${apiToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    if (jsonCall.statusCode == 200) {
      var jsonResponse = jsonCall.body;
      GetFavorite favoriteItems = getFavoriteFromJson(jsonResponse);
      // log("favoriteItems is ${favoriteItems.favorite.length.toString()} item");
      return favoriteItems;
    } else {
      return null;
    }
  } catch (e) {
    print("error in favorite is ${e}");
    var json = jsonEncode({
      "RepCode": "",
      "RepType": "",
      "RepSeq": "",
      "TextHeader": null,
      "Menu": null,
      "Announce": null,
      "Banner": null,
      "Favorite": [],
      "FlashSale": null,
      "SpecialPromotion": null,
      "NewProduct": null,
      "Content": null,
      "BestSeller": null,
      "HotItem": null
    });
    GetFavorite favoriteItems = getFavoriteFromJson(json);
    return favoriteItems;
  }
}

// ! favorite itens
Future<GetFavoriteProduct?> call_favorite_product(categoryID) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/contentinfo/FavoriteDetail");
    // var url =
    //     Uri.parse("${baseurl_home}api/Homepage/GetFavoriteProduct/type/value");

    var jsonData = jsonEncode({
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "UserID": await data.enduserId,
      "device": await data.device,
      "language": await data.language,
      "CategoryID": categoryID
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer ${apiToken}',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    if (jsonCall.statusCode == 200) {
      var jsonResponse = jsonCall.body;
      GetFavoriteProduct favoriteItems =
          getFavoriteProductFromJson(jsonResponse);
      return favoriteItems;
    }
  } catch (e) {
    print("error: $e");
  }
  return null;
}

// home pop-up
Future<PopUpMainHome> call_popup_data() async {
  SetData data = SetData(); //เรียกใช้ model api/v1/memberinfo/PopUp
  var url = Uri.parse("${base_api_app}api/v1/memberinfo/PopUp");
  // var url = Uri.parse(
  //     "${baseurl_yupinmodern}api/yupininitial/ShowPopTestModern/type/value");
  var jsonData = jsonEncode({
    'RepSeq': await data.repSeq,
    'RepCode': await data.repCode,
    'RepType': await data.repType,
    'UserID': await data.enduserId,
    'language': await data.language,
    'Device': await data.device,
    'TokenID': await data.tokenId
  });

  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  PopUpMainHome popUpItem = popUpMainHomeFromJson(jsonResponse);
  return popUpItem;
}

// home pop-up
Future<DraggableFabModel> call_draggable_fab() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/memberinfo/SmallPopUp");
    // var url = Uri.parse(
    //     "${baseurl_yupinmodern}api/yupininitial/GetDragPopUp/type/value");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      'TokenID': await data.tokenId,
      'Device': await data.device
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;

    DraggableFabModel popUpItem = draggableFabModelFromJson(jsonResponse);
    return popUpItem;
  } catch (e) {
    var json = jsonEncode({
      "ModernPopup": {
        "ShowType": "",
        "IndexName": "",
        "Member": "",
        "PopupList": [],
        "SurveyList": []
      }
    });
    DraggableFabModel popUpItem = draggableFabModelFromJson(json);
    return popUpItem;
  }
}

//? getKeyicon *** dev
Future<GetKeyIcon> call_key_icon() async {
  SetData data = SetData();
  var url = Uri.parse("${base_api_app}api/v1/contentinfo/KeyContent");
  //var url = Uri.parse("${baseurl_home}/api/Homeddpage/GetKeyIcon/type/value");
  var jsonData = jsonEncode({
    "RepSeq": await data.repSeq,
    "RepCode": await data.repCode,
    "RepType": await data.repType,
    "UserID": await data.enduserId,
    "device": await data.device,
    "language": await data.language
  });

  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer ${apiToken}',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  GetKeyIcon popUpItem = getKeyIconFromJson(jsonResponse);
  return popUpItem;
}

//? home get point
Future<HomeGetPoint> call_home_point(bool inShowPoint) async {
  SetData data = SetData();
  var url = Uri.parse("${base_api_app}api/v1/contentinfo/PointInfo");
  //var url = Uri.parse("${baseurl_home}/api/Homepage/GetPoint/type/value");
  var jsonData = jsonEncode({
    "RepSeq": await data.repSeq,
    "RepCode": await data.repCode,
    "RepType": await data.repType,
    "UserID": await data.enduserId,
    "device": await data.device,
    "language": await data.language,
    "IsShowPoint": inShowPoint
  });

  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer ${apiToken}',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  HomeGetPoint popUpItem = homeGetPointFromJson(jsonResponse);
  return popUpItem;
}

//? home special project
Future<HomeSpecialProjectModel> call_home_special_project() async {
  SetData data = SetData();
  var repcode = await data.repCode;
  var repseq = await data.repSeq;
  var url = Uri.parse("${base_api_app}api/v1/special/SpecialProjectList");

  var jsonData = jsonEncode({
    "RepSeq": await data.repSeq,
    "RepCode": await data.repCode,
    "RepType": await data.repType,
    "UserID": await data.enduserId,
    "device": await data.device,
    "language": await data.language,
  });
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer ${apiToken}',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);

  var jsonResponse = jsonCall.body;
  HomeSpecialProjectModel popUpItem =
      homeSpecialProjectModelFromJson(jsonResponse);
  return popUpItem;
}

//? home new content
Future<HomeNewContent> call_home_new_content(seemore) async {
  SetData data = SetData();
  var repcode = await data.repCode;
  var repseq = await data.repSeq;
  var url = Uri.parse("${base_api_app}api/v1/contentinfo/SpecialPromotion");
  // var url = Uri.parse(
  //     "${baseurl_home}api/Homepage/GetSpecialPromotionList/type/value");
  var jsonData = jsonEncode({
    "RepSeq": await data.repSeq,
    "RepCode": await data.repCode,
    "RepType": await data.repType,
    "UserID": await data.enduserId,
    "device": await data.device,
    "language": await data.language,
    "DataType": seemore
    // "RepSeq": "41",
    // "RepCode": "0999001406",
    // "RepType": "2",
    // "UserID": "",
    // "device": "android",
    // "language": "TH"
  });

  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer ${apiToken}',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  HomeNewContent homeNewContent = homeNewContentFromJson(jsonResponse);
  return homeNewContent;
}
