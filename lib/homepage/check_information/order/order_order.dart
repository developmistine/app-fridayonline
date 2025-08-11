import '../../../homepage/check_information/order/order_order_all.dart';
import '../../../homepage/check_information/order/order_order_approve.dart';
import '../../../homepage/check_information/order/order_order_me.dart';
import '../../../homepage/check_information/order/order_order_wait_approve.dart';
import '../../../homepage/theme/theme_color.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อ
class CheckInformationOrderOrder extends StatefulWidget {
  const CheckInformationOrderOrder({Key? key}) : super(key: key);

  @override
  State<CheckInformationOrderOrder> createState() =>
      _CheckInformationOrderOrderState();
}

class _CheckInformationOrderOrderState
    extends State<CheckInformationOrderOrder> {
  Widget?
      _content; //เก็บค่า content ให้ค่าเริ่มต้นเป็นคลาส CheckInformationOrderOrderAll
  String?
      select; //เก็บค่าที่เลือกจาก radio โดย 1=ทั้งหมด, 2=ลูกค้ารออนุมัติ, 3=ลูกค้าอนุมัติแล้ว, 4=ฉัน ให้ค่าเริ่มต้นเป็น 1
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    setSelcct('1');
  }

  //ฟังก์ชันสำหรับตรวจสอบค่าที่เลือกจาก radio
  void setSelcct(value) {
    //กรณีที่เป็น 1
    if (value == '1') {
      _content =
          const CheckInformationOrderAll(); //ให้ _content = CheckInformationOrderOrderAll

      //กรณีที่เป็น 2
    } else if (value == '2') {
      _content =
          const CheckInformationOrderOrderWaitApprove(); //ให้ _content = CheckInformationOrderOrderWaitApprove

      //กรณีที่เป็น 3
    } else if (value == '3') {
      _content =
          const CheckInformationOrderOrderApprove(); //ให้ _content = CheckInformationOrderOrderApprove

      //กรณีที่เป็น 4
    } else if (value == '4') {
      _content =
          const CheckInformationOrderOrderMe(); //ให้ _content = CheckInformationOrderOrderMe
    }

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
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: theme_color_df,
            centerTitle: true,
            title: Text(
                MultiLanguages.of(context)!.translate('title_order_info'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 20, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setSelcct('1'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                          },
                          child: Row(
                            children: [
                              if (select == '1')
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.circle,
                                      color: Color(0xFF00adef),
                                      size: 12,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('order_show_all'),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 2,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setSelcct('2'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                          },
                          child: Row(
                            children: [
                              if (select == '2')
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.circle,
                                      color: Color(0xFF00adef),
                                      size: 12,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('order_waiting_approve'),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setSelcct('3'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                          },
                          child: Row(
                            children: [
                              if (select == '3')
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.circle,
                                      color: Color(0xFF00adef),
                                      size: 12,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('order_approved'),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setSelcct('4'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                          },
                          child: Row(
                            children: [
                              if (select == '4')
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.circle,
                                      color: Color(0xFF00adef),
                                      size: 12,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('order_me'),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _content, //แสดง content ตามค่าที่เลือก
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
