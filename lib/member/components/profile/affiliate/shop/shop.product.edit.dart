import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.product.ctr.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart';
import 'package:get/get.dart';

class ShopEditProduct extends StatefulWidget {
  const ShopEditProduct({super.key, required this.index});
  final int index;

  @override
  State<ShopEditProduct> createState() => _ShopEditProductState();
}

class _ShopEditProductState extends State<ShopEditProduct> {
  final affProductCtl = Get.find<AffiliateProductCtr>();

  late final ScrollController _scrollCtr;
  final RxBool _showBackToTop = false.obs;

  @override
  void initState() {
    super.initState();

    _scrollCtr = ScrollController()
      ..addListener(() {
        _showBackToTop.value = _scrollCtr.offset > 300;
        if (_scrollCtr.position.pixels >=
            _scrollCtr.position.maxScrollExtent - 200) {
          affProductCtl.loadMoreDefaultProducts(page: 'modify');
        }
      });
  }

  @override
  void dispose() {
    _scrollCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = affProductCtl.isLoadingShopProduct.value;
      final RxList<AffiliateProduct> list = affProductCtl.editProductData;

      final isEmpty = !isLoading && list.isEmpty;

      return Stack(
        children: [
          CustomScrollView(
            controller: _scrollCtr,
            key: const PageStorageKey('tab_shop_product'),
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              if (isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: buildEmptyBox(
                        'ไม่พบรายการสินค้า',
                        'เพิ่มสินค้าเพื่อรับค่าคอมมิชชั่น',
                        'เพิ่มรายการสินค้า',
                        widget.index),
                  ),
                )
              else ...[
                SliverToBoxAdapter(
                    child:
                        buildEmptyBoxButton('เพิ่มรายการสินค้า', widget.index)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 8, left: 8, top: 8, bottom: 32),
                    child: buildEditProduct(list),
                  ),
                ),
                if (affProductCtl.isLoadingShopProduct.value)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
              ],
            ],
          ),
          Obx(() {
            if (!_showBackToTop.value) return const SizedBox.shrink();
            final safeBottom = MediaQuery.of(context).padding.bottom;
            return Positioned(
              right: 16,
              bottom: safeBottom,
              child: FloatingActionButton.small(
                heroTag: 'backToTop',
                backgroundColor: Colors.black87.withValues(alpha: .3),
                onPressed: () {
                  _scrollCtr.animateTo(
                    0,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                  );
                },
                child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
              ),
            );
          }),
        ],
      );
    });
  }
}
