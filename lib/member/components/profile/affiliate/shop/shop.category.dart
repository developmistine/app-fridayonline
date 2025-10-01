import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:get/get.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart'
    as content;

class ShopCategory extends StatelessWidget {
  const ShopCategory({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final affContentCtl = Get.find<AffiliateContentCtr>();

    return Obx(() {
      final isLoading = affContentCtl.isLoadingCategoryView.value;
      final RxList<content.ContentData> list = affContentCtl.viewCategoryData;
      final visible = list
          .where((cd) => cd.items.isNotEmpty && cd.items.first.status != 'hide')
          .toList();

      final isEmpty = !isLoading && list.isEmpty;

      return CustomScrollView(
        key: const PageStorageKey('tab_shop_content'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          if (isLoading) ...[
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          ] else if (isEmpty) ...[
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: buildEmptyBox('ไม่พบหมวดหมู่', 'โปรดสร้างหมวดหมู่สินค้า',
                    'สร้างหมวดหมู่', index),
              ),
            )
          ] else ...[
            SliverPadding(
              padding: const EdgeInsets.all(6),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final items = visible[i];

                    return buildCategorySection(items);
                  },
                  childCount: visible.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.94,
                ),
              ),
            ),
          ],
        ],
      );
    });
  }
}
