import 'package:fridayonline/homepage/widget/appbar_cart.dart';

import '../../controller/catelog/catelog_controller.dart';
import '../../homepage/page_showproduct/catelog_list_product_show.dart';
import '../../homepage/theme/theme_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/languages/multi_languages.dart';

//คลาสสำหรับแสดงข้อมูลสินค้าที่อยู่ในหน้าแค็ตตาล็อก
// ignore: must_be_immutable
class CatelogListProduct extends StatelessWidget {
  CatelogListProductByPageController dataController =
      Get.put(CatelogListProductByPageController());
  CatelogListProduct(
      {super.key}); //ทำการ get ข้อมูลจาก CatelogListProductByPageController

  var channel = Get.parameters['channel'];
  var channelId = Get.parameters['channelId'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleCart(
          MultiLanguages.of(context)!.translate('home_page_list_products'), ""),
      body: Obx(() =>
          //ตรวจสอบว่าโหลดข้อมูลได้ไหม
          dataController.isDataLoading.value
              //กรณีที่ไม่สามารถโหลดข้อมูลได้
              ? Center(child: theme_loading_df)
              //กรณีโหลดข้อมูลได้
              : CatelogListProShow(context, dataController, channel,
                  channelId)), //ส่งข้อมูลไปแสดงที่ CatelogListProShow
    ); //Obx
  }
}
