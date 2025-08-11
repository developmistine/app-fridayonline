import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/widget/appbar_cart_share.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

// import '../../controller/category/category_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/logapp/logapp_service.dart';
import '../page_showproduct/List_product.dart';
import '../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../theme/constants.dart';
import '../theme/theme_color.dart';
import 'cache_image.dart';
import 'home_new/home_more_special/home_seemore_product.dart';

class HomeContentSpecialList extends StatefulWidget {
  const HomeContentSpecialList({super.key});

  @override
  State<HomeContentSpecialList> createState() => _HomeContentSpecialListState();
}

class _HomeContentSpecialListState extends State<HomeContentSpecialList> {
  ProductFromBanner bannerProduct = Get.put(ProductFromBanner());

  Color colorBg = const Color.fromARGB(255, 229, 228, 228);

  ScrollController keyIconScroller = ScrollController();
  SetData data = SetData();
  String? typeCheck;
  getType() async {
    var getSetdata = await data.repType;
    setState(() {
      typeCheck = getSetdata;
      // print(typeCheck);
    });
  }

  @override
  void initState() {
    super.initState();
    getType();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeContentSpecialListController>(builder: (content) {
      if (!content.isDataLoading.value) {
        return Column(
          children: [
            if (content.home_content!.specialPromotionList.contentList
                    .isNotEmpty ||
                content
                    .home_content!.specialPromotionList.contentSku.isNotEmpty ||
                content
                    .home_content!.specialPromotionList.contentSlide.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                    right: 8.0, left: 18, top: 8, bottom: 8),
                child: buttonSeemore(),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: contentList(content),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: contentSku(content),
            ),
            if (content
                .home_content!.specialPromotionList.contentSlide.isNotEmpty)
              contentSlide(context, content)
          ],
        );
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme_color_df,
                  ),
                ),
                Shimmer.fromColors(
                  highlightColor: kBackgroundColor,
                  baseColor: const Color(0xFFE0E0E0),
                  child: SizedBox(
                    width: 120,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme_color_df),
                        onPressed: () {},
                        child: const Text(
                          '',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ),
          if (typeCheck != '3') contentListLoading(),
          typeCheck != '0' ? contentSkuLoading() : const SizedBox()
        ],
      );
    });
  }

  buttonSeemore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'โปรโมชันพิเศษ',
          style: TextStyle(
              fontSize: 18, color: theme_color_df, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme_color_df),
              onPressed: () {
                Get.find<HomeContentSpecialListController>()
                    .get_home_content_data("seemore");
                Get.to(() => HomeSeemoreProduct(ref: 'promotion'));
              },
              child: const Text(
                'ดูเพิ่มเติม',
                style: TextStyle(fontSize: 14, color: Colors.white),
              )),
        )
      ],
    );
  }

  contentList(HomeContentSpecialListController content) {
    return content.home_content!.specialPromotionList.contentList.isNotEmpty
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                content.home_content!.specialPromotionList.contentList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    //LogApp
                    var logData = content
                        .home_content!.specialPromotionList.contentList[index];
                    var mchannel = '5';
                    var mchannelId = content.home_content!.specialPromotionList
                        .contentList[index].id;
                    LogAppTisCall(mchannel, mchannelId);
                    InteractionLogger.logPromotion(
                      contentId: logData.id,
                      contentName: logData.contentName,
                      contentImage: logData.contentImg,
                    );
                    //  End
                    // ignore: avoid_print

                    if (content.home_content!.specialPromotionList
                            .contentList[index].contentType !=
                        'sku') {
                      if (content.home_content!.specialPromotionList
                              .contentList[index].contentType ==
                          'sharecatalog') {
                        Get.toNamed("/sharecatalog");
                      } else {
                        bannerProduct.fetch_product_banner(
                            content.home_content!.specialPromotionList
                                .contentList[index].contentIndex,
                            content.home_content!.specialPromotionList
                                .contentList[index].campaign);
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
                                    ref: 'promotion',
                                    contentId: logData.id,
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
                            ref: 'promotion',
                            contentId: content.home_content!
                                .specialPromotionList.contentList[index].id,
                          ));
                    }
                  },
                  child: CacheImageDiscount(
                      url: content.home_content!.specialPromotionList
                          .contentList[index].contentImg),
                ),
              );
            },
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
          var dataItemsCount = content.home_content!.specialPromotionList
              .contentSku[index].listSku.length;
          if (dataItemsCount >= 8) {
            dataItemsCount = 8;
          }
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              if (kDebugMode) {
                                print("LogApp Special Discount");
                              }
                              // LogApp
                              var logData = content.home_content!
                                  .specialPromotionList.contentSku[index];
                              var mchannel = '5';
                              var mchannelId = content.home_content!
                                  .specialPromotionList.contentSku[index].id;
                              InteractionLogger.logPromotion(
                                contentId: logData.id,
                                contentName: logData.contentName,
                                contentImage: logData.contentImg,
                              );
                              LogAppTisCall(mchannel, mchannelId);
                              // End
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
                                      body: Obx(() =>
                                          bannerProduct.isDataLoading.value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : showList(
                                                  bannerProduct
                                                      .BannerProduct!.skucode,
                                                  mchannel,
                                                  mchannelId,
                                                  ref: 'promotion',
                                                  contentId: logData.id,
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
                                      ref: 'promotion',
                                      contentId: content
                                          .home_content!
                                          .specialPromotionList
                                          .contentSku[index]
                                          .id,
                                    ));
                              }
                            },
                            child: CacheImageBanner(
                              url: content.home_content!.specialPromotionList
                                  .contentSku[index].contentImg,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                content.home_content!.specialPromotionList.contentSku[index]
                        .listSku.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        height: 125,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: dataItemsCount,
                          itemBuilder: (BuildContext context, int index2) {
                            if (index2 < 7) {
                              return InkWell(
                                onTap: () {
                                  var logData = content.home_content!
                                      .specialPromotionList.contentSku[index];
                                  InteractionLogger.logPromotion(
                                    contentId: logData.id,
                                    contentName: logData.contentName,
                                    contentImage: logData.contentImg,
                                  );
                                  Get.find<ProductDetailController>()
                                      .productDetailController(
                                    content
                                        .home_content!
                                        .specialPromotionList
                                        .contentSku[index]
                                        .listSku[index2]
                                        .billcamp, //campaign
                                    content
                                        .home_content!
                                        .specialPromotionList
                                        .contentSku[index]
                                        .listSku[index2]
                                        .billcode,
                                    content
                                        .home_content!
                                        .specialPromotionList
                                        .contentSku[index]
                                        .contentIndex, // brand
                                    content.home_content!.specialPromotionList
                                        .contentSku[index].fscode, // fscode
                                    "",
                                    "",
                                  );
                                  Get.to(() => ProductDetailPage(
                                        ref: 'promotion',
                                        contentId: content
                                            .home_content!
                                            .specialPromotionList
                                            .contentSku[index]
                                            .id,
                                      ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4.0, left: 2, right: 2),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(56, 0, 0, 0),
                                          offset: Offset(0.6, 2.0),
                                          blurRadius: 0.2,
                                          spreadRadius: 0.4,
                                        ), //BoxShadow
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(children: [
                                        // if (show)
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: content
                                                  .home_content!
                                                  .specialPromotionList
                                                  .contentSku[index]
                                                  .listSku[index2]
                                                  .img,
                                              height: 75,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              textAlign: TextAlign.left,
                                              '฿ ${myFormat.format(double.parse(content.home_content!.specialPromotionList.contentSku[index].listSku[index2].specialPrice))}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'notoreg',
                                                  fontWeight: FontWeight.bold,
                                                  color: theme_color_df),
                                            ),
                                            // Text(
                                            //   textAlign: TextAlign.left,
                                            //   '฿ ${content.home_content!.specialPromotionList.contentSku[index].listSku[index2].regularPrice}',
                                            //   style: const TextStyle(
                                            //     fontSize: 12,
                                            //     fontFamily: 'notoreg',
                                            //     color: Colors.grey,
                                            //     decoration: TextDecoration
                                            //         .lineThrough,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return InkWell(
                                onTap: () {
                                  print("LogApp Special Discount");
                                  //LogApp
                                  var logData = content.home_content!
                                      .specialPromotionList.contentSku[index];
                                  var mchannel = '5';
                                  var mchannelId = content
                                      .home_content!
                                      .specialPromotionList
                                      .contentSku[index]
                                      .id;
                                  LogAppTisCall(mchannel, mchannelId);
                                  InteractionLogger.logPromotion(
                                    contentId: logData.id,
                                    contentName: logData.contentName,
                                    contentImage: logData.contentImg,
                                  );
                                  //  End
                                  // ignore: avoid_print
                                  print(content.home_content!
                                      .specialPromotionList.contentSku[index]
                                      .toJson());
                                  if (content.home_content!.specialPromotionList
                                          .contentSku[index].contentType !=
                                      'sku') {
                                    bannerProduct.fetch_product_banner(
                                        content
                                            .home_content!
                                            .specialPromotionList
                                            .contentSku[index]
                                            .contentIndex,
                                        "");
                                    Get.to(
                                      () => Scaffold(
                                          appBar: appbarShare(
                                              MultiLanguages.of(context)!
                                                  .translate(
                                                      'home_page_list_products'),
                                              "",
                                              mchannel,
                                              mchannelId),
                                          body: Obx(() =>
                                              bannerProduct.isDataLoading.value
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : showList(
                                                      bannerProduct
                                                          .BannerProduct!
                                                          .skucode,
                                                      mchannel,
                                                      mchannelId,
                                                      ref: 'promotion',
                                                      contentId: logData.id,
                                                    ))),
                                    );
                                  } else {
                                    Get.find<ProductDetailController>()
                                        .productDetailController(
                                      content
                                          .home_content!
                                          .specialPromotionList
                                          .contentSku[index]
                                          .campaign, //campaign
                                      content.home_content!.specialPromotionList
                                          .contentSku[index].contentIndex,
                                      "", // brand
                                      content.home_content!.specialPromotionList
                                          .contentSku[index].fscode, // fscode
                                      mchannel,
                                      mchannelId,
                                    );
                                    Get.to(() => ProductDetailPage(
                                          ref: 'promotion',
                                          contentId: content
                                              .home_content!
                                              .specialPromotionList
                                              .contentSku[index]
                                              .id,
                                        ));
                                    // Get.find<CategoryProductDetailController>()
                                    //     .fetchproductdetail(
                                    //         "", //campaign
                                    //         content
                                    //             .home_content!
                                    //             .specialPromotionList
                                    //             .contentSku[index]
                                    //             .contentIndex,
                                    //         "", // brand
                                    //         "", // fscode
                                    //         mchannel,
                                    //         mchannelId,
                                    //         '');
                                    // Get.toNamed('/my_detail', parameters: {
                                    //   'mchannel': mchannel,
                                    //   'mchannelId': mchannelId
                                    // });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4.0, left: 2, right: 2),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(14, 0, 0, 0),
                                          offset: Offset(0.0, 4.0),
                                          blurRadius: 0.2,
                                          spreadRadius: 0.2,
                                        ), //BoxShadow
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  'ดูเพิ่มเติม',
                                                  style: TextStyle(
                                                    color: theme_color_df,
                                                  ),
                                                )),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: theme_color_df,
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 2,
                                  mainAxisExtent: 100,
                                  crossAxisCount: 1),
                        ))
                    : const SizedBox(),
              ],
            );
          }
        });
  }

  contentSlide(BuildContext context, HomeContentSpecialListController content) {
    return content.home_content!.specialPromotionList.contentSlide.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.width >= 768 ? 300 : 200,
              // width: MediaQuery.of(context).size.width - 50,
              child: RawScrollbar(
                // minOverscrollLength: 100,
                thumbColor: theme_color_df,
                trackColor: Colors.grey[350],
                trackBorderColor: Colors.transparent,
                thickness: 8,
                minThumbLength: 20,
                // mainAxisMargin: 50,
                trackRadius: const Radius.circular(20),
                radius: const Radius.circular(20),
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                controller: keyIconScroller,
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width > 390 ? 180 : 160),
                child: GridView.builder(
                  controller: keyIconScroller,
                  scrollDirection: Axis.horizontal,
                  itemCount: content
                      .home_content!.specialPromotionList.contentSlide.length,
                  itemBuilder: (BuildContext context, int index3) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            if (kDebugMode) {
                              print("LogApp Special Discount");
                            }
                            //LogApp
                            var logData = content.home_content!
                                .specialPromotionList.contentSlide[index3];
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
                                    content.home_content!.specialPromotionList
                                        .contentSlide[index3].campaign);
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
                                                ref: 'promotion',
                                                contentId: logData.id,
                                              ))));
                              }
                            } else if (content
                                    .home_content!
                                    .specialPromotionList
                                    .contentSlide[index3]
                                    .contentType ==
                                'image') {
                              return;
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
                                    ref: 'promotion',
                                    contentId: content
                                        .home_content!
                                        .specialPromotionList
                                        .contentSlide[index3]
                                        .id,
                                  ));
                              // Get.find<CategoryProductDetailController>()
                              //     .fetchproductdetail(
                              //         content
                              //             .home_content!
                              //             .specialPromotionList
                              //             .contentSlide[index3]
                              //             .campaign, //campaign
                              //         content.home_content!.specialPromotionList
                              //             .contentSlide[index3].contentIndex,
                              //         content.home_content!.specialPromotionList
                              //             .contentSlide[index3].brand, // brand
                              //         content
                              //             .home_content!
                              //             .specialPromotionList
                              //             .contentSlide[index3]
                              //             .fscode, // fscode
                              //         mchannel,
                              //         mchannelId,
                              //         '');
                              // Get.toNamed('/my_detail', parameters: {
                              //   'mchannel': mchannel,
                              //   'mchannelId': mchannelId
                              // });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: CacheImagePromotion(
                                url: content.home_content!.specialPromotionList
                                    .contentSlide[index3].contentImg),
                          )),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent:
                        MediaQuery.of(context).size.width >= 768 ? 500 : 360,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  contentListLoading() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Shimmer.fromColors(
              highlightColor: kBackgroundColor,
              baseColor: const Color(0xFFE0E0E0),
              child: Container(
                height: 180,
                color: Colors.white,
              ),
            )));
  }

  contentSkuLoading() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: Colors.grey,
                  child: Shimmer.fromColors(
                    highlightColor: kBackgroundColor,
                    baseColor: const Color(0xFFE0E0E0),
                    child: Container(
                      height: 180,
                      color: Colors.white,
                    ),
                  ),
                )),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                height: 150,
                width: double.infinity,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index2) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 4.0, left: 2, right: 2),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(14, 0, 0, 0),
                              offset: Offset(0.0, 4.0),
                              blurRadius: 0.2,
                              spreadRadius: 0.2,
                            ), //BoxShadow
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(children: [
                            // if (show)
                            Shimmer.fromColors(
                              highlightColor: kBackgroundColor,
                              baseColor: const Color(0xFFE0E0E0),
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 100,
                              ),
                            ),
                            Shimmer.fromColors(
                              highlightColor: kBackgroundColor,
                              baseColor: const Color(0xFFE0E0E0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.only(top: 12),
                                height: 12,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 2,
                      mainAxisExtent: 100,
                      crossAxisCount: 1),
                ))
          ],
        ));
  }
}
