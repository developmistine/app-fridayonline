// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/homepage/widget/appbar_cart_share.dart';
import 'package:fridayonline/model/point_rewards/point_rewards_get_msl_info.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/app_controller.dart';
import '../../controller/catelog/catelog_controller.dart';
// import '../../controller/flashsale/flash_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../model/flashsale/flashsale.dart';
import '../../model/notify/informationPushPromotionIndex.dart';
import '../../service/flashsale/flashsale_service.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/notify/informationPushNotify_sevice.dart';
import '../../service/pathapi.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';
import '../../service/profileuser/getprofile.dart';
import '../../service/profileuser/mslinfo.dart';
import '../check_information/payment/payment_cutomer.dart';
import '../flashsale/flashsale_detail.dart';
import '../home/home_special_promotion_bwpoint.dart';
import '../myhomepage.dart';
import '../page_showproduct/List_product.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../webview/webview_app.dart';

class notify_promotiondetail extends StatefulWidget {
  const notify_promotiondetail(
      {super.key, required this.idparm, required this.typedataapi});
  final String idparm;
  final String typedataapi;

  @override
  State<notify_promotiondetail> createState() => _notify_promotiondetailState();
}

class _notify_promotiondetailState extends State<notify_promotiondetail> {
  String? lsRepSeq = '';
  String? lsRepCode = '';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // ดำเนินการ Load Data
    loadgetSharedPreferences();
    // กรณีที่ระบบทำการ LoadData
  }

  // ตั้งค่าเริ่มต้น
  void loadgetSharedPreferences() async {
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;
    // ทำการ Get Data
    setState(() {
      // ทำการ Get ข้อมูลออกมาจาก SharedPreferences
      lsRepSeq = prefs.getString("RepSeq")!;
      lsRepCode = prefs.getString("RepCode")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        backgroundColor: theme_color_df,
        title: const Text(
          'โปรโมชันพิเศษ',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'notoreg',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Information_Push_PromotionIndex(
              idparm: widget.idparm, typedataapi: widget.typedataapi),
          builder: (BuildContext context,
              AsyncSnapshot<InformationPushPromotionIndex?> snapshot) {
            // print(snapshot.data);
            if (snapshot.hasData) {
              var mdataInformationPushNotifyIndex = snapshot.data;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                          textAlign: TextAlign.left,
                          mdataInformationPushNotifyIndex!
                              .promotionIndex[0].promotion[0].title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'notoreg',
                              fontWeight: FontWeight.bold)),
                    ),
                    InkWell(
                      child: CachedNetworkImage(
                        imageUrl: mdataInformationPushNotifyIndex
                            .promotionIndex[0].promotion[0].imgContent,
                      ),
                      onTap: () async {
                        var parameterKey = mdataInformationPushNotifyIndex
                            .promotionIndex[0].promotion[0].parameterKey;

                        if (mdataInformationPushNotifyIndex.promotionIndex[0]
                                .promotion[0].parameterContent ==
                            "url") {
                          Get.to(() => webview_app(
                                mparamurl: parameterKey,
                                mparamTitleName: "โปรโมชันพิเศษ",
                                mparamType: '',
                                mparamValue: '',
                              ));

                          // print("url param" +
                          //     mdataInformationPushNotifyIndex
                          //         .promotionIndex[0].promotion[0].idindex);
                        } else if (mdataInformationPushNotifyIndex
                                .promotionIndex[0]
                                .promotion[0]
                                .parameterContent ==
                            "sku") {
                          Get.find<ProductDetailController>()
                              .productDetailController(
                            "",
                            parameterKey,
                            "",
                            parameterKey,
                            '',
                            '',
                          );
                          Get.to(() => ProductDetailPage(
                                ref: 'notify',
                                contentId: mdataInformationPushNotifyIndex
                                    .promotionIndex[0].promotion[0].id,
                              ));
                        } else if (mdataInformationPushNotifyIndex
                                .promotionIndex[0]
                                .promotion[0]
                                .parameterContent ==
                            "category") {
                          // ParameterKey
                          Get.put(ProductFromBanner())
                              .fetch_product_banner(parameterKey, '');

                          Get.to(() => Scaffold(
                              appBar: appbarShare(
                                  MultiLanguages.of(context)!
                                      .translate('home_page_list_products'),
                                  "",
                                  "",
                                  ""),
                              body: Obx(() => Get.put(ProductFromBanner())
                                      .isDataLoading
                                      .value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : showList(
                                      Get.put(ProductFromBanner())
                                          .BannerProduct!
                                          .skucode,
                                      '',
                                      '',
                                      ref: 'notify',
                                      contentId: mdataInformationPushNotifyIndex
                                          .promotionIndex[0].promotion[0].id,
                                    ))));
                        } else if (mdataInformationPushNotifyIndex
                                .promotionIndex[0]
                                .promotion[0]
                                .parameterContent ==
                            "extra") {
                          var urlparam =
                              "${baseurl_web_view}app_line_home?channel=YUPIN&repseq=$lsRepSeq&repCode=$lsRepCode";
                          Get.to(() => WebViewFullScreen(mparamurl: urlparam));
                          // print("extra param");
                        } else if (mdataInformationPushNotifyIndex
                                .promotionIndex[0]
                                .promotion[0]
                                .parameterContent ==
                            'flashSale') {
                          Flashsale? flashSaleData =
                              await FlashsaleHomeService();
                          if (flashSaleData!.flashSale.isNotEmpty) {
                            Get.to(() => FlashSaleDetail(
                                  contentId: mdataInformationPushNotifyIndex
                                      .promotionIndex[0].promotion[0].id,
                                ));
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(10),
                                    titlePadding: const EdgeInsets.only(
                                        top: 20, bottom: 0),
                                    actionsPadding: const EdgeInsets.only(
                                        top: 0, bottom: 0),
                                    actionsAlignment: MainAxisAlignment.end,
                                    title: Text(
                                      textAlign: TextAlign.center,
                                      "แจ้งเตือน",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: theme_color_df),
                                    ),
                                    content: const Text(
                                        textAlign: TextAlign.center,
                                        'ขออภัยค่ะ\nขณะนี้ Flash Sale ยังไม่เปิด'),
                                    actions: [
                                      const Divider(
                                        color: Color(0XFFD9D9D9),
                                        thickness: 1,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              'ปิด',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: theme_color_df)),
                                        ),
                                      )
                                    ],
                                  );
                                });
                            debugPrint('ยังไม่เปิด');
                          }
                        } else if (mdataInformationPushNotifyIndex
                                .promotionIndex[0]
                                .promotion[0]
                                .parameterContent ==
                            'payment') {
                          Mslinfo profile = await getProfileMSL();
                          Get.to(() => payment_cutomer(profile.mslInfo.arBal));
                        } else if (mdataInformationPushNotifyIndex
                                .promotionIndex[0]
                                .promotion[0]
                                .parameterContent ==
                            'pointHome') {
                          Get.to(() =>
                              const SpecialPromotionBwpoint(type: 'notify'));
                        } else if (mdataInformationPushNotifyIndex
                                .promotionIndex[0]
                                .promotion[0]
                                .parameterContent ==
                            'pointCategoryDetail') {
                          GetMslinfo? mslinfo = await GetMslInfoSevice();
                          var idCard = mslinfo!.idcardRequire;
                          SetData data = SetData();
                          var cpRepSeq = await data.repSeq;
                          var cpRepCode = await data.repCode;
                          var cpFscode = mdataInformationPushNotifyIndex
                              .promotionIndex[0].promotion[0].parameterKey;
                          if (idCard == "Y") {
                            Get.to(() => WebViewFullScreen(
                                mparamurl:
                                    "${baseurl_web_view}main-less/main_less.php?repseq=$cpRepSeq&repcode=$cpRepCode"));
                          } else {
                            Get.to(() => webview_app(
                                mparamurl:
                                    "${base_url_web_fridayth}bwpoint/product?billCode=$cpFscode",
                                mparamTitleName: MultiLanguages.of(context)!
                                    .translate('point_titleView'),
                                mparamType: 'rewards_detail',
                                mparamValue: cpFscode));
                          }
                        } else if (mdataInformationPushNotifyIndex
                                .promotionIndex[0]
                                .promotion[0]
                                .parameterContent ==
                            'catalogHome') {
                          Get.find<AppController>().setCurrentNavInget(1);
                          Get.offAll(() => MyHomePage(
                                typeView: 'catelog',
                                indexCatelog: int.parse(
                                    mdataInformationPushNotifyIndex
                                        .promotionIndex[0]
                                        .promotion[0]
                                        .parameterKey),
                              ));
                        } else if (mdataInformationPushNotifyIndex
                                .promotionIndex[0]
                                .promotion[0]
                                .parameterContent ==
                            'catalogDetail') {
                          var value = mdataInformationPushNotifyIndex
                              .promotionIndex[0].promotion[0].parameterKey
                              .split('|');
                          var catalogCampaign = value[1];
                          var catalogBrand = value[2];
                          var catalogMedia = value[3];
                          if ((value[0].isNotEmpty) &&
                              (catalogCampaign.isNotEmpty) &&
                              (catalogBrand.isNotEmpty) &&
                              (catalogMedia.isNotEmpty)) {
                            var catalogtype;
                            if (value[0] == '1') {
                              var catalogtype = "7";
                            } else if (value[0] == '2') {
                              var catalogtype = "8";
                            }
                            Get.find<CatelogDetailController>()
                                .get_catelog_detail(catalogCampaign,
                                    catalogBrand, catalogMedia);
                            Get.toNamed('/catelog_detail',
                                parameters: {"channel": catalogtype});
                          }
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        textAlign: TextAlign.left,
                        mdataInformationPushNotifyIndex
                            .promotionIndex[0].promotion[0].desc,
                        style: const TextStyle(
                            fontSize: 17, fontFamily: 'notoreg'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        textAlign: TextAlign.left,
                        mdataInformationPushNotifyIndex
                            .promotionIndex[0].promotion[0].date
                            .toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'notoreg',
                            color: Colors.black26),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              heightFactor: 15,
              child: theme_loading_df,
            );
          },
        ),
      ),
    );
  }
}
