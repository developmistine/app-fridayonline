import 'dart:convert';
import 'dart:typed_data';

import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/models/cart/cart.bundle.model.dart';
import 'package:fridayonline/member/models/cart/cart.checkcon.model.dart';
import 'package:fridayonline/member/models/cart/cart.checkout.dart';
import 'package:fridayonline/member/models/cart/cart.checkout.input.dart';
import 'package:fridayonline/member/models/cart/cart.update.input.dart';
import 'package:fridayonline/member/models/cart/cart.update.output.dart';
import 'package:fridayonline/member/models/cart/getcart.model.dart';
import 'package:fridayonline/member/utils/auth_fetch.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:get/get.dart';

Future<ResponseCart?> addToCartService(
    int shopId, int productId, int itemId, int qty, int action) async {
  SetData data = SetData();

  var url = Uri.parse("${b2c_api_url}api/v1/cart/add");
  var trackData = Get.find<TrackCtr>();
  print("content id add to cart : ${trackData.contentId}");
  print("cotent type add to cart : ${trackData.contentType}");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "content_id": trackData.contentId,
          "content_type": trackData.contentType,
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "product_id": productId,
          "item_id": itemId,
          "qty": qty,
          "action": action,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final addCart = addtoCartresponseFromJson(utf8.decode(jsonResponse));
      return addCart;
    }
    return Future.error('Error addToCart : api/v1/cart/add');
  } catch (e) {
    return Future.error('Error: addToCart $e');
  }
}

Future<ResponseCart?> updateOptionCartService(int shopId, int productId,
    int itemId, int newItemId, int qty, int action) async {
  SetData data = SetData();

  var url = Uri.parse("${b2c_api_url}api/v1/cart/add");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId,
          "product_id": productId,
          "item_id": itemId,
          "new_item_id": newItemId == itemId ? 0 : newItemId,
          "qty": qty,
          "action": action,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final addCart = addtoCartresponseFromJson(utf8.decode(jsonResponse));
      return addCart;
    }
    return Future.error('Error updateOptionCartService : api/v1/cart/add');
  } catch (e) {
    return Future.error('Error: updateOptionCartService $e');
  }
}

Future<GetCartItems> getCartService() async {
  SetData data = SetData();

  var url = Uri.parse("${b2c_api_url}api/v1/cart/get");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final cartItems = getCartItemsFromJson(utf8.decode(jsonResponse));
      return cartItems;
    }
    return Future.error('Error get cart : api/v1/cart/get');
  } catch (e) {
    return Future.error('Error: getCartService() $e');
  }
}

Future<ResponseCart?> deleteCartService(List<int> cartId) async {
  SetData data = SetData();

  var url = Uri.parse("${b2c_api_url}api/v1/cart/delete");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "cart_id": cartId,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final deleteCart = addtoCartresponseFromJson(utf8.decode(jsonResponse));
      return deleteCart;
    }
    return Future.error('Error delete cart : api/v1/cart/delete');
  } catch (e) {
    return Future.error('Error: deleteCartService $e');
  }
}

Future<UpdateCartOutput?> updateCartService(UpdateCartInput updateInput) async {
  var url = Uri.parse("${b2c_api_url}api/v1/cart/update");
  // printWhite(jsonEncode(updateInput));
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(updateInput));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final updateCartOutput =
          updateCartOutputFromJson(utf8.decode(jsonResponse));

      return updateCartOutput;
    }
    return Future.error('Error update cart : api/v1/cart/update');
  } catch (e) {
    return Future.error('Error: updateCartService $e');
  }
}

Future<CartCheckOut> cartCheckOutService(
    CartCheckOutInput checkOutInput) async {
  printWhite(jsonEncode(checkOutInput));
  var url = Uri.parse("${b2c_api_url}api/v1/cart/checkout");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(checkOutInput));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final cartCheckOut = cartCheckOutFromJson(utf8.decode(jsonResponse));

      return cartCheckOut;
    }
    return Future.error('Error checkout cart : api/v1/cart/chekcout');
  } catch (e) {
    return Future.error('Error: cartCheckOutService $e');
  }
}

Future<CheckCon> cartCheckConService(CartCheckOutInput checkConInput) async {
  // printJSON(checkConInput);
  var url = Uri.parse("${b2c_api_url}api/v1/cart/check_con");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(checkConInput));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final checkCon = checkConFromJson(utf8.decode(jsonResponse));
      // printWhite(checkCon.code);
      return checkCon;
    }
    return Future.error('Error checkout cart : api/v1/cart/check_con');
  } catch (e) {
    return Future.error('Error: cartCheckConService $e');
  }
}

Future<ResponseCart> cartConfirmService(payload) async {
  var url = Uri.parse("${b2c_api_url}api/v1/cart/confirm");
  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: payload);
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final cartConfirm = addtoCartresponseFromJson(utf8.decode(jsonResponse));

      return cartConfirm;
    }
    return Future.error('Error confirm cart : api/v1/cart/confirm');
  } catch (e) {
    return Future.error('Error: cartConfirmService $e');
  }
}

Future<BundleDeal> getBundelDealService(int bundleId, int offset) async {
  SetData data = SetData();

  var url = Uri.parse("${b2c_api_url}api/v1/products/bundle_deal");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "bundle_deal_id": bundleId,
          "limit": 40,
          "offset": offset,
          "device": await data.device,
          "session_id": await data.sessionId,
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final bundleDeal = bundleDealFromJson(utf8.decode(jsonResponse));
      return bundleDeal;
    }
    return Future.error('Error get cart : api/v1/products/bundle_deal');
  } catch (e) {
    return Future.error('Error: getBundelDealService() $e');
  }
}

ResponseCart addtoCartresponseFromJson(String str) =>
    ResponseCart.fromJson(json.decode(str));

String addtoCartresponseToJson(ResponseCart data) => json.encode(data.toJson());

class ResponseCart {
  String code;
  String message;
  int orderId;

  ResponseCart({
    required this.code,
    required this.message,
    required this.orderId,
  });

  factory ResponseCart.fromJson(Map<String, dynamic> json) => ResponseCart(
        code: json["code"],
        message: json["message"],
        orderId: json["order_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "order_id": orderId,
      };
}
