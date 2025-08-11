import 'package:fridayonline/controller/check_information/check_information_controller.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:get/get.dart';

import 'order_history_direct_sales_enduser.dart';
import 'order_history_direct_sales_msl.dart';
import 'package:flutter/material.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อ
class CheckInformationOrderHistory extends StatefulWidget {
  const CheckInformationOrderHistory({super.key});

  @override
  State<CheckInformationOrderHistory> createState() =>
      _CheckInformationOrderHistoryState();
}

class _CheckInformationOrderHistoryState
    extends State<CheckInformationOrderHistory> {
  Widget _content =
      const OrderHistoryDirectSalesMsl(); //เก็บค่า content ให้ค่าเริ่มต้นเป็นคลาส OrderHistoryDirectSalesMsl
  String? select =
      '1'; //เก็บค่าที่เลือกจาก radio โดย 1=ทั้งหมด, 2=ลูกค้ารออนุมัติ, 3=ลูกค้าอนุมัติแล้ว, 4=ฉัน ให้ค่าเริ่มต้นเป็น 1
  String? selectStatus = '1';
  //ฟังก์ชันสำหรับตรวจสอบค่าที่เลือกจาก radio
  void setSelcct(value) {
    //กรณีที่เป็น 1
    if (value == '1') {
      _content =
          const OrderHistoryDirectSalesMsl(); //ให้ _content = OrderHistoryDirectSalesMsl

      //กรณีที่เป็น 2
    } else if (value == '2') {
      Get.find<CheckInformationOrderHistoryController>()
          .fetch_order_history_enduser();
      _content = CheckInformationOrderHistoryCustomer(
          selectTabs:
              selectStatus); //ให้ _content = CheckInformationOrderHistoryCustomer
    }

    setState(() {
      select = value; //เซ็ต select = ค่าที่ส่งมาจาก radio
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 9,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setSelcct('1'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                      },
                      child: Row(
                        children: [
                          if (select == '1')
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.black),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.circle,
                                  color: Color(0xFF00adef),
                                  size: 15,
                                ),
                              ),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.black),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Text(
                              'คำสั่งซื้อในนามสมาชิก',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: () {
                          setSelcct('2'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                        },
                        child: Row(
                          children: [
                            if (select == '2')
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.black),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.circle,
                                    color: Color(0xFF00adef),
                                    size: 15,
                                  ),
                                ),
                              )
                            else
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.black),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                'ลูกค้า (COD)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //? fade return product
              // Expanded(
              //   flex: 8,
              //   child: OutlinedButton(
              //     onPressed: () async {
              //       SetData data = SetData();
              //       var repSeq = await data.repSeq;
              //       var device = await data.device;
              //       Get.to(() => webview_app(
              //             mparamurl:
              //                 //`${base_url_web_fridayth}history/msl/return_history_webview?repSeq=$repSeq&device=$device`,
              //                 "http://localhost:3000/history/msl/return_history_webview?repSeq=$repSeq&device=$device",
              //             // "https://555e-83-118-76-254.ngrok-free.app/history/msl/return_history_webview?repSeq=$repSeq&device=$device",
              //             mparamTitleName: 'ประวัติแจ้งคืนสินค้า',
              //           ));
              //     },
              //     style: OutlinedButton.styleFrom(
              //       backgroundColor: Colors.white,
              //       foregroundColor: Colors.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       side: BorderSide(
              //         color: theme_red,
              //         width: 1,
              //       ),
              //     ),
              //     child: Text(
              //       'ประวัติการแจ้งคืนสินค้า', //แสดงข้อความ ประวัติการสั่งซื้อ
              //       style: TextStyle(
              //         color: theme_red,
              //         fontSize: 12,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        if (select == '2')
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      selectStatus = '1';
                      _content = CheckInformationOrderHistoryCustomer(
                          selectTabs: selectStatus); //ให้ _
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectStatus == '1'
                                ? theme_color_df
                                : Colors.white,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        'กำลังดำเนินการ',
                        style: TextStyle(
                          color: selectStatus == '1'
                              ? theme_color_df
                              : Colors.black,
                          fontWeight: selectStatus == '1'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      )),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      selectStatus = '2';
                      _content = CheckInformationOrderHistoryCustomer(
                          selectTabs: selectStatus); //ให้ _
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectStatus == '2'
                                ? theme_color_df
                                : Colors.white,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        'สำเร็จ',
                        style: TextStyle(
                          color: selectStatus == '2'
                              ? theme_color_df
                              : Colors.black,
                          fontWeight: selectStatus == '2'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      )),
                )),
              ],
            ),
          ),
        Expanded(
          child: _content, //แสดง content ตามค่าที่เลือก
        ),
      ],
    );
  }
}
