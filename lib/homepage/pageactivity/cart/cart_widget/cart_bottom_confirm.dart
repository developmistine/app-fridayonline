// ? ปุ่มยืนยันการสัั่งซื้อและราคารวม
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:fridayonline/controller/address/address_controller.dart';
import 'package:fridayonline/controller/cart/cart_address_enduser_controller.dart';
import 'package:fridayonline/controller/cart/cart_cheer_controller.dart';
import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/List_product.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_dialog/cart_dialog_header.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_endusers_change_address.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_msl_change_address.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbar_cart_share.dart';
import 'package:fridayonline/model/cart/enduser/enduser_address.dart';
import 'package:fridayonline/service/cart/cart_cheer.dart';
import 'package:fridayonline/service/cart/enduser/enduser_service.dart';
import 'package:fridayonline/service/logapp/logapp_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../controller/cart/cart_controller.dart';
import '../../../../controller/cart/delivery_controller.dart';
import '../../../../controller/cart/point_controller.dart';
import '../../../../model/cart/dropship/drop_ship_address.dart';
import '../../../../model/cart/get_ms_cart_info..dart';
import '../../../../model/cart/get_ms_cart_stock.dart';
// import '../../../../model/cart/order_end_user.dart';
import '../../../../service/cart/dropship/dropship_address_service.dart';
import '../../../../service/cart/popup_cart/getMessage_info_service.dart';
import '../../../../service/cart/popup_cart/getMessage_stock_service.dart';
import '../../../../service/cart/popup_cart/insert_log_service.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../dialogalert/CustomAlertDialogs.dart';
import '../../../theme/theme_color.dart';
// import '../cart_dialog/dialog_detail_bill.dart';
import '../cart_dialog/total_confirm_dialog.dart';
import '../cart_page/cart_change_address.dart';
import '../cart_page/cart_order summary.dart';
import '../cart_theme/cart_all_theme.dart';
import '../cart_theme/cart_loading_theme.dart';

// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

var blueWhite = const Color.fromARGB(199, 164, 214, 241);
CheerCartCtr ctr = Get.find<CheerCartCtr>();
final ctrAddress = Get.find<FetchCartEndUsersAddress>();
Widget bottomConfirm(
    context,
    bool showModal,
    String nameBtn,
    List<TextEditingController> inputorsDropship,
    List<TextEditingController> inputors,
    String? typeUser) {
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GetBuilder<FetchCartItemsController>(builder: (controller) {
          var supplierDeliveryPrice = controller.supplierDelivery.values
              .map((e) => e.detailDelivery[0].price)
              .toList()
              .fold(
                  0,
                  (previousValue, element) =>
                      previousValue + int.parse(element));
          var suplierProductPrice = controller
              .itemsCartList!.cardHeader.carddetailB2C
              .expand((e) => e.carddetail.map((e) => e.amount))
              .fold(0.0, (previousValue, element) => previousValue + element);
          return GetBuilder<FetchCartDropshipController>(builder: (dropship) {
            // if (controller.itemsCartList!.cardHeader.carddetail.isNotEmpty ||
            //     dropship.itemDropship!.cartHeader.cartDetail.isNotEmpty) {
            if (controller.itemsCartList!.cardHeader.carddetail.isNotEmpty ||
                controller.itemsCartList!.cardHeader.carddetailB2C.isNotEmpty) {
              var totalAmount =
                  controller.itemsCartList!.cardHeader.totalAmount;
              var totalAmtWithFlag = controller
                  .itemsCartList!.cardHeader.carddetail
                  .where((element) =>
                      element.flagNetPrice == "N" && element.isInStock)
                  .fold<double>(
                      0,
                      (previousValue, element) =>
                          previousValue + element.amount);
              var camp = controller.itemsCartList!.cardHeader.campaign;

              return GetBuilder<FetchDeliveryChange>(
                  initState: getMessageBK(totalAmount),
                  builder: (delivery) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? ป็อปอัพ text
                        Container(
                          alignment: Alignment.center,
                          width: Get.width,
                          height: 2,
                          color: theme_red,
                        ),
                        if (typeUser == '2')
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            child: nameBtn != 'pay'
                                ? GetX<CheerCartCtr>(initState: (state) {
                                    state.controller!.fetchCartConditions(
                                        camp, totalAmtWithFlag);
                                  }, builder: (linear) {
                                    if (linear.isDataLoading.value) {
                                      var countAchieve = linear
                                          .conditions!.detail
                                          .where(
                                              (element) => element.show == true)
                                          .length;

                                      var totalCondition =
                                          linear.conditions!.detail.length;
                                      if (totalCondition == 0) {
                                        return const SizedBox(
                                          height: 12,
                                        );
                                      }
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              informationWidget(
                                                  context, totalAmount);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .monetization_on_outlined,
                                                  color: theme_color_df,
                                                  size: 24,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        linear.conditions!
                                                            .cheerMessage,
                                                      ),
                                                      if (linear.conditions!
                                                              .description !=
                                                          "")
                                                        Text(
                                                          linear.conditions!
                                                              .description,
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                                // arrow icon
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Stack(
                                            alignment: Alignment.centerRight,
                                            children: [
                                              LinearPercentIndicator(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                // alignment: MainAxisAlignment.start,
                                                animation: true,
                                                lineHeight: 34.0,
                                                animationDuration: 1000,
                                                animateFromLastPercent: true,
                                                percent: (countAchieve /
                                                    totalCondition),
                                                backgroundColor:
                                                    const Color(0xFFDADADA),
                                                linearGradient: LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: const Alignment(0.8, 1),
                                                  tileMode: TileMode.mirror,
                                                  colors: [
                                                    const Color.fromARGB(
                                                        255, 137, 210, 244),
                                                    theme_color_df
                                                  ],
                                                ),
                                                barRadius:
                                                    const Radius.circular(10),
                                              ),
                                              for (var i = 0;
                                                  i < totalCondition;
                                                  i++)
                                                Positioned(
                                                  left: (Get.width * 0.8) *
                                                      (i + 1) /
                                                      totalCondition,
                                                  child: linear.conditions!
                                                          .detail[i].show
                                                      ? CircleAvatar(
                                                          radius: 12,
                                                          backgroundColor:
                                                              theme_color_df,
                                                          child: const Icon(
                                                            size: 23,
                                                            Icons
                                                                .check_circle_rounded,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: blueWhite,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 2,
                                                                  horizontal:
                                                                      8),
                                                          child: Text(
                                                            linear
                                                                .conditions!
                                                                .detail[i]
                                                                .percentage,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          )),
                                                ),
                                            ],
                                          )
                                        ],
                                      );
                                    }

                                    var countAchieve = linear.conditions!.detail
                                        .where(
                                            (element) => element.show == true)
                                        .length;

                                    var totalCondition =
                                        linear.conditions!.detail.length;
                                    if (totalCondition == 0) {
                                      return const SizedBox(
                                        height: 12,
                                      );
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            informationWidget(
                                                context, totalAmount);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.monetization_on_outlined,
                                                color: theme_color_df,
                                                size: 24,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      linear.conditions!
                                                          .cheerMessage,
                                                    ),
                                                    if (linear.conditions!
                                                            .description !=
                                                        "")
                                                      Text(
                                                        linear.conditions!
                                                            .description,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                  ],
                                                ),
                                              ),
                                              // arrow icon
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            LinearPercentIndicator(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              // alignment: MainAxisAlignment.start,
                                              animation: true,
                                              lineHeight: 34.0,
                                              animationDuration: 1000,
                                              animateFromLastPercent: true,
                                              // percent: totalAmount >= 3000
                                              //     ? 1.0
                                              //     : totalAmount / 3000,
                                              percent: (countAchieve /
                                                  totalCondition),
                                              backgroundColor:
                                                  const Color(0xFFDADADA),
                                              linearGradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: const Alignment(0.8, 1),
                                                tileMode: TileMode.mirror,
                                                colors: [
                                                  const Color.fromARGB(
                                                      255, 137, 210, 244),
                                                  theme_color_df
                                                ],
                                              ),
                                              barRadius:
                                                  const Radius.circular(10),
                                            ),
                                            for (var i = 0;
                                                i < totalCondition;
                                                i++)
                                              Positioned(
                                                left: (Get.width * 0.8) *
                                                    (i + 1) /
                                                    totalCondition,
                                                child: linear.conditions!
                                                        .detail[i].show
                                                    ? CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            theme_color_df,
                                                        child: const Icon(
                                                          size: 23,
                                                          Icons
                                                              .check_circle_rounded,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: blueWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 2,
                                                                horizontal: 8),
                                                        child: Text(
                                                          linear
                                                              .conditions!
                                                              .detail[i]
                                                              .percentage,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        )),
                                              ),
                                          ],
                                        )
                                      ],
                                    );
                                  })
                                : const SizedBox(
                                    height: 12,
                                  ),
                          )
                        else
                          const SizedBox(
                            height: 12,
                          ),
                        if (controller.itemsCartList!.cardHeader.carddetailB2C
                            .map((e) => e.carddetail)
                            .expand((element) => element)
                            .any((element) => !element.isInStock))
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 18),
                            child: SizedBox(
                              width: Get.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 8),
                                  ),
                                  onPressed: null,
                                  child: const Text('กรุณาแก้ไขรายการสินค้า')),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 18),
                            child: SizedBox(
                              width: Get.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme_color_df,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () async {
                                    if (showModal == false) {
                                      Get.back(closeOverlays: true);
                                    }
                                    loadingCart(context);
                                    // กรณีที่อยู่หน้าแรก
                                    if (nameBtn == 'order') {
                                      await handleManagePage(
                                          context,
                                          controller,
                                          dropship,
                                          totalAmount,
                                          typeUser,
                                          showModal,
                                          inputors,
                                          inputorsDropship);
                                    }
                                    // กรณีที่อยู่หน้าสรุป
                                    else {
                                      await handleSummaryPage(typeUser, context,
                                          controller, dropship);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        nameBtn == "order"
                                            ? 'สั่งซื้อ'
                                            : "ยืนยันการสั่งซื้อ",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Icon(
                                          Icons.circle,
                                          size: 8,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          "${controller.itemsCartList!.cardHeader.totalitem + controller.itemsCartList!.cardHeader.carddetailB2C.map((e) => e.carddetail).length} รายการ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: theme_color_df),
                                        ),
                                      ),
                                      const Spacer(),
                                      nameBtn == "pay"
                                          ? GetX<FetchPointMember>(
                                              builder: (discount) {
                                              if (typeUser == '2') {
                                                var fridayDeliveryPrice =
                                                    double.parse(delivery
                                                        .isChange!
                                                        .detailDelivery![
                                                            delivery.indexChange
                                                                .value]
                                                        .price);
                                                if (controller
                                                    .itemsCartList!
                                                    .cardHeader
                                                    .carddetail
                                                    .isEmpty) {
                                                  fridayDeliveryPrice = 0.0;
                                                }
                                                double totalPrice =
                                                    (fridayDeliveryPrice +
                                                            controller
                                                                .itemsCartList!
                                                                .cardHeader
                                                                .totalAmount +
                                                            suplierProductPrice +
                                                            supplierDeliveryPrice) -
                                                        discount
                                                            .discount.value -
                                                        discount.disCouponPrice
                                                            .value;
                                                return Text(
                                                  totalPrice > 0
                                                      ? '${myFormat.format(totalPrice)} บาท'
                                                      : "0 บาท",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                );
                                              } else if (typeUser == '1' &&
                                                  ctrAddress.selectedAddress
                                                          .value ==
                                                      0) {
                                                var fridayDeliveryPrice =
                                                    double.parse(delivery
                                                        .isChange!
                                                        .detailDelivery![
                                                            delivery.indexChange
                                                                .value]
                                                        .price);
                                                if (controller
                                                    .itemsCartList!
                                                    .cardHeader
                                                    .carddetail
                                                    .isEmpty) {
                                                  fridayDeliveryPrice = 0.0;
                                                }
                                                return Text(
                                                  '${myFormat.format((fridayDeliveryPrice + totalAmount + suplierProductPrice + supplierDeliveryPrice) - discount.discount.value - discount.disCouponPrice.value)} บาท',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                );
                                              } else {
                                                return Text(
                                                  '${myFormat.format(totalAmount + suplierProductPrice + supplierDeliveryPrice - discount.discount.value - discount.disCouponPrice.value)} บาท',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                );
                                              }
                                            })
                                          : Text(
                                              '${myFormat.format(totalAmount + suplierProductPrice)} บาท',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )
                                    ],
                                  )),
                            ),
                          ),
                      ],
                    );
                  });
            } else {
              return Container(
                height: 60,
                alignment: Alignment.center,
                color: const Color.fromRGBO(123, 123, 123, 1),
                child: Text(
                    MultiLanguages.of(context)!.translate('alert_no_product'),
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center),
              );
            }
          });
        }),
      ],
    ),
  );
}

// หน้าสรุปรายการ
Future<void> handleSummaryPage(
    String? typeUser,
    context,
    FetchCartItemsController controller,
    FetchCartDropshipController dropship) async {
  EndUserAddress? endUserAddress = await getEnduserAddress();

  Get.back(
    closeOverlays: true,
    canPop: false,
  );
  if (endUserAddress!.primaryAddress.id == "" &&
      typeUser == '1' &&
      ctrAddress.selectedAddress.value == 0) {
    endUserAlertAddress(context);
  } else {
    if (Get.find<AddressController>().addressMslSaveOrder!.msladdrId == 0 &&
        typeUser == "2") {
      mslAlertAddress(context);
    } else {
      showDialogConfirm(context, controller, dropship, typeUser);
    }
  }
}

// หน้ารายการสั่งซื้อ
Future<void> handleManagePage(
    context,
    FetchCartItemsController controller,
    FetchCartDropshipController dropship,
    double totalAmount,
    String? typeUser,
    bool showModal,
    List<TextEditingController> inputors,
    List<TextEditingController> inputorsDropship) async {
  FetchCartDropshipController drop = Get.find<FetchCartDropshipController>();
  DropshipGetAddress? checkDropshipAddress = await getDropshipAddress();
  Get.find<FetchCartEndUsersAddress>().fetchEnduserAddress();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // ตรวจ error การเลือกที่อยู่หลัก dropship
  if ((checkDropshipAddress!.address.isEmpty ||
          checkDropshipAddress.address
              .every((element) => (element.addressType != '1'))) &&
      drop.itemDropship!.cartHeader.cartDetail
          .any((element) => (element.isChecked))) {
    // หากพบ error จะโชว์ popup address
    dropshipAlertAddress(context);
  } else {
    // var checkBoxDirecsale = (controller.itemsCartList!.cardHeader.carddetail
    //     .any((element) => element.isChecked == true));
    // var checkBoxDropship = (dropship.itemDropship!.cartHeader.cartDetail
    //     .any((element) => element.isChecked == true));
    // if (!checkBoxDirecsale && !checkBoxDropship) {
    //   // ตรวจ error checkbox
    //   dropshipCheckBoxAlert(context).then((value) => {});
    // } else {
    // กรณีไม่มี error
    var popupData = await getMessageInfo(1, totalAmount);
    if (typeUser == '2') {
      // กรณี userType 2 จะตรวจ popup เชียร์ขาย
      if (popupData!.showMessage == "Y") {
        Get.back(closeOverlays: true);
        // แสดง popup เชียร์ขาย
        showMessagePopupCheer(context, totalAmount, popupData, showModal,
            dropship, controller, inputors, inputorsDropship, typeUser);
      }
    }
    if (popupData!.showMessage != "Y") {
      // เช็คสินค้าหมดสต๊อก ทุก type
      var popopStock = await getMessageStock();
      if (popopStock!.showMessage == "Y" && typeUser == "1") {
        // if (showModal == false) {
        Get.back(closeOverlays: true);
        // }
        // กรณีมี สินค้าหมดส๊อก
        showMessageStock(context, totalAmount, popopStock, showModal, dropship,
            controller, inputors, inputorsDropship, typeUser);
      } else {
        Get.back(closeOverlays: true);
        bool showModal = prefs.getBool("popUpCheer") ?? true;
        checkPopUpCheer(showModal, prefs, controller, context, dropship,
            inputors, inputorsDropship, typeUser, false);
      }
    }
    // }
  }
}

Future<void> checkPopUpCheer(
    bool showModal,
    SharedPreferences prefs,
    FetchCartItemsController controller,
    BuildContext context,
    FetchCartDropshipController dropship,
    List<TextEditingController> inputors,
    List<TextEditingController> inputorsDropship,
    String? typeUser,
    bool popupStock) async {
  final ctrAddress = Get.find<FetchCartEndUsersAddress>();
  // production
  if (showModal && typeUser == '2' && ctr.conditions!.popUp.title != "") {
    // test
    // if (typeUser == '2' && ctr.conditions!.popUp.title != "") {
    prefs.setBool("popUpCheer", false);

    // กรณีมี ไม่มีสินค้าหมดสต๊อก
    if (!controller.isDataLoading.value) {
      var checkUserBuy = await Get.dialog(cartDailogHeader(context, ctr));

      if (checkUserBuy == true) {
        loadingCart(context);
        // กรณีเลือกสินค้าเพิ่ม
        logAppCheer(
            controller.itemsCartList!.cardHeader.campaign.replaceAll("/", ""),
            "1");
        var listSku = await saleProductByRepSeq(
            controller.itemsCartList!.cardHeader.campaign);
        var channel = "27";
        var channelId = "";
        LogAppTisCall(channel, "");
        bannerProduct.fetch_product_banner("", "");
        Get.back(closeOverlays: true);
        Get.to(() => Scaffold(
            appBar: appbarShare(
                MultiLanguages.of(context)!
                    .translate('home_page_list_products'),
                "",
                channel,
                channelId),
            body: Obx(() => bannerProduct.isDataLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : showList(
                    listSku,
                    "27",
                    "",
                    ref: '',
                    contentId: '',
                  ))));
      } else {
        logAppCheer(
            controller.itemsCartList!.cardHeader.campaign.replaceAll("/", ""),
            "0");
        // loadingCart(context);
        var outstock = await getMessageStock();
        if (outstock!.showMessage == "Y") {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          // กรณีมีสินค้าหมดสต๊อก
          showMessageStock(
              context,
              controller.itemsCartList!.cardHeader.totalAmount,
              outstock,
              showModal,
              dropship,
              controller,
              inputors,
              inputorsDropship,
              typeUser);
          // });
        } else {
          // กรณีไม่เลือกสินค้าเพิ่ม
          Get.to(
              transition: Transition.rightToLeft,
              () => CartOrderSummary(
                  controller, dropship, inputors, inputorsDropship, typeUser));
        }
      }
    }
  } else {
    var outstock = await getMessageStock();
    if (outstock!.showMessage == "Y") {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      // กรณีมีสินค้าหมดสต๊อก
      await showMessageStock(
          context,
          controller.itemsCartList!.cardHeader.totalAmount,
          outstock,
          showModal,
          dropship,
          controller,
          inputors,
          inputorsDropship,
          typeUser);
      // });
    } else {
      if (typeUser != "1") {
        return Get.to(
            transition: Transition.rightToLeft,
            () => CartOrderSummary(
                controller, dropship, inputors, inputorsDropship, typeUser));
      }
      return endUserChangeDelivery(ctrAddress, controller, dropship, inputors,
          inputorsDropship, typeUser);
    }
  }
}

Future<void> endUserChangeDelivery(
    FetchCartEndUsersAddress ctrAddress,
    FetchCartItemsController controller,
    FetchCartDropshipController dropship,
    List<TextEditingController> inputors,
    List<TextEditingController> inputorsDropship,
    String? typeUser) {
  return Get.bottomSheet(Container(
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24))),
    child: MediaQuery(
      data: MediaQuery.of(Get.context!)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 30,
                          color: theme_color_df,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        'เลือกวิธีการรับสินค้า',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme_color_df,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              GetX<FetchDeliveryChange>(initState: (state) {
                state.controller!.fetchEndUserChangeDelivery(
                    controller.itemsCartList!.cardHeader.totalAmount);
              }, builder: (endUserDelivery) {
                if (endUserDelivery.isDataLoadingEndUser.value) {
                  return const SizedBox(
                    height: 60,
                  );
                }
                return Obx(() {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          ctrAddress.selectedAddress.value = 0;
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: ctrAddress.selectedAddress.value == 0
                                  ? Icon(
                                      Icons.radio_button_checked,
                                      color: theme_color_df,
                                    )
                                  : const Icon(
                                      Icons.radio_button_off,
                                      color: Colors.grey,
                                    ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    endUserDelivery.isEnduserChange!.toEusDetail
                                        .textHeader,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(endUserDelivery.isEnduserChange!
                                        .toEusDetail.textDetail),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () {
                          ctrAddress.selectedAddress.value = 1;
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: ctrAddress.selectedAddress.value == 1
                                  ? Icon(
                                      Icons.radio_button_checked,
                                      color: theme_color_df,
                                    )
                                  : const Icon(
                                      Icons.radio_button_off,
                                      color: Colors.grey,
                                    ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    endUserDelivery.isEnduserChange!.toMslDetail
                                        .textHeader,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      endUserDelivery.isEnduserChange!
                                          .toMslDetail.textDetail,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                    ],
                  );
                });
              }),
              SizedBox(
                width: Get.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme_color_df,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.to(
                        transition: Transition.rightToLeft,
                        () => CartOrderSummary(controller, dropship, inputors,
                            inputorsDropship, typeUser));
                  },
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          )),
    ),
  ));
}

informationWidget(BuildContext context, double totalAmount) {
  return showMaterialModalBottomSheet(
      backgroundColor: Colors.white,
      isDismissible: true,
      clipBehavior: Clip.antiAlias,
      barrierColor: Colors.black26,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0))),
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: SafeArea(
            top: false,
            left: false,
            right: false,
            child: Container(
              constraints: BoxConstraints(maxHeight: Get.height * 0.9),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 18),
                  child: Obx(() {
                    if (ctr.isDataLoading.value) {
                      return Center(
                        child: theme_loading_df,
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'เงื่อนไขและวิธีการ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            ListView.builder(
                              padding: const EdgeInsets.only(top: 8),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: ctr.conditions!.detail.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Card(
                                      color: ctr.conditions!.detail[index].show
                                          ? blueWhite
                                          : const Color.fromARGB(
                                              196, 218, 218, 218),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ListTile(
                                        horizontalTitleGap: 10,
                                        // targetPadding: const EdgeInsets.symmetric(
                                        //     vertical: 8, horizontal: 16),
                                        leading: Container(
                                          width: 55,
                                          height: 55,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: SizedBox(
                                            child: CachedNetworkImage(
                                              imageUrl: ctr.conditions!
                                                  .detail[index].image,
                                              errorWidget:
                                                  (context, url, error) {
                                                return const Icon(Icons.error);
                                              },
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          ctr.conditions!.detail[index]
                                              .condition,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          ctr.conditions!.detail[index].benefit,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ));
                              },
                            ),
                            const Text(
                              'หมายเหตุ',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            for (var indexNote = 0;
                                indexNote < ctr.conditions!.note.length;
                                indexNote++)
                              Text(
                                "● ${ctr.conditions!.note[indexNote]}",
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.red),
                              ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                                width: Get.width,
                                height: 60,
                                child: ElevatedButton(
                                    onPressed: () => Get.back(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme_color_df,
                                    ),
                                    child: const Text(
                                      'รับทราบ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )))
                          ],
                        ),
                      );
                    }
                  })),
            ),
          ),
        );
      });
}

Future<dynamic> dropshipCheckBoxAlert(context) {
  return showDialog(
    barrierColor: Colors.black26,
    context: context,
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: const CustomAlertDialogs(
          title: 'แจ้งเตือน',
          description: 'กรุณเลือกสินค้าก่อนยืนยันคำสั่งซื้อ',
        ),
      );
    },
  );
}

Future<void> dropshipAlertAddress(context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          title: Center(
            child: Icon(
              size: 40,
              Icons.info,
              color: theme_color_df,
            ),
          ),
          content: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'แจ้งเตือน',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text('กรุณาระบุที่อยู่จัดส่งสินค้าส่งด่วน',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ]),
          actions: <Widget>[
            MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Center(
                child: SizedBox(
                  width: Get.width,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          style: BorderStyle.solid, color: theme_red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () async {
                      Get.back();
                      Get.put(FetchAddressDropshipController())
                          .fetchDropshipAddress();
                      Get.to(
                          transition: Transition.cupertinoDialog,
                          () => EditAddress(page: 'page1'));
                    },
                    child: Text(
                      'ดำเนินการเพิ่มที่อยู่',
                      style: TextStyle(color: theme_red),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      });
    },
  );
}

Future<void> endUserAlertAddress(context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          title: Center(
            child: Icon(
              size: 40,
              Icons.info,
              color: theme_color_df,
            ),
          ),
          content: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('กรุณาเพิ่มที่อยู่จัดส่ง',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ]),
          actions: <Widget>[
            MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            style: BorderStyle.solid, color: theme_red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                      child: Text(
                        'ปิด',
                        style: TextStyle(color: theme_red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme_color_df,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      onPressed: () async {
                        Get.back();
                        Get.find<FetchCartEndUsersAddress>()
                            .fetchEnduserAddress();
                        Get.to(() => const EndUserChangeAddress());
                      },
                      child: const Text(
                        'เพิ่มที่อยู่',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      });
    },
  );
}

Future<void> mslAlertAddress(context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          title: Center(
            child: Icon(
              size: 40,
              Icons.info,
              color: theme_color_df,
            ),
          ),
          content: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('กรุณาเพิ่มที่อยู่จัดส่ง',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ]),
          actions: <Widget>[
            MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            style: BorderStyle.solid, color: theme_red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                      child: Text(
                        'ปิด',
                        style: TextStyle(color: theme_red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme_color_df,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      onPressed: () async {
                        Get.back();
                        Get.find<AddressController>().fetchAddressSaveOrder();
                        Get.to(() => const AddressNewMsl());
                      },
                      child: const Text(
                        'เพิ่มที่อยู่',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      });
    },
  );
}

//? check เลือกทั้งหมด
class CheckAll extends StatefulWidget {
  const CheckAll(
    this.controller, {
    super.key,
  });
  final FetchCartItemsController controller;
  @override
  State<CheckAll> createState() => _CheckAllState(controller);
}

class _CheckAllState extends State<CheckAll> {
  _CheckAllState(this.controller);
  FetchCartItemsController controller;
  FetchCartDropshipController drop = Get.put(FetchCartDropshipController());
  @override
  void dispose() {
    // controller.allowMultiple = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool checkboxNoti = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GetBuilder<FetchCartItemsController>(builder: (controller) {
          // printWhite(controller.isChecked);
          if (controller.isChecked == true &&
              drop.itemDropship!.cartHeader.cartDetail.isEmpty) {
            controller.allowMultiple = true;
          } else if (controller.isChecked == true &&
              drop.itemDropship!.cartHeader.cartDetail
                  .every((element) => element.isChecked == true)) {
            controller.allowMultiple = true;
          } else {
            controller.allowMultiple = false;
          }
          return Checkbox(
              value: controller.allowMultiple,
              onChanged: (val) async {
                final Future<SharedPreferences> prefs0 =
                    SharedPreferences.getInstance();
                final SharedPreferences prefs = await prefs0;
                // prefs.remove("notify-dropship");
                controller.checkBoxAllowAll(val);
                if (val == true &&
                    (prefs.getBool("notify-dropship") == false ||
                        prefs.getBool("notify-dropship") == null) &&
                    drop.itemDropship!.cartHeader.cartDetail.isNotEmpty) {
                  showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0)),
                          title: Center(
                            child: Icon(
                              size: 40,
                              Icons.info,
                              color: theme_color_df,
                            ),
                          ),
                          content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'สินค้าส่งด่วน',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                    'จำกัดการชำระเงินเฉพาะเก็บเงินปลายทางเท่านั้น',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        checkboxNoti = !checkboxNoti;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 24.0,
                                          width: 24.0,
                                          child: Checkbox(
                                            side: BorderSide(
                                                width: 1,
                                                color: theme_color_df),
                                            value: checkboxNoti,
                                            onChanged: (bool? value) async {
                                              // final SharedPreferences prefs =
                                              //     await _prefs;
                                              setState(() {
                                                checkboxNoti = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          ' ไม่แจ้งเตือนข้อความนี้อีก',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: theme_grey_text),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                          actions: <Widget>[
                            MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.0)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            style: BorderStyle.solid,
                                            color: theme_red),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          if (checkboxNoti == true) {
                                            prefs.setBool("notify-dropship",
                                                checkboxNoti);
                                          } else {
                                            controller.isCheckedDropship =
                                                false;
                                            Get.find<
                                                    FetchCartDropshipController>()
                                                .refreshDataFalse();
                                          }
                                        });
                                        Get.back();
                                      },
                                      child: Text(
                                        MultiLanguages.of(context)!
                                            .translate('alert_close'),
                                        style: TextStyle(color: theme_red),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (checkboxNoti == true) {
                                            prefs.setBool("notify-dropship",
                                                checkboxNoti);
                                          }
                                          Navigator.pop(context, true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                          backgroundColor: theme_color_df,
                                        ),
                                        child: const Text(
                                          'ดำเนินการต่อ',
                                          maxLines: 1,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white,
                                              fontFamily: 'notoreg'),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                    },
                  ).then((value) {
                    if (value == null && checkboxNoti == false) {
                      controller.isCheckedDropship = false;
                      Get.find<FetchCartDropshipController>()
                          .refreshDataFalse();
                    }
                  });
                }
                // if (controller.allowMultiple) {
                //   for (var element
                //       in controller.itemsCartList!.cardHeader.carddetail) {
                //     element.isChecked = true;
                //   }
                //   for (var element
                //       in drop.itemDropship!.cartHeader.cartDetail) {
                //     element.isChecked = true;
                //   }
                // } else {
                //   for (var element
                //       in controller.itemsCartList!.cardHeader.carddetail) {
                //     element.isChecked = false;
                //   }
                //   for (var element
                //       in drop.itemDropship!.cartHeader.cartDetail) {
                //     element.isChecked = false;
                //   }
                // }
              });
        }),
        const Text(
          "ทั้งหมด",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

//? cheer text
getMessageBK(totalAmount) {
  Get.find<FetchDeliveryChange>().fetchDeliveryChange(totalAmount);
}

//? popup up cheer
showMessagePopupCheer(
    BuildContext ctx,
    totalAmount,
    GetMessageCardinfo popupData,
    showModal,
    FetchCartDropshipController dropship,
    FetchCartItemsController controller,
    inputors,
    inputorsDropship,
    typeUser) async {
  showDialog(
      context: ctx,
      builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0)),
              titlePadding: const EdgeInsets.all(0),
              title: MediaQuery(
                data: MediaQuery.of(ctx)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Container(
                  height: 80,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(41, 0, 0, 0),
                        offset: Offset(0.0, 4.0),
                        blurRadius: 1,
                        spreadRadius: 0.8,
                      ), //BoxShadow
                    ],
                    color: theme_color_df,
                  ),
                  child: Center(
                      child: Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                  )),
                ),
              ),
              content: MediaQuery(
                data: MediaQuery.of(ctx)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      popupData.textMessage![0].textHeader,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: boldText, fontSize: 22),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      textAlign: TextAlign.center,
                      popupData.textMessage![0].textBody1,
                      style: TextStyle(
                          fontWeight: boldText,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      textAlign: TextAlign.center,
                      popupData.textMessage![0].textFooter,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theme_color_df),
                          onPressed: () async {
                            Get.back(closeOverlays: true, result: false);
                            await insertLogEventCovid(
                                popupData.projectCode, totalAmount, '101', '1');
                            // print(
                            //     'media ${controller.itemsCartList!.cardHeader.carddetail[0].media}');
                            // print('กลับไปยังหน้าเลือกสินค้า');
                          },
                          child: Text(
                            popupData.action![0].action1,
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        Get.back(closeOverlays: true, result: true);
                        await insertLogEventCovid(
                            popupData.projectCode, totalAmount, '102', '1');
                        var popopStock = await getMessageStock();

                        if (popopStock!.showMessage == "Y") {
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                          showMessageStock(
                              ctx,
                              totalAmount,
                              popopStock,
                              showModal,
                              dropship,
                              controller,
                              inputors,
                              inputorsDropship,
                              typeUser);
                          // });
                        } else {
                          Get.to(
                              transition: Transition.rightToLeft,
                              () => CartOrderSummary(controller, dropship,
                                  inputors, inputorsDropship, typeUser));
                        }
                      },
                      child: Text(
                        popupData.action![0].action2,
                        style: TextStyle(color: theme_grey_text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )).then((value) {
    return value;
  });
}

//? pupup check stock
showMessageStock(
    BuildContext ctx,
    totalAmount,
    GetMessageCartStock popupData,
    showModal,
    FetchCartDropshipController dropship,
    FetchCartItemsController controller,
    inputors,
    inputorsDropship,
    typeUser) async {
  // var prefs = await SharedPreferences.getInstance();
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0)),
            titlePadding: const EdgeInsets.all(0),
            title: MediaQuery(
              data: MediaQuery.of(ctx)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Container(
                height: 80,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(41, 0, 0, 0),
                      offset: Offset(0.0, 4.0),
                      blurRadius: 1,
                      spreadRadius: 0.8,
                    ), //BoxShadow
                  ],
                  color: theme_color_df,
                ),
                child: Center(
                    child: Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                )),
              ),
            ),
            content: MediaQuery(
              data: MediaQuery.of(ctx)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    popupData.textMessage![0].description1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: boldText, fontSize: 22),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    textAlign: TextAlign.center,
                    popupData.textMessage![0].description2,
                    style: TextStyle(
                        fontWeight: boldText,
                        fontSize: 16,
                        color: Colors.red.shade600),
                  ),
                  const SizedBox(height: 14),
                  if (popupData.textMessage![0].description3 != "")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.start,
                          "${MultiLanguages.of(ctx)!.translate('note')} : ",
                          style: TextStyle(
                              fontSize: 12, color: Colors.red.shade600),
                        ),
                        Expanded(
                          child: Text(
                            // textAlign: TextAlign.start,
                            popupData.textMessage![0].description3,
                            style: TextStyle(
                                fontSize: 12, color: Colors.red.shade600),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme_color_df),
                        onPressed: () async {
                          Get.back(closeOverlays: true, result: true);
                          Get.to(
                              transition: Transition.rightToLeft,
                              () => CartOrderSummary(controller, dropship,
                                  inputors, inputorsDropship, typeUser));
                          await InsertLogCartStock('Confirm');
                        },
                        child: Text(
                          popupData.action![0].action1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      Get.back(result: false);
                      await InsertLogCartStock('Edit');
                      // print('กลับไปยังหน้าเลือกสินค้า');
                    },
                    child: Text(
                      popupData.action![0].action2,
                      style: TextStyle(color: theme_grey_text),
                    ),
                  ),
                ],
              ),
            ),
          )).then((value) {
    // if (value == null) {
    //   Get.back();
    // }
    // printWhite(value);
  });
  // });
}

Widget showCaseBottomConfirm(
    context,
    bool showModal,
    String nameBtn,
    List<TextEditingController> inputors,
    List<TextEditingController> inputorsDropship,
    GlobalKey<State<StatefulWidget>> keyFour,
    MultiLanguages ChangeLanguage,
    String? typeUser) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GetBuilder<FetchCartItemsController>(builder: (controller) {
        return GetBuilder<FetchCartDropshipController>(builder: (dropship) {
          if (controller.itemsCartList!.cardHeader.carddetail.isNotEmpty ||
              controller.itemsCartList!.cardHeader.carddetailB2C.isNotEmpty) {
            var totalAmount = controller.itemsCartList!.cardHeader.totalAmount;
            var totalAmtWithFlag = controller
                .itemsCartList!.cardHeader.carddetail
                .where((element) =>
                    element.flagNetPrice == "N" && element.isInStock)
                .fold<double>(0,
                    (previousValue, element) => previousValue + element.amount);
            var camp = controller.itemsCartList!.cardHeader.campaign;
            final result = controller.itemsCartList!.cardHeader.carddetailB2C
                .expand((e) => e.carddetail.map((e) => e.amount))
                .fold(0.0, (previousValue, element) => previousValue + element);
            int supplierDeliveryPrice = controller.supplierDelivery.values
                .map((e) => e.detailDelivery[0].price)
                .toList()
                .fold(
                    0,
                    (previousValue, element) =>
                        previousValue + int.parse(element));
            return GetBuilder<FetchDeliveryChange>(
                initState: getMessageBK(totalAmount),
                builder: (delivery) {
                  return Column(
                    children: [
                      //? ป็อปอัพ text
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 3,
                        color: theme_red,
                      ),
                      if (typeUser == '2')
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          child: nameBtn != 'pay'
                              ? GetX<CheerCartCtr>(initState: (state) {
                                  state.controller!.fetchCartConditions(
                                      camp, totalAmtWithFlag);
                                }, builder: (linear) {
                                  if (linear.isDataLoading.value) {
                                    var countAchieve = linear.conditions!.detail
                                        .where(
                                            (element) => element.show == true)
                                        .length;

                                    var totalCondition =
                                        linear.conditions!.detail.length;
                                    if (totalCondition == 0) {
                                      return const SizedBox(
                                        height: 12,
                                      );
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            informationWidget(
                                                context, totalAmount);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.monetization_on_outlined,
                                                color: theme_color_df,
                                                size: 24,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      linear.conditions!
                                                          .cheerMessage,
                                                    ),
                                                    if (linear.conditions!
                                                            .description !=
                                                        "")
                                                      Text(
                                                        linear.conditions!
                                                            .description,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                  ],
                                                ),
                                              ),
                                              // arrow icon
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            LinearPercentIndicator(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              // alignment: MainAxisAlignment.start,
                                              animation: true,
                                              lineHeight: 34.0,
                                              animationDuration: 1000,
                                              animateFromLastPercent: true,
                                              // percent: totalAmount >= 3000
                                              //     ? 1.0
                                              //     : totalAmount / 3000,
                                              percent: (countAchieve /
                                                  totalCondition),
                                              backgroundColor:
                                                  const Color(0xFFDADADA),
                                              linearGradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: const Alignment(0.8, 1),
                                                tileMode: TileMode.mirror,
                                                colors: [
                                                  const Color.fromARGB(
                                                      255, 137, 210, 244),
                                                  theme_color_df
                                                ],
                                              ),
                                              barRadius:
                                                  const Radius.circular(10),
                                            ),
                                            for (var i = 0;
                                                i < totalCondition;
                                                i++)
                                              Positioned(
                                                left: (Get.width * 0.8) *
                                                    (i + 1) /
                                                    totalCondition,
                                                child: linear.conditions!
                                                        .detail[i].show
                                                    ? CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            theme_color_df,
                                                        child: const Icon(
                                                          size: 23,
                                                          Icons
                                                              .check_circle_rounded,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: blueWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 2,
                                                                horizontal: 8),
                                                        child: Text(
                                                          linear
                                                              .conditions!
                                                              .detail[i]
                                                              .percentage,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        )),
                                              ),
                                          ],
                                        )
                                      ],
                                    );
                                  }

                                  var countAchieve = linear.conditions!.detail
                                      .where((element) => element.show == true)
                                      .length;

                                  var totalCondition =
                                      linear.conditions!.detail.length;
                                  if (totalCondition == 0) {
                                    return const SizedBox(
                                      height: 12,
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          informationWidget(
                                              context, totalAmount);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.monetization_on_outlined,
                                              color: theme_color_df,
                                              size: 24,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    linear.conditions!
                                                        .cheerMessage,
                                                  ),
                                                  if (linear.conditions!
                                                          .description !=
                                                      "")
                                                    Text(
                                                      linear.conditions!
                                                          .description,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                ],
                                              ),
                                            ),
                                            // arrow icon
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          LinearPercentIndicator(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            // alignment: MainAxisAlignment.start,
                                            animation: true,
                                            lineHeight: 34.0,
                                            animationDuration: 1000,
                                            animateFromLastPercent: true,
                                            // percent: totalAmount >= 3000
                                            //     ? 1.0
                                            //     : totalAmount / 3000,
                                            percent:
                                                (countAchieve / totalCondition),
                                            backgroundColor:
                                                const Color(0xFFDADADA),
                                            linearGradient: LinearGradient(
                                              begin: Alignment.bottomLeft,
                                              end: const Alignment(0.8, 1),
                                              tileMode: TileMode.mirror,
                                              colors: [
                                                const Color.fromARGB(
                                                    255, 137, 210, 244),
                                                theme_color_df
                                              ],
                                            ),
                                            barRadius:
                                                const Radius.circular(10),
                                          ),
                                          for (var i = 0;
                                              i < totalCondition;
                                              i++)
                                            Positioned(
                                              left: (Get.width * 0.8) *
                                                  (i + 1) /
                                                  totalCondition,
                                              child: linear.conditions!
                                                      .detail[i].show
                                                  ? CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          theme_color_df,
                                                      child: const Icon(
                                                        size: 23,
                                                        Icons
                                                            .check_circle_rounded,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        color: blueWhite,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 2,
                                                          horizontal: 8),
                                                      child: Text(
                                                        linear
                                                            .conditions!
                                                            .detail[i]
                                                            .percentage,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      )),
                                            ),
                                        ],
                                      )
                                    ],
                                  );
                                })
                              : const SizedBox(
                                  height: 12,
                                ),
                        )
                      else
                        const SizedBox(
                          height: 12,
                        ),
                      if (controller.itemsCartList!.cardHeader.carddetailB2C
                          .map((e) => e.carddetail)
                          .expand((element) => element)
                          .any((element) => !element.isInStock))
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 18),
                          child: SizedBox(
                            width: Get.width,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                ),
                                onPressed: null,
                                child: const Text('กรุณาแก้ไขรายการสินค้า')),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Showcase.withWidget(
                                  disableMovingAnimation: true,
                                  width: width,
                                  height: height / 1.4,
                                  container: InkWell(
                                    onTap: () {
                                      ShowCaseWidget.of(context).next();
                                    },
                                    child: MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          textScaler:
                                              const TextScaler.linear(1.0)),
                                      child: SizedBox(
                                        width: width / 1,
                                        height: height / 1.5,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Center(
                                                child: IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      ShowCaseWidget.of(context)
                                                          .next();
                                                    })),
                                            Expanded(
                                              // <-- Use Expanded with SizedBox.expand
                                              child: SizedBox.expand(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 70.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 170.0),
                                                          child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                  foregroundColor:
                                                                      WidgetStateProperty.all<Color>(
                                                                          theme_color_df),
                                                                  backgroundColor:
                                                                      WidgetStateProperty.all<Color>(Colors
                                                                          .white),
                                                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                      side: BorderSide(
                                                                          color:
                                                                              theme_color_df)))),
                                                              onPressed: () {
                                                                ShowCaseWidget.of(
                                                                        context)
                                                                    .next();
                                                              },
                                                              child: SizedBox(
                                                                width: 50,
                                                                height: 40,
                                                                child: Center(
                                                                  child: Text(
                                                                      maxLines:
                                                                          1,
                                                                      ChangeLanguage
                                                                          .translate(
                                                                              'btn_end_guide'),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16)),
                                                                ),
                                                              )),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Container(
                                                              color:
                                                                  theme_color_df,
                                                              width: 250,
                                                              height: 80,
                                                              child: Center(
                                                                child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  ChangeLanguage
                                                                      .translate(
                                                                          'guide_in_cart4'),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                          height: 75,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  //overlayColor: theme_color_df,
                                  // targetPadding: const EdgeInsets.all(20),
                                  key: keyFour,
                                  onTargetClick: () {
                                    ShowCaseWidget.of(context).next();
                                  },
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: theme_color_df,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 8),
                                        side: BorderSide(
                                            width: 1.0, color: theme_color_df),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ), // foreground
                                      ),
                                      onPressed: () async {
                                        if (showModal == false) {
                                          Get.back(closeOverlays: true);
                                        }
                                        loadingCart(context);
                                        // กรณีที่อยู่หน้าแรก
                                        if (nameBtn == 'order') {
                                          await handleManagePage(
                                              context,
                                              controller,
                                              dropship,
                                              totalAmount,
                                              typeUser,
                                              showModal,
                                              inputors,
                                              inputorsDropship);
                                        }
                                        // กรณีที่อยู่หน้าสรุป
                                        else {
                                          await handleSummaryPage(typeUser,
                                              context, controller, dropship);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            nameBtn == "order"
                                                ? 'สั่งซื้อ'
                                                : "ยืนยันการสั่งซื้อ",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Icon(
                                              Icons.circle,
                                              size: 8,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Text(
                                              "${controller.itemsCartList!.cardHeader.totalitem + controller.itemsCartList!.cardHeader.carddetailB2C.map((e) => e.carddetail).length} รายการ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme_color_df),
                                            ),
                                          ),
                                          const Spacer(),
                                          nameBtn == "pay"
                                              ? GetX<FetchPointMember>(
                                                  builder: (discount) {
                                                  if (typeUser == '2') {
                                                    var fridayDeliveryPrice =
                                                        double.parse(delivery
                                                            .isChange!
                                                            .detailDelivery![
                                                                delivery
                                                                    .indexChange
                                                                    .value]
                                                            .price);
                                                    if (controller
                                                        .itemsCartList!
                                                        .cardHeader
                                                        .carddetail
                                                        .isEmpty) {
                                                      fridayDeliveryPrice = 0.0;
                                                    }
                                                    double totalPrice =
                                                        (fridayDeliveryPrice +
                                                                controller
                                                                    .itemsCartList!
                                                                    .cardHeader
                                                                    .totalAmount +
                                                                result +
                                                                supplierDeliveryPrice) -
                                                            discount.discount
                                                                .value -
                                                            discount
                                                                .disCouponPrice
                                                                .value;
                                                    return Text(
                                                      totalPrice > 0
                                                          ? '${myFormat.format(totalPrice)} บาท'
                                                          : "0 บาท",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    );
                                                  } else if (typeUser == '1' &&
                                                      ctrAddress.selectedAddress
                                                              .value ==
                                                          0) {
                                                    return Text(
                                                      '${myFormat.format((double.parse(delivery.isChange!.detailDelivery![delivery.indexChange.value].price) + totalAmount) - discount.discount.value - discount.disCouponPrice.value)} บาท',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    );
                                                  } else {
                                                    return Text(
                                                      '${myFormat.format(totalAmount + result - discount.discount.value - discount.disCouponPrice.value)} บาท',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    );
                                                  }
                                                })
                                              : Text(
                                                  '${myFormat.format(totalAmount + result)} บาท',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  );
                });
          } else {
            return Container(
              height: 60,
              alignment: Alignment.center,
              color: const Color.fromRGBO(123, 123, 123, 1),
              child: Text(
                  MultiLanguages.of(context)!.translate('alert_no_product'),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            );
          }
        });
      }),
    ],
  );
}
