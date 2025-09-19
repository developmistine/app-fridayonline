import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate.ctr.dart';
import 'package:get/get.dart';

const cetegoryData = [
  // {
  //   "catid": 846,
  //   "catname": "โฟมล้างหน้าตัวดังมิสทิน ชิ้นละ 65.-",
  //   "sub_categories": []
  // }
];

class ShopEditCategory extends StatelessWidget {
  const ShopEditCategory({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = cetegoryData.isEmpty;

    final affiliateCtl = Get.find<AffiliateController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      affiliateCtl.categoryEmpty.value = isEmpty;
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
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: buildHeaderBox(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final Map<String, dynamic> items =
                      cetegoryData[index] as Map<String, dynamic>;

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: buildContentSection(items),
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
