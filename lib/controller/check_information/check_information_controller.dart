// ignore_for_file: non_constant_identifier_names

import 'package:fridayonline/model/check_information/enduser/enduser_check_information.dart';
import 'package:fridayonline/model/check_information/order/order_orderdetail_user_b2c.dart';
import 'package:fridayonline/model/check_information/order_history/order_history_enduser.dart';
import 'package:fridayonline/model/check_information/payment/get_payment_enduser.dart';
import 'package:fridayonline/model/check_information/payment/get_payment_msl.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/service/paymentsystem/payment.dart';

import '../../model/check_information/delivery_status/delivery_status.dart';
import '../../model/check_information/delivery_status/dropship_delivery_detail.dart';
import '../../model/check_information/order/order_order_all.dart';
import '../../model/check_information/order/order_orderdetail_enduser.dart';
import '../../model/check_information/order/order_orderdetail_user.dart';
import '../../model/check_information/order/order_orderdetail_check_productlimit.dart';
import '../../model/check_information/order/update_detail_response.dart';
import '../../model/check_information/order_history/get_history_invoice.dart';
// import '../../model/check_information/order_history/order_histor_dropship.dart';
import '../../model/check_information/order_history/order_history_dropship_detail.dart';
import '../../model/check_information/order_history/order_history_msl.dart';
import '../../service/check_information/check_information_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../service/return_product/return_product_sv.dart';

//controller สำหรับ set active tab bar
class SetSelectInformation extends GetxController {
  int? index; //เก็บค่า tapbar

  //ฟังก์ชันสำหรับ set active tab bar
  set_select_information(select) {
    index = select; //ให้ index = ค่าที่ส่งมา
  }
}

// controller สำหรับจัดการข้อมูลคำสั่งซื้อ
class CheckInformationOrderOrderAllController extends GetxController {
  CheckInformationOrderOrderAll?
      infornation_order_all; //เรียกใช้ model CheckInformationOrderOrderAll
  CheckInformationOrderOrderDetail?
      infornation_orderdetail; //เรียกใช้ model CheckInformationOrderOrderDetail
  CheckInformationOrderOrderDetailB2C?
      infornation_orderdetail_b2c; //เรียกใช้ model CheckInformationOrderOrderDetail
  CheckInformationOrderOrderDetailEndUser?
      infornation_orderdetail_enduser; //เรียกใช้ model CheckInformationOrderOrderDetailEndUser
  CheckInformationOrderOrderDetailCheckProductLimit?
      check_product_limit; //เรียกใช้ model CheckInformationOrderOrderDetailCheckProductLimit
  String? headerStatus; //ใช้เก็บค่า headerStatus ที่ส่งมา
  String? statusDiscription; //ใช้เก็บค่า statusDiscription ที่ส่งมา
  String? orderNo; //ใช้เก็บค่า orderNo ที่ส่งมา
  String? statusOrder; //ใช้เก็บค่า statusOrder ที่ส่งมา
  String? ordercamp; //ใช้เก็บค่า ordercamp ที่ส่งมา
  String? orderDate; //ใช้เก็บค่า orderDate ที่ส่งมา
  String? name; //ใช้เก็บค่า name ที่ส่งมา
  String? userId; //ใช้เก็บค่า userId ที่ส่งมา
  String? userTel; //ใช้เก็บค่า userTel ที่ส่งมา
  String? totalAmount; //ใช้เก็บค่า  ที่ส่งมา
  String? downloadflag; //ใช้เก็บค่า totalAmount ที่ส่งมา
  String? recieveType; //ใช้เก็บค่า recieveType ที่ส่งมา
  bool approve_all =
      false; //ใช้ไว้เก็บค่าที่ได้จากการตรวจสอบ สถานะ ลูกค้ารออนุมัติ ว่ามีไหม เพื่อซ่อน หรือ เปิดปุ่ม อนุมัติทั้งหมด
  List? msl_limit_check; //ใช้เก็บค่าของการตรวจสอบสินค้าที่จำกัดการสั่งซื้อ
  List? enduser_limit_check; //ใช้เก็บค่าของการตรวจสอบสินค้าที่จำกัดการสั่งซื้อ
  List? msl_check_update; //ใช้เก็บค่าของสินค้าที่มีการแก้ไข หรือ ไม่แก้ไข
  List? enduser_check_update; //ใช้เก็บค่าของสินค้าที่มีการแก้ไข หรือ ไม่แก้ไข
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  int shopType = 0;

  fetch_information_order_all() async {
    //ฟังก์ชันสำหรับเรีกข้อมูลการสั่งซื้อ "ทั้งหมด"
    approve_all = false; //ให้สถานะ ลูกค้ารออนุมัติ = false ไว้ก่อน
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      infornation_order_all = await call_information_order_order(
          '9'); //เรียกใช้งาน service สำหรับเรีกข้อมูลการสั่งซื้อ "ทั้งหมด"

      /***********************************/
      //วนลูปเช็กว่ามีรายการสั่งซื้อสถานะ ลูกค้ารออนุมัติ ไหม
      var i = 0;
      while (i <
          infornation_order_all!
              .customerOrderHistory.customerEndUserOrderDetail.length) {
        if (infornation_order_all!.customerOrderHistory
                .customerEndUserOrderDetail[i].statusOrder ==
            'N') {
          //ถ้ามีสถานะ ลูกค้ารออนุมัติ
          approve_all = true; //ให้สถานะ ลูกค้ารออนุมัติ = true
        }
        i++;
      }
      /***********************************/
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  fetch_information_order_wait_approve() async {
    //ฟังก์ชันสำหรับเรีกข้อมูลการสั่งซื้อ "ลูกค้ารออนุมัติ"
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      infornation_order_all = await call_information_order_order(
          '3'); //เรียกใช้งาน service สำหรับเรีกข้อมูลการสั่งซื้อ "ลูกค้ารออนุมัติ"
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  fetch_information_order_approve() async {
    //ฟังก์ชันสำหรับเรีกข้อมูลการสั่งซื้อ "ลูกค้าอนุมัติแล้ว"
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      infornation_order_all = await call_information_order_order(
          '1'); //เรียกใช้งาน service สำหรับเรีกข้อมูลการสั่งซื้อ "ลูกค้าอนุมัติแล้ว"
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  fetch_information_order_me() async {
    //ฟังก์ชันสำหรับเรีกข้อมูลการสั่งซื้อ "ฉัน"
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      infornation_order_all = await call_information_order_order(
          '2'); //เรียกใช้งาน service สำหรับเรีกข้อมูลการสั่งซื้อ "ฉัน"
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  fetch_information_order_orderdetail_b2c(Downloadflag, HeaderStatus,
      StatusDiscription, Ordercamp, orderNo, orderId, shopType) async {
    //ฟังก์ชันสำหรับเรีกข้อมูลรายละเอียดการสั่งซื้อ msl
    headerStatus = HeaderStatus;
    statusDiscription = StatusDiscription;
    ordercamp = Ordercamp;
    downloadflag = Downloadflag;
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      infornation_orderdetail_b2c = await call_information_order_orderdetail_b2c(
          orderNo,
          orderId,
          shopType); //เรียกใช้งาน service เรีกข้อมูลรายละเอียดการสั่งซื้อ msl
      // if (infornation_orderdetail_b2c != null) {
      //   //เช็คค่าว่าง

      //   /***********************/
      //   //วนลูปเซ็ต qty = qtyConfirm
      //   var i = 0;
      //   while (i < infornation_orderdetail_b2c!.orderDetail.length) {
      //     infornation_orderdetail!.orderDetail[i].qty = infornation_orderdetail!
      //         .orderDetail[i].qtyConfirm; //เซ็ต qty = qtyConfirm
      //     i++;
      //   }
      //   /***********************/

      //   msl_limit_check = List<String>.filled(
      //       infornation_orderdetail!.orderDetail.length,
      //       'false'); //ให้ array ของ limit_check ยาวเท่ากับ จำนวนของสินค้า listdetail และให้ค่าเริ่มต้นเป็น 'false'
      //   msl_check_update = List<bool>.filled(
      //       infornation_orderdetail!.orderDetail.length,
      //       false); //ให้ array ของ check_update ยาวเท่ากับ จำนวนของสินค้า listdetail และให้ค่าเริ่มต้นเป็น false
      // }
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  fetch_information_order_orderdetail(OrderDate, Ordertype, UserID,
      Downloadflag, HeaderStatus, StatusDiscription, Ordercamp, OrderNo) async {
    //ฟังก์ชันสำหรับเรีกข้อมูลรายละเอียดการสั่งซื้อ msl
    headerStatus = HeaderStatus;
    statusDiscription = StatusDiscription;
    ordercamp = Ordercamp;
    downloadflag = Downloadflag;
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      infornation_orderdetail = await call_information_order_orderdetail(
          OrderDate,
          Ordertype,
          UserID,
          Downloadflag,
          OrderNo); //เรียกใช้งาน service เรีกข้อมูลรายละเอียดการสั่งซื้อ msl

      if (infornation_orderdetail != null) {
        //เช็คค่าว่าง

        /***********************/
        //วนลูปเซ็ต qty = qtyConfirm
        var i = 0;
        while (i < infornation_orderdetail!.orderDetail.length) {
          infornation_orderdetail!.orderDetail[i].qty = infornation_orderdetail!
              .orderDetail[i].qtyConfirm; //เซ็ต qty = qtyConfirm
          i++;
        }
        /***********************/

        msl_limit_check = List<String>.filled(
            infornation_orderdetail!.orderDetail.length,
            'false'); //ให้ array ของ limit_check ยาวเท่ากับ จำนวนของสินค้า listdetail และให้ค่าเริ่มต้นเป็น 'false'
        msl_check_update = List<bool>.filled(
            infornation_orderdetail!.orderDetail.length,
            false); //ให้ array ของ check_update ยาวเท่ากับ จำนวนของสินค้า listdetail และให้ค่าเริ่มต้นเป็น false
      }
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  fetch_information_order_orderdetail_enduser(
      Downloadflag,
      HeaderStatus,
      StatusDiscription,
      StatusOrder,
      OrderDate,
      Name,
      Ordercamp,
      TotalAmount,
      UserId,
      UserTel,
      OrderNo,
      RecieveType,
      shopType) async {
    //ฟังก์ชันสำหรับเรีกข้อมูลรายละเอียดการสั่งซื้อ end user
    downloadflag = Downloadflag;
    headerStatus = HeaderStatus;
    statusDiscription = StatusDiscription;
    statusOrder = StatusOrder;
    orderDate = OrderDate;
    name = Name;
    userTel = UserTel;
    ordercamp = Ordercamp;
    totalAmount = TotalAmount;
    userId = UserId;
    orderNo = OrderNo;
    recieveType = RecieveType;
    shopType = int.parse(shopType);
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      infornation_orderdetail_enduser =
          await call_information_order_orderdetail_enduser(UserId, userTel,
              OrderNo); //เรียกใช้งาน service เรีกข้อมูลรายละเอียดการสั่งซื้อ end user
      if (infornation_orderdetail_enduser != null) {
        enduser_limit_check = List<String>.filled(
            infornation_orderdetail_enduser!.orderDetail.length,
            'false'); //ให้ array ของ limit_check ยาวเท่ากับ จำนวนของสินค้า listdetail และให้ค่าเริ่มต้นเป็น 'false'
        enduser_check_update = List<bool>.filled(
            infornation_orderdetail_enduser!.orderDetail.length,
            false); //ให้ array ของ check_update ยาวเท่ากับ จำนวนของสินค้า listdetail และให้ค่าเริ่มต้นเป็น false
      }
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

// controller สำหรับ call ข้อมูลสถานะการจัดส่ง
class CheckInformationDeliveryStatusController extends GetxController {
  CheckInformationDeliveryStatus?
      delivery_status; //เรียกใช้ model CheckInformationDeliveryStatus
  CheckInformationOrderOrderDetailB2C? delivery_orderdetail_b2c;

  DropshipDeliveryStatusDetail? response;
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  String? url_delivery_status_detail; //ใช้เก็บ url webviwe
  String? url_endcode; //ใช้เก็บ url webviwe หลัง encode

  String? headerStatus; //ใช้เก็บค่า headerStatus ที่ส่งมา
  String? statusDiscription; //ใช้เก็บค่า statusDiscription ที่ส่งมา
  String? orderNo; //ใช้เก็บค่า orderNo ที่ส่งมา
  String? statusOrder; //ใช้เก็บค่า statusOrder ที่ส่งมา
  String? ordercamp; //ใช้เก็บค่า ordercamp ที่ส่งมา
  String? downloadflag;

  //ฟังก์ชันสำหรับเรีกข้อมูลสถานะการจัดส่ง
  fetch_information_delivery_status() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      delivery_status =
          await call_information_delivery_status(); //เรียกใช้งาน service สำหรับ call ข้อมูลสถานะการจัดส่ง
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  fetch_enduser_sale_details(statusCode, orderId, invoice, campaign, billseq,
      saleCamp, shopType) async {
    String? repSeq;
    String? repCode;
    String? repType;
    String? endUserid;
    final Future<SharedPreferences> pref = SharedPreferences.getInstance();
    final SharedPreferences prefs = await pref;
    repSeq = prefs.getString("RepSeq"); //get ค่า RepSeq
    repCode = prefs.getString("RepCode"); //get ค่า RepCode
    repType = "1";
    endUserid = prefs.getString("EndUserID"); //get ค่า EndUserid
    var urlEnduserSaleDetails =
        "${shopMistine}st_order_enduser_b2c?repcode=$repCode&enduser_id=$endUserid&repseq=$repSeq&reptype=$repType&status=$statusCode&order_id=$orderId&trans_no=$invoice&campaign=$campaign&bill_seq=$billseq&salescamp=$saleCamp&shopType=$shopType&app=1";
    url_endcode =
        Uri.encodeFull(urlEnduserSaleDetails.toString()); //ทำการเข้ารหัส url
    // printWhite(url_endcode);
  }

  //ฟังก์ชันสำหรับเซ็ตข้อมูลเพื่อเรียก webviwe รายละเอียดสถานะการจัดส่ง
  fetch_information_delivery_status_detail(
      orderCampaign, invNo, billCamp, billSeq) async {
    String? RepSeq;
    String? RepCode;
    String? RepType;
    String? deviceName;

    final Future<SharedPreferences> pref = SharedPreferences.getInstance();
    final SharedPreferences prefs = await pref;

    RepSeq = prefs.getString("RepSeq"); //get ค่า RepSeq
    RepCode = prefs.getString("RepCode"); //get ค่า RepCode
    deviceName = prefs.getString("deviceName"); //get ค่า deviceName
    RepType = '2'; //เซ็ตค่า RepType เป็น 2
    if (invNo != "ใบสั่งซื้อ") {
      url_delivery_status_detail =
          "${shopMistine}st_tracking?repcode=$RepCode&repseq=$RepSeq&reptype=$RepType&campaign=$orderCampaign&orderno=$invNo&app=1&device=$deviceName";
    } else {
      url_delivery_status_detail =
          "${shopMistine}st_tracking_noinvoice?repcode=$RepCode&repseq=$RepSeq&reptype=$RepType&campaign=$orderCampaign&orderno=&app=1&device=$deviceName&billcamp=$billCamp&billseq=$billSeq";
    }

    url_endcode = Uri.encodeFull(
        url_delivery_status_detail.toString()); //ทำการเข้ารหัส url
    // printWhite(url_endcode);
  }

  detail_delivery_dropship(OrderId, TrackingNo) async {
    try {
      isDataLoading(true);
      response = await delivery_detail_status_dropship(OrderId, TrackingNo);
      update();
      return response;
    } finally {
      isDataLoading(false);
    }
  }

  fetch_information_delivery_orderdetail_b2c(orderNo, orderId, shopType) async {
    //ฟังก์ชันสำหรับเรีกข้อมูลรายละเอียดการสั่งซื้อ msl
    // headerStatus = HeaderStatus;
    // statusDiscription = StatusDiscription;
    // ordercamp = Ordercamp;
    // downloadflag = Downloadflag;
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      delivery_orderdetail_b2c = await call_information_order_orderdetail_b2c(
          orderNo,
          orderId,
          shopType); //เรียกใช้งาน service เรีกข้อมูลรายละเอียดการสั่งซื้อ msl
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

// controller สำหรับ call ข้อมูลประวัติรายการสั่งซื้อ
class CheckInformationOrderHistoryController extends GetxController {
  List<OrderHistoryMsl>?
      order_history_me; //เรียกใช้ model CheckInformationOrderHistoryMe
  GetHistoryEnduser? order_history_enduser;
  GetProductByInvioce? productByInvioce;
  DropshipOrderHistoryDetail? responseDropship;
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  var isDropshipLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  String? url_order_history_detail; //ใช้เก็บ url webviwe
  String? url_endcode; //ใช้เก็บ url webviwe หลัง encode

  //ฟังก์ชันสำหรับเรีกข้อมูลประวัติรายการสั่งซื้อ
  fetch_information_order_history_me() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      order_history_me =
          await call_information_order_history_me(); //เรียกใช้งาน service สำหรับ call ข้อมูลประวัติรายการสั่งซื้อ
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  // ประวัติการสั่งซื้อ EndUser
  fetch_order_history_enduser() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      order_history_enduser =
          await call_information_order_history_enduser(); //เรียกใช้งาน service สำหรับ call ข้อมูลประวัติรายการสั่งซื้อ
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  //ฟังก์ชันสำหรับเรีกข้อมูลประวัติรายการสั่งซื้อ
  fetch_detail_history_dropship(OrderId) async {
    try {
      isDropshipLoading(true); // สถานะการโหลดข้อมูล true
      responseDropship = await delivery_detail_history_dropship(
          OrderId); //เรียกใช้งาน service สำหรับ call ข้อมูลประวัติรายการสั่งซื้อ
    } finally {
      isDropshipLoading(false); // สถานะการโหลดข้อมูล false
      // update();
    }
  }

  //ฟังก์ชันสำหรับเซ็ตข้อมูลเพื่อเรียก webviwe รายละเอียดประวัติการสั่งซื้อ
  fetch_information_order_history_detail(
      orderNo, orderCampaign, saleCamp) async {
    String? RepSeq;
    String? RepCode;
    String? RepType;
    String? deviceName;
    final Future<SharedPreferences> pref = SharedPreferences.getInstance();
    final SharedPreferences prefs = await pref;

    RepSeq = prefs.getString("RepSeq"); //get ค่า RepSeq
    RepCode = prefs.getString("RepCode"); //get ค่า RepCode
    deviceName = prefs.getString("deviceName"); //get ค่า deviceName
    RepType = '2'; //เซ็ตค่า RepType เป็น 2
    // ignore: prefer_interpolation_to_compose_strings
    url_order_history_detail =
        "${shopMistine}st_history_msl?repCode=$RepCode&repSeq=$RepSeq&repType=$RepType&orderNo=$orderNo&endUserId=&transCamp=$orderCampaign&saleCamp=$saleCamp&device=$deviceName&app=1"; //ทำการต่อ url
    url_endcode =
        Uri.encodeFull(url_order_history_detail.toString()); //ทำการเข้ารหัส url
  }

  fetch_information_order_history_enduser_detail(
      orderNo, userId, orderCampaign, saleCampaign, status) async {
    String? RepSeq;
    String? RepCode;
    String? RepType;
    String? deviceName;
    final Future<SharedPreferences> pref = SharedPreferences.getInstance();
    final SharedPreferences prefs = await pref;

    RepSeq = prefs.getString("RepSeq"); //get ค่า RepSeq
    RepCode = prefs.getString("RepCode"); //get ค่า RepCode
    deviceName = prefs.getString("deviceName"); //get ค่า deviceName
    RepType = '2'; //เซ็ตค่า RepType เป็น 2
    url_order_history_detail =
        "${shopMistine}st_history_enduser?repcode=$RepCode&repseq=$RepSeq&reptype=$RepType&orderno=$orderNo&enduser_id=$userId&trans_camp=$orderCampaign&salescamp=$saleCampaign&device=$deviceName&app=1&status=$status"; //ทำการต่อ url
    url_endcode =
        Uri.encodeFull(url_order_history_detail.toString()); //ทำการเข้ารหัส url
    // printWhite(url_endcode);
  }
}

class ApproveOrderController extends GetxController {
  ResponseUpdateDetail? response;
  var isDataLoading = false.obs;
  call_approve_order_enduser(json, type) async {
    if (type == 'approve_all') {
      try {
        isDataLoading(true);
        response =
            await call_information_order_orderdetail_approve_enduser_all(json);
        update();
        return response;
      } finally {
        isDataLoading(false);
      }
    } else if (type == 'approve_item') {
      try {
        isDataLoading(true);

        response =
            await call_information_order_orderdetail_approve_enduser(json);
        update();
        return response;
      } finally {
        isDataLoading(false);
      }
    } else if (type == 'update_order') {
      try {
        isDataLoading(true);
        response =
            await call_information_order_orderdetail_detail_enduser_update(
                json);
        update();
        return response;
      } finally {
        isDataLoading(false);
      }
    } else if (type == 'update_approve') {
      try {
        isDataLoading(true);
        response =
            await call_information_order_orderdetail_detail_enduser_update(
                json);
        update();
        return response;
      } finally {
        isDataLoading(false);
      }
    }
  }

  call_approve_order_msl(json) async {
    try {
      isDataLoading(true);
      response = await call_information_order_orderdetail_msl_update(json);
      update();
      return response;
    } finally {
      isDataLoading(false);
    }
  }
}

class EndUserOrderCtr extends GetxController {
  EnduserCheckInformation? endUserOrder;
  var isDataLoading = false.obs;
  call_enduser_order() async {
    try {
      isDataLoading(true);
      endUserOrder = await call_enduser_information();
      update();
      return endUserOrder;
    } finally {
      isDataLoading(false);
    }
  }
}

class PayMentController extends GetxController {
  List<GetMslPayment>? getMslPayment;
  GetEnduserPayment? getEnduserPayment;
  var isDataLoading = false.obs;

  call_get_payment_msl() async {
    try {
      isDataLoading(true);
      getMslPayment = await getPaymentMsl();
      return getMslPayment;
    } finally {
      isDataLoading(false);
    }
  }

  call_get_payment_endUser() async {
    try {
      isDataLoading(true);
      getEnduserPayment = await getPaymentEndUser();
      return getMslPayment;
    } finally {
      isDataLoading(false);
    }
  }
}
