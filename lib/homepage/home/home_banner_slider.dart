// ignore_for_file: must_be_immutable

// import 'dart:developer';

// import 'dart:convert';

// import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/List_product.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
// import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:fridayonline/homepage/widget/appbar_cart_share.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
// import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
// import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
// import '../../controller/product_detail/product_detail_controller.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/logapp/logapp_service.dart';
import '../../service/pathapi.dart';
// import '../../service/product_details/product_details_services.dart';
// import '../page_showproduct/dev.dart';
import '../theme/constants.dart';
import '../theme/theme_color.dart';
import '../webview/webview_app.dart';
import '../webview/webview_full_screen.dart';
import 'cache_image.dart';

// import 'home_product_detail.dart';

class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  ProductFromBanner bannerProduct = Get.put(ProductFromBanner());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetX<BannerController>(
      builder: ((banner) {
        if (!banner.isDataLoading.value) {
          if (banner.banner!.banner.isNotEmpty) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  height: width >= 768
                      ? MediaQuery.of(context).size.height / 3
                      : 190,
                  width: width,
                  child: CarouselSlider.builder(
                    autoSliderTransitionTime: const Duration(milliseconds: 500),
                    unlimitedMode: true,
                    slideBuilder: (index) {
                      return InkWell(
                        onTap: () async {
                          //LogApp
                          var logData = banner.banner!.banner[index];
                          var mchannel = '1';
                          var mchannelId = banner.banner!.banner[index].id;
                          InteractionLogger.logBanner(
                            contentId: logData.id,
                            contentName: logData.contentName,
                            contentImage: logData.contentImg,
                          );
                          LogAppTisCall(mchannel, mchannelId);
                          final bannerItem = banner.banner!.banner[index];

                          switch (bannerItem.keyindex) {
                            case 'sku':
                              Get.find<ProductDetailController>()
                                  .productDetailController(
                                bannerItem.campaign,
                                bannerItem.contentIndcx,
                                "",
                                bannerItem.fsCode,
                                mchannel,
                                mchannelId,
                              );
                              Get.to(() => ProductDetailPage(
                                  ref: "banner", contentId: bannerItem.id));
                              break;
                            case 'image':
                              return; // No action for 'image'
                            case 'url':
                              Get.to(() => WebViewFullScreen(
                                  mparamurl: bannerItem.contentIndcx));
                              break;
                            case 'coupon_rewards':
                              final urlContent =
                                  "${base_url_web_fridayth}bwpoint/product?billCode=${bannerItem.contentIndcx}";
                              Get.to(() => webview_app(
                                  mparamurl: urlContent,
                                  mparamTitleName: MultiLanguages.of(context)!
                                      .translate('point_titleView'),
                                  mparamType: "rewards_detail",
                                  mparamValue: bannerItem.contentIndcx,
                                  type: 'home'));
                              break;
                            case 'sharecatalog':
                              Get.toNamed("/sharecatalog");
                              break;
                            case 'coupon_popup':
                              SetData userData = SetData();
                              var repCode = await userData.repCode;
                              var repSeq = await userData.repSeq;
                              var repType = await userData.repType;
                              var tokenApp = await userData.tokenId;
                              var couponId = bannerItem.contentIndcx;
                              var url =
                                  "${sp_fridayth}webnew/RecieveCoupon?couponId=$couponId&RepCode=$repCode&RepSeq=$repSeq&RepType=$repType&Token=$tokenApp";
                              Get.to(() => WebViewFullScreen(mparamurl: url));
                              break;
                            default:
                              bannerProduct.fetch_product_banner(
                                  bannerItem.contentIndcx, bannerItem.campaign);
                              Get.to(() => Scaffold(
                                  appBar: appbarShare(
                                      MultiLanguages.of(context)!
                                          .translate('home_page_list_products'),
                                      "",
                                      mchannel,
                                      mchannelId),
                                  body: Obx(() => bannerProduct
                                          .isDataLoading.value
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : showList(
                                          bannerProduct.BannerProduct!.skucode,
                                          mchannel,
                                          mchannelId,
                                          ref: 'banner',
                                          contentId: mchannelId,
                                        ))));
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: CacheImageBanner(
                              url: banner.banner!.banner[index].contentImg),

                          // ),
                        ),
                      );
                    },
                    slideTransform: const DefaultTransform(),
                    slideIndicator: CircularSlideIndicator(
                        indicatorRadius: 3,
                        itemSpacing: 10,
                        padding: const EdgeInsets.only(bottom: 4),
                        currentIndicatorColor: theme_color_df,
                        indicatorBackgroundColor: Colors.grey.withOpacity(0.3)),
                    itemCount: banner.banner!.banner.length,
                    initialPage: 0,
                    enableAutoSlider: true,
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        }
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height:
                  width >= 768 ? MediaQuery.of(context).size.height / 3 : 200,
              width: width,
              child: Shimmer.fromColors(
                highlightColor: kBackgroundColor,
                baseColor: const Color(0xFFE0E0E0),
                child: Container(
                  color: Colors.grey[400],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
