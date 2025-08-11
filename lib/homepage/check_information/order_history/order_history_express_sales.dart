import 'package:get/get.dart';

import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/theme/theme_loading.dart';
import '../../../model/check_information/order_history/order_histor_dropship.dart';
// import '../../../model/check_information/order_history/order_history_me.dart';
import '../../../service/check_information/check_information_service.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../layout/head_title_card_express.dart';

//คลาสสำหรับแสดงข้อมูลประวัติรายการสั่งซื้อ ส่งด่วน
class OrderHistoryExpressSales extends StatefulWidget {
  const OrderHistoryExpressSales({Key? key}) : super(key: key);

  @override
  State<OrderHistoryExpressSales> createState() =>
      _OrderHistoryExpressSalesState();
}

class _OrderHistoryExpressSalesState extends State<OrderHistoryExpressSales> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future:
          call_history_dropship(), //เรียกใช้งานฟังก์ชัน call_information_delivery_status เพื่อ get ข้อมูล
      builder: (BuildContext context,
          AsyncSnapshot<List<DropshipOrderHistory>?> snapshot) {
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
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Get.find<CheckInformationOrderHistoryController>()
                              .fetch_detail_history_dropship(result[index]
                                  .orderId); //ส่งค่าไปที่ CheckInformationOrderHistoryController และไปที่ฟังก์ชัน fetch_information_order_history
                          Get.toNamed(
                              '/check_information_order_history_express_detail'); //กำหนด Route ไปที่ /check_information_order_history_detail
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const HeadTitleExpress(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20, bottom: 10),
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
                                                result[index].orderNo,
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        Text(
                                            'รอบการขาย ${result[index].orderCamp}',
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    // Expanded(
                                    //   child: Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.end,
                                    //     children: [
                                    //       Container(
                                    //         width: 104,
                                    //         decoration: BoxDecoration(
                                    //             border: Border.all(
                                    //                 width: 3,
                                    //                 color: const Color(
                                    //                     0XFFC5E4F4)),
                                    //             color: const Color(0XFFC5E4F4),
                                    //             borderRadius:
                                    //                 BorderRadius.circular(25)),
                                    //         child: Padding(
                                    //           padding: const EdgeInsets.all(5),
                                    //           child: Center(
                                    //             child: Row(
                                    //               children: [
                                    //                 Container(
                                    //                   decoration: BoxDecoration(
                                    //                     border: Border.all(
                                    //                         width: 3,
                                    //                         color: const Color(
                                    //                             0XFFFD7F6B)),
                                    //                     color: const Color(
                                    //                         0XFFC5E4F4),
                                    //                     borderRadius:
                                    //                         BorderRadius
                                    //                             .circular(100),
                                    //                   ),
                                    //                   child: Padding(
                                    //                     padding:
                                    //                         const EdgeInsets
                                    //                             .all(2),
                                    //                     child: Container(
                                    //                       decoration:
                                    //                           BoxDecoration(
                                    //                         border: Border.all(
                                    //                             width: 3,
                                    //                             color: const Color(
                                    //                                 0XFFFD7F6B)),
                                    //                         color: const Color(
                                    //                             0XFFFD7F6B),
                                    //                         borderRadius:
                                    //                             BorderRadius
                                    //                                 .circular(
                                    //                                     100),
                                    //                       ),
                                    //                       child: const Text(
                                    //                         'BW',
                                    //                         style: TextStyle(
                                    //                             fontWeight:
                                    //                                 FontWeight
                                    //                                     .bold,
                                    //                             color: Color(
                                    //                                 0XFFC5E4F4),
                                    //                             fontSize: 8),
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 const Padding(
                                    //                   padding: EdgeInsets.only(
                                    //                       left: 5, right: 5),
                                    //                   child: Text(
                                    //                     '+50',
                                    //                     style: TextStyle(
                                    //                         fontWeight:
                                    //                             FontWeight.bold,
                                    //                         color: Colors.black,
                                    //                         fontSize: 10),
                                    //                   ),
                                    //                 ),
                                    //                 const Expanded(
                                    //                   child: Text(
                                    //                     'คะแนน',
                                    //                     style: TextStyle(
                                    //                         fontWeight:
                                    //                             FontWeight.bold,
                                    //                         color: Colors.black,
                                    //                         fontSize: 10),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    'สินค้า ' +
                                        result[index].totItem +
                                        ' รายการ สรุปยอดชำระ ' +
                                        NumberFormat.decimalPattern().format(
                                            double.parse(
                                                result[index].totAmount)) +
                                        ' บาท',
                                    style: const TextStyle(
                                        color: Color(0XFFFF0000),
                                        fontSize: 15)),
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
