// import 'dart:developer';

import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/homepage/show_case/category/show_case_category_product.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../controller/app_controller.dart';
import '../../../controller/home/home_controller.dart';
import '../../../service/languages/multi_languages.dart';
import '../../myhomepage.dart';
import '../../theme/theme_color.dart';

import '../../../service/logapp/logapp_service.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
ProductFromBanner bannerProduct = Get.put(ProductFromBanner());

Expanded categoryListItems(CategoryMenuController controller) {
  return Expanded(
    child: PageView(
      onPageChanged: (index) {
        // log(index.toString());
      },
      // controller: _pageController,
      // scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 5.0,
                  mainAxisExtent: 145),
              itemCount: controller
                  .GroupItems[controller.count.value].childrenData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    var logData = controller
                        .GroupItems[controller.count.value].childrenData[index];
                    var id = logData.id;
                    var parent = logData.parentId;

                    InteractionLogger.logCategoryInteraction(
                      categoryId: logData.parentId,
                      categoryName:
                          controller.GroupItems[controller.count.value].name,
                      subCategoryId: logData.id,
                      subCategoryName: logData.name,
                    );

                    var Channelid = "$parent,$id";
                    print("LogApp Category");
                    //LogApp
                    LogAppTisCall('9', Channelid);
                    //  End
                    bannerProduct.fetch_product_banner("", "");
                    Get.find<CategoryProductlistController>()
                        .fetch_list(parent, id);
                    final SharedPreferences prefs = await _prefs;

                    if (prefs.getString("ShowcaseCategoryProduct") == '1') {
                      Get.toNamed('/my_list_category', parameters: {
                        "mChannel": "9",
                        "mChannelId": Channelid,
                        "ref": "category",
                        "contentId": id
                      });
                    } else {
                      Get.to(() => const ShowCaseCategoryProductHome());
                      prefs.setString("ShowcaseCategoryProduct", '1');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(14, 0, 0, 0),
                            offset: Offset(0.0, 4.0),
                            blurRadius: 0.2,
                            spreadRadius: 0.2,
                          ), //BoxShadow
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: controller
                                  .GroupItems[controller.count.value]
                                  .childrenData[index]
                                  .img,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                    controller
                                        .GroupItems[controller.count.value]
                                        .childrenData[index]
                                        .name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    ),
  );
}

Expanded ShowCasecategoryListItems(
    CategoryMenuController controller,
    GlobalKey<State<StatefulWidget>> keyNine,
    MultiLanguages ChangeLanguage,
    double width,
    double height) {
  return Expanded(
    child: PageView(
      onPageChanged: (index) {
        // log(index.toString());
      },
      // controller: _pageController,
      // scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 5.0,
                  mainAxisExtent: 130),
              itemCount: controller
                  .GroupItems[controller.count.value].childrenData.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Showcase.withWidget(
                    disableMovingAnimation: true,
                    width: width,
                    height: height / 1.73,
                    container: InkWell(
                      onTap: () {
                        Get.find<AppController>().setCurrentNavInget(0);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      },
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: SizedBox(
                          width: width / 1.1,
                          height: height / 1.73,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 50.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 20),
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
                                                  ChangeLanguage.translate(
                                                      'category_guides2'),
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
                                          const EdgeInsets.only(left: 165.0),
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
                                            //  ShowCaseWidget.of(context).next();
                                            Get.find<AppController>()
                                                .setCurrentNavInget(0);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage()));
                                          },
                                          child: SizedBox(
                                            width: 50,
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                  maxLines: 1,
                                                  ChangeLanguage.translate(
                                                      'btn_end_guide'),
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
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
                                        ShowCaseWidget.of(context).next();
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    scrollLoadingWidget: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.transparent)),
                    key: keyNine,
                    child: GestureDetector(
                      onTap: () async {
                        var id = controller.GroupItems[controller.count.value]
                            .childrenData[index].id;
                        var parent = controller
                            .GroupItems[controller.count.value]
                            .childrenData[index]
                            .parentId;

                        Get.find<CategoryProductlistController>()
                            .fetch_list(parent, id);
                        final SharedPreferences prefs = await _prefs;
                        print(prefs.getString("ShowcaseCategoryProduct"));
                        if (prefs.getString("ShowcaseCategoryProduct") == '1') {
                          Get.toNamed(
                            '/my_list_category',
                          );
                        } else {
                          Get.to(() => const ShowCaseCategoryProductHome());
                          prefs.setString("ShowcaseCategoryProduct", '1');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(14, 0, 0, 0),
                                offset: Offset(0.0, 4.0),
                                blurRadius: 0.2,
                                spreadRadius: 0.2,
                              ), //BoxShadow
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: controller
                                      .GroupItems[controller.count.value]
                                      .childrenData[index]
                                      .img,
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                    controller
                                        .GroupItems[controller.count.value]
                                        .childrenData[index]
                                        .name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  // return Showcase(
                  //   //overlayColor: theme_color_df,
                  //
                  //   descTextStyle:
                  //       const TextStyle(fontSize: 16, color: Colors.white),
                  //   key: keyNine,
                  //   description: ChangeLanguage.translate('category_guides2'),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       var _id = controller.GroupItems[controller.count.value]
                  //           .childrenData[index].id;
                  //       var _parent = controller
                  //           .GroupItems[controller.count.value]
                  //           .childrenData[index]
                  //           .parentId;

                  //       Get.find<CategoryProductlistController>()
                  //           .fetch_list(_parent, _id);
                  //       Get.toNamed(
                  //         '/my_list_category',
                  //       );
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(2.0),
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         decoration: BoxDecoration(
                  //           boxShadow: const [
                  //             BoxShadow(
                  //               color: Color.fromARGB(14, 0, 0, 0),
                  //               offset: Offset(0.0, 4.0),
                  //               blurRadius: 0.2,
                  //               spreadRadius: 0.2,
                  //             ), //BoxShadow
                  //           ],
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(12.0),
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               CachedNetworkImage(
                  //                 imageUrl: controller
                  //                     .GroupItems[controller.count.value]
                  //                     .childrenData[index]
                  //                     .img,
                  //                 height: 60,
                  //                 fit: BoxFit.contain,
                  //               ),
                  //               Text(
                  //                   controller
                  //                       .GroupItems[controller.count.value]
                  //                       .childrenData[index]
                  //                       .name,
                  //                   maxLines: 2,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   textAlign: TextAlign.center,
                  //                   style: const TextStyle(fontSize: 12)),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      var id = controller.GroupItems[controller.count.value]
                          .childrenData[index].id;
                      var parent = controller.GroupItems[controller.count.value]
                          .childrenData[index].parentId;

                      Get.find<CategoryProductlistController>()
                          .fetch_list(parent, id);
                      final SharedPreferences prefs = await _prefs;

                      if (prefs.getString("ShowcaseCategoryProduct") == '1') {
                        Get.toNamed(
                          '/my_list_category',
                        );
                      } else {
                        Get.to(() => const ShowCaseCategoryProductHome());
                        prefs.setString("ShowcaseCategoryProduct", '1');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(14, 0, 0, 0),
                              offset: Offset(0.0, 4.0),
                              blurRadius: 0.2,
                              spreadRadius: 0.2,
                            ), //BoxShadow
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: controller
                                    .GroupItems[controller.count.value]
                                    .childrenData[index]
                                    .img,
                                height: 60,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                  controller.GroupItems[controller.count.value]
                                      .childrenData[index].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }),
        )
      ],
    ),
  );
}
