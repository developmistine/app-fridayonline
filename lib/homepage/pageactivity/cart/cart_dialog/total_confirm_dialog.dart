import 'package:fridayonline/controller/address/address_controller.dart';
import 'package:fridayonline/controller/cart/cart_address_enduser_controller.dart';
import 'package:fridayonline/controller/cart/coupon_discount_controller.dart';
import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_dialog/success_bottom.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_dialog/success_bottom_enduser.dart';
import 'package:fridayonline/model/address/address_list.dart';
import 'package:fridayonline/model/cart/enduser/enduser_save_order.dart'
    as enduser_save_order;
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/cart/enduser/enduser_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../controller/cart/cart_address_controller.dart';
import '../../../../controller/cart/cart_controller.dart';
import '../../../../controller/cart/delivery_controller.dart';
import '../../../../controller/cart/point_controller.dart';
import '../../../../model/cart/dropship/drop_ship_address.dart';
import '../../../../model/cart/dropship/dropship_confirm.dart';
import '../../../../model/cart/enduser/enduser_address.dart';
import '../../../../model/cart/order_end_user.dart';
import '../../../../service/cart/dropship/dropship_address_service.dart';
import '../../../../service/cart/popup_cart/getMessage_info_service.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../theme/theme_color.dart';
import '../cart_theme/cart_all_theme.dart';
import 'popupcheer_pagetotal.dart';

FetchPointMember cDiscount = FetchPointMember();
final ctrAddress = Get.find<FetchCartEndUsersAddress>();
final ctrCoupon = Get.find<FetchCouponDiscount>();
final controller = Get.find<FetchCartItemsController>();
FetchDeliveryChange deliveryData = Get.find<FetchDeliveryChange>();

Future showDialogConfirm(
  context,
  FetchCartItemsController controller,
  FetchCartDropshipController dropship,
  String? typeUser,
) {
  int supplierDeliveryPrice = controller.supplierDelivery.values
      .map((e) => e.detailDelivery[0].price)
      .toList()
      .fold(0, (previousValue, element) => previousValue + int.parse(element));
  final suplierProductPrice = controller.itemsCartList!.cardHeader.carddetailB2C
      .expand((e) => e.carddetail.map((e) => e.amount))
      .toList()
      .fold(0.0, (previousValue, element) => previousValue + element);

  var ctx =
      context; //? ตัวแปรรับ context context เพื่อปิด popup ก่อนเปิด bottome sheet
  String totalAmount = '0';
  String totalItems = controller.itemsCartList!.cardHeader.totalitem.toString();
  String totalItemsAllShop = (controller.itemsCartList!.cardHeader.totalitem +
          controller.itemsCartList!.cardHeader.carddetailB2C
              .map((e) => e.carddetail)
              .length)
      .toString();
  String totalDiscount = '0';
  String discountCoupon = '0';
  List<CouponDiscount>? couponDiscountID = [];

  for (var element in ctrCoupon.listCoupon) {
    couponDiscountID.add(CouponDiscount(couponId: element.id));
  }

  return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            actionsPadding:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            title: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                                width: 63,
                                'assets/images/home/friday_logo.png'),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                'สินค้ารอบการขาย ${controller.itemsCartList!.cardHeader.campaign}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: boldText),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('รวมสินค้าทั้งหมด',
                                style: TextStyle(
                                    height: 2,
                                    fontSize: 16,
                                    color: theme_grey_text,
                                    fontWeight: FontWeight.normal)),
                            Text(
                              "x $totalItemsAllShop รายการ",
                              style: TextStyle(
                                  height: 2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: theme_grey_text),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (typeUser == '2')
                              Text("ค่าจัดส่ง",
                                  style: TextStyle(
                                      height: 2,
                                      fontSize: 16,
                                      color: theme_grey_text,
                                      fontWeight: FontWeight.normal))
                            else if ((typeUser == '1' &&
                                    ctrAddress.selectedAddress.value == 0) ||
                                supplierDeliveryPrice > 0)
                              Text(
                                "ค่าจัดส่ง",
                                style: TextStyle(
                                    height: 2,
                                    fontSize: 16,
                                    color: theme_grey_text,
                                    fontWeight: FontWeight.normal),
                              ),
                            if (typeUser == '2' &&
                                controller.itemsCartList!.cardHeader.carddetail
                                    .isNotEmpty)
                              Text(
                                  '${myFormat.format(double.parse(deliveryData.isChange!.detailDelivery![deliveryData.indexChange.value].price) + supplierDeliveryPrice)} บาท',
                                  style: TextStyle(
                                      height: 2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: theme_grey_text))
                            else if (typeUser == '1' &&
                                ctrAddress.selectedAddress.value == 0 &&
                                controller.itemsCartList!.cardHeader.carddetail
                                    .isNotEmpty)
                              Text(
                                  '${myFormat.format(double.parse(deliveryData.isChange!.detailDelivery![deliveryData.indexChange.value].price) + supplierDeliveryPrice)} บาท',
                                  style: TextStyle(
                                      height: 2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: theme_grey_text))
                            else
                              Text('${supplierDeliveryPrice.obs} บาท',
                                  style: TextStyle(
                                      height: 2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: theme_grey_text))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ส่วนลดทั้งหมด',
                                style: TextStyle(
                                    height: 2,
                                    fontSize: 16,
                                    color: theme_grey_text,
                                    fontWeight: FontWeight.normal)),
                            GetX<FetchPointMember>(
                              builder: (discount) {
                                totalDiscount =
                                    discount.discount.value.toString();
                                discountCoupon =
                                    discount.disCouponPrice.value.toString();
                                double sumDiscount =
                                    double.parse(totalDiscount) +
                                        double.parse(discountCoupon);
                                return Text(
                                    '- ${myFormat.format(sumDiscount)} บาท',
                                    style: TextStyle(
                                        height: 2,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: theme_red));
                              },
                            ),
                          ],
                        ),
                        // if (1 < 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('รวมเป็นเงิน',
                                style: TextStyle(
                                    height: 2,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            if (typeUser == '2' ||
                                (typeUser == '1' &&
                                    ctrAddress.selectedAddress.value == 0))
                              GetBuilder<FetchDeliveryChange>(
                                  builder: (delivery) {
                                return GetX<FetchPointMember>(
                                    builder: (discount) {
                                  var fridayDeliveryPrice = double.parse(
                                      delivery
                                          .isChange!
                                          .detailDelivery![
                                              delivery.indexChange.value]
                                          .price);
                                  if (controller.itemsCartList!.cardHeader
                                      .carddetail.isEmpty) {
                                    fridayDeliveryPrice = 0.0;
                                  }
                                  double totalPrice = (fridayDeliveryPrice +
                                          controller.itemsCartList!.cardHeader
                                              .totalAmount +
                                          suplierProductPrice +
                                          supplierDeliveryPrice) -
                                      discount.discount.value -
                                      discount.disCouponPrice.value;
                                  return Text(
                                      totalPrice > 0
                                          ? '${myFormat.format(totalPrice)} บาท'
                                          : "0 บาท",
                                      style: const TextStyle(
                                          height: 2,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold));
                                });
                              })
                            else
                              GetBuilder<FetchDeliveryChange>(
                                  builder: (delivery) {
                                return GetX<FetchPointMember>(
                                    builder: (discount) {
                                  var sumAmount = myFormat.format((controller
                                              .itemsCartList!
                                              .cardHeader
                                              .totalAmount +
                                          suplierProductPrice +
                                          supplierDeliveryPrice) -
                                      discount.discount.value -
                                      discount.disCouponPrice.value);
                                  return Text('$sumAmount บาท',
                                      style: const TextStyle(
                                          height: 2,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold));
                                });
                              }),
                          ],
                        ),
                        if (typeUser != '1')
                          // !v16
                          Text(
                              textAlign: TextAlign.start,
                              'คาดว่าจะได้รับใน ${controller.itemsCartList!.cardHeader.deliveryDate}',
                              style: TextStyle(
                                  height: 2,
                                  fontSize: 16,
                                  fontWeight: boldText)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            content: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: GetX<FetchCartNotiAddress>(builder: (noti) {
                return noti.isDataLoading.value
                    ? const SizedBox()
                    : typeUser == '1'
                        ? Text(
                            'หมายเหตุ : ${ctrAddress.selectedAddress.value == 0 ? 'ท่านสามารถดูสถานะได้ที่ข้อมูลสั่งซื้อในหน้าฉัน' : 'ติดตามสถานะสินค้าและชำระเงิน กับสมาชิกผู้ขายของท่าน'}',
                            style: TextStyle(
                                color: theme_red,
                                fontSize: 15,
                                fontWeight: boldText),
                          )
                        : Text(
                            'หมายเหตุ : ${noti.addressCart!.detail}',
                            style: TextStyle(
                                color: theme_red,
                                fontSize: 14,
                                fontWeight: boldText),
                          );
              }),
            ),
            actions: <Widget>[
              MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              style: BorderStyle.solid, color: theme_red),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text(
                          MultiLanguages.of(context)!.translate('alert_cancel'),
                          style: TextStyle(
                              color: theme_red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            // success_bottomsheet(context);
                            if (typeUser != "2") {
                              totalAmount = myFormat.format(controller
                                      .itemsCartList!.cardHeader.totalAmount +
                                  suplierProductPrice);
                            }
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            backgroundColor: theme_color_df,
                          ),
                          child: Text(
                            MultiLanguages.of(context)!
                                .translate('alert_confirm'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          )).then((value) async {
    // กรณีที่ออกโดยไม่กดปุ่ม
    if (value == null) return;
    // กรณีที่กดยืนยัน
    if (value) {
      // final msladdress = await GetMslInfoSevice();
      var poupcheer = await getMessageInfo(2, totalAmount);
      DropshipGetAddress? infoAddress = await getDropshipAddress();
      EndUserAddress? endUserAddress = await getEnduserAddress();

      if (poupcheer!.showMessage.toLowerCase() == 'y') {
        showPopupCheerPageTotal(
            ctx,
            deliveryData,
            totalItems,
            totalAmount,
            couponDiscountID,
            totalDiscount,
            poupcheer,
            controller,
            dropship,
            typeUser,
            infoAddress,
            endUserAddress);
      } else {
        if (typeUser == '2') {
          saveOrderTotal(
              ctx,
              controller,
              dropship,
              deliveryData,
              totalItems,
              totalDiscount,
              couponDiscountID,
              totalAmount,
              typeUser,
              infoAddress!);
        } else {
          saveOrderTotalEndUser(
              ctx,
              controller,
              dropship,
              deliveryData,
              totalItems,
              totalDiscount,
              couponDiscountID,
              totalAmount,
              typeUser,
              infoAddress!,
              endUserAddress!);
        }
      }
    }
  });
}

//? function เตรียข้อมูลและ save order
void saveOrderTotal(
    context,
    FetchCartItemsController controller,
    FetchCartDropshipController dropship,
    FetchDeliveryChange deliveryData,
    totalItems,
    totalDiscount,
    couponDiscountID,
    totalAmount,
    typeUser,
    DropshipGetAddress infoAddress) async {
  SetData data = SetData();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Datum? addressSaveOrder = Get.find<AddressController>().addressMslSaveOrder;
  prefs.setBool("popUpCheer", true);
  var discountCal = 0;
  var typeUsers = typeUser;
  var repseq = await data.repSeq;
  var repname = await data.repName; //name type 2
  var reptel = await data.repTel; //tel type 2
  var device = await data.device;
  var language = await data.language;
  var repcode = await data.repCode;

  //? end user information
  var telEndUsers = await data.telEndUsers;
  var nameEndUsers = await data.nameEndUsers;
  var surNameEndUsers = await data.surNameEndUsers;

  //? ตัวแปรสำหรับเก็บค่าก่อน confirm
  OrderEndUserClass? dataOrder; //? order direcsale
  DropshipConfirmOrder? dataOrderDropship; //? order dropship

  if (controller.itemsCartList!.cardHeader.carddetail.isNotEmpty ||
      controller.itemsCartList!.cardHeader.carddetailB2C.isNotEmpty) {
    if (typeUsers == '2') {
      discountCal = 5; // type 2 (5 คะแนน = 1 บาท)
    } else if (typeUsers == '1') {
      discountCal = 1; // type ๅ (1 รีวอร์ด = 1 บาท)
    }
    //? set เวลา order
    final now = DateTime.now();
    String orderDate = DateFormat('yMMdd').format(now); // orderdate
    String orderTime = DateFormat('kkmmss').format(now); //order time
    //? set เวลา order

    //? set รายละเอียด ของ order
    String starDiscount = (int.parse(totalDiscount) * discountCal)
        .toString(); //? จำนวน point ที่ใช้
    String pointDiscount = (int.parse(totalDiscount) * discountCal)
        .toString(); //? จำนวน point ที่ใช้
    String useStar = 'N';
    String userPoint = 'N';
    String orderType;
    String deliveryType;
    String shipFee;
    //? จัดการ delivery
    if (typeUsers == '2') {
      deliveryType = deliveryData.isChange!
          .detailDelivery![deliveryData.indexChange.value].deliveryType;
      orderType = (deliveryData
          .isChange!.detailDelivery![deliveryData.indexChange.value].orderType);
      shipFee = deliveryData
          .isChange!.detailDelivery![deliveryData.indexChange.value].price;
    } else {
      orderType = "0";
      deliveryType = '0';
      shipFee = "0";
    }

    //? จัดการคะแนนและ star
    String autoRun = '${orderDate}_$orderTime${await data.repSeq}';
    if (starDiscount != '0' || pointDiscount != '0') {
      //?type 2(สมาชิก) ใช้ point
      if (typeUsers == '2') {
        useStar = 'N'; //ไม่ใช้ star rewards
        userPoint = 'Y'; //ใช้ point
        starDiscount = '0'; //
      }
      //?type 3(ลูกค้าสมาชิก) ใช้ star rewards
      else if (typeUsers == '1') {
        useStar = 'Y'; //ใช้ star rewards
        userPoint = 'N'; //ไม่ใช้ point
        pointDiscount = '0'; //
      }
    }
    //? กรณีไม่ใช้
    else {
      useStar = 'N'; // ไม่ใช้ star rewards
      userPoint = 'N'; // ไม่ใช้ point
    }

    List<Orderdetail> orderDetail = []; //ประกาศตัวแปรชนิด list
    List<OrderHeader> orderHeader = []; //ประกาศตัวแปรชนิด list
    var i = 0;

    //? add ข้อมูลเข้าโมเดล orderHeader
    orderHeader.add(
      OrderHeader(
        sessionId: await data.sessionId,
        autoRun: autoRun,
        customerName: typeUsers == '1' || typeUsers == '3'
            ? nameEndUsers
            : repname, // type 2  use repname
        customerSurName: typeUsers != '2' ? surNameEndUsers : '',
        deliveryType: deliveryType,
        device: device,
        enduserId: typeUsers == '2'
            ? int.parse(repseq)
            : int.parse(await data.enduserId),
        enduserTel: typeUsers == '1' || typeUsers == '3' ? telEndUsers : reptel,
        imei: await data.imei,
        language: language,
        orderDate: orderDate,
        orderNo: '',
        orderTime: orderTime,
        orderType: orderType,
        pointDiscount: totalDiscount, //pointDiscount
        repCode: repcode,
        repSeq: int.parse(repseq),
        shipFee: shipFee,
        starDiscount: starDiscount,
        totalAmount:
            controller.itemsCartList!.cardHeader.totalAmount.toString(),
        totalDiscount:
            (int.parse(totalDiscount) + cDiscount.disCouponPrice.value)
                .toString(),
        totalItems: totalItems,
        usePoint: userPoint,
        couponDiscount: couponDiscountID,
        useStar: useStar,
        userType: int.parse(typeUsers),
      ),
    );

    //? add ข้อมูลเข้าโมเดล orderDetail
    while (i < controller.itemsCartList!.cardHeader.carddetail.length) {
      orderDetail.add(Orderdetail(
          amount: controller.itemsCartList!.cardHeader.carddetail[i].amount
              .toString(),
          billCode: controller.itemsCartList!.cardHeader.carddetail[i].billCode
              .toString(),
          billDesc: controller.itemsCartList!.cardHeader.carddetail[i].billName,
          billcamp: controller.itemsCartList!.cardHeader.carddetail[i].billcamp,
          brand: controller.itemsCartList!.cardHeader.carddetail[i].brand,
          discount: 0,
          listno: controller.itemsCartList!.cardHeader.carddetail[i].listno
              .toString(),
          media: controller.itemsCartList!.cardHeader.carddetail[i].media,
          orderNo:
              controller.itemsCartList!.cardHeader.carddetail[i].tokenOrder,
          price: controller.itemsCartList!.cardHeader.carddetail[i].price
              .toString(),
          qty: controller.itemsCartList!.cardHeader.carddetail[i].qty
              .toString()));
      i++;
    }
    // ? add ข้อมูลเข้า b2c
    var orderDetailB2C = <OrderdetailB2C>[];

    for (var i = 0;
        i < controller.itemsCartList!.cardHeader.carddetailB2C.length;
        i++) {
      var b2cShop = controller.itemsCartList!.cardHeader.carddetailB2C[i];
      var orderDetailSub = <Orderdetail>[];

      for (var j = 0; j < b2cShop.carddetail.length; j++) {
        var detail = b2cShop.carddetail[j];
        orderDetailSub.add(Orderdetail(
          amount: detail.amount.toString(),
          billCode: detail.billCode.toString(),
          billDesc: detail.billName,
          billcamp: detail.billcamp,
          brand: detail.brand,
          discount: 0,
          listno: detail.listno.toString(),
          media: detail.media,
          orderNo: detail.tokenOrder,
          price: detail.price.toString(),
          qty: detail.qty.toString(),
        ));
      }

      orderDetailB2C.add(OrderdetailB2C(
          supplierCode: b2cShop.supplierCode,
          supplierName: b2cShop.supplierName,
          orderdetail: orderDetailSub,
          shipFee: int.parse(controller.supplierDelivery[b2cShop.supplierCode]!
              .detailDelivery[0].price)));
    }

    // String jsonString = jsonEncode(orderHeader);
    // print(jsonString);

    //? direcsale data
    dataOrder = OrderEndUserClass(
        orderHeader: orderHeader,
        orderdetail: orderDetail,
        dataAddress: [
          DataAddress(
            customerName: addressSaveOrder!.deliverContact == ""
                ? repname
                : addressSaveOrder.deliverContact,
            address1: addressSaveOrder.addrline1,
            address2: addressSaveOrder.addrline2,
            addressType: addressSaveOrder.addrtype,
            provinceId: addressSaveOrder.provinceCode,
            amphurId: addressSaveOrder.amphurCode,
            tumbonId: addressSaveOrder.tumbonCode,
            provinceName: addressSaveOrder.provinceName,
            amphurName: addressSaveOrder.amphurName,
            tumbonName: addressSaveOrder.tumbonName,
            postalCode: addressSaveOrder.postalCode,
            telnumber: addressSaveOrder.mobileNo,
            note: addressSaveOrder.deliveryNote,
          )
        ],
        orderdetailB2C: orderDetailB2C);

    // printJSON(dataOrder);
    // return;
    //? direcsale data
  }
  if (dropship.itemDropship!.cartHeader.cartDetail.isNotEmpty) {
    var drop = 0;
    List<OrderCartList> orderCartList = [];

    //? add dropship สินค้า
    while (drop < dropship.itemDropship!.cartHeader.cartDetail.length) {
      orderCartList.addIf(
          dropship.itemDropship!.cartHeader.cartDetail[drop].isChecked == true,
          OrderCartList(
              billB2C:
                  dropship.itemDropship!.cartHeader.cartDetail[drop].billB2C,
              billName:
                  dropship.itemDropship!.cartHeader.cartDetail[drop].billName,
              supplierCode: dropship
                  .itemDropship!.cartHeader.cartDetail[drop].supplierCode,
              brand: dropship.itemDropship!.cartHeader.cartDetail[drop].brand,
              brandCode:
                  dropship.itemDropship!.cartHeader.cartDetail[drop].brandCode,
              qty: dropship.itemDropship!.cartHeader.cartDetail[drop].qty
                  .toString(),
              price: dropship.itemDropship!.cartHeader.cartDetail[drop].price
                  .toString(),
              priceRegular: dropship
                  .itemDropship!.cartHeader.cartDetail[drop].priceRegular
                  .toString(),
              amount: dropship.itemDropship!.cartHeader.cartDetail[drop].amount
                  .toString()));
      drop++;
    }

    dataOrderDropship = DropshipConfirmOrder(
      orderCartList: orderCartList,
      repCode: await data.repCode,
      repSeq: await data.repSeq,
      repType: await data.repType,
      totAmount: dropship.itemDropship!.cartHeader.cartDetail
          .where((item) => item.isChecked == true)
          .fold<double>(
              0, (previousValue, element) => previousValue + element.amount)
          .toString(),
      totItem: dropship.itemDropship!.cartHeader.cartDetail
          .where((item) => item.isChecked == true)
          .length
          .toString(),
      shipAddress: ShipAddress(
        addressLine1: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .addressLine1,
        addressLine2: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .addressLine2,
        amphurCode: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .amphurCode,
        areaType: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .areaType,
        mobileNo: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .mobileNo,
        nameAmphur: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .nameAmphur,
        nameProvince: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .nameProvince,
        nameReceive: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .nameReceive,
        nameTumbon: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .nameTumbon,
        postCode: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .postCode,
        provinceCode: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .provinceCode,
        tumbonCode: infoAddress.address
            .firstWhere((element) => element.addressType == '1')
            .tumbonCode,
      ),
    );
  }

  //? data directsale
  var orderTotal = dataOrder ??
      OrderEndUserClass(
          orderHeader: [],
          orderdetail: [],
          dataAddress: [],
          orderdetailB2C: []);
  // printWhite(jsonEncode(orderTotal));
  //? dropship data
  var dataDropship = dataOrderDropship ??
      DropshipConfirmOrder(
          repCode: '',
          repSeq: '',
          repType: '',
          orderCartList: [],
          shipAddress: ShipAddress(
              addressLine1: '',
              addressLine2: '',
              amphurCode: '',
              areaType: '',
              mobileNo: '',
              nameAmphur: '',
              nameProvince: '',
              nameReceive: '',
              nameTumbon: '',
              postCode: '',
              provinceCode: '',
              tumbonCode: ''),
          totAmount: '',
          totItem: '');
  //? ส่งข้อมูลที่ได้ไปเข้า bottom sheet และแสดง

  // await Get.find<SaveOrderDropship>().saveOrderCartDropship(dataDropship);
  successConfirmDialog(context, orderTotal, dataDropship);
}

//? function เตรียข้อมูลและ save order ของ end user
void saveOrderTotalEndUser(
    context,
    FetchCartItemsController controller,
    FetchCartDropshipController dropship,
    FetchDeliveryChange deliveryData,
    totalItems,
    totalDiscount,
    couponDiscountID,
    totalAmount,
    typeUser,
    DropshipGetAddress infoAddress,
    EndUserAddress endUserAddress) async {
  SetData data = SetData();

  var discountCal = 0;
  var typeUsers = typeUser;
  var repseq = await data.repSeq;
  var repname = await data.repName; //name type 2
  var reptel = await data.repTel; //tel type 2
  var device = await data.device;
  var language = await data.language;
  var repcode = await data.repCode;

  //? end user information
  var telEndUsers = await data.telEndUsers;
  var nameEndUsers = await data.nameEndUsers;
  var surNameEndUsers = await data.surNameEndUsers;

  //? ตัวแปรสำหรับเก็บค่าก่อน confirm
  enduser_save_order.OrderEndUser? dataOrderEndUser;

  if (controller.itemsCartList!.cardHeader.carddetail.isNotEmpty ||
      controller.itemsCartList!.cardHeader.carddetailB2C.isNotEmpty) {
    discountCal = 1;
    //? set เวลา order
    final now = DateTime.now();
    String orderDate = DateFormat('yMMdd').format(now); // orderdate
    String orderTime = DateFormat('kkmmss').format(now); //order time
    //? set เวลา order

    //? set รายละเอียด ของ order
    String starDiscount = (int.parse(totalDiscount) * discountCal)
        .toString(); //? จำนวน point ที่ใช้
    String useStar = 'N';
    String userPoint = 'N';
    String orderType = "0";
    String deliveryType = "0";
    String shipFee = "0";
    //? จัดการ delivery

    //? จัดการคะแนนและ star
    String autoRun = '${orderDate}_$orderTime${await data.repSeq}';
    if (starDiscount != '0') {
      useStar = 'Y'; //ใช้ star rewards
    }
    //? กรณีไม่ใช้
    else {
      useStar = 'N'; // ไม่ใช้ star rewards
    }
    //? ค่าจัดส่ง

    deliveryType = Get.find<FetchDeliveryChange>()
        .isChange!
        .detailDelivery![Get.find<FetchDeliveryChange>().indexChange.value]
        .deliveryType;
    orderType = (Get.find<FetchDeliveryChange>()
        .isChange!
        .detailDelivery![Get.find<FetchDeliveryChange>().indexChange.value]
        .orderType);
    shipFee = Get.find<FetchDeliveryChange>()
        .isChange!
        .detailDelivery![Get.find<FetchDeliveryChange>().indexChange.value]
        .price;

    List<enduser_save_order.Orderdetail> orderDetail =
        []; //ประกาศตัวแปรชนิด list
    List<enduser_save_order.OrderHeader> orderHeader =
        []; //ประกาศตัวแปรชนิด list

    []; //ประกาศตัวแปรชนิด list
    var i = 0;

    //? add ข้อมูลเข้าโมเดล orderHeader
    orderHeader.add(
      enduser_save_order.OrderHeader(
        sessionId: await data.sessionId,
        autoRun: autoRun,
        customerName: typeUsers == '1' || typeUsers == '3'
            ? nameEndUsers
            : repname, // type 2  use repname
        customerSurName: typeUsers != '2' ? surNameEndUsers : '',
        deliveryType: deliveryType,
        device: device,
        enduserId: typeUsers == '2'
            ? int.parse(repseq)
            : int.parse(await data.enduserId),
        enduserTel: typeUsers == '1' || typeUsers == '3' ? telEndUsers : reptel,
        imei: await data.imei,
        language: language,
        orderDate: orderDate,
        orderNo: '',
        orderTime: orderTime,
        orderType: orderType,
        pointDiscount: "0",
        repCode: repcode,
        repSeq: int.parse(repseq),
        shipFee: shipFee,
        starDiscount: starDiscount,
        totalAmount:
            controller.itemsCartList!.cardHeader.totalAmount.toString(),
        totalDiscount:
            (int.parse(totalDiscount) + cDiscount.disCouponPrice.value)
                .toString(),
        totalItems: totalItems,
        usePoint: userPoint,
        couponDiscount: couponDiscountID,
        useStar: useStar,
        userType: int.parse(typeUsers),
        paymentType: ctrAddress.selectedAddress.value == 0
            ? "cod"
            : "msl", // 1 = ที่อยู่ msl 0 = ที่อยู่ลูกค้า
      ),
    );

    //? add ข้อมูลเข้าโมเดล orderDetail
    while (i < controller.itemsCartList!.cardHeader.carddetail.length) {
      orderDetail.add(enduser_save_order.Orderdetail(
          amount: controller.itemsCartList!.cardHeader.carddetail[i].amount
              .toString(),
          billCode: controller.itemsCartList!.cardHeader.carddetail[i].billCode
              .toString(),
          billDesc: controller.itemsCartList!.cardHeader.carddetail[i].billName,
          billcamp: controller.itemsCartList!.cardHeader.carddetail[i].billcamp,
          brand: controller.itemsCartList!.cardHeader.carddetail[i].brand,
          discount: 0,
          listno: controller.itemsCartList!.cardHeader.carddetail[i].listno
              .toString(),
          media: controller.itemsCartList!.cardHeader.carddetail[i].media,
          orderNo:
              controller.itemsCartList!.cardHeader.carddetail[i].tokenOrder,
          price: controller.itemsCartList!.cardHeader.carddetail[i].price
              .toString(),
          qty: controller.itemsCartList!.cardHeader.carddetail[i].qty
              .toString()));
      i++;
    }
    var orderDetailB2C = <enduser_save_order.OrderdetailB2C>[];

    for (var i = 0;
        i < controller.itemsCartList!.cardHeader.carddetailB2C.length;
        i++) {
      var b2cShop = controller.itemsCartList!.cardHeader.carddetailB2C[i];
      var orderDetailSub = <enduser_save_order.Orderdetail>[];

      for (var j = 0; j < b2cShop.carddetail.length; j++) {
        var detail = b2cShop.carddetail[j];
        orderDetailSub.add(enduser_save_order.Orderdetail(
          amount: detail.amount.toString(),
          billCode: detail.billCode.toString(),
          billDesc: detail.billName,
          billcamp: detail.billcamp,
          brand: detail.brand,
          discount: 0,
          listno: detail.listno.toString(),
          media: detail.media,
          orderNo: detail.tokenOrder,
          price: detail.price.toString(),
          qty: detail.qty.toString(),
        ));
      }

      orderDetailB2C.add(enduser_save_order.OrderdetailB2C(
        supplierCode: b2cShop.supplierCode,
        supplierName: b2cShop.supplierName,
        orderdetail: orderDetailSub,
        shipFee: int.parse(controller
            .supplierDelivery[b2cShop.supplierCode]!.detailDelivery[0].price),
      ));
    }

    // String jsonString = jsonEncode(orderHeader);
    // print(jsonString);

    //? direcsale data
    dataOrderEndUser = enduser_save_order.OrderEndUser(
        orderHeader: orderHeader,
        orderdetail: orderDetail,
        dataAddress: ctrAddress.selectedAddress.value == 1
            ? []
            : [
                enduser_save_order.DataAddress(
                  customerName: endUserAddress.primaryAddress.name,
                  address1: endUserAddress.primaryAddress.address1,
                  address2: '',
                  provinceId: endUserAddress.primaryAddress.provinceId,
                  amphurId: endUserAddress.primaryAddress.amphurId,
                  tumbonId: endUserAddress.primaryAddress.tumbonId,
                  provinceName: endUserAddress.primaryAddress.provinceName,
                  amphurName: endUserAddress.primaryAddress.amphurName,
                  tumbonName: endUserAddress.primaryAddress.tumbonName,
                  postalCode: endUserAddress.primaryAddress.postalcode,
                  telNumber: endUserAddress.primaryAddress.telnumber,
                  note: endUserAddress.primaryAddress.note,
                )
              ],
        orderdetailB2C: orderDetailB2C);

    //? direcsale data
  }
  // printJSON(dataOrderEndUser!);
  // return;
  //? data directsale
  var orderTotal = dataOrderEndUser ??
      enduser_save_order.OrderEndUser(
          orderHeader: [],
          orderdetail: [],
          dataAddress: [],
          orderdetailB2C: []);

  // String jsonString = jsonEncode(orderTotal);
  // await Get.find<SaveOrderDropship>().saveOrderCartDropship(dataDropship);
  successConfirmDialogEndUser(context, orderTotal);
}
