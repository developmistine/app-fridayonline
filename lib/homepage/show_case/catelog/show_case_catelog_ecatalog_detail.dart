import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../controller/app_controller.dart';
import '../../../controller/catelog/catelog_controller.dart';
import '../../../model/set_data/set_data.dart';
import '../../../service/languages/multi_languages.dart';
import '../../myhomepage.dart';
import '../../theme/theme_color.dart';
import '../../theme/theme_loading.dart';
// import 'show_case_catelog_detail.dart';
import 'show_case_catelog_home.dart';

//คลาสสำหรับแสดงปกของเล่มแค็ตตาล็อก Ecatalog
// ignore: camel_case_types
class ShowCaseCatelog_Ecatalog_Detail extends StatefulWidget {
  ShowCaseCatelog_Ecatalog_Detail(
      {Key? key, required this.ChangeLanguage, this.keySaven, this.keyEight})
      : super(key: key);
  final MultiLanguages ChangeLanguage;
  final GlobalKey<State<StatefulWidget>>? keySaven;
  final GlobalKey<State<StatefulWidget>>? keyEight;

  @override
  State<ShowCaseCatelog_Ecatalog_Detail> createState() =>
      _ShowCaseCatelog_Ecatalog_DetailState();
}

// ignore: camel_case_types
class _ShowCaseCatelog_Ecatalog_DetailState
    extends State<ShowCaseCatelog_Ecatalog_Detail> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SetData data = SetData();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetX<CatelogController>(
      builder: ((catelogData) {
        if (!catelogData.isDataLoading.value) {
          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (catelogData.eCatalog!.ecatalogDetail.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemCount: catelogData.eCatalog!.ecatalogDetail.length,
                  itemBuilder: (BuildContext ctx, index) {
                    if (index == 0) {
                      return Showcase.withWidget(
                        disableMovingAnimation: true,
                        width: width,
                        height: height / 2.35,
                        container: InkWell(
                          onTap: () {
                            setState(() {
                              ShowCaseWidget.of(context)
                                  .startShowCase([widget.keyEight!]);
                            });
                          },
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                                textScaler: const TextScaler.linear(1.0)),
                            child: SizedBox(
                              width: width / 1.1,
                              height: height / 2.35,
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
                                          height: 80,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                widget.ChangeLanguage.translate(
                                                    'cat_guide2'),
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
                                                        BorderRadius.circular(
                                                            30.0),
                                                    side: BorderSide(
                                                        color: theme_color_df)))),
                                        onPressed: () {
                                          setState(() {
                                            ShowCaseWidget.of(context)
                                                .startShowCase(
                                                    [widget.keyEight!]);
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
                                                style: const TextStyle(
                                                    fontSize: 16)),
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
                                              Get.find<AppController>()
                                                  .setCurrentNavInget(0);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyHomePage()));
                                            })),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        scrollLoadingWidget: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Colors.transparent)),
                        key: widget.keySaven!,
                        disposeOnTap: true,
                        onTargetClick: () {
                          setState(() {
                            ShowCaseWidget.of(context)
                                .startShowCase([widget.keyEight!]);
                          });
                        },
                        child: GestureDetector(
                          onTap: () async {
                            final SharedPreferences prefs = await _prefs;
                            Get.find<CatelogDetailController>().get_catelog_detail(
                                catelogData.eCatalog!.ecatalogDetail[index]
                                    .catalogCampaign,
                                catelogData.eCatalog!.ecatalogDetail[index]
                                    .catalogBrand,
                                catelogData.eCatalog!.ecatalogDetail[index]
                                    .catalogMedia); //ส่งค่าไปที่  CatelogDetailController ไปที่ฟังก์ชัน get_catelog_detail

                            if (prefs.getString("ShowcaseCatelog") == '1') {
                              Get.toNamed('/catelog_detail',
                                  parameters: {'channel': '7'});
                            } else {
                              Get.to(() => ShowCaseCatelogHome(channel: '7'));
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
                                      height:
                                          MediaQuery.of(context).size.height,
                                      //แสดงรูปภาพ
                                      child: CachedNetworkImage(
                                        imageUrl: catelogData.eCatalog!
                                            .ecatalogDetail[index].catalogImage,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 1),
                                    //แสดงข้อความ
                                    child: SizedBox(
                                      height: 35,
                                      child: Text(
                                          catelogData
                                              .eCatalog!
                                              .ecatalogDetail[index]
                                              .catalogName,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 11)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                      // return Showcase(
                      //   //overlayColor: theme_color_df,
                      //
                      //   targetPadding: const EdgeInsets.all(20),
                      //   descTextStyle:
                      //       const TextStyle(fontSize: 16, color: Colors.white),
                      //   key: widget.keySaven!,
                      //   description:
                      //       widget.ChangeLanguage.translate('cat_guide2'),
                      //   disposeOnTap: true,
                      //   onTargetClick: () {
                      //     ShowCaseWidget.of(context)
                      //         .startShowCase([widget.keyEight!]);
                      //   },
                      //   child: GestureDetector(
                      //     onTap: () async {
                      //       final SharedPreferences prefs = await _prefs;
                      //       Get.find<CatelogDetailController>().get_catelog_detail(
                      //           catelogData.eCatalog!.ecatalogDetail[index]
                      //               .catalogCampaign,
                      //           catelogData.eCatalog!.ecatalogDetail[index]
                      //               .catalogBrand,
                      //           catelogData.eCatalog!.ecatalogDetail[index]
                      //               .catalogMedia); //ส่งค่าไปที่  CatelogDetailController ไปที่ฟังก์ชัน get_catelog_detail

                      //       if (prefs.getString("login") == '1') {
                      //         var typeuser = await data.repType;
                      //         if (typeuser == '2') {
                      //           if (prefs.getString("MslShowcaseCatelog") ==
                      //               '1') {
                      //             Get.toNamed('/catelog_detail');
                      //           } else {
                      //             Get.to(() => ShowCaseCatelogHome());
                      //             prefs.setString("MslShowcaseCatelog", '1');
                      //           }
                      //         } else {
                      //           if (prefs.getString("EnduserShowcaseCatelog") ==
                      //               '1') {
                      //             Get.toNamed('/catelog_detail');
                      //           } else {
                      //             Get.to(() => ShowCaseCatelogHome());
                      //             prefs.setString(
                      //                 "EnduserShowcaseCatelog", '1');
                      //           }
                      //         }
                      //       } else {
                      //         if (prefs.getString("AnonymousShowcaseCatelog") ==
                      //             '1') {
                      //           Get.toNamed('/catelog_detail');
                      //         } else {
                      //           Get.to(() => ShowCaseCatelogHome());
                      //           prefs.setString(
                      //               "AnonymousShowcaseCatelog", '1');
                      //         }
                      //       }
                      //     },
                      //     child: Container(
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(3),
                      //           border: Border.all(
                      //             // ignore: use_full_hex_values_for_flutter_colors
                      //             color: const Color(0xff2e5e5e5),
                      //             width: 1,
                      //           )),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(3.0),
                      //         child: Column(
                      //           children: [
                      //             Flexible(
                      //               child: SizedBox(
                      //                 height:
                      //                     MediaQuery.of(context).size.height,
                      //                 //แสดงรูปภาพ
                      //                 child: CachedNetworkImage(
                      //                   imageUrl: catelogData.eCatalog!
                      //                       .ecatalogDetail[index].catalogImage,
                      //                   fit: BoxFit.fill,
                      //                   height:
                      //                       MediaQuery.of(context).size.height,
                      //                   width:
                      //                       MediaQuery.of(context).size.width,
                      //                 ),
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.only(
                      //                   top: 10, bottom: 10),
                      //               //แสดงข้อความ
                      //               child: Text(
                      //                   catelogData.eCatalog!
                      //                       .ecatalogDetail[index].catalogName,
                      //                   textAlign: TextAlign.center,
                      //                   style: const TextStyle(fontSize: 11)),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Get.find<CatelogDetailController>().get_catelog_detail(
                              catelogData.eCatalog!.ecatalogDetail[index]
                                  .catalogCampaign,
                              catelogData
                                  .eCatalog!.ecatalogDetail[index].catalogBrand,
                              catelogData.eCatalog!.ecatalogDetail[index]
                                  .catalogMedia); //ส่งค่าไปที่  CatelogDetailController ไปที่ฟังก์ชัน get_catelog_detail
                          Get.to(() => ShowCaseCatelogHome(
                                channel: '7',
                              )); //กำหนด Route ไปที่ /catelog_detail
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
                                  //แสดงข้อความ
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
                    }
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
