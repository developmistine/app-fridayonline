import 'dart:convert';
import 'package:fridayonline/model/check_information/order/order_orderdetail_user_b2c.dart';

import '../../model/check_information/delivery_status/delivery_status.dart';
import '../../model/check_information/delivery_status/dropship_delivery_detail.dart';
import '../../model/check_information/delivery_status/getdropship_delivery_status.dart';
import '../../model/check_information/enduser/enduser_check_information.dart';
import '../../model/check_information/lead/lead_check_information.dart';
import '../../model/check_information/order/order_order_all.dart';
import '../../model/check_information/order/order_orderdetail_enduser.dart';
import '../../model/check_information/order/order_orderdetail_user.dart';
import '../../model/check_information/order/update_detail_response.dart';
import '../../model/check_information/order_history/order_histor_dropship.dart';
import '../../model/check_information/order_history/order_history_dropship_detail.dart';
import '../../model/check_information/order_history/order_history_enduser.dart';
import '../../model/check_information/order_history/order_history_msl.dart';
import '../../model/register/enduserinfo.dart';
import '../../model/set_data/set_data.dart';
import '../../service/pathapi.dart';

import 'package:http/http.dart' as http;

import '../profileuser/getenduserinfoprofile.dart';

Future<LeadCheckInformation?> call_lead_information() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/order/lead/GetOrder");
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/EndUsergetviewOrder/type/value");
    var jsonData = jsonEncode(
        {"UserID": await data.repSeq, "UserType": await data.repType});

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;

    LeadCheckInformation endUserCheck =
        leadCheckInformationFromJson(jsonResponse);

    return endUserCheck;
  } catch (e) {
    print('Error function >>call_information_order_orderdetail<< is $e');
  }
  return null;
}

Future<EnduserCheckInformation?> call_enduser_information() async {
  SetData data = SetData(); //เรียกใช้ model
  EndUserInfo UserInfo =
      await getProfileEnduser(await data.enduserId, await data.repSeq);
  try {
    // var url = Uri.parse("${base_api_app}api/v1/order/enduser/GetOrder");
    var url = Uri.parse("${base_api_app}api/v1/order/enduser/GetOrder");
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/EnduserHistoryOrder/type/value");
    var jsonData = jsonEncode({
      "UserID": await data.enduserId,
      "PhoneNumber": UserInfo.endUserInfo[0].infodetail[0].enduserTelNumber,
      "UserType": await data.repType,
      "RepCode": await data.repCode,
      "RepSeq": await data.repSeq,
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    // printWhite(jsonResponse);
    EnduserCheckInformation endUserCheck =
        enduserCheckInformationFromJson(jsonResponse);

    return endUserCheck;
  } catch (e) {
    print('Error function >>call_information_order_orderdetail<< is $e');
  }
  return null;
}

Future<CheckInformationOrderOrderAll?> call_information_order_order(
    repType) async {
  SetData data = SetData(); //เรียกใช้ model

  try {
    // var url = Uri.parse("${base_api_app}api/v2/order/msl/GetOrder");
    var url = Uri.parse("${base_api_app}api/v1/order/msl/GetOrder");
    // var url = Uri.parse(
    // "${baseurl_pathapi}api/apiserviceyupin/CustomerHistoryOrder/type/value");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': repType,
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
    CheckInformationOrderOrderAll informationOrderAll =
        checkInformationOrderOrderAllFromJson(jsonResponse);
    return informationOrderAll;
  } catch (e) {
    print('Error function >>call_information_order_orderdetail<< is $e');
  }
  return null;
}

Future<CheckInformationOrderOrderDetail?> call_information_order_orderdetail(
    orderDate, ordertype, userID, downloadflag, orderNo) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    // var url = Uri.parse("${base_api_app}api/v3/order/msl/GetOrderDetail");
    var url = Uri.parse("${base_api_app}api/v1/order/msl/OrderDetail");

    var jsonData = jsonEncode({
      "RepSeq": await data.repSeq,
      "OrderDate": orderDate,
      "OrderNo": orderNo,
      "Ordertype": ordertype,
      "UserID": userID,
      "Downloadflag": downloadflag,
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
    var orderDetail = checkInformationOrderOrderDetailFromJson(jsonResponse);

    return orderDetail;
  } catch (e) {
    print('Error function >>call_information_order_orderdetail<< is $e');
  }
  return null;
}

Future<CheckInformationOrderOrderDetailB2C?>
    call_information_order_orderdetail_b2c(orderNo, orderId, shopType) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    // var url = Uri.parse("${base_api_app}api/v1/order/msl/GetOrderDetail");
    var url = Uri.parse("${base_api_app}api/v1/order/msl/GetOrderDetail");

    var jsonData = jsonEncode({
      "rep_seq": await data.repSeq,
      "order_no": orderNo,
      "order_id": int.parse(orderId),
      "shop_type": int.parse(shopType),
      "device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    var orderDetail = checkInformationOrderOrderDetailB2CFromJson(jsonResponse);

    return orderDetail;
  } catch (e) {
    print('Error function >>call_information_order_orderdetail_b2c<< is $e');
  }
  return null;
}

Future<CheckInformationOrderOrderDetailEndUser?>
    call_information_order_orderdetail_enduser(userId, userTel, orderNo) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url =
        Uri.parse("${base_api_app}api/v3/order/msl/enduser/GetOrderDetail");
    // api/v3/order/msl/enduser/GetOrderDetail
    var jsonData = jsonEncode({
      "RepSeq": await data.repSeq,
      "RepCode": await data.repCode,
      "UserID": userId,
      "PhoneNumber": userTel,
      "OrderNo": orderNo,
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
    var orderDetailEnduser =
        checkInformationOrderOrderDetailEndUserFromJson(jsonResponse);
    return orderDetailEnduser;
  } catch (e) {
    print(
        'Error function >>call_information_order_orderdetail_enduser in service folder<< is $e');
  }
  return null;
}

Future<ResponseUpdateDetail?> call_information_order_orderdetail_msl_update(
    json) async {
  try {
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/UpdateDetailMSL/type/value");
    var url = Uri.parse("${base_api_app}api/v2/order/msl/UpdateOrderDetail");
    var jsonData = jsonEncode(json);

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;

    ResponseUpdateDetail updateMslResponse =
        responseUpdateDetailFromJson(jsonResponse);
    return updateMslResponse;
  } catch (e) {
    print(
        'Error function >>call_information_order_orderdetail_msl_update in service folder<< is $e');
  }
  return null;
}

Future<ResponseUpdateDetail?>
    call_information_order_orderdetail_approve_enduser_all(json) async {
  try {
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/ApproveEndUserByAll/type/value");
    var url =
        Uri.parse("${base_api_app}api/v1/order/msl/ApproveEndUserByOrderAll");
    var jsonData = jsonEncode(json);

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;

    ResponseUpdateDetail approveEnduserAllResponse =
        responseUpdateDetailFromJson(jsonResponse);
    return approveEnduserAllResponse;
  } catch (e) {
    print(
        'Error function >>call_information_order_orderdetail_approve_enduser_all in service folder<< is $e');
  }
  return null;
}

Future<ResponseUpdateDetail?>
    call_information_order_orderdetail_approve_enduser(json) async {
  try {
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/ApproveEndUserByOrder/type/value");
    var url =
        Uri.parse("${base_api_app}api/v1/order/msl/ApproveEndUserByOrder");
    var jsonData = jsonEncode(json);

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;

    ResponseUpdateDetail approveEnduserResponse =
        responseUpdateDetailFromJson(jsonResponse);
    return approveEnduserResponse;
  } catch (e) {
    print(
        'Error function >>call_information_order_orderdetail_approve_enduser in service folder<< is $e');
  }
  return null;
}

Future<ResponseUpdateDetail?>
    call_information_order_orderdetail_detail_enduser_update(json) async {
  try {
    var url =
        Uri.parse("${base_api_app}api/v1/order/enduser/ApproveDetailEndUser");
    var jsonData = jsonEncode(json);

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;

    ResponseUpdateDetail updateDetailEnduserResponse =
        responseUpdateDetailFromJson(jsonResponse);
    return updateDetailEnduserResponse;
  } catch (e) {
    print(
        'Error function >>call_information_order_orderdetail_detail_enduser_update in service folder<< is $e');
  }
  return null;
}

//ฟังก์ชันสำหรับ ลบข้อมูลรายละเอียดรายการสั่งซื้อ enduser
Future<ResponseUpdateDetail?>
    call_information_order_orderdetail_detail_enduser_delete(json) async {
  try {
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/UpdateDetailEndUser/type/value");
    var url =
        Uri.parse("${base_api_app}api/v1/order/enduser/DeleteOrderDetail");
    var jsonData = jsonEncode(json);

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;

    ResponseUpdateDetail updateDetailEnduserResponse =
        responseUpdateDetailFromJson(jsonResponse);
    return updateDetailEnduserResponse;
  } catch (e) {
    print(
        'Error function >>call_information_order_orderdetail_detail_enduser_delete in service folder<< is $e');
  }
  return null;
}

//ฟังก์ชันสำหรับ call ข้อมูลสถานะการสั่งซื้อ
Future<CheckInformationDeliveryStatus?>
    call_information_delivery_status() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/order/msl/GetTracking");
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/HistoryOrderInvMslLimit/type/value");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
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
    CheckInformationDeliveryStatus informationDeliveryStatus =
        checkInformationDeliveryStatusFromJson(jsonResponse);
    return informationDeliveryStatus;
  } catch (e) {
    print('Error function >>call_information_delivery_status<< is $e');
  }
  return null;
}

//ฟังก์ชันสำหรับ call ข้อมูลประวัติรายการสั่งซื้อ "ฉัน"
Future<List<OrderHistoryMsl>?> call_information_order_history_me() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/order/msl/GetHistory");
    var jsonData = jsonEncode({
      'rep_seq': await data.repSeq,
      'rep_code': await data.repCode,
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    List<OrderHistoryMsl>? informationOrderHistoryMe =
        orderHistoryMslFromJson(jsonResponse);

    return informationOrderHistoryMe;
  } catch (e) {
    print('Error function >>call_information_order_history_me<< is $e');
  }
  return null;
}

//ฟังก์ชันสำหรับ call ข้อมูลประวัติรายการสั่งซื้อ "ลูกค้า"
Future<GetHistoryEnduser?> call_information_order_history_enduser() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v2/order/msl/GetHistoryEnduser");
    // var url = Uri.parse("${base_api_app}api/v1/order/msl/GetHistory");
    var jsonData = jsonEncode(
        {"rep_seq": await data.repSeq, "rep_code": await data.repCode});
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    GetHistoryEnduser informationOrderHistoryEnduser =
        getHistoryEnduserFromJson(jsonResponse);

    return informationOrderHistoryEnduser;
  } catch (e) {
    print('Error function >>call_information_order_history_enuser<< is $e');
  }
  return null;
}

// //ฟังก์ชันสำหรับ call check limit product msl
// Future<CheckInformationOrderOrderDetailCheckProductLimit?>
//     call_information_product_limit_msl(
//         BillCode, Billcamp, Qty, QtyConfirm) async {
//   SetData data = SetData(); //เรียกใช้ model
//   try {
//     var url = Uri.parse(
//         "${baseurl_home}api/yupininitial/ItemOrderCompareEditMSLNew/type/value"); //สร้าง url link
//     var jsonData = jsonEncode({
//       "RepCode": await data.repCode,
//       "RepSeq": await data.repSeq,
//       "DetailIncart": [
//         {
//           "BillCode": BillCode,
//           "Billcamp": Billcamp,
//           "Qty": Qty,
//           "QtyConfirm": QtyConfirm
//         }
//       ]
//     }); //แปลงเป็น json

//     var jsonCall = await http.post(url,
//         headers: <String, String>{
//           'Content-type': 'application/json; charset=utf-8'
//         },
//         body: jsonData); //ทำการ call ข้อมูล
//     var jsonResponse = jsonCall.body;
//     CheckInformationOrderOrderDetailCheckProductLimit productLimit =
//         checkInformationOrderOrderDetailCheckProductLimitFromJson(
//             jsonResponse); //map ข้อมูลเข้ากับ model

//     return productLimit;
//   } catch (e) {
//     print('Error function >>call_information_product_limit_msl<< is $e');
//   }
//   return null;
// }

//ฟังก์ชันสำหรับ call check limit product enduser
// Future<CheckInformationOrderOrderDetailCheckProductLimit?>
//     call_information_product_limit_enduser(
//         BillCode, Billcamp, Qty, OrderNo) async {
//   SetData data = SetData(); //เรียกใช้ model

//   try {
//     //ตรวจสอบค่าว่าง
//     //กรณีไม่เป็นค่าว่าง
//     if (BillCode.toString().isNotEmpty) {
//       var url = Uri.parse(
//           "${baseurl_home}api/yupininitial/ItemOrderCompareEditEnduser/type/value"); //สร้าง url link
//       var jsonData = jsonEncode({
//         "RepCode": await data.repCode,
//         "RepSeq": await data.repSeq,
//         "DetailIncart": [
//           {
//             "BillCode": BillCode,
//             "Billcamp": Billcamp,
//             "Qty": Qty,
//           }
//         ],
//         "RepSeq": await data.repSeq,
//         "UserType": await data.repType,
//         "OrderNo": OrderNo,
//         "RepCode": await data.repCode
//       }); //แปลงเป็น json
//       var jsonCall = await http.post(url,
//           headers: <String, String>{
//             'Content-type': 'application/json; charset=utf-8'
//           },
//           body: jsonData); //ทำการ call ข้อมูล
//       var jsonResponse = jsonCall.body;
//       CheckInformationOrderOrderDetailCheckProductLimit productLimit =
//           checkInformationOrderOrderDetailCheckProductLimitFromJson(
//               jsonResponse); //map ข้อมูลเข้ากับ model
//       return productLimit;
//     }
//   } catch (e) {
//     print('Error function >>call_information_product_limit_enduser<< is $e');
//   }
//   return null;
// }

//ฟังก์ชันสำหรับ call ข้อมูลสถานะการสั่งซื้อ dropship
Future<List<GetDropshipDeliveryStatus>?>
    call_information_delivery_status_dropship() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url =
        Uri.parse("${base_api_app}api/v1/dropship/GetDropshipDeliveryStatus");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "Language": await data.language,
      "Token": await data.tokenId,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    List<GetDropshipDeliveryStatus>? informationDeliveryStatusDropship =
        getDropshipDeliveryStatusFromJson(jsonResponse);
    return informationDeliveryStatusDropship;
  } catch (e) {
    print('Error function >>call_information_delivery_status_dropship<< is $e');
  }
  return null;
}

//ฟังก์ชันสำหรับ call ข้อมูลสถานะการสั่งซื้อ dropship deatail
Future<DropshipDeliveryStatusDetail?> delivery_detail_status_dropship(
    OrderId, TrackingNo) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse(
        "${base_api_app}api/v1/dropship/GetDropshipDeliveryStatusDetail");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "Language": await data.language,
      "OrderId": OrderId,
      "TrackingNo": TrackingNo,
      "Token": await data.tokenId,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    DropshipDeliveryStatusDetail? informationDeliveryStatusDropship =
        dropshipDeliveryStatusDetailFromJson(jsonResponse);
    return informationDeliveryStatusDropship;
  } catch (e) {
    print('Error function >>call_information_delivery_status_dropship<< is $e');
  }
  return null;
}

//ฟังก์ชันสำหรับ call ข้อมูลประวัติการสั่งซื้อ dropship
// List<DropshipOrderHistory> dropshipOrderHistoryFromJson
Future<List<DropshipOrderHistory>?> call_history_dropship() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url =
        Uri.parse("${base_api_app}api/v1/dropship/GetDropshipOrderHistory");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "Language": await data.language,
      "Token": await data.tokenId,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    List<DropshipOrderHistory>? informationDeliveryStatusDropship =
        dropshipOrderHistoryFromJson(jsonResponse);
    return informationDeliveryStatusDropship;
  } catch (e) {
    print('Error function >>call_history_dropship<< is $e');
  }
  return null;
}

//ฟังก์ชันสำหรับ call ข้อมูลรายละเอียดการสั่งซื้อ dropship deatail

Future<DropshipOrderHistoryDetail?> delivery_detail_history_dropship(
    OrderId) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse(
        "${base_api_app}api/v1/dropship/GetDropshipOrderHistoryDetail");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      'RepCode': await data.repCode,
      'RepType': await data.repType,
      "Language": await data.language,
      "OrderId": OrderId,
      "Token": await data.tokenId,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    DropshipOrderHistoryDetail? informationDeliveryStatusDropship =
        dropshipOrderHistoryDetailFromJson(jsonResponse);
    return informationDeliveryStatusDropship;
  } catch (e) {
    print('Error function >>delivery_detail_history_dropship<< is $e');
  }
  return null;
}

Future<ResponseUpdateDetail?> fetchPopup(jsonInsert) async {
  var url = Uri.parse("${base_api_app}api/v1/order/msl/GetPopupUpdate");
  // var url = Uri.parse("${base_api_app}api/v1/order/msl/GetPopupUpdate");
  jsonInsert = jsonEncode(jsonInsert);
  var response = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonInsert);

  if (response.statusCode == 200) {
    // Successful response
    final jsonData = response.body;

    var jsonRes = responseUpdateDetailFromJson(jsonData);
    return jsonRes;
    // Do something with the data
  } else {
    // Handle the error
    print('Request failed with status: ${response.statusCode}.');
  }
  return null;
}
