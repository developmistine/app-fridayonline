import 'package:fridayonline/controller/check_information/check_information_controller.dart';
import 'package:fridayonline/homepage/check_information/layout/head_title_card_darect.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPayMentMsl extends StatefulWidget {
  const OrderPayMentMsl({super.key});

  @override
  State<OrderPayMentMsl> createState() => _OrderPayMentMslState();
}

class _OrderPayMentMslState extends State<OrderPayMentMsl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster('คำสั่งซื้อของสมาชิก'),
      body: GetX<PayMentController>(builder: (payment) {
        return payment.isDataLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : payment.getMslPayment!.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.asset('assets/images/logo/logofriday.png',
                            width: 70),
                      ),
                      const Center(child: Text('ไม่พบข้อมูล')),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: payment.getMslPayment!.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, payindex) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  payment.getMslPayment![payindex].textCampaign,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              ListView.builder(
                                itemCount: payment.getMslPayment![payindex]
                                    .orderMsl.header.length,
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      String orderNo = payment
                                          .getMslPayment![payindex]
                                          .orderMsl
                                          .header[index]
                                          .invNo;
                                      String orderCampaign = payment
                                          .getMslPayment![payindex]
                                          .orderMsl
                                          .header[index]
                                          .orderCampaign;
                                      String saleCamp = payment
                                          .getMslPayment![payindex]
                                          .orderMsl
                                          .header[index]
                                          .saleCampaign;

                                      Get.find<
                                              CheckInformationOrderHistoryController>()
                                          .fetch_information_order_history_detail(
                                              orderNo,
                                              orderCampaign,
                                              saleCamp); //ส่งค่าไปที่ CheckInformationOrderHistoryController และไปที่ฟังก์ชัน fetch_information_order_history
                                      Get.toNamed(
                                        '/check_information_order_history_detail',
                                        arguments: {
                                          "status": "",
                                          "invNo": orderNo,
                                        },
                                      ); //
                                    },
                                    child: Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const HeadTitleCardDirect(
                                                headTitles: ''),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8,
                                                  bottom: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'เลขที่ใบส่งของ ${payment.getMslPayment![payindex].orderMsl.header[index].invNo}'),
                                                  // convert 262023 to 26/2023

                                                  Text(
                                                    'รอบการขาย ${formatCamp(payment.getMslPayment![payindex].orderMsl.header[index].orderCampaign)}',
                                                    style: TextStyle(
                                                        color: theme_grey_text),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'ยอดก่อนส่วนลด',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                        ' ${myFormat.format(double.parse(payment.getMslPayment![payindex].orderMsl.header[index].grossAmount))} บาท',
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'ส่วนลดจากกำไร',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                        ' ${myFormat.format(double.parse(payment.getMslPayment![payindex].orderMsl.header[index].totalDiscount))} บาท',
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'สรุปยอดชำระ(หักส่วนลด)',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ' ${myFormat.format(double.parse(payment.getMslPayment![payindex].orderMsl.header[index].totalAmount))} บาท',
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ],
                          );
                        }),
                  );
      }),
    );
  }
}
