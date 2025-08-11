// ignore_for_file: unrelated_type_equality_checks

import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/homepage/category/category_page/category_Items.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../analytics/analytics_engine.dart';
import '../../service/languages/multi_languages.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    super.initState();
    if (Get.find<CategoryMenuController>().isDataLoading.value) {
      Get.find<CategoryMenuController>().fetch_groupcate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<CategoryMenuController>(
      builder: ((controller) {
        if (!controller.isDataLoading.value) {
          if (controller.GroupItems.isNotEmpty) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      // scrollDirection: Axis.horizontal,
                      itemCount: controller.GroupItems.length,

                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Get.find<CategoryMenuController>()
                                  .selectgroup(index);
                              _trackCategoryGroup(
                                  controller.GroupItems[index].name,
                                  controller.GroupItems[index].id);
                            },
                            child: Container(
                              // color: Colors.blueGrey.withOpacity(0.02),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey.shade300))),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      height:
                                          (controller.count == index) ? 60 : 0,
                                      width: 5,
                                      color: theme_color_df),
                                  Expanded(
                                      child: AnimatedContainer(
                                    alignment: Alignment.center,
                                    duration: const Duration(milliseconds: 0),
                                    height: 60,
                                    color: (controller.count == index)
                                        ? Colors.white
                                        : Colors.transparent,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 5),
                                        child: Text(
                                            controller.GroupItems[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: (controller.count == index)
                                                  ? theme_color_df
                                                  : Colors.black,
                                            ),
                                            textAlign: TextAlign.center)),
                                  )),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                  categoryListItems(controller)
                ],
              ),
            );
          } else {
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
        }

        //  loading data
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Future<void> _trackCategoryGroup(String name, String id) async {
    SetData data = SetData();
    AnalyticsEngine.sendAnalyticsEventCategory(
        name, id, await data.repCode, await data.repSeq, await data.repType);
  }
}
