import 'package:fridayonline/controller/log_analytics/log_analytics_ctr.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/catelog/catelog_controller.dart';
import '../../homepage/theme/theme_loading.dart';
import '../../service/languages/multi_languages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/logapp/logapp_service.dart';
import '../show_case/catelog/show_case_catelog_home.dart';

//คลาสสำหรับแสดงข้อมูลหน้าปกแค็ตตาล็อก HandBill
// ignore: camel_case_types
class Catelog_Hand_Bill_Detail extends StatefulWidget {
  const Catelog_Hand_Bill_Detail({super.key});

  @override
  State<Catelog_Hand_Bill_Detail> createState() =>
      _Catelog_Hand_Bill_DetailState();
}

// ignore: camel_case_types
class _Catelog_Hand_Bill_DetailState extends State<Catelog_Hand_Bill_Detail> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return GetX<CatelogController>(
      builder: ((catelogData) {
        if (!catelogData.isDataLoading.value) {
          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (catelogData.hCatalog!.handBillDetail.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemCount: catelogData.hCatalog!.handBillDetail.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () async {
                        var logData =
                            catelogData.hCatalog!.handBillDetail[index];
                        print("object catalogueTab2");
                        Get.find<LogAnalyticsController>().catalogName.value =
                            catelogData
                                .hCatalog!.handBillDetail[index].handBillName;

                        InteractionLogger.logCatalogInteraction(
                            catalogId: logData.handBillID,
                            catalogType: '2',
                            catalogBrand: logData.handBillBrand,
                            catalogMedia: logData.handBillMedia,
                            catalogName: logData.handBillName,
                            catalogCampaign: logData.handBillCampaign,
                            catalogImage: logData.handBillImage);
                        //Log App
                        LogAppEventCall(
                            "Download_Catalog",
                            catelogData
                                .hCatalog!.handBillDetail[index].handBillBrand,
                            catelogData.hCatalog!.handBillDetail[index]
                                .handBillCampaign,
                            catelogData
                                .hCatalog!.handBillDetail[index].handBillMedia,
                            "",
                            "",
                            "");
                        //End Log

                        Get.find<CatelogDetailController>().get_catelog_detail(
                            catelogData.hCatalog!.handBillDetail[index]
                                .handBillCampaign,
                            catelogData
                                .hCatalog!.handBillDetail[index].handBillBrand,
                            catelogData.hCatalog!.handBillDetail[index]
                                .handBillMedia); //ส่งค่าไปที่  CatelogDetailController ไปที่ฟังก์ชัน get_catelog_detail
                        final SharedPreferences prefs = await _prefs;
                        if (prefs.getString("ShowcaseCatelog") == '1') {
                          Get.toNamed('/catelog_detail',
                              parameters: {"channel": "8"});
                        } else {
                          Get.to(() => const ShowCaseCatelogHome(
                                channel: '8',
                              ));
                          prefs.setString("ShowcaseCatelog", '1');
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              // ignore: use_full_hex_values_for_flutter_colors
                              color: const Color(0xff2e5e5e5),
                              width: 1,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: [
                              Flexible(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  //แสดงรูปภาพ
                                  child: CachedNetworkImage(
                                    imageUrl: catelogData.hCatalog!
                                        .handBillDetail[index].handBillImage,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 1),
                                //แสดงข้อความ
                                child: SizedBox(
                                  height: 35,
                                  child: Text(
                                      catelogData.hCatalog!
                                          .handBillDetail[index].handBillName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
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
                Text(MultiLanguages.of(context)!.translate('alert_no_datas')),
              ],
            ));
          }
        } else {
          return Center(child: theme_loading_df);
        }
      }),
    );
  }
}
