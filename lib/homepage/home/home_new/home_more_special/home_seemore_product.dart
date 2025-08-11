// ignore_for_file: must_be_immutable

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbar_cart_share.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../../controller/category/category_controller.dart';
import '../../../../controller/home/home_controller.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../../service/logapp/logapp_service.dart';
import '../../../page_showproduct/List_product.dart';
import '../../../theme/theme_color.dart';
import '../../../widget/cartbutton.dart';
import '../../cache_image.dart';

class HomeSeemoreProduct extends StatelessWidget {
  HomeSeemoreProduct({super.key, required this.ref});
  final String ref;
  ScrollController scroller = ScrollController();
  ProductFromBanner bannerProduct = Get.put(ProductFromBanner());
  Color colorBg = const Color.fromARGB(255, 229, 228, 228);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back();
        return Get.find<HomeContentSpecialListController>()
            .get_home_content_data("");
      },
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBar(
                leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Get.find<HomeContentSpecialListController>()
                        .get_home_content_data("");
                    Get.back();
                  },
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
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CartIconButton(),
                  )
                ],
              )),
          body: GetX<HomeContentSpecialListController>(builder: ((content) {
            if (!content.isDataLoading.value) {
              return SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                      child: contentList(content),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: contentSku(content),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: contentSlide(context, content)),
                  ],
                ),
              );
            }
            return Center(
              child: theme_loading_df,
            );
          })),
        ),
      ),
    );
  }

  contentSlide(BuildContext context, HomeContentSpecialListController content) {
    return content.home_content!.specialPromotionList.contentSlide.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount:
                content.home_content!.specialPromotionList.contentSlide.length,
            itemBuilder: (context, index3) {
              return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                      onTap: () {
                        print("LogApp Special Discount");
                        //LogApp
                        var logData = content.home_content!.specialPromotionList
                            .contentSlide[index3];
                        var mchannel = '5';
                        var mchannelId = content.home_content!
                            .specialPromotionList.contentSlide[index3].id;
                        LogAppTisCall(mchannel, mchannelId);
                        InteractionLogger.logPromotion(
                          contentId: logData.id,
                          contentName: logData.contentName,
                          contentImage: logData.contentImg,
                        );
                        //  End
                        // ignore: avoid_print
                        print(content.home_content!.specialPromotionList
                            .contentSlide[index3]
                            .toJson());
                        if (content.home_content!.specialPromotionList
                                .contentSlide[index3].contentType !=
                            'sku') {
                          if (content.home_content!.specialPromotionList
                                  .contentSlide[index3].contentType ==
                              'sharecatalog') {
                            Get.toNamed("/sharecatalog");
                          } else {
                            bannerProduct.fetch_product_banner(
                                content.home_content!.specialPromotionList
                                    .contentSlide[index3].contentIndex,
                                "");
                            Get.to(() => Scaffold(
                                appBar: appbarShare(
                                    MultiLanguages.of(context)!
                                        .translate('home_page_list_products'),
                                    "",
                                    mchannel,
                                    mchannelId),
                                body:
                                    Obx(() => bannerProduct.isDataLoading.value
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : showList(
                                            bannerProduct
                                                .BannerProduct!.skucode,
                                            mchannel,
                                            mchannelId,
                                            ref: '',
                                            contentId: '',
                                          ))));
                          }
                        } else {
                          Get.find<ProductDetailController>()
                              .productDetailController(
                            content.home_content!.specialPromotionList
                                .contentSlide[index3].campaign, //campaign
                            content.home_content!.specialPromotionList
                                .contentSlide[index3].contentIndex,
                            "", // brand
                            content.home_content!.specialPromotionList
                                .contentSlide[index3].fscode, // fscode
                            mchannel,
                            mchannelId,
                          );
                          Get.to(() => ProductDetailPage(
                                ref: ref,
                                contentId: content
                                    .home_content!
                                    .specialPromotionList
                                    .contentSlide[index3]
                                    .id,
                              ));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 4),
                        child: CacheImagePromotion(
                            url: content.home_content!.specialPromotionList
                                .contentSlide[index3].contentImg),
                      )));
            },
            // physics: const NeverScrollableScrollPhysics(),
          )
        : const SizedBox();
  }

  contentSku(HomeContentSpecialListController content) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const BouncingScrollPhysics(),
        itemCount: content.home_content!.specialPromotionList.contentSku.length,
        itemBuilder: (BuildContext context, index) {
          if (content.home_content!.specialPromotionList.contentSku.isEmpty) {
            return const SizedBox();
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                content.home_content!.specialPromotionList.contentSku[index]
                        .contentImg.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: InkWell(
                          onTap: () {
                            print("LogApp Special Discount");
                            //LogApp
                            var logData = content.home_content!
                                .specialPromotionList.contentSku[index];
                            var mchannel = '5';
                            var mchannelId = content.home_content!
                                .specialPromotionList.contentSku[index].id;
                            LogAppTisCall(mchannel, mchannelId);
                            InteractionLogger.logPromotion(
                              contentId: logData.id,
                              contentName: logData.contentName,
                              contentImage: logData.contentImg,
                            );
                            //  End
                            // ignore: avoid_print
                            print(content.home_content!.specialPromotionList
                                .contentSku[index]
                                .toJson());
                            if (content.home_content!.specialPromotionList
                                    .contentSku[index].contentType !=
                                'sku') {
                              if (content.home_content!.specialPromotionList
                                      .contentSku[index].contentType ==
                                  'sharecatalog') {
                                Get.toNamed("/sharecatalog");
                              } else {
                                bannerProduct.fetch_product_banner(
                                    content.home_content!.specialPromotionList
                                        .contentSku[index].contentIndex,
                                    "");
                                Get.to(() => Scaffold(
                                    appBar: appbarShare(
                                        MultiLanguages.of(context)!.translate(
                                            'home_page_list_products'),
                                        "",
                                        mchannel,
                                        mchannelId),
                                    body: Obx(
                                        () => bannerProduct.isDataLoading.value
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : showList(
                                                bannerProduct
                                                    .BannerProduct!.skucode,
                                                mchannel,
                                                mchannelId,
                                                ref: ref,
                                                contentId: mchannelId,
                                              ))));
                              }
                            } else {
                              Get.find<ProductDetailController>()
                                  .productDetailController(
                                content.home_content!.specialPromotionList
                                    .contentSku[index].campaign, //campaign
                                content.home_content!.specialPromotionList
                                    .contentSku[index].contentIndex,
                                "", // brand
                                content.home_content!.specialPromotionList
                                    .contentSku[index].fscode, // fscode
                                mchannel,
                                mchannelId,
                              );
                              Get.to(() => ProductDetailPage(
                                    ref: ref,
                                    contentId: content
                                        .home_content!
                                        .specialPromotionList
                                        .contentSku[index]
                                        .id,
                                  ));
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CacheImageBanner(
                              url: content.home_content!.specialPromotionList
                                  .contentSku[index].contentImg,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          }
        });
  }

  contentList(HomeContentSpecialListController content) {
    return content.home_content!.specialPromotionList.contentList.isNotEmpty
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            primary: false,
            itemCount:
                content.home_content!.specialPromotionList.contentList.length,
            itemBuilder: (context, index) {
              if (content.home_content!.specialPromotionList.contentList[index]
                      .id ==
                  "") {
                return Container();
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      print("LogApp Special Discount");
                      //LogApp
                      var logData = content.home_content!.specialPromotionList
                          .contentList[index];
                      var mchannel = '5';
                      var mchannelId = content.home_content!
                          .specialPromotionList.contentList[index].id;
                      LogAppTisCall(mchannel, mchannelId);
                      InteractionLogger.logPromotion(
                        contentId: logData.id,
                        contentName: logData.contentName,
                        contentImage: logData.contentImg,
                      );
                      //  End
                      // ignore: avoid_print
                      print(content
                          .home_content!.specialPromotionList.contentList[index]
                          .toJson());
                      if (content.home_content!.specialPromotionList
                              .contentList[index].contentType !=
                          'sku') {
                        print(content.home_content!.specialPromotionList
                            .contentList[index].contentType);
                        if (content.home_content!.specialPromotionList
                                .contentList[index].contentType ==
                            'sharecatalog') {
                          Get.toNamed("/sharecatalog");
                        } else {
                          bannerProduct.fetch_product_banner(
                              content.home_content!.specialPromotionList
                                  .contentList[index].contentIndex,
                              "");
                          Get.to(() => Scaffold(
                              appBar: appbarShare(
                                  MultiLanguages.of(context)!
                                      .translate('home_page_list_products'),
                                  "",
                                  mchannel,
                                  mchannelId),
                              body: Obx(() => bannerProduct.isDataLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : showList(
                                      bannerProduct.BannerProduct!.skucode,
                                      mchannel,
                                      mchannelId,
                                      ref: ref,
                                      contentId: mchannelId,
                                    ))));
                        }
                      } else {
                        Get.find<ProductDetailController>()
                            .productDetailController(
                          content.home_content!.specialPromotionList
                              .contentList[index].campaign, //campaign
                          content.home_content!.specialPromotionList
                              .contentList[index].contentIndex,
                          "", // brand
                          content.home_content!.specialPromotionList
                              .contentList[index].fscode, // fscode
                          mchannel,
                          mchannelId,
                        );
                        Get.to(() => ProductDetailPage(
                              ref: ref,
                              contentId: mchannelId,
                            ));
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CacheImageDiscount(
                          url: content.home_content!.specialPromotionList
                              .contentList[index].contentImg),
                    ),
                  ),
                );
              }
            },
          )
        : const SizedBox();
  }
}
