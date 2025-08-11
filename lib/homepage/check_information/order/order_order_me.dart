import 'package:fridayonline/homepage/check_information/order/order_new/order_detail.dart';

import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/theme/theme_loading.dart';
import '../../../model/check_information/order/order_order_all.dart';
import '../../../service/check_information/check_information_service.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../layout/head_title_card_darect.dart';
import 'order_orderdetail.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อ "ฉัน"
class CheckInformationOrderOrderMe extends StatefulWidget {
  const CheckInformationOrderOrderMe({super.key});

  @override
  State<CheckInformationOrderOrderMe> createState() =>
      _CheckInformationOrderOrderMeState();
}

class _CheckInformationOrderOrderMeState
    extends State<CheckInformationOrderOrderMe> {
  setReload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: call_information_order_order(
          '2'), //เรียกใช้งานฟังก์ชัน call_information_order_order เพื่อ get ข้อมูล
      builder: (BuildContext context,
          AsyncSnapshot<CheckInformationOrderOrderAll?> snapshot) {
        //ตรวจสอบว่าโหลดข้อมูลได้ไหม
        //กรณีโหลดข้อมูลได้
        if (snapshot.connectionState == ConnectionState.done) {
          var result = snapshot.data; //เซ็ตค่า result

          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (result!.customerOrderHistory.customerMslOrderDetail.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    result.customerOrderHistory.customerMslOrderDetail.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (result.customerOrderHistory
                              .customerMslOrderDetail[index].orderSource ==
                          '1') {
                        Get.find<CheckInformationOrderOrderAllController>()
                            .fetch_information_order_orderdetail(
                                result
                                    .customerOrderHistory
                                    .customerMslOrderDetail[index]
                                    .orderDateTemp,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].orderType,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].userId,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].downloadFlag,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].headerStatus,
                                result
                                    .customerOrderHistory
                                    .customerMslOrderDetail[index]
                                    .statusDiscription,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].ordercamp,
                                result
                                    .customerOrderHistory
                                    .customerMslOrderDetail[index]
                                    .orderNo); //ส่งค่าไปที่ CheckInformationOrderOrderAllController และไปที่ฟังก์ชัน fetch_information_order_orderdetail
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      CheckInformationOrderOrderdetail(
                                        shopType: result
                                            .customerOrderHistory
                                            .customerMslOrderDetail[index]
                                            .orderSource,
                                      )),
                            )
                            .then((val) => val ? setReload() : null);
                      } else {
                        Get.find<CheckInformationOrderOrderAllController>()
                            .fetch_information_order_orderdetail_b2c(
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].downloadFlag,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].headerStatus,
                                result
                                    .customerOrderHistory
                                    .customerMslOrderDetail[index]
                                    .statusDiscription,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].ordercamp,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].orderNo,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].ordshopId,
                                result.customerOrderHistory
                                    .customerMslOrderDetail[index].orderSource);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => OrderDetailMsl(
                                    shopType: result
                                        .customerOrderHistory
                                        .customerMslOrderDetail[index]
                                        .orderSource,
                                  )),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [
                            HeadTitleCardDirect(
                                headTitles: result
                                    .customerOrderHistory
                                    .customerMslOrderDetail[index]
                                    .supplierName),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 15, right: 15),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              result
                                                  .customerOrderHistory
                                                  .customerMslOrderDetail[index]
                                                  .headerStatus,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          result
                                                          .customerOrderHistory
                                                          .customerMslOrderDetail[
                                                              index]
                                                          .statusOrder ==
                                                      'Y' &&
                                                  result
                                                          .customerOrderHistory
                                                          .customerMslOrderDetail[
                                                              index]
                                                          .downloadFlag ==
                                                      'Y'
                                              ? Text(
                                                  result
                                                      .customerOrderHistory
                                                      .customerMslOrderDetail[
                                                          index]
                                                      .statusDiscription,
                                                  style: const TextStyle(
                                                      color: Color(0XFF0055FF)))
                                              : Text(
                                                  result
                                                      .customerOrderHistory
                                                      .customerMslOrderDetail[
                                                          index]
                                                      .statusDiscription,
                                                  style: const TextStyle(
                                                      color:
                                                          Color(0XFF20BE79))),
                                          Text(
                                              result
                                                  .customerOrderHistory
                                                  .customerMslOrderDetail[index]
                                                  .name,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          // !v16
                                          Text(
                                              'รอบการขาย ${result.customerOrderHistory.customerMslOrderDetail[index].ordercamp}',
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          // Text(
                                          //     MultiLanguages.of(context)!
                                          //             .translate(
                                          //                 'txt_campaign_no') +
                                          //         result
                                          //             .customerOrderHistory
                                          //             .customerMslOrderDetail[
                                          //                 index]
                                          //             .ordercamp,
                                          //     style: const TextStyle(
                                          //         color: Colors.grey)),
                                          Text(
                                              MultiLanguages.of(context)!
                                                  .translate(
                                                      'txt_total_amount'),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(''),
                                          Text(result
                                              .customerOrderHistory
                                              .customerMslOrderDetail[index]
                                              .orderDate),
                                          Text(
                                              result
                                                  .customerOrderHistory
                                                  .customerMslOrderDetail[index]
                                                  .userTel
                                                  .replaceAllMapped(
                                                      RegExp(
                                                          r'(\d{3})(\d{3})(\d+)'),
                                                      (Match m) =>
                                                          "${m[1]}-${m[2]}-${m[3]}"),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey)),
                                          const Text(''),
                                          Text(
                                              "${NumberFormat.decimalPattern().format(double.parse(result.customerOrderHistory.customerMslOrderDetail[index].totalAmount))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
