import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/model/check_information/order_history/order_history_enduser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/check_information/check_information_controller.dart';
// import '../../../model/check_information/order_history/order_history_enduser.dart';
// import '../../../service/check_information/check_information_service.dart';
import '../../../service/languages/multi_languages.dart';
import '../../theme/theme_loading.dart';
import '../layout/head_title_card_darect.dart';

class CheckInformationOrderHistoryCustomer extends StatefulWidget {
  final String? selectTabs;
  const CheckInformationOrderHistoryCustomer({super.key, this.selectTabs});

  @override
  State<CheckInformationOrderHistoryCustomer> createState() =>
      _CheckInformationOrderHistoryCustomerState();
}

class _CheckInformationOrderHistoryCustomerState
    extends State<CheckInformationOrderHistoryCustomer> {
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    String tabs = widget.selectTabs.toString();
    if (tabs == '1') {
      return GetX<CheckInformationOrderHistoryController>(
        //เรียกใช้งานฟังก์ชัน call_information_delivery_status เพื่อ get ข้อมูล
        builder: (snapshot) {
          if (snapshot.isDataLoading.value) {
            return Center(
              child: theme_loading_df,
            );
          } else {
            if (snapshot.order_history_enduser!.inprocessDetail.isNotEmpty) {
              var result = snapshot.order_history_enduser!;
              return inprocess(result);
            } else {
              return empty(context);
            }
          }
        },
      );
    } else {
      return GetX<CheckInformationOrderHistoryController>(
        //ตรวจสอบว่าโหลดข้อมูลได้ไหม
        //กรณีโหลดข้อมูลได้
        builder: (snapshot) {
          if (snapshot.isDataLoading.value) {
            return Center(
              child: theme_loading_df,
            );
          } else {
            if (snapshot.order_history_enduser!.successDetail.isNotEmpty) {
              var result = snapshot.order_history_enduser!;
              return success(result);
            } else {
              return empty(context);
            }
          }
        },
      );
    }
  }

  Padding success(GetHistoryEnduser result) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: result.successDetail.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: InkWell(
              onTap: () {
                Get.find<CheckInformationOrderHistoryController>()
                    .fetch_information_order_history_enduser_detail(
                        result.successDetail[index].invoiceNo,
                        result.successDetail[index].enduserId,
                        result.successDetail[index].orderCampaign,
                        result.successDetail[index].saleCampaign,
                        '3'); //ส่งค่าไปที่ CheckInformationOrderHistoryController และไปที่ฟังก์ชัน fetch_information_order_history
                Get.toNamed(
                    '/check_information_order_history_detail'); //กำหนด Route ไปที่ /check_information_order_history_detail
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeadTitleCardDirect(headTitles: ''),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,s
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'เลขที่ใบส่งของ ${result.successDetail[index].invoiceNo}',
                                  style: const TextStyle(color: Colors.black)),
                              Text(result.successDetail[index].status,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color: Color(0xFF20BE79),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text(
                              'รอบการขาย ${result.successDetail[index].orderCampaign}',
                              style: TextStyle(color: Colors.grey.shade600)),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'ลูกค้า',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                    ':  ${result.successDetail[index].enduserName}',
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'เบอร์โทร',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                    ':  ${formatPhoneNumber(result.successDetail[index].enduserTelnumber)}',
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'การชำระเงิน',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                    ":  ${result.successDetail[index].reciveTypeText}",
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ยอดก่อนหักส่วนลด',
                                style: TextStyle(color: Colors.red),
                              ),
                              Text(
                                  "${myFormat.format(result.successDetail[index].grossAmount)}  บาท",
                                  style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ส่วนลดจากกำไร',
                                style: TextStyle(color: Colors.red),
                              ),
                              Text(
                                  "${myFormat.format(result.successDetail[index].totalDiscount)}  บาท",
                                  style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('สรุปยอดชำระ(หักส่วนลด)',
                              style: TextStyle(
                                  color: Color(0XFFFF0000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              '${myFormat.format(result.successDetail[index].totalAmount)} บาท',
                              style: const TextStyle(
                                  color: Color(0XFFFF0000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))
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
    );
  }

  Padding inprocess(GetHistoryEnduser result) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: result.inprocessDetail.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: InkWell(
              onTap: () {
                Get.find<CheckInformationOrderHistoryController>()
                    .fetch_information_order_history_enduser_detail(
                        result.inprocessDetail[index].invoiceNo,
                        result.inprocessDetail[index].enduserId,
                        result.inprocessDetail[index].orderCampaign,
                        result.inprocessDetail[index].saleCampaign,
                        '2'); //ส่งค่าไปที่ CheckInformationOrderHistoryController และไปที่ฟังก์ชัน fetch_information_order_history
                Get.toNamed(
                    '/check_information_order_history_detail'); //กำหนด Route ไปที่ /check_information_order_history_detail
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeadTitleCardDirect(headTitles: ''),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,s
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'เลขที่ใบส่งของ ${result.inprocessDetail[index].invoiceNo}',
                                  style: const TextStyle(color: Colors.black)),
                              Text(result.inprocessDetail[index].status,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: result.inprocessDetail[index]
                                                  .statusCode ==
                                              "G"
                                          ? const Color(0xFF20BE79)
                                          : Colors.orange,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text(
                              'รอบการขาย ${result.inprocessDetail[index].orderCampaign}',
                              style: TextStyle(color: Colors.grey.shade600)),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'ลูกค้า',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                    ': ${result.inprocessDetail[index].enduserName}',
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'เบอร์โทร',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                    ': ${formatPhoneNumber(result.inprocessDetail[index].enduserTelnumber)}',
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'การชำระเงิน',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                    result
                                        .inprocessDetail[index].reciveTypeText,
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ยอดก่อนหักส่วนลด',
                                        style: TextStyle(
                                            color: Color(0XFFFF0000),
                                            fontSize: 15)),
                                  ]),
                              Column(children: [
                                Text(
                                    "${myFormat.format(result.inprocessDetail[index].grossAmount)} บาท",
                                    style: const TextStyle(
                                        color: Color(0XFFFF0000),
                                        fontSize: 15)),
                              ]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ส่วนลดจากกำไร',
                                        style: TextStyle(
                                            color: Color(0XFFFF0000),
                                            fontSize: 15)),
                                  ]),
                              Column(children: [
                                Text(
                                    "${myFormat.format(result.inprocessDetail[index].totalDiscount)}  บาท",
                                    style: const TextStyle(
                                        color: Color(0XFFFF0000),
                                        fontSize: 15)),
                              ]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('สรุปยอดชำระ(หักส่วนลด)',
                                        style: TextStyle(
                                            color: Color(0XFFFF0000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                              Column(children: [
                                Text(
                                    myFormat.format(result
                                        .inprocessDetail[index].totalAmount),
                                    style: const TextStyle(
                                        color: Color(0XFFFF0000),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ]),
                            ],
                          ),
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
    );
  }

  Column empty(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo/logofriday.png',
          width: 50,
          height: 50,
        ),
        Text(MultiLanguages.of(context)!.translate('alert_no_datas')),
      ],
    );
  }
}
