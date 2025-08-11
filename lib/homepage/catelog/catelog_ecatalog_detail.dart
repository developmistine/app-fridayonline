import 'dart:async';

import 'package:fridayonline/controller/log_analytics/log_analytics_ctr.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/catelog/catelog_controller.dart';
import '../../model/set_data/set_data.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/logapp/logapp_service.dart';
import '../show_case/catelog/show_case_catelog_home.dart';
import '../theme/theme_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//คลาสสำหรับแสดงปกของเล่มแค็ตตาล็อก Ecatalog
// ignore: camel_case_types
class Catelog_Ecatalog_Detail extends StatefulWidget {
  const Catelog_Ecatalog_Detail({super.key});

  @override
  State<Catelog_Ecatalog_Detail> createState() =>
      _Catelog_Ecatalog_DetailState();
}

// ignore: camel_case_types
class _Catelog_Ecatalog_DetailState extends State<Catelog_Ecatalog_Detail> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SetData data = SetData();

  @override
  Widget build(BuildContext context) {
    return GetX<CatelogController>(
      builder: ((catelogData) {
        if (!catelogData.isDataLoading.value) {
          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (catelogData.eCatalog!.ecatalogDetail.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemCount: catelogData.eCatalog!.ecatalogDetail.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () async {
                        //Log App
                        var logData =
                            catelogData.eCatalog!.ecatalogDetail[index];

                        InteractionLogger.logCatalogInteraction(
                            catalogId: logData.catalogId,
                            catalogType: '1',
                            catalogBrand: logData.catalogBrand,
                            catalogMedia: logData.catalogMedia,
                            catalogName: logData.catalogName,
                            catalogCampaign: logData.catalogCampaign,
                            catalogImage: logData.catalogImage);
                        Get.find<LogAnalyticsController>().catalogName.value =
                            catelogData
                                .eCatalog!.ecatalogDetail[index].catalogName;
                        LogAppEventCall(
                            "Download_Catalog",
                            catelogData
                                .eCatalog!.ecatalogDetail[index].catalogBrand,
                            catelogData.eCatalog!.ecatalogDetail[index]
                                .catalogCampaign,
                            catelogData
                                .eCatalog!.ecatalogDetail[index].catalogMedia,
                            "",
                            "",
                            "");
                        //End Log
                        Get.find<CatelogDetailController>().get_catelog_detail(
                            catelogData.eCatalog!.ecatalogDetail[index]
                                .catalogCampaign,
                            catelogData
                                .eCatalog!.ecatalogDetail[index].catalogBrand,
                            catelogData.eCatalog!.ecatalogDetail[index]
                                .catalogMedia); //ส่งค่าไปที่  CatelogDetailController ไปที่ฟังก์ชัน get_catelog_detail
                        final SharedPreferences prefs = await _prefs;
                        if (prefs.getString("ShowcaseCatelog") == '1') {
                          Get.toNamed('/catelog_detail',
                              parameters: {"channel": "7"});
                        } else {
                          Get.to(() => const ShowCaseCatelogHome(
                                channel: '7',
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
                                    imageUrl: catelogData.eCatalog!
                                        .ecatalogDetail[index].catalogImage,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 1),
                                child: SizedBox(
                                  height: 35,
                                  child: Text(
                                      catelogData.eCatalog!
                                          .ecatalogDetail[index].catalogName,
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
