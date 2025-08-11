import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/theme/theme_color.dart';
import '../../../homepage/theme/theme_loading.dart';
import '../../../model/check_information/order/order_order_all.dart';
import '../../../service/check_information/check_information_service.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_orderdetail_enduser.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อ "ลูกค้าอนุมัติแล้ว"
class CheckInformationOrderOrderApprove extends StatefulWidget {
  const CheckInformationOrderOrderApprove({Key? key}) : super(key: key);

  @override
  State<CheckInformationOrderOrderApprove> createState() =>
      _CheckInformationOrderOrderApproveState();
}

class _CheckInformationOrderOrderApproveState
    extends State<CheckInformationOrderOrderApprove> {
  setReload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: call_information_order_order(
          '1'), //เรียกใช้งานฟังก์ชัน call_information_order_order เพื่อ get ข้อมูลหน้าปกแค็ตตาล็อก Ecatalog
      builder: (BuildContext context,
          AsyncSnapshot<CheckInformationOrderOrderAll?> snapshot) {
        //ตรวจสอบว่าโหลดข้อมูลได้ไหม
        //กรณีโหลดข้อมูลได้
        if (snapshot.connectionState == ConnectionState.done) {
          var result = snapshot.data; //เซ็ตค่า result =  ข้อมูลหน้าปกแค็ตตาล็อก

          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (result!
              .customerOrderHistory.customerEndUserOrderDetail.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: result
                    .customerOrderHistory.customerEndUserOrderDetail.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap: () {
                        Get.find<CheckInformationOrderOrderAllController>()
                            .fetch_information_order_orderdetail_enduser(
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].downloadFlag,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].headerStatus,
                          result
                              .customerOrderHistory
                              .customerEndUserOrderDetail[index]
                              .statusDiscription,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].statusOrder,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].orderDate,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].name,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].ordercamp,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].totalAmount,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].userId,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].userTel,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].orderNo,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].reciveTypeText,
                          result.customerOrderHistory
                              .customerEndUserOrderDetail[index].orderSource,
                        ); //ส่งค่าไปที่ CheckInformationOrderOrderAllController และไปที่ฟังก์ชัน fetch_information_order_orderdetail_enduser
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      CheckInformationOrderOrderdetailEndUser(
                                        userId: result
                                            .customerOrderHistory
                                            .customerEndUserOrderDetail[index]
                                            .userId,
                                        orderNo: result
                                            .customerOrderHistory
                                            .customerEndUserOrderDetail[index]
                                            .orderNo,
                                        phone: result
                                            .customerOrderHistory
                                            .customerEndUserOrderDetail[index]
                                            .userTel,
                                      )),
                            )
                            .then((val) => val ? setReload() : null);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.0,
                                color: Color.fromARGB(255, 224, 224, 224)),
                          ), // Set border width
                          // Make rounded corner of border
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              result
                                                  .customerOrderHistory
                                                  .customerEndUserOrderDetail[
                                                      index]
                                                  .headerStatus,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          Text(
                                              result
                                                  .customerOrderHistory
                                                  .customerEndUserOrderDetail[
                                                      index]
                                                  .statusDiscription,
                                              style: result
                                                          .customerOrderHistory
                                                          .customerEndUserOrderDetail[
                                                              index]
                                                          .statusOrder ==
                                                      'N'
                                                  ? const TextStyle(
                                                      color: Color(0XFFEC8E00))
                                                  : const TextStyle(
                                                      color: Color(0XFF20BE79),
                                                    )),
                                          Text(
                                              result
                                                  .customerOrderHistory
                                                  .customerEndUserOrderDetail[
                                                      index]
                                                  .name,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          Text(
                                              'รอบการขาย ${result.customerOrderHistory.customerEndUserOrderDetail[index].ordercamp}',
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
                                          Text(
                                              MultiLanguages.of(context)!
                                                  .translate('txt_see_more'),
                                              style: TextStyle(
                                                  color: theme_color_df)),
                                          Text(result
                                              .customerOrderHistory
                                              .customerEndUserOrderDetail[index]
                                              .orderDate),
                                          Text(
                                              result
                                                  .customerOrderHistory
                                                  .customerEndUserOrderDetail[
                                                      index]
                                                  .userTel
                                                  .replaceAllMapped(
                                                      RegExp(
                                                          r'(\d{3})(\d{3})(\d+)'),
                                                      (Match m) =>
                                                          "${m[1]}-${m[2]}-${m[3]}"),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey)),
                                          Text(
                                            result
                                                .customerOrderHistory
                                                .customerEndUserOrderDetail[
                                                    index]
                                                .reciveTypeText,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          Text(
                                              "${result.customerOrderHistory.customerEndUserOrderDetail[index].totalAmount} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    )
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
                    Text(MultiLanguages.of(context)!
                        .translate('alert_no_datas')),
                  ],
                ),
              ),
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
