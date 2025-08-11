import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/theme/theme_loading.dart';
// import '../../../model/check_information/delivery_status/delivery_status.dart';
import '../../../model/check_information/delivery_status/getdropship_delivery_status.dart';
import '../../../service/check_information/check_information_service.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../layout/head_title_card_express.dart';

//คลาสสำหรับแสดงสถานะการจัดส่ง
class DeliveryStatusExpressSales extends StatefulWidget {
  const DeliveryStatusExpressSales({Key? key}) : super(key: key);

  @override
  State<DeliveryStatusExpressSales> createState() =>
      _DeliveryStatusExpressSalesState();
}

class _DeliveryStatusExpressSalesState
    extends State<DeliveryStatusExpressSales> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          call_information_delivery_status_dropship(), //เรียกใช้งานฟังก์ชัน call_information_delivery_status เพื่อ get ข้อมูล
      builder: (BuildContext context,
          AsyncSnapshot<List<GetDropshipDeliveryStatus>?> snapshot) {
        //ตรวจสอบว่าโหลดข้อมูลได้ไหม
        //กรณีโหลดข้อมูลได้
        if (snapshot.connectionState == ConnectionState.done) {
          var result = snapshot.data; //เซ็ตค่า result =  ข้อมูลหน้าปกแค็ตตาล็อก

          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (result!.isNotEmpty) {
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Get.find<CheckInformationDeliveryStatusController>()
                              .detail_delivery_dropship(result[index].orderId,
                                  result[index].trackingNo);
                          Get.toNamed(
                              '/delivery_status_express_sales_detail'); //กำหนด Route ไปที่ /check_information_delivery_status_detail
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
                              const HeadTitleExpress(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            MultiLanguages.of(context)!
                                                .translate('order_no'),
                                          ),
                                          Text(
                                            result[index].orderNo,
                                          ),
                                        ]),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(result[index].orderStatus,
                                            style: const TextStyle(
                                                color: Color(0XFF20BE79))),
                                        Text(result[index]
                                            .createDate
                                            .split(' ')
                                            .last),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(result[index].name,
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                        Text(
                                            'รอบจำหน่ายที่ ${result[index].orderCamp}',
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            MultiLanguages.of(context)!
                                                .translate('txt_total_amount'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Text(
                                            '${NumberFormat.decimalPattern().format(double.parse(result[index].totAmount))} บาท',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ],
                                    )
                                  ],
                                ),
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
