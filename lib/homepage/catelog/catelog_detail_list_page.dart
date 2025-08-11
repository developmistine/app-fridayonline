import 'dart:async';

import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/service/logapp/interaction.dart';

import '../../controller/catelog/catelog_controller.dart';
import '../../homepage/catelog/catelog_detail_list.dart';
import '../../homepage/theme/theme_color.dart';
import '../../homepage/widget/cartbutton.dart';
import '../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../theme/themeimage_menu.dart';

//คลาสสำหรับแสดงข้อมูลหน้าแค็ตตาล็อกที่เลือกมาจาก catelog list
class CatelogDetailListPage extends StatefulWidget {
  const CatelogDetailListPage({super.key, this.channel});
  final channel;
  @override
  State<CatelogDetailListPage> createState() => _CatelogDetailListPageState();
}

class _CatelogDetailListPageState extends State<CatelogDetailListPage> {
  CatelogDetailController dataController = Get.put(CatelogDetailController());
  CatelogSetFirstPageController setPage = Get.put(
      CatelogSetFirstPageController()); //รับค่าจาก CatelogSetFirstPageController
  // ignore: prefer_typing_uninitialized_variables
  var _currentIndex; //เก็บค่า index
  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  var first_page; //เก็บค่า index ของหน้าแค็ตตาล็อกที่ต้องการให้แสดงเป็นลำดับแรก
  var pageName;

  int count = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        count++;
      });
    });
    set_first_page();
  }

  @override
  void dispose() {
    timer!.cancel();
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
    super.dispose();
  }

  void set_first_page() {
    //ฟังก์ชันที่ใช้สำหรับเซ็ตหน้าแค็ตตาล็อกที่ต้องการให้แสดงหน้าแรก
    _currentIndex = setPage
        .page; //ให้ _currentIndex = ค่า index ที่ส่งมาจาก CatelogSetFirstPageController
    first_page = setPage
        .page; //ให้ first_page = ค่า index ที่ส่งมาจาก CatelogSetFirstPageController
    pageName = setPage.pageName;
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
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
                  Get.toNamed('/backAppbarnotify',
                      parameters: {'changeView': '1'});
                },
              ),
              backgroundColor: theme_color_df,
              centerTitle: true,
              title: Obx(
                //ตรวจสอบว่าโหลดข้อมูลได้ไหม
                () => dataController.isDataLoading.value
                    //กรณีโหลดข้อมูลไม่ได้
                    ? const Text('')

                    //กรณีโหลดข้อมูลได้ แสดงเลขหน้าที่กำลังเปิดอยู่ / จำนวนหน้าทั้งหมดของเล่มแค็ตตาล็อก
                    : dataController
                            .catelog_detail!.ecatalogDetail[0].isShowPageNumber
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              CatelogDetailList(channel: widget.channel)),
                    );
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
                ),
              ],
            ),
          ),
          body: Obx(
            //ตรวจสอบการโหลดข้อมูล
            () => dataController.isDataLoading.value
                //กรณีโหลดข้อมูลไม่ได้
                ? const Text('')

                //กรณีโหลดข้อมูลได้
                : Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: PhotoViewGallery.builder(
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.white),
                      itemCount:
                          dataController.catelog_detail!.ecatalogDetail.length,
                      pageController: PageController(initialPage: first_page),
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index; //เช็ต _currentIndex = index
                          pageName = dataController
                              .catelog_detail!.ecatalogDetail[index].pageDetail;
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
              onPressed: () {
                //ตรวจสอบ text_bottom = ดูรายการสินค้า

                //กรณีที่ text_bottom = ดูรายการสินค้า
                if (dataController.text_bottom == 'ดูรายการสินค้า') {
                  Get.find<CatelogListProductByPageController>()
                      .get_catelog_list_product_by_page(
                    dataController.catelog_detail!.ecatalogDetail[_currentIndex]
                        .pageDetail,
                    dataController
                        .catelog_detail!.ecatalogDetail[_currentIndex].campaign,
                    dataController
                        .catelog_detail!.ecatalogDetail[_currentIndex].brand,
                    dataController
                        .catelog_detail!.ecatalogDetail[_currentIndex].media,
                  ); //ส่งค่าไปที่ CatelogListProductByPageController และไปที่ฟังก์ชัน get_catelog_list_product_by_page
                  Get.toNamed('/catelog_list_product_page', parameters: {
                    "channel": widget.channel,
                    "channelId": dataController
                        .catelog_detail!.ecatalogDetail[_currentIndex].id
                  }); //กำหนด Route ไปที่ /catelog_list_product_page
                }
              },
              child: Obx(
                () =>
                    //ตรวจสอบการโหลดข้อมูล
                    dataController.isDataLoading.value
                        ? const Text('') //กรณีโหลดข้อมูลไม่ได้
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (dataController.text_bottom !=
                                  'เลื่อนหน้าถัดไป')
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: ImageSearchboxWhite,
                                ),
                              Text(
                                //กรณีโหลดข้อมูลได้
                                //ตรวจสอบ text_bottom = เลื่อนหน้าถัดไป

                                //กรณี text_bottom = เลื่อนหน้าถัดไป
                                dataController.text_bottom == 'เลื่อนหน้าถัดไป'
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
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
