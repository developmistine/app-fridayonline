import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:get/get.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart'
    as content;

class ShopEditCategory extends StatefulWidget {
  const ShopEditCategory({super.key, required this.index});
  final int index;

  @override
  State<ShopEditCategory> createState() => _ShopEditCategoryState();
}

class _ShopEditCategoryState extends State<ShopEditCategory> {
  final _listCtrl = ScrollController();

  void scrollToTop() {
    if (!_listCtrl.hasClients) return;
    _listCtrl.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void initState() {
    super.initState();

    _listCtrl.addListener(() {});
  }

  @override
  void dispose() {
    _listCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final affContentCtl = Get.find<AffiliateContentCtr>();

    return Obx(() {
      final isLoading = affContentCtl.isLoadingCategoryEdit.value;
      final RxList<content.ContentData> list = affContentCtl.editCategoryData;
      final isEmpty = !isLoading && list.isEmpty;

      return CustomScrollView(
        controller: _listCtrl,
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
                    'สร้างหมวดหมู่', widget.index),
              ),
            )
          ] else ...[
            SliverToBoxAdapter(
                child: buildEmptyBoxButton('เพิ่มหมวดหมู่', widget.index)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final items = list[i];

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child:
                          buildEditCategory(items, i, onScrollTop: scrollToTop),
                    );
                  },
                  childCount: list.length,
                ),
              ),
            ),
          ],
        ],
      );
    });
  }
}
