import 'package:appfridayecommerce/enduser/controller/category.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/enduser.home.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/showproduct.category.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/track.ctr.dart';
import 'package:appfridayecommerce/enduser/utils/cached_image.dart';
import 'package:appfridayecommerce/enduser/views/(category)/subcategory.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryB2C extends StatefulWidget {
  const CategoryB2C({super.key});

  @override
  State<CategoryB2C> createState() => _CategoryB2CState();
}

class _CategoryB2CState extends State<CategoryB2C> {
  final EndUserHomeCtr endUserHomeCtr = Get.find();
  final CategoryCtr categoryCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'หมวดหมู่',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ).marginOnly(left: 12),
                const SizedBox(
                  height: 4,
                ),
                Obx(() {
                  if (endUserHomeCtr.isLoadingCategory.value) {
                    return SizedBox(
                      height: 140,
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisExtent: 80),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                border:
                                    Border.all(color: Colors.grey.shade200)),
                            child: Image.asset(
                              'assets/images/b2c/logo/logo_bg.png',
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 162),
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: endUserHomeCtr.homeCategory!.data.length,
                      itemBuilder: (context, index) {
                        var items = endUserHomeCtr.homeCategory!.data[index];

                        return InkWell(
                          onTap: () {
                            Get.find<TrackCtr>()
                                .setDataTrack(items.catid, "", "home_category");
                            categoryCtr.fetchSubCategory(items.catid);

                            Get.find<ShowProductCategoryCtr>()
                                .fetchProductByCategoryIdWithSort(
                                    items.catid, 0, "ctime", "", 40, 0);
                            Get.to(() => const SubCategory());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                    color: Colors.grey.shade100, width: 0.5)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CacheImageProducts(
                                        height: 40, url: items.image),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    items.displayName,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11, height: 1.2),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
