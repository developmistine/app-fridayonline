// ignore_for_file: camel_case_types

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../controller/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_loadmore_hoursband.dart';

class Home_loadmore extends StatelessWidget {
  const Home_loadmore({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<ProductHotIutemLoadmoreController>().itemList.length;
      if (Get.find<ProductHotIutemLoadmoreController>().itemProduct > 0) {
        return MasonryGridView.builder(
            shrinkWrap: true,
            primary: false,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (width >= 768.0) ? 3 : 2,
            ),
            itemCount:
                Get.find<ProductHotIutemLoadmoreController>().itemList.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemCardLoadmore(
                  Get.find<ProductHotIutemLoadmoreController>()
                      .itemList[index]);
            });
      }
      return Container();
    });
  }
}
