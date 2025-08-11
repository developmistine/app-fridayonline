// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

// import 'package:flutter/cupertino.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/model/check_information/enduser/enduser_check_information.dart';
import 'package:get/get.dart';

import '../../../controller/check_information/check_information_controller.dart';
import '../../../homepage/theme/theme_loading.dart';
// import '../../../model/check_information/enduser/enduser_check_information.dart';
import '../../../service/languages/multi_languages.dart';
// import '../../../service/check_information/check_information_service.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../webview/webview_app.dart';
import '../layout/head_title_card_darect.dart';
// import 'enduser_check_information_detail.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อ "ทั้งหมด"
class EnduserCheckAll extends StatefulWidget {
  EnduserCheckAll(this.type, {super.key});
  var type;
  @override
  State<EnduserCheckAll> createState() => _EnduserCheckAllState();
}

class _EnduserCheckAllState extends State<EnduserCheckAll> {
  // final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetX<EndUserOrderCtr>(
      builder: (endUserData) {
        //ตรวจสอบว่าโหลดข้อมูลได้ไหม
        //กรณีโหลดข้อมูลได้
        if (!endUserData.isDataLoading.value) {
          var result = endUserData.endUserOrder; //เซ็ตค่า
          List<Inprocess> data = [];
          if (widget.type == "1") {
            data = result!.waitingForApproval;
          } else if (widget.type == "2") {
            data = result!.inprocess;
          } else if (widget.type == "3") {
            data = result!.success;
          } else if (widget.type == "4") {
            data = result!.unsuccessful;
          }
          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (data.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (data[index].orderSource == "2") {
                        Get.find<CheckInformationDeliveryStatusController>()
                            .fetch_enduser_sale_details(
                                data[index].statusCode,
                                data[index].ordshopId,
                                data[index].invoice,
                                data[index].orderCamp,
                                data[index].billSeq,
                                data[index].salesCamp,
                                data[index].orderSource);
                      } else {
                        Get.find<CheckInformationDeliveryStatusController>()
                            .fetch_enduser_sale_details(
                                data[index].statusCode,
                                data[index].orderId,
                                data[index].invoice,
                                data[index].orderCamp,
                                data[index].billSeq,
                                data[index].salesCamp,
                                data[index].orderSource);
                      }
                      Get.toNamed('/check_information_delivery_status_detail');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
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
                            HeadTitleCardDirect(
                                headTitles: data[index].supplierName),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('รายการสั่งซื้อของฉัน',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              Text(
                                                  'รอบการขาย ${data[index].orderCamp}',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .grey.shade600)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // const Text(''),
                                              Text(
                                                data[index].status,
                                                style: TextStyle(
                                                    color: setColorStatus(
                                                        widget.type),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(data[index].orderDate,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .grey.shade600)),
                                            ],
                                          ),
                                        )
                                      ]),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('สมาชิก',
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(': ',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Text(data[index].repName,
                                              style: TextStyle(
                                                  color:
                                                      Colors.grey.shade600))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('เบอร์โทร',
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(': ',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                              formatPhoneNumber(
                                                  (data[index].repTelnumber)),
                                              style: TextStyle(
                                                  color:
                                                      Colors.grey.shade600))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('เลือกวิธีรับสินค้า',
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(': ',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                              data[index].reciveTypeText,
                                              style: TextStyle(
                                                  color:
                                                      Colors.grey.shade600))),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('ยอดรวมการสั่งซื้อ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      Row(
                                        children: [
                                          Text(
                                              myFormat.format(double.parse(
                                                  data[index].totalAmount)),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          const Text(
                                            ' บาท',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            data[index].note != ''
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        color: Colors.grey.shade600,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, left: 15, right: 15),
                                          child: Text(
                                            data[index].note,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14),
                                          )),
                                    ],
                                  )
                                : const SizedBox()
                          ],
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

setColorStatus(String val) {
  switch (val) {
    case "1":
      return Colors.orange;
    case "2":
      return Colors.orange;
    case "3":
      return const Color(0XFF20BE79);
    case "4":
      return Colors.red;
    default:
      break;
  }
}
