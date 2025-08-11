// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, camel_case_types

// import 'dart:developer';

import 'package:fridayonline/model/category/Catagory_group.dart';
import 'package:fridayonline/model/category/Category_Product.dart';
import 'package:fridayonline/model/category/Product_detail.dart';
import 'package:fridayonline/service/category/category_Service.dart';
import 'package:get/get.dart';

import '../../model/home/banner_product.dart';
import '../../service/home/home_service.dart';

// controller for fetch product list in menu category
class CategoryProductlistController extends GetxController {
  Listproduct? listproduct;
  GetProductByCategoryBanner? BannerProduct;

  var isDataLoading = false.obs;
  fetch_list(id, parent) async {
    try {
      isDataLoading(true);
      listproduct =
          await Category_product_list(id.toString(), parent.toString());
    } finally {
      isDataLoading(false);
    }
  }

  fetch_product_category_byperson(categoryID, campaign) async {
    try {
      isDataLoading(true);
      BannerProduct = await call_product_banner(categoryID, campaign);
    } finally {
      isDataLoading(false);
    }
  }
}

// controller for fetch menu in category
class CategoryMenuController extends GetxController {
  RxList<Groupcatelogy> GroupItems = RxList<Groupcatelogy>();
  var isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch_groupcate();
  }

  RxInt count = 0.obs;
  selectgroup(index) {
    count.value = index;
  }

  fetch_groupcate() async {
    try {
      isDataLoading(true);
      GroupItems.value = await (Category_group_menu()) ?? [];
      update();
    } finally {
      isDataLoading(false);
    }
  }
}

//  controller for fetch detail product

class CategoryProductDetailController extends GetxController {
  ProductDetail? listproduct;
  var isDataLoading = false.obs;

  fetchproductdetail(
      campaign, billCode, brand, fsCode, channel, channelId, stock) async {
    // log(campaign +
    //     ":" +
    //     billCode +
    //     ":" +
    //     brand +
    //     ":" +
    //     fsCode +
    //     ":" +
    //     channel +
    //     ":" +
    //     channelId +
    //     ":" +
    //     stock);
    try {
      isDataLoading(true);
      listproduct = await Category_product_detail(
          campaign, billCode, brand, fsCode, channel, channelId, stock);
      // print(listproduct!.toJson().toString());
      update();
    } finally {
      isDataLoading(false);
    }
  }
}

//  call for get data from webview
