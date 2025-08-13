import 'dart:async';

import 'package:fridayonline/enduser/components/appbar/appbar.nosearch.dart';
import 'package:fridayonline/enduser/components/shimmer/shimmer.product.dart';
import 'package:fridayonline/enduser/components/showproduct/nodata.dart';
// import 'package:fridayonline/enduser/components/showproduct/nodata.dart';
import 'package:fridayonline/enduser/components/showproduct/showproduct.category.dart';
import 'package:fridayonline/enduser/controller/brand.ctr.dart';
import 'package:fridayonline/enduser/controller/category.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/widgets/arrow_totop.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/safearea.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SubCategory extends StatefulWidget {
  const SubCategory({super.key});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  final CategoryCtr categoryCtr = Get.find();
  final ShowProductCategoryCtr showProductCtr = Get.find();
  final ScrollController _scrollController = ScrollController();
  final BrandCtr brandCtr = Get.find();

  bool isShowArrow = false;
  bool isShowImage = false;
  int offset = 40;
  int count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    brandCtr.fetchBrads('category', showProductCtr.catIdVal.value);
    _scrollController.addListener(() {
      // print(_scrollController.offset);
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !showProductCtr.isLoadingMore.value) {
        fetchMoreProductContent();
      }
      // print(_scrollController.offset);
      bool shouldSetArrow = _scrollController.offset > 205;
      bool shouldSetImg = _scrollController.offset > 440;

      if (shouldSetArrow != isShowArrow) {
        setState(() {
          isShowArrow = shouldSetArrow;
        });
      }

      if (shouldSetImg != isShowImage) {
        setState(() {
          isShowImage = shouldSetImg;
        });
      }
    });
  }

  void fetchMoreProductContent() async {
    showProductCtr.isLoadingMore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newRecommend =
          await showProductCtr.fetchMoreProductCategoryWithSort(
              showProductCtr.catIdVal.value,
              showProductCtr.subCatIdVal.value,
              showProductCtr.sortByVal.value,
              showProductCtr.orderByVal.value,
              40,
              offset);
      if (newRecommend!.data.products.isNotEmpty) {
        showProductCtr.productFilter!.data.products
            .addAll(newRecommend.data.products);
        offset += 40;
      }
    } finally {
      showProductCtr.isLoadingMore.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    showProductCtr.resetProductCategory();
    offset = 0;
    categoryCtr.activeTab.value = 0;
    categoryCtr.activeCat.value = -9;
    categoryCtr.isPriceUp.value = false;
    showProductCtr.subCatIdVal.value = 0;
    showProductCtr.catIdVal.value = 0;
    showProductCtr.sortByVal.value = "";
    showProductCtr.orderByVal.value = "";
    isShowImage = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaProvider(
      child: Scaffold(
        appBar: appBarNoSearchEndUser('หมวดหมู่สินค้า'),
        body: Theme(
          data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Stack(
                children: [
                  Obx(() {
                    if (categoryCtr.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return SingleChildScrollView(
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(8),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Friday Mall',
                                    style: GoogleFonts.notoSansThaiLooped(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Obx(() {
                                    if (brandCtr.isLoading.value) {
                                      return SizedBox(
                                          width: Get.width, height: 120);
                                    }
                                    return SizedBox(
                                      width: Get.width,
                                      height:
                                          brandCtr.brandsList!.data.length > 5
                                              ? 120
                                              : 60,
                                      child: GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        primary: false,
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: brandCtr
                                                            .brandsList!
                                                            .data
                                                            .length >
                                                        5
                                                    ? 2
                                                    : 1,
                                                mainAxisSpacing: 4,
                                                crossAxisSpacing: 4,
                                                mainAxisExtent: 100),
                                        itemCount:
                                            brandCtr.brandsList!.data.length,
                                        itemBuilder: (context, index) {
                                          var items =
                                              brandCtr.brandsList!.data[index];

                                          return InkWell(
                                              onTap: () async {
                                                Get.find<TrackCtr>()
                                                    .setLogContentAddToCart(
                                                        items.brandId,
                                                        'category_brands');
                                                Get.find<TrackCtr>()
                                                    .setDataTrack(
                                                        items.brandId,
                                                        items.brandName,
                                                        'category_brands');
                                                brandCtr.fetchShopData(
                                                    items.sellerId);
                                                // Get.to(() => const BrandStore());
                                                await Get.toNamed(
                                                        '/BrandStore/${items.sellerId}',
                                                        arguments:
                                                            items.sectionId == 0
                                                                ? 0
                                                                : 1,
                                                        parameters: {
                                                      "sectionId": items
                                                          .sectionId
                                                          .toString(),
                                                      "viewType":
                                                          items.sectionId == 0
                                                              ? '0'
                                                              : '1',
                                                    })!
                                                    .then((res) {
                                                  Get.find<TrackCtr>()
                                                      .clearLogContent();
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 0.5)),
                                                child: CachedNetworkImage(
                                                  height: 50,
                                                  imageUrl: items.icon,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Icon(
                                                      Icons.shopify_sharp,
                                                      color:
                                                          Colors.grey.shade400,
                                                    );
                                                  },
                                                ),
                                              ));
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            if (categoryCtr
                                .subcategory!.data.subCategories.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(8),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categoryCtr.subcategory!.data.catname,
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: Get.width,
                                      height: categoryCtr.subcategory!.data
                                                  .subCategories.length >
                                              6
                                          ? 180
                                          : 90,
                                      child: GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        primary: false,
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: categoryCtr
                                                      .subcategory!
                                                      .data
                                                      .subCategories
                                                      .length >
                                                  6
                                              ? 2
                                              : 1,
                                          mainAxisSpacing: 4,
                                          crossAxisSpacing: 4,
                                        ),
                                        itemCount: categoryCtr.subcategory!.data
                                            .subCategories.length,
                                        itemBuilder: (context, index) {
                                          var items = categoryCtr.subcategory!
                                              .data.subCategories[index];

                                          return InkWell(
                                            onTap: () {
                                              offset = 40;
                                              if (index ==
                                                  categoryCtr.activeCat.value) {
                                                categoryCtr.setActiveCat(-9);
                                                showProductCtr
                                                    .fetchProductByCategoryIdWithSort(
                                                        showProductCtr
                                                            .catIdVal.value,
                                                        0,
                                                        showProductCtr
                                                            .sortByVal.value,
                                                        showProductCtr
                                                            .orderByVal.value,
                                                        40,
                                                        0);
                                              } else {
                                                categoryCtr.setActiveCat(index);
                                                showProductCtr
                                                    .fetchProductByCategoryIdWithSort(
                                                        showProductCtr
                                                            .catIdVal.value,
                                                        items.subcatId,
                                                        showProductCtr
                                                            .sortByVal.value,
                                                        showProductCtr
                                                            .orderByVal.value,
                                                        40,
                                                        0);
                                              }
                                            },
                                            child: Obx(() {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    border: Border.all(
                                                        color: categoryCtr
                                                                    .activeCat
                                                                    .value ==
                                                                index
                                                            ? themeColorDefault
                                                            : Colors
                                                                .grey.shade300,
                                                        width: 0.5)),
                                                child: Column(
                                                  children: [
                                                    CachedNetworkImage(
                                                      height: 50,
                                                      imageUrl: items.image,
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Icon(
                                                          Icons.shopify_sharp,
                                                          color: Colors
                                                              .grey.shade400,
                                                        );
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      child: Text(
                                                        items.displayName,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.notoSansThaiLooped(
                                                            fontWeight: categoryCtr
                                                                        .activeCat
                                                                        .value ==
                                                                    index
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal,
                                                            color: categoryCtr
                                                                        .activeCat
                                                                        .value ==
                                                                    index
                                                                ? themeColorDefault
                                                                : Colors.black,
                                                            fontSize: 11,
                                                            height: 1.2),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 8,
                            ),
                            sortProduct(),
                            Obx(() {
                              return showProductCtr
                                      .isLoadingProductCategory.value
                                  ? MasonryGridView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      shrinkWrap: true,
                                      primary: false,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2,
                                      gridDelegate:
                                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            (Get.width >= 768.0) ? 4 : 2,
                                      ),
                                      itemCount: 12,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return const ShimmerProductItem();
                                      })
                                  : showProductCtr.productFilter!.data.products
                                          .isNotEmpty
                                      ? SingleChildScrollView(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              MasonryGridView.builder(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  crossAxisSpacing: 2,
                                                  mainAxisSpacing: 2,
                                                  gridDelegate:
                                                      SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        (Get.width >= 768.0)
                                                            ? 4
                                                            : 2,
                                                  ),
                                                  itemCount: showProductCtr
                                                          .productFilter!
                                                          .data
                                                          .products
                                                          .length +
                                                      (showProductCtr
                                                              .isLoadingMore
                                                              .value
                                                          ? 1
                                                          : 0),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    if (index ==
                                                            showProductCtr
                                                                .productFilter!
                                                                .data
                                                                .products
                                                                .length &&
                                                        showProductCtr
                                                            .isLoadingMore
                                                            .value) {
                                                      // แสดง loader เมื่อมีการโหลดข้อมูลเพิ่มเติม
                                                      return const SizedBox
                                                          .shrink();
                                                    }
                                                    return ProductCategoryComponents(
                                                      item: showProductCtr
                                                          .productFilter!
                                                          .data
                                                          .products[index],
                                                      referrer:
                                                          'category_detail_page',
                                                    );
                                                  }),
                                              Obx(() => showProductCtr
                                                      .isLoadingMore.value
                                                  ? Column(
                                                      children: [
                                                        Text(
                                                          'กำลังโหลด...',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .notoSansThaiLooped(
                                                                  color:
                                                                      themeColorDefault,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        const SizedBox(
                                                          height: 24,
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox()),
                                            ],
                                          ),
                                        )
                                      : nodata(context);
                            }),
                          ]),
                    );
                  }),
                  // if (isShowImage)
                  AnimatedOpacity(
                    opacity: isShowImage ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: sortProduct(),
                  ),
                ],
              )),
        ),
        floatingActionButton:
            arrowToTop(scrCtrl: _scrollController, isShowArrow: isShowArrow),
      ),
    );
  }

  Obx sortProduct() {
    return Obx(
      () {
        if (categoryCtr.isLoadingSort.value) {
          return const SizedBox();
        } else {
          return Container(
            color: Colors.white,
            width: Get.width,
            child: Row(children: [
              ...List.generate(
                categoryCtr.sortData!.data.length,
                (index) {
                  var items = categoryCtr.sortData!.data[index];
                  return Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        InkWell(
                          onTap: () {
                            offset = 40;
                            categoryCtr.setActiveTab(index);
                            if (items.subLevels.isNotEmpty) {
                              categoryCtr.isPriceUp.value =
                                  !categoryCtr.isPriceUp.value;
                              showProductCtr
                                  .fetchProductByCategoryIdWithSort(
                                      showProductCtr.catIdVal.value,
                                      showProductCtr.subCatIdVal.value,
                                      items.sortBy,
                                      categoryCtr.isPriceUp.value
                                          ? items.subLevels.last.order
                                          : items.subLevels.first.order,
                                      40,
                                      0)
                                  .then((res) {
                                _scrollController.animateTo(400,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.linear);
                              });
                            } else {
                              showProductCtr.orderByVal.value = "";
                              showProductCtr
                                  .fetchProductByCategoryIdWithSort(
                                      showProductCtr.catIdVal.value,
                                      showProductCtr.subCatIdVal.value,
                                      items.sortBy,
                                      "",
                                      40,
                                      0)
                                  .then((res) {
                                _scrollController.animateTo(400,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.linear);
                              });
                            }
                          },
                          child: Container(
                              // width: 100,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: categoryCtr.activeTab.value ==
                                                  index
                                              ? themeColorDefault
                                              : Colors.grey.shade300))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    items.text,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.notoSansThaiLooped(
                                        fontSize: 12,
                                        fontWeight:
                                            categoryCtr.activeTab.value == index
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color:
                                            categoryCtr.activeTab.value == index
                                                ? themeColorDefault
                                                : Colors.grey.shade700),
                                  ),
                                  Obx(() {
                                    if (index == categoryCtr.activeTab.value) {
                                      if (categoryCtr.sortData!.data.length ==
                                          index + 1) {
                                        if (categoryCtr.isPriceUp.value) {
                                          return Icon(
                                              Icons.arrow_upward_outlined,
                                              size: 12,
                                              color: themeColorDefault);
                                        }
                                        return Icon(
                                            Icons.arrow_downward_outlined,
                                            size: 12,
                                            color: themeColorDefault);
                                      }
                                    }
                                    return const SizedBox();
                                  })
                                ],
                              )),
                        ),
                        Text(
                          "|",
                          style: TextStyle(color: Colors.grey.shade300),
                        )
                      ],
                    ),
                  );
                },
              ),
            ]),
          );
        }
      },
    );
  }
}
