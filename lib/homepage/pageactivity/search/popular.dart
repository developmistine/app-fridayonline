// ignore_for_file: must_be_immutable, camel_case_types

import 'package:fridayonline/controller/search_product/search_controller.dart';
import 'package:fridayonline/homepage/pageactivity/search/search_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class popular extends StatelessWidget {
  const popular({super.key});
  @override
  Widget build(BuildContext context) {
    Get.find<ShowPopularProductController>().searchProduct();
    return GetBuilder<ShowPopularProductController>(
        builder: (PopularItems) => PopularItems.isDataLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: Container(
                    padding: EdgeInsets.zero,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: PopularItems.ItemsPopular!.keyPopular.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              PopularItems.ItemsPopular!.keyPopular[0].keyWord),
                          onTap: () {
                            Get.put(ShowSearchProductController())
                                .searchProduct(PopularItems
                                    .ItemsPopular!.keyPopular[index].keyWord);
                            Get.to(() => ShowSearchList(
                                showAppbar: false,
                                pChannel: '10',
                                contentId: PopularItems
                                    .ItemsPopular!.keyPopular[index].keyWord));
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    )),
              ));
  }
}
