import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/check_information/check_information_controller.dart';
import '../../controller/return_product_controller.dart';
import 'return_history_details.dart';

class OrderHistoryReturnProduct extends StatelessWidget {
  const OrderHistoryReturnProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster(
        'ประวัติแจ้งคืนสินค้า',
      ),
      body: GetX<ReturnProductController>(builder: (ctl) {
        if (ctl.isDataLoading.value) {
          return Center(
            child: theme_loading_df,
          );
        } else {
          if (ctl.historyReturnAll!.isNotEmpty) {
            return WillPopScope(
              onWillPop: () async {
                Get.find<SetSelectInformation>().set_select_information(2);
                Get.find<CheckInformationOrderOrderAllController>()
                    .fetch_information_order_all();
                Get.find<CheckInformationDeliveryStatusController>()
                    .fetch_information_delivery_status();
                Get.find<CheckInformationOrderHistoryController>()
                    .fetch_information_order_history_me();
                Get.find<ReturnProductController>().fetchBadgerReturnProduct();
                Get.offAllNamed(
                  'check_information_order_history',
                  predicate: (route) =>
                      route.isFirst || route.settings.name == '/index',
                );
                return true;
              },
              child: ListView.builder(
                itemCount: ctl.historyReturnAll!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(14, 0, 0, 0),
                              offset: Offset(0.0, 4.0),
                              blurRadius: 0.2,
                              spreadRadius: 0.2,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0,
                                left: 10.0,
                                right: 10.0,
                                top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('แจ้งคืนสินค้า',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: theme_red,
                                        fontWeight: FontWeight.bold)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: theme_red)),
                                      onPressed: () {},
                                      child: Text(
                                        ctl.historyReturnAll![index].status,
                                        style: TextStyle(
                                            color: theme_red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'รอบการขาย ${ctl.historyReturnAll![index].campDate}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  ctl.historyReturnAll![index].creDate,
                                  style: TextStyle(color: theme_grey_text),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('เลขที่ใบส่งของ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(ctl.historyReturnAll![index].invoice)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('แจ้งคืน',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(ctl.historyReturnAll![index].totalAll)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 4, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('ยอดเงินคืน',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                RichText(
                                    text: TextSpan(
                                        text: myFormat.format(ctl
                                            .historyReturnAll![index].amount),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontFamily: 'notoreg',
                                            fontWeight: FontWeight.bold),
                                        children: const [
                                      TextSpan(
                                          text: ' บาท',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'notoreg'))
                                    ]))
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: Get.width,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: theme_red,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () {
                                      // getHistoryBySeq
                                      // Get.find<ReturnProductController>()
                                      //     .fetchHistoryReturnBySeq(
                                      //         ctl.historyReturnAll![index]
                                      //             .invoice,
                                      //         ctl.historyReturnAll![index]
                                      //             .seqNo);
                                      Get.to(() => const ReturnHistoryDetails(),
                                          transition: Transition.rightToLeft);
                                    },
                                    child:
                                        const Text('ติดตามสถานะคำขอคืนสินค้า')),
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo/logofriday.png', width: 70),
                const SizedBox(
                  height: 10,
                ),
                const Center(child: Text('ไม่พบข้อมูล')),
              ],
            );
          }
        }
      }),
    );
  }
}
