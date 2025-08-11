import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/theme/theme_color.dart';
import '../../../homepage/theme/theme_loading.dart';
import '../../../model/check_information/order/approve_enduser_all.dart';
import '../../../model/check_information/order/order_order_all.dart';
import '../../../model/check_information/order/update_detail_response.dart';
import '../../../service/languages/multi_languages.dart';
import '../../../service/check_information/check_information_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'order_orderdetail_enduser.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อ "ลูกค้ารออนุมัติ"
class CheckInformationOrderOrderWaitApprove extends StatefulWidget {
  const CheckInformationOrderOrderWaitApprove({Key? key}) : super(key: key);

  @override
  State<CheckInformationOrderOrderWaitApprove> createState() =>
      _CheckInformationOrderOrderWaitApproveState();
}

class _CheckInformationOrderOrderWaitApproveState
    extends State<CheckInformationOrderOrderWaitApprove> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  alertConfirmDelete(json) async {
    var stap1 = true;
    var stap2 = false;
    var stap3 = false;
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        MultiLanguages.of(context)!.translate('alert_title'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                    ),
                  if (stap1 == true)
                    Text(
                      textAlign: TextAlign.center,
                      'คุณแน่ใจใช่ไหมที่จะยกเลิกคำสั่งซื้อของลูกค้าท่านนี้',
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
                    const Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        'สำเร็จ',
                        style: TextStyle(
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
                                  ResponseUpdateDetail? approveEnduserResponse =
                                      await call_information_order_orderdetail_approve_enduser(
                                          json); //ส่งค่า json ไปที่ฟังก์ชัน call_information_order_orderdetail_approve_enduser เพื่อทำการอัพเดท
                                  if (approveEnduserResponse!.values == '1') {
                                    setState(() {
                                      stap1 = false;
                                      stap2 = false;
                                      stap3 = true;
                                    });
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
                                  setReload();
                                  // Get.toNamed('/check_information_order',
                                  //     parameters: {'select': '1'});
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
                                  setReload();
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

  setReload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: call_information_order_order(
          '3'), //เรียกใช้งานฟังก์ชัน call_information_order_order เพื่อ get ข้อมูลหน้าปกแค็ตตาล็อก Ecatalog
      builder: (BuildContext context,
          AsyncSnapshot<CheckInformationOrderOrderAll?> snapshot) {
        //ตรวจสอบว่าโหลดข้อมูลได้ไหม
        //กรณีโหลดข้อมูลได้
        if (snapshot.connectionState == ConnectionState.done) {
          var result = snapshot.data; //เซ็ตค่า result =  ข้อมูลหน้าปกแค็ตตาล็อก

          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (result!
              .customerOrderHistory.customerEndUserOrderDetail.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await _pref; //get ข้อมูล SharedPreferences
                          List<ListUpdateAll> detail =
                              []; //ประกาศตัวแปรชนิด list

                          /***********************/
                          //วนลูปสร้าง list รายการสินค้าที่อนุมัติทั้งหมด
                          var i = 0;
                          while (i <
                              result.customerOrderHistory
                                  .customerEndUserOrderDetail.length) {
                            if (result
                                    .customerOrderHistory
                                    .customerEndUserOrderDetail[i]
                                    .statusOrder ==
                                'N') {
                              detail.add(ListUpdateAll(
                                  repCode:
                                      prefs.getString("RepCode").toString(),
                                  repSeq: prefs.getString("RepSeq").toString(),
                                  userId: result.customerOrderHistory
                                      .customerEndUserOrderDetail[i].userId,
                                  phoneNumber: result.customerOrderHistory
                                      .customerEndUserOrderDetail[i].userTel,
                                  orderNo: result.customerOrderHistory
                                      .customerEndUserOrderDetail[i].orderNo,
                                  flagData: 'Y'));
                            }

                            i++;
                          }
                          /***********************/

                          //ปั้น model เพื่อจะอัพเดท
                          var data = ApproveEndUserAll(listUpdateAll: detail);
                          var json = data.toJson(); //แปลงเป็น json

                          alertConfirmOrder(json, 'approve_all');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme_color_df,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            textStyle: const TextStyle(
                                fontSize: 15, fontFamily: 'notoreg')),
                        child: Text(
                          MultiLanguages.of(context)!
                              .translate('btn_all_approved'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: result
                        .customerOrderHistory.customerEndUserOrderDetail.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: InkWell(
                          onTap: () {
                            Get.find<CheckInformationOrderOrderAllController>()
                                .fetch_information_order_orderdetail_enduser(
                              result
                                  .customerOrderHistory
                                  .customerEndUserOrderDetail[index]
                                  .downloadFlag,
                              result
                                  .customerOrderHistory
                                  .customerEndUserOrderDetail[index]
                                  .headerStatus,
                              result
                                  .customerOrderHistory
                                  .customerEndUserOrderDetail[index]
                                  .statusDiscription,
                              result
                                  .customerOrderHistory
                                  .customerEndUserOrderDetail[index]
                                  .statusOrder,
                              result.customerOrderHistory
                                  .customerEndUserOrderDetail[index].orderDate,
                              result.customerOrderHistory
                                  .customerEndUserOrderDetail[index].name,
                              result.customerOrderHistory
                                  .customerEndUserOrderDetail[index].ordercamp,
                              result
                                  .customerOrderHistory
                                  .customerEndUserOrderDetail[index]
                                  .totalAmount,
                              result.customerOrderHistory
                                  .customerEndUserOrderDetail[index].userId,
                              result.customerOrderHistory
                                  .customerEndUserOrderDetail[index].userTel,
                              result.customerOrderHistory
                                  .customerEndUserOrderDetail[index].orderNo,
                              result
                                  .customerOrderHistory
                                  .customerEndUserOrderDetail[index]
                                  .reciveTypeText,
                              result
                                  .customerOrderHistory
                                  .customerEndUserOrderDetail[index]
                                  .orderSource,
                            ); //ส่งค่าไปที่ CheckInformationOrderOrderAllController และไปที่ฟังก์ชัน fetch_information_order_orderdetail_enduser
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          CheckInformationOrderOrderdetailEndUser(
                                            userId: result
                                                .customerOrderHistory
                                                .customerEndUserOrderDetail[
                                                    index]
                                                .userId,
                                            orderNo: result
                                                .customerOrderHistory
                                                .customerEndUserOrderDetail[
                                                    index]
                                                .orderNo,
                                            phone: result
                                                .customerOrderHistory
                                                .customerEndUserOrderDetail[
                                                    index]
                                                .userTel,
                                          )),
                                )
                                .then((val) => val ? setReload() : null);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 1.0,
                                    color: Color.fromARGB(255, 224, 224, 224)),
                              ), // Set border width
                              // Make rounded corner of border
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  result
                                                      .customerOrderHistory
                                                      .customerEndUserOrderDetail[
                                                          index]
                                                      .headerStatus,
                                                  style: const TextStyle(
                                                      color: Colors.grey)),
                                              Text(
                                                  result
                                                      .customerOrderHistory
                                                      .customerEndUserOrderDetail[
                                                          index]
                                                      .statusDiscription,
                                                  style: result
                                                              .customerOrderHistory
                                                              .customerEndUserOrderDetail[
                                                                  index]
                                                              .statusOrder ==
                                                          'N'
                                                      ? const TextStyle(
                                                          color: Colors.orange)
                                                      : const TextStyle(
                                                          color:
                                                              Color(0XFF20BE79),
                                                        )),
                                              Text(
                                                  result
                                                      .customerOrderHistory
                                                      .customerEndUserOrderDetail[
                                                          index]
                                                      .name,
                                                  style: const TextStyle(
                                                      color: Colors.grey)),
                                              // !v16
                                              Text(
                                                  'รอบการขาย ${result.customerOrderHistory.customerEndUserOrderDetail[index].ordercamp}',
                                                  style: const TextStyle(
                                                      color: Colors.grey)),
                                              // Text(
                                              //     MultiLanguages.of(context)!
                                              //             .translate(
                                              //                 'txt_campaign_no') +
                                              //         result
                                              //             .customerOrderHistory
                                              //             .customerEndUserOrderDetail[
                                              //                 index]
                                              //             .ordercamp,
                                              //     style: const TextStyle(
                                              //         color: Colors.grey)),
                                              Text(
                                                  MultiLanguages.of(context)!
                                                      .translate(
                                                          'txt_total_amount'),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                  MultiLanguages.of(context)!
                                                      .translate(
                                                          'txt_see_more'),
                                                  style: TextStyle(
                                                      color: theme_color_df)),
                                              Text(result
                                                  .customerOrderHistory
                                                  .customerEndUserOrderDetail[
                                                      index]
                                                  .orderDate),
                                              InkWell(
                                                onTap: () async {
                                                  final Uri launchUri = Uri(
                                                      scheme: 'tel',
                                                      path: result
                                                          .customerOrderHistory
                                                          .customerEndUserOrderDetail[
                                                              index]
                                                          .userTel);
                                                  if (await canLaunchUrl(
                                                      launchUri)) {
                                                    await launchUrl(launchUri);
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.phone,
                                                      color: theme_color_df,
                                                      size: 12,
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                        result
                                                            .customerOrderHistory
                                                            .customerEndUserOrderDetail[
                                                                index]
                                                            .userTel
                                                            .replaceAllMapped(
                                                                RegExp(
                                                                    r'(\d{3})(\d{3})(\d+)'),
                                                                (Match m) =>
                                                                    "${m[1]}-${m[2]}-${m[3]}"),
                                                        style: TextStyle(

                                                            // add under line
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.orange
                                                                .shade400)),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                result
                                                    .customerOrderHistory
                                                    .customerEndUserOrderDetail[
                                                        index]
                                                    .reciveTypeText,
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                  "${NumberFormat.decimalPattern().format(double.parse(result.customerOrderHistory.customerEndUserOrderDetail[index].totalAmount))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        )
                                      ]),
                                  result
                                              .customerOrderHistory
                                              .customerEndUserOrderDetail[index]
                                              .statusOrder ==
                                          'N'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            OutlinedButton(
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all(RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0))),
                                                  side:
                                                      MaterialStateProperty.all(
                                                          BorderSide(
                                                    color: theme_color_df,
                                                  )),
                                                ),
                                                onPressed: () async {
                                                  final SharedPreferences
                                                      prefs = await _pref;

                                                  //ปั้น model เพื่อทำการอัพเดทรายดชการสั่งซื้อของ end user ที่เลือก
                                                  var data = ListUpdateAll(
                                                      repCode: prefs
                                                          .getString("RepCode")
                                                          .toString(),
                                                      repSeq: prefs
                                                          .getString("RepSeq")
                                                          .toString(),
                                                      userId: result
                                                          .customerOrderHistory
                                                          .customerEndUserOrderDetail[
                                                              index]
                                                          .userId,
                                                      phoneNumber: result
                                                          .customerOrderHistory
                                                          .customerEndUserOrderDetail[
                                                              index]
                                                          .userTel,
                                                      orderNo: result
                                                          .customerOrderHistory
                                                          .customerEndUserOrderDetail[
                                                              index]
                                                          .orderNo,
                                                      flagData: 'N');

                                                  var json = data
                                                      .toJson(); //แปลงเป็น json
                                                  alertConfirmDelete(json);
                                                },
                                                child: SizedBox(
                                                  width: width / 3,
                                                  child: Center(
                                                    child: Text(
                                                        MultiLanguages.of(
                                                                context)!
                                                            .translate(
                                                                'btn_notApprove'),
                                                        style: const TextStyle(
                                                            fontSize: 20)),
                                                  ),
                                                )),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            Colors.white),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                theme_color_df),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(10.0),
                                                            side: BorderSide(color: theme_color_df)))),
                                                onPressed: () async {
                                                  final SharedPreferences
                                                      prefs = await _pref;

                                                  //ปั้น model เพื่อทำการอัพเดทรายดชการสั่งซื้อของ end user ที่เลือก
                                                  var data = ListUpdateAll(
                                                      repCode: prefs
                                                          .getString("RepCode")
                                                          .toString(),
                                                      repSeq: prefs
                                                          .getString("RepSeq")
                                                          .toString(),
                                                      userId: result
                                                          .customerOrderHistory
                                                          .customerEndUserOrderDetail[
                                                              index]
                                                          .userId,
                                                      phoneNumber: result
                                                          .customerOrderHistory
                                                          .customerEndUserOrderDetail[
                                                              index]
                                                          .userTel,
                                                      orderNo: result
                                                          .customerOrderHistory
                                                          .customerEndUserOrderDetail[
                                                              index]
                                                          .orderNo,
                                                      flagData: 'Y');

                                                  var json = data
                                                      .toJson(); //แปลงเป็น json

                                                  alertConfirmOrder(
                                                      json, 'approve_item');
                                                },
                                                child: SizedBox(
                                                  width: width / 3,
                                                  child: Center(
                                                    child: Text(
                                                        MultiLanguages.of(
                                                                context)!
                                                            .translate(
                                                                'btn_approved'),
                                                        style: const TextStyle(
                                                            fontSize: 20)),
                                                  ),
                                                )),
                                          ],
                                        )
                                      : const Text('')
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );

            //กรณีไม่มีข้อมูล
          } else {
            //แสดงข้อความว่า ไม่พบข้อมูล
            return SizedBox(
              height: height / 1.4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo/logofriday.png',
                      width: 50,
                      height: 50,
                    ),
                    Text(MultiLanguages.of(context)!
                        .translate('alert_no_datas')),
                  ],
                ),
              ),
            );
          }

          //กรณีไม่สามารถโหลดข้อมูลได้
        } else {
          return SizedBox(
            height: height / 1.4,
            child: Center(
              child: theme_loading_df,
            ),
          );
        }
      },
    );
  }
}
