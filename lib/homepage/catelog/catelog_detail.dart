// ignore_for_file: use_build_context_synchronously

import 'dart:async';

// import 'package:fridayonline/controller/log_analytics/log_analytics_ctr.dart';
// import 'package:fridayonline/controller/log_analytics/log_analytics_model.dart';
import 'package:fridayonline/model/catelog/catelog_detail.dart';
// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/catelog/catelog_controller.dart';
import '../../homepage/catelog/catelog_detail_list.dart';
import '../../homepage/theme/theme_color.dart';
import '../../homepage/theme/theme_loading.dart';
import '../../homepage/widget/cartbutton.dart';
import '../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../service/logapp/logapp_service.dart';
import '../show_case/catelog/show_case_catelog_detail_list.home.dart';
import '../theme/themeimage_menu.dart';

//คลาสสำหรับแสดงหน้าในเล่มแค็ตตาล็อก
class CatelogDetail extends StatefulWidget {
  const CatelogDetail({super.key});

  @override
  State<CatelogDetail> createState() => _CatelogDetailState();
}

class _CatelogDetailState extends State<CatelogDetail> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CatelogDetailController dataController = Get.put(CatelogDetailController());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  SetData data = SetData();
  var _currentIndex = 0; //เซ็ตค่าเริมต้นของเลขหน้า
  // var _currentIndexShow = '001';
  var channel = Get.parameters['channel'];

  int count = 0;
  Timer? timer;
  Future<void> _sendAnalyticsEvent(time, EcatalogDetail cattalogDetail) async {
    await insertLogViewPageSessions(
        channel,
        cattalogDetail.id,
        cattalogDetail.campaign,
        cattalogDetail.media,
        cattalogDetail.brand,
        cattalogDetail.pageDetail,
        time);
    // await analytics.logEvent(
    //     callOptions: AnalyticsCallOptions(global: true),
    //     name: 'view_catalog',
    //     parameters: LogAnalyticsCatalogDetail(
    //             logEvent: 'view_catalog',
    //             time: time.toString(),
    //             repType: await data.repType,
    //             repCode: await data.repCode,
    //             repSeq: await data.repSeq,
    //             catalogName:
    //                 Get.find<LogAnalyticsController>().catalogName.value,
    //             catalogPage: (_currentIndex + 1).toString(),
    //             catalogId: cattalogDetail.id.toString())
    //         .toJson());
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        count++;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
    if (count > 3) {
      _sendAnalyticsEvent(
          count, dataController.catelog_detail!.ecatalogDetail[_currentIndex]);
    }
    var logData = dataController.catelog_detail!.ecatalogDetail[_currentIndex];
    InteractionLogger.logCatalogPageInteraction(
      catalogId: logData.id,
      catalogType: logData.type,
      catalogBrand: logData.brand,
      catalogMedia: logData.media,
      catalogCampaign: logData.campaign,
      catalogPageIndex: logData.pageDetail,
      catalogPageImage: logData.pathImg,
      catalogPageTime: count,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SafeAreaProvider(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Get.back();
                    }),
                backgroundColor: theme_color_df,
                centerTitle: true,
                title: Obx(
                  //ตรวจสอบการโหลดข้อมูล
                  () => dataController.isDataLoading.value
                      //กรณีโหลดข้อมูลไม่สำเร็จ
                      ? const Text('')

                      //กรณีโหลดข้อมูลสำเร็จ
                      //แสดงเลขหน้าปัจจุบัน / เลขหน้าทั้งหมด
                      // : Text('test'),
                      : dataController.catelog_detail!.ecatalogDetail[0]
                              .isShowPageNumber
                          ? Text(
                              '${MultiLanguages.of(context)!.translate('catalog_page_number')} ${_currentIndex + 1} / ${dataController.catelog_detail!.ecatalogDetail.length}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              'เลื่อนหน้าถัดไป',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      final SharedPreferences prefs = await _prefs;

                      if (prefs.getString("ShowcaseCatelogDetailList") == '1') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  CatelogDetailList(channel: channel)),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShowCaseCatelogdetailListHome(
                                      channel: channel)),
                        );
                        prefs.setString("ShowcaseCatelogDetailList", '1');
                      }
                    },
                    icon: const Icon(
                      Icons.apps,
                      size: 33,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 2),
                    child: CartIconButton(),
                  )
                ],
              ),
            ),
            body: Obx(
              //ตรวจสอบการโหลดข้อมูล
              () => dataController.isDataLoading.value

                  //กรณีโหลดข้อมูลไม่ได้
                  ? Center(child: theme_loading_df)

                  //กรณีโหลดข้อมูลได้
                  : Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: PhotoViewGallery.builder(
                        backgroundDecoration:
                            const BoxDecoration(color: Colors.white),
                        itemCount: dataController
                            .catelog_detail!.ecatalogDetail.length,
                        onPageChanged: (index) {
                          setState(() {
                            if (count > 3) {
                              _sendAnalyticsEvent(
                                  count,
                                  dataController
                                      .catelog_detail!.ecatalogDetail[index]);
                            }
                            var logData = dataController
                                .catelog_detail!.ecatalogDetail[_currentIndex];
                            InteractionLogger.logCatalogPageInteraction(
                              catalogId: logData.id,
                              catalogType: logData.type,
                              catalogBrand: logData.brand,
                              catalogMedia: logData.media,
                              catalogCampaign: logData.campaign,
                              catalogPageIndex: logData.pageDetail,
                              catalogPageImage: logData.pathImg,
                              catalogPageTime: count,
                            );
                            timer!.cancel();
                            count = 0;
                            timer = Timer.periodic(const Duration(seconds: 1),
                                (timer) {
                              setState(() {
                                count++;
                              });
                            });

                            _currentIndex = index; //เช็ต _currentIndex = index
                            // _currentIndexShow = dataController
                            //     .catelog_detail!.ecatalogDetail[index].pageDetail;
                            //ตรวจสอบสถานะ Y
                            //ถ้าสถานะ flagViewProduct = Y
                            if (dataController.catelog_detail!
                                    .ecatalogDetail[index].flagViewProduct ==
                                'Y') {
                              dataController.text_bottom =
                                  'ดูรายการสินค้า'; //ให้ text_bottom = ดูรายการสินค้า
                            } else {
                              dataController.text_bottom =
                                  'เลื่อนหน้าถัดไป'; //ให้ text_bottom = เลื่อนหน้าถัดไป
                            }
                          });
                        },
                        builder: (context, index) {
                          final urlimage = dataController
                              .catelog_detail!.ecatalogDetail[index].pathImg;
                          return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(urlimage),
                              initialScale: PhotoViewComputedScale.contained,
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.contained * 3);
                        },
                      ),
                    ),
            ),
            bottomNavigationBar: Container(
              color: theme_color_df,
              height: 60,
              child: TextButton(
                  onPressed: () async {
                    //Log App
                    LogAppEventCall(
                        "view_list",
                        dataController.catelog_detail!
                            .ecatalogDetail[_currentIndex].brand,
                        dataController.catelog_detail!
                            .ecatalogDetail[_currentIndex].campaign,
                        dataController.catelog_detail!
                            .ecatalogDetail[_currentIndex].media,
                        dataController.catelog_detail!
                            .ecatalogDetail[_currentIndex].pageDetail,
                        "",
                        "");
                    //End Log

                    //ตรวจสอบ text_bottom = ดูรายการสินค้า
                    //กรณีที่ text_bottom = ดูรายการสินค้า
                    if (dataController.text_bottom == 'ดูรายการสินค้า') {
                      timer!.cancel();
                      var logData = dataController
                          .catelog_detail!.ecatalogDetail[_currentIndex];
                      InteractionLogger.logCatalogPageInteraction(
                        catalogId: logData.id,
                        catalogType: logData.type,
                        catalogBrand: logData.brand,
                        catalogMedia: logData.media,
                        catalogCampaign: logData.campaign,
                        catalogPageIndex: logData.pageDetail,
                        catalogPageImage: logData.pathImg,
                        catalogPageTime: count,
                      );
                      setState(() {
                        count = 0;
                      });
                      Get.find<CatelogListProductByPageController>()
                          .get_catelog_list_product_by_page(
                              dataController.catelog_detail!
                                  .ecatalogDetail[_currentIndex].pageDetail,
                              dataController.catelog_detail!
                                  .ecatalogDetail[_currentIndex].campaign,
                              dataController.catelog_detail!
                                  .ecatalogDetail[_currentIndex].brand,
                              dataController
                                  .catelog_detail!
                                  .ecatalogDetail[_currentIndex]
                                  .media); //ส่งค่าไปที่ CatelogListProductByPageController และไปที่ฟังก์ชัน get_catelog_list_product_by_page
                      await Get.toNamed('/catelog_list_product_page',
                              parameters: {
                            "channel": channel.toString(),
                            "channelId": dataController.catelog_detail!
                                .ecatalogDetail[_currentIndex].id
                          })!
                          .then((res) {
                        timer =
                            Timer.periodic(const Duration(seconds: 1), (timer) {
                          setState(() {
                            count++;
                          });
                        });
                      }); //กำหนด Route ไปที่ /catelog_list_product_page
                    }
                  },
                  //ตรวจสอบการโหลดข้อมูล
                  child: Obx(() => dataController.isDataLoading.value

                      //กรณีโหลดข้อมูลไม่ได้
                      ? const Text('')

                      //กรณีโหลดข้อมูลได้
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (dataController.text_bottom != 'เลื่อนหน้าถัดไป')
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: ImageSearchboxWhite,
                              ),
                            Text(
                              //ตรวจสอบ text_bottom = เลื่อนหน้าถัดไป
                              dataController.text_bottom == 'เลื่อนหน้าถัดไป'
                                  //กรณี text_bottom = เลื่อนหน้าถัดไป
                                  ? MultiLanguages.of(context)!
                                      .translate('catalog_next_page')
                                  //กรณี text_bottom != ดูรายการสินค้า
                                  : MultiLanguages.of(context)!
                                      .translate('catalog_product_list'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ))),
            )),
      ),
    );
  }
}
