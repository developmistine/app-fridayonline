import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:get/get.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart'
    as content;

class ShopContent extends StatefulWidget {
  const ShopContent({super.key, required this.index});
  final int index;

  @override
  State<ShopContent> createState() => _ShopContentState();
}

class _ShopContentState extends State<ShopContent>
    with AutomaticKeepAliveClientMixin {
  final affContentCtl = Get.find<AffiliateContentCtr>();

  void scrollInnerToTop(BuildContext context) {
    final c = PrimaryScrollController.of(context);
    if (c.hasClients) {
      c.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final affContentCtl = Get.find<AffiliateContentCtr>();

    return Obx(() {
      final isLoading = affContentCtl.isLoadingContentView.value;
      final RxList<content.ContentData> list = affContentCtl.viewContentData;

      final isEmpty = !isLoading && list.isEmpty;

      return CustomScrollView(
        key: const PageStorageKey('tab_shop_content'),
        physics: ClampingScrollPhysics(),
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
                child: buildEmptyBox(
                  'ไม่พบเนื้อหา',
                  'เพิ่มเนื้อหาร้านค้าเพื่อตกแต่งร้านของคุณ',
                  'สร้างเนื้อหา',
                  widget.index,
                ),
              ),
            )
          ] else ...[
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
                    final content.ContentData d = list[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: buildContentSection(d),
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
