import 'package:fridayonline/analytics/analytics_engine.dart';
import 'package:fridayonline/member/components/category/category.group.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final EndUserHomeCtr controller = Get.find();
final CategoryCtr categoryCtr = Get.put(CategoryCtr());

class CategoryCtr extends GetxController {
  RxInt activeIndex = 0.obs;
  setActive(index) {
    activeIndex.value = index;
  }
}

class EndUserCategory extends StatelessWidget {
  const EndUserCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      (() {
        if (!controller.isLoadingCategory.value) {
          if (controller.category!.data.isNotEmpty) {
            var groupCategory = controller.category!.data;

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
                      itemCount: groupCategory.length,

                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Get.put(CategoryCtr()).setActive(index);
                              _trackCategoryGroup(groupCategory[index].category,
                                  groupCategory[index].categoryId.toString());
                            },
                            child: Container(
                              // color: Colors.blueGrey.withOpacity(0.02),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey.shade300))),
                              child: Obx(() {
                                return Row(
                                  children: [
                                    AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        height:
                                            (categoryCtr.activeIndex.value ==
                                                    index)
                                                ? 60
                                                : 0,
                                        width: 5,
                                        color: themeColorDefault),
                                    Expanded(
                                        child: AnimatedContainer(
                                      alignment: Alignment.center,
                                      duration: const Duration(milliseconds: 0),
                                      height: 60,
                                      color: (categoryCtr.activeIndex.value ==
                                              index)
                                          ? Colors.white
                                          : Colors.transparent,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 5),
                                          child: Text(
                                              controller.category!.data[index]
                                                  .category,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: (categoryCtr.activeIndex
                                                            .value ==
                                                        index)
                                                    ? themeColorDefault
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.center)),
                                    )),
                                  ],
                                );
                              }),
                            ));
                      },
                    ),
                  ),
                  categoryListItems(
                      groupCategory[categoryCtr.activeIndex.value])
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
                const Text('ไม่พอข้อมูล'),
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
