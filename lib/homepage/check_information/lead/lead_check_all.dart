// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables
import '../../../homepage/theme/theme_loading.dart';
import '../../../model/check_information/lead/lead_check_information.dart';
import '../../../service/languages/multi_languages.dart';
import '../../../service/check_information/check_information_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/theme_color.dart';
import '../layout/head_title_card_darect.dart';
import 'lead_check_information_detail.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อ "ทั้งหมด"
class LeadCheckAll extends StatefulWidget {
  const LeadCheckAll({Key? key}) : super(key: key);
  @override
  State<LeadCheckAll> createState() => _LeadCheckAllState();
}

class _LeadCheckAllState extends State<LeadCheckAll> {
  // final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
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
        body: FutureBuilder(
          future:
              call_lead_information(), //เรียกใช้งานฟังก์ชัน call_lead_information เพื่อ get ข้อมูล
          builder: (BuildContext context,
              AsyncSnapshot<LeadCheckInformation?> snapshot) {
            //ตรวจสอบว่าโหลดข้อมูลได้ไหม
            //กรณีโหลดข้อมูลได้
            if (snapshot.connectionState == ConnectionState.done) {
              var result = snapshot.data; //เซ็ตค่า

              //ตรวจสอบว่ามีข้อมูลไหม
              //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
              if (result!
                  .orderEndUser.orderHeader.headerList.header.isNotEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: result
                        .orderEndUser.orderHeader.headerList.header.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Header dataHeader = result.orderEndUser.orderHeader
                              .headerList.header[index];

                          Get.to(() => LeadCheckInformationDetail(
                              dataHeader: dataHeader));
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
                              children: [
                                const HeadTitleCardDirect(headTitles: ''),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 15, right: 15),
                                  child: Row(
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
                                                      color: Colors.grey)),
                                              Text(
                                                  'วันที่สั่งซื้อ ${result.orderEndUser.orderHeader.headerList.header[index].orderDate}',
                                                  style: const TextStyle(
                                                      color: Colors.grey)),
                                              Text(
                                                  'เลขที่ใบสั่งซื้อ ${result.orderEndUser.orderHeader.headerList.header[index].orderNo}',
                                                  style: const TextStyle(
                                                      color: Colors.grey)),
                                              Text(
                                                  'สินค้า ${result.orderEndUser.orderHeader.headerList.header[index].footer.items} รายการ สรุปยอดรวม ${NumberFormat.decimalPattern().format(double.parse(result.orderEndUser.orderHeader.headerList.header[index].footer.totalall))} บาท',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.end,
                                        //     children: [
                                        //       const Text(''),
                                        //       result
                                        //                   .orderEndUser
                                        //                   .orderHeader
                                        //                   .headerList
                                        //                   .header[index]
                                        //                   .orderText ==
                                        //               'รออนุมัติ'
                                        //           ? Text(
                                        //               result
                                        //                   .orderEndUser
                                        //                   .orderHeader
                                        //                   .headerList
                                        //                   .header[index]
                                        //                   .orderText,
                                        //               style: const TextStyle(
                                        //                   color: Color(
                                        //                       0XFFEC8E00)))
                                        //           : Text(
                                        //               result
                                        //                   .orderEndUser
                                        //                   .orderHeader
                                        //                   .headerList
                                        //                   .header[index]
                                        //                   .orderText,
                                        //               style: const TextStyle(
                                        //                 color:
                                        //                     Color(0XFF20BE79),
                                        //               )),
                                        //       const Text(''),
                                        //       Text(
                                        //           NumberFormat.decimalPattern()
                                        //               .format(double.parse(
                                        //                   result
                                        //                       .orderEndUser
                                        //                       .orderHeader
                                        //                       .headerList
                                        //                       .header[index]
                                        //                       .footer[0]
                                        //                       .totalall)),
                                        //           style: const TextStyle(
                                        //               fontWeight:
                                        //                   FontWeight.bold,
                                        //               fontSize: 15)),
                                        //     ],
                                        //   ),
                                        // )
                                      ]),
                                ),
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
                return Center(
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
                );
              }
              //กรณีไม่สามารถโหลดข้อมูลได้
            } else {
              return Center(
                child: theme_loading_df,
              );
            }
          },
        ),
      ),
    );
  }
}
