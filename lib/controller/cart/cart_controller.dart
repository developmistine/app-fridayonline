//  controller for fetch detail product

// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names

// import 'dart:developer';

import 'package:fridayonline/controller/cart/cart_cheer_controller.dart';
import 'package:fridayonline/model/cart/cart_getItems.dart';
import 'package:fridayonline/model/cart/cart_model.dart';
import 'package:fridayonline/model/cart/getsupplierDelivery.dart';
import 'package:fridayonline/model/category/Product_detail.dart';
import 'package:fridayonline/service/cart/cart_service.dart';
import 'package:fridayonline/service/category/category_Service.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ?controller สำหรับ call ข้อมูลแสดง bottomsheet และ function จัดการจำนวนสินค้าในตะกร้า
class Category_getData_webview_controller extends GetxController {
  ProductDetail? listproduct;
  var isDataLoading = false.obs;

  RxInt bottomShow = 0.obs;
  var url;
  var getParams;
  var billcode;
  var fscode;
  var campaign;
  var media;
  var brand;
  var type_flash_stock;

  bottomShowFN(Uri uri) {
    // url = Uri.parse(uri);

    if (uri.pathSegments.last == 'sku-product-yup') {
      getParams = uri.queryParameters; // get all params from webview
      type_flash_stock = getParams["type_flash_stock"];
      billcode = getParams["Bill_YUP"]; // get billcode from webview
      fscode = getParams["FSCODE"]; // get  fscode from webview
      campaign = getParams["CATE_CAMP"]; // get  cate_camp from webview
      media = getParams["MEDIA"]; // get  media from webview
      brand = getParams["BRAND"];

      if (type_flash_stock == '0') {
        bottomShow.value = 0;
      } else {
        //  get brand from webview
        bottomShow.value = 1;
      }
    } else {
      bottomShow.value = 0;
    }
  }

  RxInt CountItems = 1.obs;
  void AddItems() {
    if (CountItems.value <= 999) {
      CountItems.value = CountItems.value + 1;
    }
  }

  void RemoveItems() {
    if (CountItems.value > 1) {
      CountItems.value = CountItems.value - 1;
    }
  }

  //call เพื่อนำรูปและรายละเอียดมาโชว์หน้าหยิบใส่ตระกร้า webview
  fetchproductdetail(
      campaign, billCode, brand, fsCode, channel, channelId) async {
    // log(campaign + ":" + billCode + ":" + brand + ":" + fsCode);
    try {
      isDataLoading(true);
      listproduct = await Category_product_detail(
          campaign, billCode, brand, fsCode, channel, channelId, '');
    } finally {
      isDataLoading(false);
    }
  }
}

// !controller for isert update delete cart
class CartItemsEdit extends GetxController {
  ItemCartEdit? itemsCart;

  var isDataLoading = false.obs;

  edit_cart(Campaign, BillCode, Qty, action, BillType, Brand, MediaCode,
      Channel, ChannelId, contentType, contentId) async {
    try {
      isDataLoading(true);
      itemsCart = await CartService(Campaign, BillCode, Qty, action, BillType,
          Brand, MediaCode, Channel, ChannelId, contentType, contentId);
      // log(" edit ${itemsCart!.toJson()}");
      await Get.find<FetchCartItemsController>().fetch_cart_items();
      // log(itemsCart!.toJson().toString());
      update();
      return itemsCart;
    } finally {
      isDataLoading(false);
    }
  }
}

// !controller for fetch cart items
class FetchCartItemsController extends GetxController {
  ItemsGetCart? itemsCartList;
  bool isChecked = true;
  bool isCheckedDropship = false;
  bool allowMultiple = false;
  var isDataLoading = false.obs;
  var isChangeLanguage = false.obs;
  Map<String, GetSupplierDelivery> supplierDelivery = {};
  @override
  void onInit() {
    super.onInit();
    fetch_cart_items();
  }

  updateCheckbox(statusChek) {
    isChecked = statusChek;
    update();
    return isChecked;
  }

  updateCheckboxDrop(statusChek) {
    isCheckedDropship = statusChek;
    update();
    return isCheckedDropship;
  }

  checkBoxAllowAll(statusChek) {
    // allowMultiple = statusChek;

    if (statusChek) {
      updateCheckbox(statusChek);
      updateCheckboxDrop(statusChek);
    } else {
      updateCheckbox(false);
      updateCheckboxDrop(false);
    }
    var single = updateCheckbox(statusChek);
    var drop = updateCheckboxDrop(statusChek);
    if (single == true && drop == true) {
      allowMultiple = true;
    } else {
      allowMultiple = false;
    }
    update();
  }

  fetch_cart_items() async {
    try {
      isDataLoading(true);
      itemsCartList = await getCartService();
      supplierDelivery.clear();
      for (var supplier in itemsCartList!.cardHeader.carddetailB2C) {
        supplierDelivery[supplier.supplierCode] =
            (await getSupplierDeliveryService(supplier.supplierCode))!;
      }

      await Get.find<CheerCartCtr>().fetchCartConditions(
          itemsCartList!.cardHeader.campaign,
          itemsCartList!.cardHeader.carddetail
              .where(
                  (element) => element.flagNetPrice == "N" && element.isInStock)
              .fold<double>(0,
                  (previousValue, element) => previousValue + element.amount));
      update();
    } finally {
      isDataLoading(false);
      isChangeLanguage(false);
    }
  }
}
