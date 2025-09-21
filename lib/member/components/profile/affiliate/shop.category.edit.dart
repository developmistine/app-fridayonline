import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.category.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:get/get.dart';

class ShopEditCategory extends StatelessWidget {
  const ShopEditCategory({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = cetegoryData.isEmpty;

    final affContentCtl = Get.find<AffiliateContentCtr>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      affContentCtl.categoryEmpty.value = isEmpty;
    });

    return CustomScrollView(
      key: const PageStorageKey('tab_shop_content'),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        if (isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: buildEmptyBox('ไม่พบหมวดหมู่', 'โปรดสร้างหมวดหมู่สินค้า',
                  'สร้างหมวดหมู่', index),
            ),
          )
        else ...[
          SliverToBoxAdapter(
              child: buildEmptyBoxButton('เพิ่มหมวดหมู่', index)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final Map<String, dynamic> items =
                      cetegoryData[i] as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
                    child: buildEditCategory(items),
                  );
                },
                childCount: cetegoryData.length,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
