import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/showproduct/showproduct.category.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/cart.ctr.dart';

class BundleProducts extends StatefulWidget {
  final int bundleId;
  const BundleProducts({super.key, required this.bundleId});

  @override
  State<BundleProducts> createState() => _BundleProductsState();
}

class _BundleProductsState extends State<BundleProducts> {
  final EndUserCartCtr cartCtr = Get.find();
  ScrollController scrCtrl = ScrollController();
  int offset = 0;
  @override
  void initState() {
    super.initState();
    scrCtrl.addListener(() {
      if (scrCtrl.position.pixels == scrCtrl.position.maxScrollExtent &&
          !cartCtr.isFetchingLoadmore.value) {
        fetchMoreBundleProuduct();
      }
    });
  }

  @override
  void dispose() {
    offset = 0;
    scrCtrl.dispose();
    cartCtr.resetBundleProducts();
    super.dispose();
  }

  void fetchMoreBundleProuduct() async {
    cartCtr.isFetchingLoadmore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newBundleProduts =
          await cartCtr.fetchMoreBundleProductws(widget.bundleId, offset);

      if (newBundleProduts!.data.bundleDealProducts.isNotEmpty) {
        cartCtr.bundleProduct!.data.bundleDealProducts
            .addAll(newBundleProduts.data.bundleDealProducts);
        offset += 40;
      }
    } finally {
      cartCtr.isFetchingLoadmore.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: appBarMasterEndUser('Bundle Deals'),
        body: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Theme(
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
                child: Obx(() {
                  if (cartCtr.isLoadingBundleProduct.value) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (cartCtr.bundleProduct!.code == '-9') {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/search/zero_search.png',
                            width: 150,
                          ),
                          Text(
                            'ไม่พบข้อมูลสินค้า',
                            style: GoogleFonts.notoSansThaiLooped(),
                          )
                        ],
                      ),
                    );
                  }
                  var prouduct = cartCtr.bundleProduct!.data;
                  return SingleChildScrollView(
                    controller: scrCtrl,
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: theme_color_df,
                                maxRadius: 12,
                                child: const Icon(
                                  Icons.local_mall,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  prouduct.bundleDealDetail,
                                  style: GoogleFonts.notoSansThaiLooped(
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        MasonryGridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            primary: false,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                            gridDelegate:
                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
                            ),
                            itemCount: prouduct.bundleDealProducts.length +
                                (cartCtr.isFetchingLoadmore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < prouduct.bundleDealProducts.length) {
                                return ProductCategoryComponents(
                                  item: prouduct.bundleDealProducts[index],
                                  referrer: 'bundle_products_page',
                                );
                              }
                              return const SizedBox.shrink();
                            })
                      ],
                    ),
                  );
                }))));
  }
}
