import 'package:fridayonline/safearea.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../controller/catelog/catelog_controller.dart';
import '../../../service/languages/multi_languages.dart';
import '../../catelog/catelog_detail_list_page.dart';
import '../../theme/theme_color.dart';

//คลาสสำหรับแสดง catalog list
class ShowCaseCatelogDetailList extends StatefulWidget {
  const ShowCaseCatelogDetailList(
      {super.key, required this.ChangeLanguage, required this.channel});
  final MultiLanguages ChangeLanguage;
  final String channel;

  @override
  State<ShowCaseCatelogDetailList> createState() =>
      _ShowCaseCatelogDetailListState();
}

class _ShowCaseCatelogDetailListState extends State<ShowCaseCatelogDetailList> {
  final GlobalKey _one = GlobalKey();
  CatelogDetailController dataController = Get.put(
      CatelogDetailController()); //ทำการ get ข้อมูลจาก CatelogDetailController
  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase([_one]),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SafeAreaProvider(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme_color_df,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(widget.ChangeLanguage.translate('menu_catalog'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 10),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemCount: dataController.catelog_detail!.ecatalogDetail.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Showcase.withWidget(
                          disableMovingAnimation: true,
                          width: width,
                          height: height / 1.4,
                          container: InkWell(
                            onTap: () {
                              // setState(() {
                              //   ShowCaseWidget.of(context).startShowCase([_three]);
                              // });
                            },
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.0)),
                              child: SizedBox(
                                width: width / 1.1,
                                height: height / 1.7,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                                  widget.ChangeLanguage
                                                      .translate('cat_guide5'),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            )),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.only(left: 170.0),
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  WidgetStateProperty.all<Color>(
                                                      theme_color_df),
                                              backgroundColor:
                                                  WidgetStateProperty.all<Color>(
                                                      Colors.white),
                                              shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          30.0),
                                                      side: BorderSide(
                                                          color: theme_color_df)))),
                                          onPressed: () {
                                            ShowCaseWidget.of(context).next();
                                          },
                                          child: SizedBox(
                                            width: 50,
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                  maxLines: 1,
                                                  widget.ChangeLanguage
                                                      .translate(
                                                          'btn_end_guide'),
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
                                                ShowCaseWidget.of(context)
                                                    .next();
                                              })),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //overlayColor: theme_color_df,
                          targetPadding: const EdgeInsets.all(20),
                          key: _one,
                          disposeOnTap: true,
                          onTargetClick: () {
                            setState(() {
                              ShowCaseWidget.of(context).startShowCase([_one]);
                            });
                          },
                          child: GestureDetector(
                            // When the child is tapped, show a snackbar.
                            onTap: () {
                              Get.find<CatelogSetFirstPageController>()
                                  .set_first_page(
                                      index,
                                      dataController
                                          .catelog_detail!
                                          .ecatalogDetail[index]
                                          .pageDetail); //ส่งค่าไปที่ CatelogSetFirstPageController และไปที่ฟังก์ชัน set_first_page
                              Get.find<CatelogDetailController>()
                                  .set_text_bottom(dataController
                                      .catelog_detail!
                                      .ecatalogDetail[index]
                                      .flagViewProduct); //ส่งค่าไปที่ CatelogSetFirstPageController และไปที่ฟังก์ชัน set_text_bottom
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CatelogDetailListPage(
                                            channel: widget.channel,
                                          )) //เปิดหน้า catelog detail
                                  );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Stack(
                                children: [
                                  //แสดงรูปภาพ
                                  CachedNetworkImage(
                                    imageUrl: dataController.catelog_detail!
                                        .ecatalogDetail[index].pathImg,
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        color: Colors.black.withOpacity(0.7),
                                        child: Center(
                                          child: dataController
                                                  .catelog_detail!
                                                  .ecatalogDetail[index]
                                                  .isShowPageNumber
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  //แสดงเลขหน้า
                                                  child: Text(
                                                      '${MultiLanguages.of(context)!.translate('catalog_page_number')} ${index + 1}',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11)),
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        // Showcase(
                        //   //overlayColor: theme_color_df,
                        //
                        //   targetPadding: const EdgeInsets.all(20),
                        //   overlayPadding: const EdgeInsets.all(8),
                        //   descTextStyle: const TextStyle(
                        //       fontSize: 16, color: Colors.white),
                        //   key: _one,
                        //   description:
                        //       widget.ChangeLanguage.translate('cat_guide5'),
                        //   disposeOnTap: true,
                        //   onTargetClick: () {
                        //     Get.find<CatelogSetFirstPageController>()
                        //         .set_first_page(
                        //             index); //ส่งค่าไปที่ CatelogSetFirstPageController และไปที่ฟังก์ชัน set_first_page
                        //     Get.find<CatelogDetailController>().set_text_bottom(
                        //         dataController
                        //             .catelog_detail!
                        //             .ecatalogDetail[index]
                        //             .flagViewProduct); //ส่งค่าไปที่ CatelogSetFirstPageController และไปที่ฟังก์ชัน set_text_bottom
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 const CatelogDetailListPage()) //เปิดหน้า catelog detail
                        //         );
                        //   },
                        //   child:
                        // ),
                        );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        // When the child is tapped, show a snackbar.
                        onTap: () {
                          Get.find<CatelogSetFirstPageController>().set_first_page(
                              index,
                              dataController
                                  .catelog_detail!
                                  .ecatalogDetail[index]
                                  .pageDetail); //ส่งค่าไปที่ CatelogSetFirstPageController และไปที่ฟังก์ชัน set_first_page
                          Get.find<CatelogDetailController>().set_text_bottom(
                              dataController
                                  .catelog_detail!
                                  .ecatalogDetail[index]
                                  .flagViewProduct); //ส่งค่าไปที่ CatelogSetFirstPageController และไปที่ฟังก์ชัน set_text_bottom
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CatelogDetailListPage(
                                        channel: widget.channel,
                                      )) //เปิดหน้า catelog detail
                              );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Stack(
                            children: [
                              //แสดงรูปภาพ
                              CachedNetworkImage(
                                imageUrl: dataController.catelog_detail!
                                    .ecatalogDetail[index].pathImg,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    color: Colors.black.withOpacity(0.7),
                                    child: Center(
                                      child: dataController
                                              .catelog_detail!
                                              .ecatalogDetail[index]
                                              .isShowPageNumber
                                          ? Padding(
                                              padding: const EdgeInsets.all(5),

                                              //แสดงเลขหน้า
                                              child: Text(
                                                  '${widget.ChangeLanguage.translate('catalog_page_number')} ${index + 1}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11)),
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
