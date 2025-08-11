// ignore_for_file: unrelated_type_equality_checks

import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/homepage/category/category_page/category_Items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/languages/multi_languages.dart';

class ShowCaseCategory extends StatefulWidget {
  const ShowCaseCategory(
      {super.key, required this.ChangeLanguage, this.keyNine});
  final MultiLanguages ChangeLanguage;
  final GlobalKey<State<StatefulWidget>>? keyNine;

  @override
  State<ShowCaseCategory> createState() => _ShowCaseCategoryState();
}

class _ShowCaseCategoryState extends State<ShowCaseCategory> {
  @override
  void initState() {
    super.initState();
    if (Get.find<CategoryMenuController>().isDataLoading.value) {
      Get.find<CategoryMenuController>().fetch_groupcate();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                    width: 100,
                    child: ListView.builder(
                      // scrollDirection: Axis.horizontal,
                      itemCount: controller.GroupItems.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Get.find<CategoryMenuController>()
                                  .selectgroup(index);
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
                                      color: const Color.fromRGBO(
                                          46, 169, 225, 1)),
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
                                                  ? const Color.fromRGBO(
                                                      46, 169, 225, 1)
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
                  ShowCasecategoryListItems(controller, widget.keyNine!,
                      widget.ChangeLanguage, width, height)
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
}
