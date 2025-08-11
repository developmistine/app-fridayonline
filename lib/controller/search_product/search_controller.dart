// import 'dart:developer';

import 'package:fridayonline/model/search_bar/getkeyword.dart';
import 'package:fridayonline/model/search_bar/product_search.dart';
import 'package:fridayonline/model/search_bar/poppular_keys.dart';
import 'package:fridayonline/service/search_bar/search_service.dart';
import 'package:get/get.dart';

class SearchProductController extends GetxController {
  RxList<KeySearch> listSearch = RxList<KeySearch>();
  var isDataLoading = false.obs;

  searchProduct(text) async {
    try {
      isDataLoading(true);
      listSearch.value = (await SearchKeywords(text)) ?? [];
      update();
    } catch (e) {
      print("error seach: $e");
    } finally {
      isDataLoading(false);
    }
  }
}

class ShowSearchProductController extends GetxController {
  ProductSearch? itemsSearch;

  var isDataLoading = false.obs;

  searchProduct(text) async {
    try {
      isDataLoading(true);
      itemsSearch = await Product_search(text);
      update();
    } finally {
      isDataLoading(false);
    }
  }
}

class ShowPopularProductController extends GetxController {
  PoppularKeys? ItemsPopular;

  var isDataLoading = false.obs;

  searchProduct() async {
    try {
      isDataLoading(true);
      ItemsPopular = await SearchPopular();
      update();
      // log("popular is ${ItemsPopular!.keyPopular[0].keyWord.toString()}");
    } finally {
      isDataLoading(false);
    }
  }
}
