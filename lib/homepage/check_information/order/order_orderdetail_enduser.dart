import 'package:fridayonline/controller/cancel_order/cancel_ctr.dart';
// import 'package:fridayonline/homepage/check_information/order/order_orderdetail.dart';
import 'package:fridayonline/model/check_information/order/update_detail_response.dart';
import 'package:fridayonline/service/check_information/check_information_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/pageactivity/widget_appbar_title_only.dart';
import '../../../homepage/theme/theme_color.dart';
// import '../../../homepage/theme/theme_loading.dart';
import '../../../model/check_information/order/approve_detail_enduser.dart';
import '../../../model/check_information/order/approve_enduser_all.dart';
// import '../../../model/check_information/order/delete_detail_enduser.dart';
// import '../../../model/check_information/order/order_orderdetail_check_productlimit.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'download_flag_y.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อที่ต้องการแก้ไขจำนวนสินค้าของ end user
class CheckInformationOrderOrderdetailEndUser extends StatefulWidget {
  final String? userId;
  final String? orderNo;
  final String? phone;
  const CheckInformationOrderOrderdetailEndUser(
      {super.key, this.userId, this.orderNo, this.phone});

  @override
  State<CheckInformationOrderOrderdetailEndUser> createState() =>
      _CheckInformationOrderOrderdetailEndUserState();
}

class _CheckInformationOrderOrderdetailEndUserState
    extends State<CheckInformationOrderOrderdetailEndUser>
    with SingleTickerProviderStateMixin {
  CheckInformationOrderOrderAllController dataController = Get.put(
      CheckInformationOrderOrderAllController()); //ทำการ get จาก CheckInformationOrderOrderAllController
  TextEditingController textController =
      TextEditingController(); //เก็บค่า TextField
  bool error_limit_check = false;

  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  void _show_dialog_limit_error() {
    showDialog<void>(
      barrierColor: Colors.black45.withOpacity(0.1),
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: CupertinoAlertDialog(
            title: Text(
              MultiLanguages.of(context)!.translate(
                  'profile_page_check_information_order_orderdetail_alert_error_product_limit_1'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(MultiLanguages.of(context)!.translate(
                      'profile_page_check_information_order_orderdetail_alert_error_product_limit_1')),
                  Text(MultiLanguages.of(context)!.translate(
                      'profile_page_check_information_order_orderdetail_alert_error_product_limit_2')),
                  Text(MultiLanguages.of(context)!.translate(
                      'profile_page_check_information_order_orderdetail_alert_error_product_limit_3')),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child:
                    Text(MultiLanguages.of(context)!.translate('alert_okay')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  alertConfirmOrder(json, type) async {
    Get.find<ApproveOrderController>().call_approve_order_enduser(json, type);
    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      builder: (builder) {
        double width = MediaQuery.of(context).size.width;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: WillPopScope(
              onWillPop: () async => false,
              child:
                  GetBuilder<ApproveOrderController>(builder: (dataResponse) {
                if (dataResponse.isDataLoading.value) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 330,
                        child: Lottie.asset(
                            width: 180, 'assets/images/loading_line.json'),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Lottie.asset(
                            width: 230,
                            height: 230,
                            'assets/images/cart/success_lottie.json'),
                      ),
                      Center(
                        child: Text(
                          dataResponse.response!.description1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: width / 1.3,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: theme_color_df),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  textAlign: TextAlign.center,
                                  MultiLanguages.of(context)!
                                      .translate('alert_okay'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          );
        });
      },
    );
  }

  alertConfirmDelete(json, type, orderNo) async {
    var stap1 = true;
    var stap2 = false;
    var stap3 = false;
    var text = 'สำเร็จ';
    var text1 = '';
    if (type == 'delete_all') {
      text1 = 'คุณต้องการลบรายการทั้งหมดใช่หรือไม่';
    } else if (type == 'delete_item') {
      text1 = '${'กรุณายืนยันที่จะลบสินค้ารหัส ' + orderNo} ค่ะ';
    } else {
      text1 = 'ระบบจะทำการแจ้งอนุมัติไปยังลูกค้าของท่าน';
    }
    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      builder: (builder) {
        double width = MediaQuery.of(context).size.width;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: WillPopScope(
              onWillPop: () async => false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stap1 == true)
                    Lottie.asset(
                        width: 160,
                        height: 160,
                        'assets/images/warning_red.json'),
                  if (stap1 == true)
                    Text(
                      MultiLanguages.of(context)!.translate('alert_title'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                  if (stap1 == true)
                    Text(
                      text1,
                      style: TextStyle(color: theme_grey_text, fontSize: 18),
                    ),
                  if (stap1 == true)
                    const SizedBox(
                      height: 10,
                    ),
                  if (stap2 == true)
                    Center(
                      child: SizedBox(
                        height: 355,
                        child: Lottie.asset(
                            width: 180,
                            height: 180,
                            'assets/images/loading_line.json'),
                      ),
                    ),
                  if (stap3 == true)
                    Center(
                      child: Lottie.asset(
                          width: 230,
                          height: 230,
                          'assets/images/cart/success_lottie.json'),
                    ),
                  if (stap3 == true)
                    Center(
                      child: Text(
                        text,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                    ),
                  if (stap2 != true)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (stap1 == true)
                            SizedBox(
                              width: width / 1.3,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XFFFD7F6B)),
                                onPressed: () async {
                                  setState(() {
                                    stap1 = false;
                                    stap2 = true;
                                    stap3 = false;
                                  });
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  if (type == 'approve') {
                                    ResponseUpdateDetail?
                                        approveEnduserResponse =
                                        await call_information_order_orderdetail_approve_enduser(
                                            json); //ส่งค่า json ไปที่ฟังก์ชัน call_information_order_orderdetail_approve_enduser เพื่อทำการอัพเดท
                                    if (approveEnduserResponse!.values == '1') {
                                      setState(() {
                                        stap1 = false;
                                        stap2 = false;
                                        stap3 = true;
                                        text =
                                            approveEnduserResponse.description1;
                                      });
                                    }
                                  } else {
                                    ResponseUpdateDetail?
                                        updateDetailEnduserResponse =
                                        await call_information_order_orderdetail_detail_enduser_delete(
                                            json); //ส่งค่า json ไปที่ฟังก์ชัน call_information_order_orderdetail_detail_enduser_delete เพื่อทำการอัพเดท

                                    if (updateDetailEnduserResponse!.values ==
                                        '1') {
                                      setState(() {
                                        stap1 = false;
                                        stap2 = false;
                                        stap3 = true;
                                        text = updateDetailEnduserResponse
                                            .description1;
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  textAlign: TextAlign.center,
                                  MultiLanguages.of(context)!
                                      .translate('alert_confirm'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          if (stap1 == true)
                            const SizedBox(
                              height: 10,
                            ),
                          if (stap1 == true)
                            SizedBox(
                              width: width / 1.3,
                              height: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0XFFFD7F6B)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  textAlign: TextAlign.center,
                                  MultiLanguages.of(context)!
                                      .translate('alert_cancel'),
                                  style: const TextStyle(
                                    color: Color(0XFFFD7F6B),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          if (stap3 == true)
                            SizedBox(
                              width: width / 1.3,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: theme_color_df),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  textAlign: TextAlign.center,
                                  MultiLanguages.of(context)!
                                      .translate('alert_okay'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  final ScrollController _firstController = ScrollController();
  final canCtr = Get.put(CancelProductController());
  bool isShowDiscount = false;
  @override
  void initState() {
    super.initState();
    canCtr.fetchCancelReason(dataController.shopType);
  }

  @override
  void dispose() {
    canCtr.isCheck.value = false;
    canCtr.isOther.value = false;
    canCtr.otherNoteCtr.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: header_title_only(context, 'title_order_detail_view'),
            body: Obx(
              () => dataController.isDataLoading.value
                  ? const Text('')
                  : dataController.statusOrder == 'Y'
                      ? EnduserDownloadFlagY(
                          dataController: dataController,
                          width: width,
                          height: height,
                          firstController: _firstController)
                      : ListView(
                          children: [
                            Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(dataController.headerStatus!,
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                            Text(
                                                dataController
                                                    .statusDiscription!,
                                                style: dataController
                                                            .statusOrder! ==
                                                        'N'
                                                    ? const TextStyle(
                                                        color: Colors.orange)
                                                    : const TextStyle(
                                                        color:
                                                            Color(0XFF20BE79),
                                                      )),
                                            Text(dataController.name!,
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                            Text(
                                                'รอบการขาย ${dataController.ordercamp!}',
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text(''),
                                            Text(dataController.orderDate!),
                                            InkWell(
                                              onTap: () async {
                                                final Uri launchUri = Uri(
                                                  scheme: 'tel',
                                                  path: dataController.userTel,
                                                );
                                                if (await canLaunchUrl(
                                                    launchUri)) {
                                                  // print('ok');
                                                  await launchUrl(launchUri);
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    size: 14,
                                                    color:
                                                        Colors.amber.shade700,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      dataController.userTel!
                                                          .replaceAllMapped(
                                                              RegExp(
                                                                  r'(\d{3})(\d{3})(\d+)'),
                                                              (Match m) =>
                                                                  "${m[1]}-${m[2]}-${m[3]}"),
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          height: 2,
                                                          fontSize: 13,
                                                          color: Colors
                                                              .amber.shade700)),
                                                ],
                                              ),
                                            ),
                                            Text(dataController.recieveType!,
                                                style: const TextStyle(
                                                    height: 1.5,
                                                    color: Colors.grey)),
                                          ],
                                        )
                                      ]),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: BorderDirectional(
                                          bottom: BorderSide(
                                        width: 2,
                                        color: theme_color_df,
                                      ))),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: Text(
                                      'รายการสินค้า',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Container(
                                    color: Colors.white,
                                    child: ListView.builder(
                                      controller: _firstController,
                                      shrinkWrap: true,
                                      itemCount: dataController
                                          .infornation_orderdetail_enduser!
                                          .orderDetail
                                          .length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Color.fromARGB(
                                                        255, 224, 224, 224)),
                                              ), // Set border width
                                              // Make rounded corner of border
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                                  Radius
                                                                      .circular(
                                                                          4)),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              width: 0.5)),
                                                      child: CachedNetworkImage(
                                                        imageUrl: dataController
                                                            .infornation_orderdetail_enduser!
                                                            .orderDetail[index]
                                                            .image,
                                                        width: ((width - 32.0) /
                                                                2) /
                                                            2,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15.0,
                                                              top: 12),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "รหัส ${dataController.infornation_orderdetail_enduser!.orderDetail[index].billCode}"),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            dataController
                                                                .infornation_orderdetail_enduser!
                                                                .orderDetail[
                                                                    index]
                                                                .billDesc,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '${NumberFormat.decimalPattern().format(dataController.infornation_orderdetail_enduser!.orderDetail[index].amount)} บาท',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            height: 9,
                                                          ),
                                                          Text(
                                                              'x${dataController.infornation_orderdetail_enduser!.orderDetail[index].qtyConfirm}',
                                                              style: TextStyle(
                                                                  color:
                                                                      theme_color_df,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      },
                                    )),
                              ],
                            ),
                          ],
                        ),
            ),
            bottomNavigationBar: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Obx(
                () => dataController.isDataLoading.value
                    ? const Text('')
                    : dataController.statusOrder == 'N'
                        ? SizedBox(
                            // height: 140,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 197, 230, 248),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40.0),
                                    topRight: Radius.circular(40.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 30, right: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (dataController.recieveType ==
                                        'รับสินค้าเอง (COD)')
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('ค่าจัดส่ง'),
                                          Text(
                                              '${NumberFormat.decimalPattern().format(dataController.infornation_orderdetail_enduser!.shipFee)} บาท')
                                        ],
                                      ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isShowDiscount = !isShowDiscount;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'ส่วนลดทั้งหมด',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              isShowDiscount
                                                  ? Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: theme_red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          size: 20,
                                                          color: Colors.white,
                                                          Icons
                                                              .arrow_drop_up_rounded,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: theme_red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          size: 20,
                                                          color: Colors.white,
                                                          Icons
                                                              .arrow_drop_down_rounded,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Text(
                                            "- ${NumberFormat.decimalPattern().format(dataController.infornation_orderdetail_enduser!.couponDiscount + dataController.infornation_orderdetail_enduser!.pointDiscount)} บาท",
                                            style: TextStyle(
                                                fontSize: 16, color: theme_red),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (isShowDiscount &&
                                        dataController
                                                .infornation_orderdetail_enduser!
                                                .couponDiscount >
                                            0)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              MultiLanguages.of(context)!
                                                  .translate('lb_dis_count'),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              "${NumberFormat.decimalPattern().format(dataController.infornation_orderdetail_enduser!.couponDiscount)} บาท",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: theme_red),
                                            )
                                          ],
                                        ),
                                      ),
                                    if (isShowDiscount &&
                                        dataController
                                                .infornation_orderdetail_enduser!
                                                .pointDiscount >
                                            0)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "ส่วนลด Star Reward",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              "${NumberFormat.decimalPattern().format(dataController.infornation_orderdetail_enduser!.pointDiscount)} บาท",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: theme_red),
                                            )
                                          ],
                                        ),
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "รวมเป็นเงิน",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${NumberFormat.decimalPattern().format(dataController.infornation_orderdetail_enduser!.totalAmount)} บาท",
                                          style: const TextStyle(fontSize: 18),
                                        )
                                      ],
                                    ),
                                    dataController.statusOrder == 'Y' ||
                                            error_limit_check == true
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '* ข้อมูลอาจมีการเปลี่ยนแปลง',
                                                    style: TextStyle(
                                                        color: theme_red,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                OutlinedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all(
                                                                  Colors.white),
                                                      shape: WidgetStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0))),
                                                      side: WidgetStateProperty
                                                          .all(BorderSide(
                                                        color: theme_color_df,
                                                      )),
                                                    ),
                                                    onPressed: () async {
                                                      final SharedPreferences
                                                          prefs = await _pref;
                                                      //ปั้น model เพื่อทำการอัพเดทรายดชการสั่งซื้อของ end user ที่เลือก
                                                      var data = ListUpdateAll(
                                                          repCode: prefs
                                                              .getString(
                                                                  "RepCode")
                                                              .toString(),
                                                          repSeq: prefs
                                                              .getString(
                                                                  "RepSeq")
                                                              .toString(),
                                                          userId: widget.userId
                                                              .toString(),
                                                          phoneNumber: widget
                                                              .phone
                                                              .toString(),
                                                          orderNo: widget
                                                              .orderNo
                                                              .toString(),
                                                          flagData: 'N');

                                                      var json = data
                                                          .toJson(); //แปลงเป็น json

                                                      alertConfirmDelete(
                                                          json, 'approve', '');
                                                    },
                                                    child: SizedBox(
                                                      width: width / 3.3,
                                                      child: Center(
                                                        child: Text(
                                                            MultiLanguages.of(
                                                                    context)!
                                                                .translate(
                                                                    'btn_notApprove'),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                      ),
                                                    )),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        foregroundColor:
                                                            WidgetStateProperty.all<Color>(
                                                                Colors.white),
                                                        backgroundColor:
                                                            WidgetStateProperty.all<Color>(
                                                                theme_color_df),
                                                        shape: WidgetStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        10.0),
                                                                side: BorderSide(
                                                                    color: theme_color_df)))),
                                                    onPressed: () async {
                                                      final SharedPreferences
                                                          prefs =
                                                          await _pref; //get ข้อมูล SharedPreferences
                                                      List<Listdetail> detail =
                                                          []; //ประกาศตัวแปรชนิด list

                                                      /***********************/
                                                      //วนลูปสร้าง list รายการสินค้าที่จะแก้ไขทั้งหมด
                                                      var i = 0;
                                                      while (i <
                                                          dataController
                                                              .infornation_orderdetail_enduser!
                                                              .orderDetail
                                                              .length) {
                                                        // var flag = '0';
                                                        if (dataController
                                                                    .enduser_check_update![
                                                                i] ==
                                                            true) {
                                                          // flag = '11';
                                                        } else {
                                                          // flag = '11';
                                                          dataController
                                                                  .infornation_orderdetail_enduser!
                                                                  .orderDetail[i]
                                                                  .qtyConfirm =
                                                              dataController
                                                                  .infornation_orderdetail_enduser!
                                                                  .orderDetail[
                                                                      i]
                                                                  .qty;
                                                        }
                                                        detail.add(Listdetail(
                                                            orderNo: dataController
                                                                .infornation_orderdetail_enduser!
                                                                .orderNo,
                                                            listno: "",
                                                            billCode: dataController
                                                                .infornation_orderdetail_enduser!
                                                                .orderDetail[i]
                                                                .billCode,
                                                            billDesc: dataController
                                                                .infornation_orderdetail_enduser!
                                                                .orderDetail[i]
                                                                .billDesc,
                                                            billCamp: dataController
                                                                .infornation_orderdetail_enduser!
                                                                .orderDetail[i]
                                                                .billCamp,
                                                            orderCamp: dataController
                                                                .infornation_orderdetail_enduser!
                                                                .campaign,
                                                            qty: dataController.infornation_orderdetail_enduser!.orderDetail[i].qty
                                                                .toString(),
                                                            qtyConfirm: dataController
                                                                .infornation_orderdetail_enduser!
                                                                .orderDetail[i]
                                                                .qtyConfirm
                                                                .toString(),
                                                            billFlag: '11',
                                                            price: dataController
                                                                .infornation_orderdetail_enduser!
                                                                .orderDetail[i]
                                                                .price
                                                                .toString(),
                                                            amount: dataController
                                                                .infornation_orderdetail_enduser!
                                                                .orderDetail[i]
                                                                .amount
                                                                .toString(),
                                                            brand: dataController.infornation_orderdetail_enduser!.orderDetail[i].brand));
                                                        i++;
                                                      }
                                                      /***********************/

                                                      //ปั้น model เพื่อจะอัพเดท
                                                      var data = ApproveDetailEndUser(
                                                          repSeq: prefs
                                                              .getString(
                                                                  "RepSeq")
                                                              .toString(),
                                                          userId: dataController
                                                              .userId!,
                                                          orderNo:
                                                              dataController
                                                                  .orderNo!,
                                                          approveFlag: '11',
                                                          listdetail: detail);

                                                      var json = data
                                                          .toJson(); //แปลงเป็น json
                                                      alertConfirmOrder(json,
                                                          'update_approve');
                                                    },
                                                    child: SizedBox(
                                                      width: width / 3.3,
                                                      child: Center(
                                                        child: Text(
                                                            MultiLanguages.of(
                                                                    context)!
                                                                .translate(
                                                                    'btn_approved'),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
              ),
            )),
      ),
    );
  }
}
