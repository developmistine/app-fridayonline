// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../controller/catelog/catelog_controller.dart';
import '../../../service/languages/multi_languages.dart';
import '../../catelog/catelog_detail_list.dart';
import '../../theme/theme_color.dart';
import '../../theme/theme_loading.dart';
import '../../theme/themeimage_menu.dart';
import '../../widget/cartbutton.dart';
import 'show_case_catelog_detail_list.home.dart';

//คลาสสำหรับแสดงหน้าในเล่มแค็ตตาล็อก
class ShowCaseCatelogDetail extends StatefulWidget {
  ShowCaseCatelogDetail({Key? key, required this.ChangeLanguage, this.channel})
      : super(key: key);
  final MultiLanguages ChangeLanguage;
  final channel;

  @override
  State<ShowCaseCatelogDetail> createState() => _ShowCaseCatelogDetailState();
}

class _ShowCaseCatelogDetailState extends State<ShowCaseCatelogDetail> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();

  CatelogDetailController dataController = Get.put(CatelogDetailController());

  @override
  void initState() {
    super.initState();

    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase([_one, _two]),
    );
  }

  var _currentIndex = 0; //เซ็ตค่าเริมต้นของเลขหน้า
  // var _currentIndexShow = "001";
  double paddingPhoto = 160;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: theme_color_df,
            centerTitle: true,
            title: Obx(
              //ตรวจสอบการโหลดข้อมูล
              () => dataController.isDataLoading.value
                  //กรณีโหลดข้อมูลไม่สำเร็จ
                  ? const Text('')

                  //กรณีโหลดข้อมูลสำเร็จ
                  //แสดงเลขหน้าปัจจุบัน / เลขหน้าทั้งหมด
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
              Showcase.withWidget(
                disableMovingAnimation: true,
                width: width,
                height: height / 1.4,
                container: InkWell(
                  onTap: () {
                    setState(() {
                      ShowCaseWidget.of(context).startShowCase([_three]);
                    });
                  },
                  child: MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: SizedBox(
                      width: width / 1,
                      height: height / 1.3,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 60.0, top: 50),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                  color: theme_color_df,
                                  width: 250,
                                  height: 80,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        widget.ChangeLanguage.translate(
                                          'cat_guide4',
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 220.0),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            theme_color_df),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            side: BorderSide(
                                                color: theme_color_df)))),
                                onPressed: () {
                                  setState(() {
                                    ShowCaseWidget.of(context)
                                        .startShowCase([_three]);
                                  });
                                },
                                child: SizedBox(
                                  width: 50,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                        maxLines: 1,
                                        widget.ChangeLanguage.translate(
                                            'btn_next_guide'),
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      paddingPhoto = 0;
                                      ShowCaseWidget.of(context).next();
                                      ShowCaseWidget.of(context).next();
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // overlayColor: theme_color_df,
                // targetPadding: const EdgeInsets.all(20),
                key: _two,
                disposeOnTap: true,
                onTargetClick: () {
                  setState(() {
                    ShowCaseWidget.of(context).startShowCase([_three]);
                  });
                },
                child: IconButton(
                  onPressed: () async {
                    final SharedPreferences prefs = await _prefs;

                    if (prefs.getString("ShowcaseCatelogDetailList") == '1') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                CatelogDetailList(channel: widget.channel)),
                      );
                    } else {
                      //แสดง dialog ของ list catelog
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ShowCaseCatelogdetailListHome(
                                channel: widget.channel)),
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
                  padding: EdgeInsets.only(bottom: paddingPhoto),
                  child: Showcase.withWidget(
                    disableMovingAnimation: true,
                    width: width,
                    height: height / 3,
                    container: InkWell(
                      onTap: () {
                        setState(() {
                          ShowCaseWidget.of(context).startShowCase([_two]);
                        });
                      },
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: SizedBox(
                          width: width / 1.1,
                          height: height / 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                      color: theme_color_df,
                                      width: 250,
                                      height: 85,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            widget.ChangeLanguage.translate(
                                                'cat_guide3'),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 165.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                theme_color_df),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                side: BorderSide(
                                                    color: theme_color_df)))),
                                    onPressed: () {
                                      setState(() {
                                        ShowCaseWidget.of(context)
                                            .startShowCase([_two]);
                                      });
                                    },
                                    child: SizedBox(
                                      width: 50,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                            maxLines: 1,
                                            widget.ChangeLanguage.translate(
                                                'btn_next_guide'),
                                            style:
                                                const TextStyle(fontSize: 16)),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            paddingPhoto = 0;
                                            ShowCaseWidget.of(context).next();
                                            ShowCaseWidget.of(context).next();
                                          });
                                        })),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    scrollLoadingWidget: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.transparent)),
                    key: _one,
                    disposeOnTap: true,
                    onTargetClick: () {
                      setState(() {
                        ShowCaseWidget.of(context).startShowCase([_two]);
                      });
                    },

                    tooltipPosition: TooltipPosition.bottom,
                    // targetPadding: EdgeInsets.only(bottom: -130),
                    child: PhotoViewGallery.builder(
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.white),
                      itemCount:
                          dataController.catelog_detail!.ecatalogDetail.length,
                      onPageChanged: (index) {
                        setState(() {
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
                  )),
        ),
        bottomNavigationBar: Showcase.withWidget(
          disableMovingAnimation: true,
          width: width,
          height: height / 1.4,
          container: InkWell(
            onTap: () {
              // setState(() {
              //   _body = ShowCaseCategory(
              //     ChangeLanguage: widget.ChangeLanguage,
              //     keyNine: _nine,
              //   );
              //   controller.setCurrentNavInget(2);
              //   ShowCaseWidget.of(context).startShowCase([_nine]);
              // });
            },
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: SizedBox(
                width: width / 1.1,
                height: height / 1.4,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                        child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                paddingPhoto = 0;
                                ShowCaseWidget.of(context).next();
                              });
                            })),
                    Expanded(
                      // <-- Use Expanded with SizedBox.expand
                      child: SizedBox.expand(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 80.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 160.0),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  theme_color_df),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  side: BorderSide(
                                                      color: theme_color_df)))),
                                      onPressed: () {
                                        setState(() {
                                          paddingPhoto = 0;
                                          ShowCaseWidget.of(context).next();
                                        });
                                      },
                                      child: SizedBox(
                                        width: 50,
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                              maxLines: 1,
                                              widget.ChangeLanguage.translate(
                                                  'btn_end_guide'),
                                              style: const TextStyle(
                                                  fontSize: 16)),
                                        ),
                                      )),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                      color: theme_color_df,
                                      width: 270,
                                      height: 90,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            widget.ChangeLanguage.translate(
                                                'cat_guide6'),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 75,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // overlayColor: theme_color_df,
          // targetPadding: const EdgeInsets.all(20),
          key: _three,
          onTargetClick: () {},
          child: Container(
            color: theme_color_df,
            child: TextButton(
              onPressed: () {
                //ตรวจสอบ text_bottom = ดูรายการสินค้า
                //กรณีที่ text_bottom = ดูรายการสินค้า
                if (dataController.text_bottom == 'ดูรายการสินค้า') {
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
                  Get.toNamed('/catelog_list_product_page', parameters: {
                    "channel": widget.channel,
                    "channelId": dataController
                        .catelog_detail!.ecatalogDetail[_currentIndex].id
                  }); //กำหนด Route ไปที่ /catelog_list_product_page
                }
              },
              //ตรวจสอบการโหลดข้อมูล
              child: Obx(
                () => dataController.isDataLoading.value

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
                                ? widget.ChangeLanguage.translate(
                                    'catalog_next_page')
                                //กรณี text_bottom != ดูรายการสินค้า
                                : widget.ChangeLanguage.translate(
                                    'catalog_product_list'),
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
