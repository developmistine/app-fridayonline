import 'package:fridayonline/homepage/check_information/delivery_status/delivery_status_detail_b2c.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';

import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/theme/theme_loading.dart';
import '../../../model/check_information/order_history/order_history_msl.dart';
import '../../../service/check_information/check_information_service.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../layout/head_title_card_darect.dart';

//คลาสสำหรับแสดงข้อมูลประวัติรายการสั่งซื้อ "ฉัน"
class OrderHistoryDirectSalesMsl extends StatefulWidget {
  const OrderHistoryDirectSalesMsl({super.key});

  @override
  State<OrderHistoryDirectSalesMsl> createState() =>
      _OrderHistoryDirectSalesMslState();
}

class _OrderHistoryDirectSalesMslState
    extends State<OrderHistoryDirectSalesMsl> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future:
          call_information_order_history_me(), //เรียกใช้งานฟังก์ชัน call_information_delivery_status เพื่อ get ข้อมูล
      builder: (BuildContext context,
          AsyncSnapshot<List<OrderHistoryMsl>?> snapshot) {
        //ตรวจสอบว่าโหลดข้อมูลได้ไหม
        //กรณีโหลดข้อมูลได้

        if (snapshot.hasData) {
          var result = snapshot.data; //เซ็ตค่า result =  ข้อมูลหน้าปกแค็ตตาล็อก

          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (result!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: InkWell(
                      onTap: () {
                        if (result[index].orderSource == '1') {
                          Get.find<CheckInformationOrderHistoryController>()
                              .fetch_information_order_history_detail(
                                  result[index].invoiceNo,
                                  result[index].orderCampaign,
                                  result[index]
                                      .saleCampaign); //ส่งค่าไปที่ CheckInformationOrderHistoryController และไปที่ฟังก์ชัน fetch_information_order_history
                          Get.toNamed(
                            '/check_information_order_history_detail',
                            arguments: {
                              "status": result[index].status,
                              "invNo": result[index].invoiceNo,
                            },
                          ); //กำหนด Route ไปที่ /check_information_order_history_detail
                        } else {
                          Get.find<CheckInformationDeliveryStatusController>()
                              .fetch_information_delivery_orderdetail_b2c(
                                  result[index].orderNo,
                                  result[index].ordshopId,
                                  result[index].orderSource);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    CheckInformationDeliveryStatusDetailB2C(
                                      shopType: result[index].orderSource,
                                    )),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // !v16
                            HeadTitleCardDirect(
                                headTitles: result[index].supplierName),
                            // HeadTitleCardDirect(
                            //     headTitles: 'จัดส่งตามรอบจำหน่าย'),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          MultiLanguages.of(context)!
                                                  .translate('order_no') +
                                              result[index].invoiceNo,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      Text(
                                          "รอบการขาย ${result[index].saleCampaign}",
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: result[index].note == "" ? 10 : 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          'ยอดก่อนส่วนลด',
                                          style: TextStyle(
                                              color: Color(0XFFFF0000),
                                              fontSize: 15)),
                                      Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          'ส่วนลดจากกำไร',
                                          style: TextStyle(
                                              color: Color(0XFFFF0000),
                                              fontSize: 15)),
                                      Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          'สรุปยอดชำระ(หักส่วนลด)',
                                          style: TextStyle(
                                              color: Color(0XFFFF0000),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          myFormat.format(
                                                  result[index].grossAmount) +
                                              ' บาท',
                                          style: const TextStyle(
                                              color: Color(0XFFFF0000),
                                              fontSize: 15)),
                                      Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          myFormat.format(
                                                  result[index].totalDiscount) +
                                              ' บาท',
                                          style: const TextStyle(
                                              color: Color(0XFFFF0000),
                                              fontSize: 15)),
                                      Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          myFormat.format(
                                                  result[index].totalAmount) +
                                              ' บาท',
                                          style: const TextStyle(
                                              color: Color(0XFFFF0000),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (result[index].note != "")
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'หมายเหตุ',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 170,
                                      child: Text(
                                        result[index].note,
                                        overflow: TextOverflow.clip,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
                  Text(MultiLanguages.of(context)!.translate('alert_no_datas')),
                ],
              )),
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
