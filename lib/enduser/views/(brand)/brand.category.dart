import 'dart:async';

import 'package:appfridayecommerce/enduser/components/appbar/appbar.nosearch.dart';
import 'package:appfridayecommerce/enduser/components/shimmer/shimmer.product.dart';
import 'package:appfridayecommerce/enduser/components/showproduct/nodata.dart';
import 'package:appfridayecommerce/enduser/components/showproduct/showproduct.category.dart';
import 'package:appfridayecommerce/enduser/controller/brand.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/category.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/showproduct.category.ctr.dart';
import 'package:appfridayecommerce/enduser/widgets/arrow_totop.dart';
import 'package:appfridayecommerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final ShowProductCategoryCtr showProductCtr = Get.find();
final CategoryCtr categoryCtr = Get.find();

class ShowProductBrands extends StatefulWidget {
  const ShowProductBrands({super.key});

  @override
  State<ShowProductBrands> createState() => _ShowProductCategoryState();
}

class _ShowProductCategoryState extends State<ShowProductBrands>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final BrandCtr brandCtr = Get.find<BrandCtr>();

  bool isShowArrow = false;
  int offset = 10;
  var title = Get.arguments ?? "";
  int activeTab = 0;
  bool isPriceUp = false;

  setActiveTab(index) {
    setState(() {
      activeTab = index;
    });
  }

  int count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    // ตรวจสอบการเลื่อนถึงท้ายรายการ
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMoreProductContent();
      }

      bool shouldSetArrow = _scrollController.offset > 205;

      if (shouldSetArrow != isShowArrow) {
        setState(() {
          isShowArrow = shouldSetArrow;
        });
      }
    });
  }

  void fetchMoreProductContent() async {
    brandCtr.isLoadingMore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newProductFilter = await brandCtr.fetchMoreShopProductFilter(
          brandCtr.sectionIdVal,
          brandCtr.shopIdVal,
          brandCtr.sortByVal,
          brandCtr.orderByVal,
          offset);

      if (newProductFilter!.data.products.isNotEmpty) {
        brandCtr.shopProductFilter!.data.products
            .addAll(newProductFilter.data.products);
        offset += 40;
      }
    } finally {
      brandCtr.isLoadingMore.value = false;
    }
  }

  @override
  void dispose() {
    if (!mounted) {
      return;
    }
    offset = 10;
    super.dispose();
    _scrollController.dispose();
    brandCtr.resetShopProductFilter();
    brandCtr.isPriceUp.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarNoSearchEndUser(title != "" ? title : 'รายการสินค้า'),
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: Stack(
          children: [
            listProduct(),
            Positioned(top: 0, left: 0, right: 0, child: sortProduct())
          ],
        ),
      ),
      floatingActionButton:
          arrowToTop(scrCtrl: _scrollController, isShowArrow: isShowArrow),
    );
  }

  Widget sortProduct() {
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
                            if (!mounted) {
                              return;
                            }
                            offset = 10;
                            _scrollController.jumpTo(
                              0,
                            );
                            setActiveTab(index);
                            if (items.subLevels.isNotEmpty) {
                              isPriceUp = !isPriceUp;
                              brandCtr.fetchShopProductFilter(
                                  brandCtr.sectionIdVal,
                                  brandCtr.shopIdVal,
                                  items.sortBy,
                                  isPriceUp
                                      ? items.subLevels.last.order
                                      : items.subLevels.first.order,
                                  0);
                            } else {
                              showProductCtr.orderByVal.value = "";
                              brandCtr.orderByVal = "";
                              brandCtr.fetchShopProductFilter(
                                  brandCtr.sectionIdVal,
                                  brandCtr.shopIdVal,
                                  items.sortBy,
                                  "",
                                  0);
                            }
                            setState(() {});
                          },
                          child: Container(
                              // width: 100,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: activeTab == index
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
                                        fontWeight: activeTab == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: activeTab == index
                                            ? themeColorDefault
                                            : Colors.grey.shade700),
                                  ),
                                  Builder(builder: (context) {
                                    if (index == activeTab) {
                                      if (categoryCtr.sortData!.data.length ==
                                          index + 1) {
                                        if (isPriceUp) {
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

  Widget listProduct() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (brandCtr.isLoadingShopProductFilter.value) {
                return MasonryGridView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    shrinkWrap: true,
                    primary: false,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
                    ),
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      return const ShimmerProductItem();
                    });
              }
              if (brandCtr.shopProductFilter!.data.products.isEmpty) {
                return SizedBox(
                  width: Get.width,
                  height: Get.height / 1.5,
                  child: nodata(context),
                );
              }
              return MasonryGridView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  shrinkWrap: true,
                  primary: false,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
                  ),
                  itemCount: brandCtr.shopProductFilter!.data.products.length +
                      (brandCtr.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (index ==
                            brandCtr.shopProductFilter!.data.products.length &&
                        brandCtr.isLoadingMore.value) {
                      return const SizedBox.shrink();
                    }
                    return ProductCategoryComponents(
                      item: brandCtr.shopProductFilter!.data.products[index],
                      referrer: 'shop_product',
                    );
                  });
            }),
          ],
        ),
      ),
    );
  }
}
