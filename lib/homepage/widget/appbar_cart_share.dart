// ignore_for_file: sort_child_properties_last

import 'dart:convert';

import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/homepage/widget/cartbutton.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/app_controller.dart';
import '../theme/theme_color.dart';

PreferredSize appbarShare(String titles, String backPage, channel, channelId) {
  return PreferredSize(
      child: MediaQuery(
        data: MediaQuery.of(Get.context!)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              if (backPage.toLowerCase() == 'home') {
                Get.find<AppController>().setCurrentNavInget(0);
                Get.toNamed('/backAppbarnotify',
                    parameters: {'changeView': '0'});
              } else if (backPage == "cheering") {
                Get.until((route) => (Get.currentRoute == '/Cart' ||
                    Get.currentRoute == '/cart_activity' ||
                    Get.currentRoute == '/show_case_cart_activity'));
                // Get.back();
                // Get.back();
                // Get.offAll(() => const Cart());
              } else {
                Get.back();
              }
            },
          ),
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: Text(
            titles,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'notoreg',
                fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              children: [
                GetX<ProductFromBanner>(builder: (share) {
                  return share.isDataLoading.value
                      ? const SizedBox()
                      : share.BannerProduct!.flagShare && share.pathShare != ""
                          ? InkWell(
                              onTap: () async {
                                SetData userData = SetData();
                                var repcode = await userData.repCode;
                                var repseq = await userData.repSeq;
                                var categoryId = share.pathShare.split('/')[0];
                                var campaign = share.pathShare.split('/')[1];
                                if (channel == "") {
                                  channel = "''";
                                }
                                if (channelId == "") {
                                  channelId = "''";
                                }
                                var url =
                                    "$pathShare/product_category/${encryptId(categoryId)}/${encryptId(campaign)}/${encryptId(channel)}/${encryptId(channelId)}/${encryptId(repcode)}/${encryptId(repseq)}?Type=EndUser&FirstLoad=true";
                                // printWhite(url);
                                await Share.share(
                                    "ลองเข้ามาดู ▶️ สินค้าราคาพิเศษ รีบซื้อเลย ที่ฟรายเดย์เท่านั้น! ${Uri.parse(url)}");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.white)),
                                child: Image.asset('assets/images/share.png',
                                    width: 20, height: 20),
                              ))
                          : const SizedBox();
                }),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CartIconButton(),
                ),
              ],
            )
          ],
        ),
      ),
      preferredSize: const Size.fromHeight(50));
}

encryptId(String id) {
  String encode = base64Encode(utf8.encode(id));
  return encode;
}
