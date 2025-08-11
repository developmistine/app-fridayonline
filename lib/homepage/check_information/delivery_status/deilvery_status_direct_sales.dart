import 'package:fridayonline/homepage/check_information/delivery_status/delivery_status_detail_b2c.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';

import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/theme/theme_loading.dart';
import '../../../model/check_information/delivery_status/delivery_status.dart';
import '../../../service/check_information/check_information_service.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../layout/head_title_card_darect.dart';

//คลาสสำหรับแสดงสถานะการจัดส่ง
class DeliveryStatusDirectSales extends StatefulWidget {
  const DeliveryStatusDirectSales({super.key});

  @override
  State<DeliveryStatusDirectSales> createState() =>
      _DeliveryStatusDirectSalesState();
}

class _DeliveryStatusDirectSalesState extends State<DeliveryStatusDirectSales> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          call_information_delivery_status(), //เรียกใช้งานฟังก์ชัน call_information_delivery_status เพื่อ get ข้อมูล
      builder: (BuildContext context,
          AsyncSnapshot<CheckInformationDeliveryStatus?> snapshot) {
        //ตรวจสอบว่าโหลดข้อมูลได้ไหม
        //กรณีโหลดข้อมูลได้
        if (snapshot.connectionState == ConnectionState.done) {
          var result = snapshot.data; //เซ็ตค่า result =  ข้อมูลหน้าปกแค็ตตาล็อก

          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (result!.orderMsl.header.isNotEmpty) {
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: result.orderMsl.header.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          if (result.orderMsl.header[index].orderSource ==
                              '1') {
                            Get.find<CheckInformationDeliveryStatusController>()
                                .fetch_information_delivery_status_detail(
                              result.orderMsl.header[index].orderCampaign,
                              result.orderMsl.header[index].invNo,
                              result.orderMsl.header[index].billCampaign,
                              result.orderMsl.header[index].billSeq,
                            ); //ส่งค่าไปที่ CheckInformationDeliveryStatusController และไปที่ฟังก์ชัน fetch_information_delivery_status_detail
                            Get.toNamed(
                                '/check_information_delivery_status_detail'); //กำหนด Route ไปที่ /check_information_delivery_status_detail
                          } else {
                            Get.find<CheckInformationDeliveryStatusController>()
                                .fetch_information_delivery_orderdetail_b2c(
                                    result.orderMsl.header[index].orderNo,
                                    result.orderMsl.header[index].ordshopId,
                                    result.orderMsl.header[index].orderSource);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      CheckInformationDeliveryStatusDetailB2C(
                                          shopType: result.orderMsl
                                              .header[index].orderSource)),
                            );
                          }
                        },
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
                              // !v16
                              HeadTitleCardDirect(
                                  headTitles: result
                                      .orderMsl.header[index].supplierName),
                              // HeadTitleCardDirect(
                              //     headTitles: 'จัดส่งตามรอบจำหน่าย'),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20, bottom: 15),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    MultiLanguages.of(context)!
                                                            .translate(
                                                                'order_no') +
                                                        result
                                                            .orderMsl
                                                            .header[index]
                                                            .invNo,
                                                    style: const TextStyle(
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                            Text(
                                              result.orderMsl.header[index]
                                                  .status,
                                              style: TextStyle(
                                                  color: setBillColor(result
                                                      .orderMsl
                                                      .header[index]
                                                      .statusColor)),
                                            ),
                                            Text(
                                                result.orderMsl.header[index]
                                                    .repName,
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                            Text(
                                                result.orderMsl.header[index]
                                                    .saleCampaign,
                                                style: const TextStyle(
                                                    color: Colors.grey)),
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
                                                .orderMsl.header[index].invDate
                                                .split(' ')
                                                .last),
                                            const Text(''),
                                            const Text(''),
                                            Text(
                                                "${NumberFormat.decimalPattern().format(double.parse(result.orderMsl.header[index].totalAmount))} ${MultiLanguages.of(context)!.translate('order_baht')}",
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
              ),
            );

            //กรณีไม่มีข้อมูล
          } else {
            //แสดงข้อความว่า ไม่พบข้อมูล
            return Center(
              child:
                  Text(MultiLanguages.of(context)!.translate('alert_no_datas')),
            );
          }

          //กรณีไม่สามารถโหลดข้อมูลได้
        } else {
          return Center(
            child: theme_loading_df,
          );
        }
      },
    );
  }
}
