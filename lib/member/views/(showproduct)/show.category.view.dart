import 'dart:async';

import 'package:fridayonline/member/components/appbar/appbar.nosearch.dart';
import 'package:fridayonline/member/components/shimmer/shimmer.product.dart';
import 'package:fridayonline/member/components/showproduct/nodata.dart';
import 'package:fridayonline/member/components/showproduct/showproduct.category.dart';
import 'package:fridayonline/member/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/member/widgets/arrow_totop.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final ShowProductCategoryCtr showProductCtr = Get.find();

class ShowProductCategory extends StatefulWidget {
  const ShowProductCategory({super.key});

  @override
  State<ShowProductCategory> createState() => _ShowProductCategoryState();
}

class _ShowProductCategoryState extends State<ShowProductCategory>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool isShowArrow = false;
  int offset = 10;
  var title = Get.arguments ?? "";
  int count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // ตรวจสอบการเลื่อนถึงท้ายรายการ
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !showProductCtr.isLoadingMore.value) {
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
    showProductCtr.isLoadingMore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newRecommend = await showProductCtr.fetchMoreProductCategory(
          showProductCtr.acType.value, showProductCtr.acValue.value, offset);

      if (newRecommend!.data.isNotEmpty) {
        showProductCtr.productCategory!.data.addAll(newRecommend.data);
        offset += 10;
      }
    } finally {
      showProductCtr.isLoadingMore.value = false;
    }
  }

  @override
  void dispose() {
    offset = 10;
    super.dispose();
    _scrollController.dispose();
    showProductCtr.resetProductCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade50,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Scaffold(
          appBar: appBarNoSearchEndUser(title != "" ? title : 'รายการสินค้า'),
          body: Obx(() {
            return showProductCtr.isLoadingProductCategory.value
                ? MasonryGridView.builder(
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
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return const ShimmerProductItem();
                    })
                : showProductCtr.productCategory!.data.isNotEmpty
                    ? SingleChildScrollView(
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            if (showProductCtr.productCategory!.contentImg !=
                                "")
                              CachedNetworkImage(
                                  imageUrl: showProductCtr
                                      .productCategory!.contentImg),
                            MasonryGridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                shrinkWrap: true,
                                primary: false,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
                                ),
                                itemCount: showProductCtr
                                        .productCategory!.data.length +
                                    (showProductCtr.isLoadingMore.value
                                        ? 1
                                        : 0),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index ==
                                          showProductCtr
                                              .productCategory!.data.length &&
                                      showProductCtr.isLoadingMore.value) {
                                    // แสดง loader เมื่อมีการโหลดข้อมูลเพิ่มเติม
                                    return const SizedBox.shrink();
                                  }
                                  return ProductCategoryComponents(
                                      item: showProductCtr
                                          .productCategory!.data[index],
                                      referrer: 'category_detail_page');
                                }),
                            Obx(() => showProductCtr.isLoadingMore.value
                                ? Column(
                                    children: [
                                      Text(
                                        'กำลังโหลด...',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.ibmPlexSansThai(
                                            color: themeColorDefault,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
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
          floatingActionButton:
              arrowToTop(scrCtrl: _scrollController, isShowArrow: isShowArrow),
        ),
      ),
    );
  }
}
