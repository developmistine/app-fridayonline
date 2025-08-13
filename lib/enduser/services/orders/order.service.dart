import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fridayonline/enduser/models/orders/bank.model.dart';
import 'package:fridayonline/enduser/models/orders/courier.model.dart';
import 'package:fridayonline/enduser/models/orders/orderdetail.checkout.model.dart';
import 'package:fridayonline/enduser/models/orders/orderdetail.model.dart';
import 'package:fridayonline/enduser/models/orders/orderheader.model.dart';
import 'package:fridayonline/enduser/models/orders/orderlist.checkout.model.dart';
import 'package:fridayonline/enduser/models/orders/orderlist.model.dart';
import 'package:fridayonline/enduser/models/orders/reason.model.dart';
import 'package:fridayonline/enduser/models/orders/reason.return.model.dart';
import 'package:fridayonline/enduser/utils/auth_fetch.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

Future<OrdersHeader?> fetchOrderHeadersService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/orders/header");

  try {
    var jsonCall = await AuthFetch.post(
      url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final ordersHeader = ordersHeaderFromJson(utf8.decode(jsonResponse));
      return ordersHeader;
    }
    return Future.error('Error get order header : api/v1/orders/header');
  } catch (e) {
    return Future.error('Error fetchOrderHeadersService : $e');
  }
}

Future<OrdersList?> fetchOrderListService(
    int orderType, int sellerId, int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/orders/list");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "order_type": orderType,
          "seller_id": sellerId,
          "limit": 20,
          "offset": offset
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final ordersList = ordersListFromJson(utf8.decode(jsonResponse));
      return ordersList;
    }
    return Future.error('Error get order list : api/v1/orders/list');
  } catch (e) {
    return Future.error('Error fetchOrderListService : $e');
  }
}

Future<OrdersListCheckOut?> fetchOrderListCheckOutService(
    int orderType, int offset) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/orders/list_checkout");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "order_type": orderType,
          "limit": 20,
          "offset": offset
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final ordersListCheckOut =
          ordersListCheckOutFromJson(utf8.decode(jsonResponse));
      return ordersListCheckOut;
    }
    return Future.error('Error get order list : api/v1/orders/list_checkout');
  } catch (e) {
    return Future.error('Error fetchOrderListCheckOutService : $e');
  }
}

Future<OrderDetail?> fetchOrderDetailService(int orderId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/orders/detail");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body:
            jsonEncode({"cust_id": await data.b2cCustID, "order_id": orderId}));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final orderDetail = orderDetailFromJson(utf8.decode(jsonResponse));
      // printJSON(orderDetail);

      return orderDetail;
    }
    return Future.error('Error get order detail : api/v1/orders/detail');
  } catch (e) {
    return Future.error('Error fetchOrderDetailService: $e');
  }
}

Future<OrderDetailCheckOut?> fetchOrderDetailCheckOutService(
    int orderId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/orders/detail_checkout");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "order_id": orderId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final orderDetailCheckOut =
          orderDetailCheckOutFromJson(utf8.decode(jsonResponse));

      return orderDetailCheckOut;
    }
    return Future.error(
        'Error get order detail : api/v1/orders/detail_checkout');
  } catch (e) {
    return Future.error('Error fetchOrderDetailCheckOutService: $e');
  }
}

Future updateOrderAddressServices(int orderId, int addressId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/orders/update_address");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "order_id": orderId,
          "addr_id": addressId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final orderDetailCheckOut = utf8.decode(jsonResponse);

      return jsonDecode(orderDetailCheckOut);
    }
    return Future.error(
        'Error get order detail : api/v1/orders/update_address');
  } catch (e) {
    return Future.error('Error updateOrderAddressServices: $e');
  }
}

Future updatePaymentServices(int orderId, String paymentType) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/orders/update_payment");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "order_id": orderId,
          "payment_type": paymentType
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final orderDetailCheckOut = utf8.decode(jsonResponse);

      return jsonDecode(orderDetailCheckOut);
    }
    return Future.error(
        'Error get order detail : api/v1/orders/update_address');
  } catch (e) {
    return Future.error('Error updateOrderAddressServices: $e');
  }
}

Future<CancelOrderReason> fetchCancelReasonOrdersService(int shopId) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/orders/cancel_reason");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "shop_id": shopId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final cancelOrderReason =
          cancelOrderReasonFromJson(utf8.decode(jsonResponse));
      return cancelOrderReason;
    }
    return Future.error(
        'Error fetchCancelReasonOrders : api/v1/orders/cancel_reason');
  } catch (e) {
    return Future.error(
        'Error fetchCancelReasonOrdersService api/v1/orders/cancel_reason: $e');
  }
}

Future<ReturnReason> fetchReturnReasonOrdersService() async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/orders/return_reason");

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "device": await data.device,
          "session_id": await data.sessionId
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final returnOrder = returnReasonFromJson(utf8.decode(jsonResponse));
      return returnOrder;
    }
    return Future.error(
        'Error fetchCancelReasonOrders : api/v1/orders/return_reason');
  } catch (e) {
    return Future.error(
        'Error fetchCancelReasonOrdersService api/v1/orders/return_reason: $e');
  }
}

Future<Bank> fetchBankService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/bank");

  try {
    var jsonCall = await AuthFetch.get(
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
      url,
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final bank = bankFromJson(utf8.decode(jsonResponse));

      return bank;
    }
    return Future.error('Error fetchBankService : api/v1/bank');
  } catch (e) {
    return Future.error('Error fetchBankService api/v1/bank: $e');
  }
}

Future<Courier> fetchCourierService() async {
  var url = Uri.parse("${b2c_api_url}api/v1/courier");

  try {
    var jsonCall = await AuthFetch.get(
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
      url,
    );
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final courier = courierFromJson(utf8.decode(jsonResponse));

      return courier;
    }
    return Future.error('Error fetchCourierService : api/v1/courier');
  } catch (e) {
    return Future.error('Error fetchCourierService api/v1/courier: $e');
  }
}

Future<Response?> submitReturnSaveService({
  required Map<String, dynamic> json,
  required List<File> images,
  File? video,
}) async {
  var url = Uri.parse("${b2c_api_url}api/v1/orders/return_save");
  try {
    // 🔹 เพิ่มข้อมูลรีวิว (แปลงเป็น JSON)
    Map<String, dynamic> reviewData = json;
    Map<String, String> fields = {
      'return': jsonEncode(reviewData),
    };

    List<http.MultipartFile> files = [];

    if (video != null) {
      files.add(
        await http.MultipartFile.fromPath(
          'video', // ชื่อ video_{itemId}
          video.path.replaceAll("file://", ""),
        ),
      );
    }

    // 🔹 แนบไฟล์รูปภาพ
    for (var image in images) {
      files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );
    }

    // 🔹 ส่งคำขอไปยัง API
    // ใช้ AuthFetch สำหรับ multipart request
    var response = await AuthFetch.multipartRequestWithAuth(
      url, // แปลง Uri เป็น String
      method: 'POST',
      headers: {
        'Content-Type': 'multipart/form-data',
      },
      fields: fields,
      files: files,
    );

    // 🔹 อ่าน response body
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final response = responseFromJson(responseBody);
      return response;
    }
    return Future.error(
        'Error chat submitReturnSaveService : api/v1/orders/return_save');
  } catch (e) {
    print("❗ เกิดข้อผิดพลาด: $e");
    return null;
  }
}

Future<Response?> submitReturnUpdateInfoService({
  required Map<String, dynamic> json,
  required List<File> images,
}) async {
  var url = Uri.parse("${base_api_app}api/v1/orders/return_update_info");
  try {
    Map<String, dynamic> reviewData = json;
    Map<String, String> fields = {
      'return': jsonEncode(reviewData),
    };

    List<http.MultipartFile> files = [];

    fields['return'] = jsonEncode(reviewData);

    // 🔹 แนบไฟล์รูปภาพ (รองรับหลายไฟล์ต่อ item_id)
    for (var image in images) {
      files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );
    }

    // 🔹 ส่งคำขอไปยัง API
    // ใช้ AuthFetch สำหรับ multipart request
    var response = await AuthFetch.multipartRequestWithAuth(
      url, // แปลง Uri เป็น String
      method: 'POST',
      headers: {
        'Content-Type': 'multipart/form-data',
      },
      fields: fields,
      files: files,
    );

    // 🔹 อ่าน response body
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final response = responseFromJson(responseBody);
      return response;
    }
    return Future.error(
        'Error chat submitReturnUpdateInfoService : api/v1/orders/return_update_info');
  } catch (e) {
    print("❗ เกิดข้อผิดพลาด: $e");
    return null;
  }
}

Future<SaveReason> saveCancelOrderService(
  int orderId,
  int cancelId,
  String note,
) async {
  SetData data = SetData();
  var url = Uri.parse("${b2c_api_url}api/v1/orders/cancel");
  if (note == "checkout") {
    url = Uri.parse("${b2c_api_url}api/v1/orders/cancel_checkout");
  }

  try {
    var jsonCall = await AuthFetch.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonEncode({
          "cust_id": await data.b2cCustID,
          "order_id": orderId,
          "cancel_id": cancelId,
          "note": note,
          "device": await data.device
        }));
    if (jsonCall.statusCode == 200) {
      Uint8List jsonResponse = jsonCall.bodyBytes;
      final saveReason = saveReasonFromJson(utf8.decode(jsonResponse));

      return saveReason;
    }
    return Future.error('Error saveCancelOrderService : api/v1/orders/cancel');
  } catch (e) {
    return Future.error(
        'Error saveCancelOrderService api/v1/orders/cancel: $e');
  }
}

SaveReason saveReasonFromJson(String str) =>
    SaveReason.fromJson(json.decode(str));

String saveReasonToJson(SaveReason data) => json.encode(data.toJson());

class SaveReason {
  String code;
  String message;

  SaveReason({
    required this.code,
    required this.message,
  });

  factory SaveReason.fromJson(Map<String, dynamic> json) => SaveReason(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  String code;
  String message;

  Response({
    required this.code,
    required this.message,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
