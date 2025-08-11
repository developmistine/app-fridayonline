import 'order_history_direct_sales_enduser.dart';
import 'order_history_direct_sales_msl.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อ
class CheckInformationOrderHistory extends StatefulWidget {
  const CheckInformationOrderHistory({Key? key}) : super(key: key);

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

  //ฟังก์ชันสำหรับตรวจสอบค่าที่เลือกจาก radio
  void setSelcct(value) {
    //กรณีที่เป็น 1
    if (value == '1') {
      _content =
          const OrderHistoryDirectSalesMsl(); //ให้ _content = OrderHistoryDirectSalesMsl

      //กรณีที่เป็น 2
    } else if (value == '2') {
      _content =
          const CheckInformationOrderHistoryCustomer(); //ให้ _content = CheckInformationOrderHistoryCustomer

    }

    setState(() {
      select = value; //เซ็ต select = ค่าที่ส่งมาจาก radio
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                            border: Border.all(width: 2, color: Colors.black),
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
                            border: Border.all(width: 2, color: Colors.black),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          MultiLanguages.of(context)!.translate('order_me'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: InkWell(
                    onTap: () {
                      setSelcct('2'); //ส่งค่า 1 ไปที่ฟังก์ชัน setSelcct
                    },
                    child: Row(
                      children: [
                        if (select == '2')
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.black),
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
                              border: Border.all(width: 2, color: Colors.black),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            MultiLanguages.of(context)!
                                .translate('order_me_customer'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 14),
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
            child: _content, //แสดง content ตามค่าที่เลือก
          ),
        ],
      ),
    );
  }
}
