import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/home/cache_image.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
// import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/product_detail/product_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class OutStockFlashSale extends StatefulWidget {
  const OutStockFlashSale(this.channel, this.channelId, {super.key});
  final String channel;
  final String channelId;
  @override
  State<OutStockFlashSale> createState() => _OutStockFlashSaleState();
}

class _OutStockFlashSaleState extends State<OutStockFlashSale> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitleMaster(
          "รายการสินค้า",
        ),
        body: GetX<ProductDetailController>(builder: (detail) {
          return detail.isDataLoading.value
              ? Center(
                  child: theme_loading_df,
                )
              : detail.cacheProductDetailFlash!.billCode == ""
                  ? Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/logo/logofriday.png',
                            width: 70),
                        const Text('ไม่พบข้อมูล'),
                      ],
                    ))
                  : SingleChildScrollView(
                      child: Column(children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: [
                                            CacheImageProduct(
                                              url: detail
                                                  .cacheProductDetailFlash!
                                                  .productImages
                                                  .image[0],
                                              // set image opacity
                                            ),
                                            CachedNetworkImage(
                                              imageUrl: detail
                                                  .cacheProductDetailFlash!
                                                  .imgOutOfStock,
                                              width: 70,
                                              height: 70,
                                              // set image opacity
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.contain,
                                                        opacity: 0.85),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                detail.cacheProductDetailFlash!
                                                    .billName,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                  'ราคา ${myFormat.format(detail.cacheProductDetailFlash!.specialPrice)} บาท'),
                                            ],
                                          )),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset(
                                    'assets/images/flashsale/img_out_stock_big.png',
                                    width: 120,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        if (detail.cacheProductDetailFlash!.relatedProducts
                            .isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: Get.width / 3.5,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0XFFD9D9D9),
                                  ),
                                ),
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'สินค้าแนะนำ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  width: Get.width / 3.5,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0XFFD9D9D9),
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (detail.cacheProductDetailFlash!.relatedProducts
                            .isNotEmpty)
                          JustForU(widget: widget, detail: detail)
                      ]),
                    );
        }));
  }
}

class JustForU extends StatelessWidget {
  const JustForU({
    super.key,
    required this.widget,
    required this.detail,
  });

  final OutStockFlashSale widget;
  final ProductDetailController detail;
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (Get.width >= 768.0) ? 3 : 2,
        ),
        itemCount: detail.cacheProductDetailFlash!.relatedProducts.length,
        itemBuilder: (context, index) {
          List<RelatedProduct>? prodcutJust =
              detail.cacheProductDetailFlash!.relatedProducts;
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: InkWell(
                onTap: () {
                  Get.to(() => const ProductDetailPage(
                        ref: '',
                        contentId: '',
                      ));
                  detail.productDetailController(
                      prodcutJust[index].billCamp,
                      prodcutJust[index].billCode,
                      prodcutJust[index].media,
                      prodcutJust[index].fsCode,
                      widget.channel,
                      widget.channelId);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(children: [
                    Center(
                      child: CacheImageProduct(url: prodcutJust[index].image),
                    ),
                    // if (show)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 14.0, right: 14, bottom: 20, top: 8),
                      child: Text(prodcutJust[index].billName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
