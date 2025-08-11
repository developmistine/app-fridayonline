// import '../../../homepage/check_information/order/order_order_all.dart';
// import '../../../homepage/check_information/order/order_order_approve.dart';
// import '../../../homepage/check_information/order/order_order_wait_approve.dart';
import 'package:fridayonline/controller/check_information/check_information_controller.dart';

import '../../../homepage/theme/theme_color.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'enduser_check_all.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อ
class EndUserCheck extends StatefulWidget {
  const EndUserCheck({super.key});

  @override
  State<EndUserCheck> createState() => _EndUserCheckState();
}

class _EndUserCheckState extends State<EndUserCheck> {
  Widget? _content = EnduserCheckAll(
      1); //เก็บค่า content ให้ค่าเริ่มต้นเป็นคลาส CheckInformationOrderOrderAll
  String? select = Get.parameters[
      'select']; //เก็บค่าที่เลือกจาก radio โดย 1=ทั้งหมด, 2=ลูกค้ารออนุมัติ, 3=ลูกค้าอนุมัติแล้ว, 4=ฉัน ให้ค่าเริ่มต้นเป็น 1
  @override
  void initState() {
    super.initState();
    Get.find<EndUserOrderCtr>().call_enduser_order();
    setSelcct(select);
  }

  //ฟังก์ชันสำหรับตรวจสอบค่าที่เลือกจาก radio
  void setSelcct(value) {
    _content = EnduserCheckAll(value);
    setState(() {
      select = value; //เซ็ต select = ค่าที่ส่งมาจาก radio
    });
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: theme_color_df,
          centerTitle: true,
          title: Text(MultiLanguages.of(context)!.translate('title_order_info'),
              style: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 0, bottom: 0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            setSelcct('1'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 2,
                                    color: select == '1'
                                        ? theme_color_df
                                        : Colors.white),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Text(
                              'รอการอนุมัติ',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: select == '1'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: select == '1'
                                      ? theme_color_df
                                      : Colors.black),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            setSelcct('2'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 2,
                                    color: select == '2'
                                        ? theme_color_df
                                        : Colors.white),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Text(
                              'กำลังจัดส่ง',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: select == '2'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: select == '2'
                                      ? theme_color_df
                                      : Colors.black),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            setSelcct('3'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 2,
                                    color: select == '3'
                                        ? theme_color_df
                                        : Colors.white),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Text(
                              'สำเร็จ',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: select == '3'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: select == '3'
                                      ? theme_color_df
                                      : Colors.black),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            setSelcct('4'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 2,
                                    color: select == '4'
                                        ? theme_color_df
                                        : Colors.white),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Text(
                              'ไม่สำเร็จ',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: select == '4'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: select == '4'
                                      ? theme_color_df
                                      : Colors.black),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 12,
                child: SingleChildScrollView(
                  child: _content, //แสดง content ตามค่าที่เลือก
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
