import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.category.edit.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.content.edit.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.product.edit.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.product.ctr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fridayonline/theme.dart';

// ----- Tab config -----
final shopTabs = [
  {"name": "ร้านค้า", "key": "content"},
  {"name": "รายการสินค้า", "key": "product_list"},
  {"name": "หมวดหมู่", "key": "category"},
];

class AffiliateEdit extends StatefulWidget {
  const AffiliateEdit({super.key, this.index = 0});
  final int index;

  @override
  State<AffiliateEdit> createState() => _AffiliateEditState();
}

class _AffiliateEditState extends State<AffiliateEdit>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final affContentCtl = Get.find<AffiliateContentCtr>();
  final affProductCtl = Get.find<AffiliateProductCtr>();
  final affAccountCtl = Get.find<AffiliateAccountCtr>();

  final Set<int> _loadedTabs = <int>{};

  @override
  void initState() {
    super.initState();

    final int initial = (widget.index < 0)
        ? 0
        : (widget.index >= shopTabs.length
            ? shopTabs.length - 1
            : widget.index);

    _tab = TabController(
      length: shopTabs.length,
      vsync: this,
      initialIndex: initial,
    );

    void triggerForIndex(int i, {bool force = false}) {
      if (!force && _loadedTabs.contains(i)) return;
      _loadedTabs.add(i);

      switch (i) {
        case 0: // ร้านค้า (content)
          affContentCtl.getAffiliateContent(
            page: 'modify',
            target: 'content',
            contentId: 0,
          );
          break;

        case 1:
          affProductCtl.refreshDefaultProducts(page: 'modify');

          break;

        case 2: // หมวดหมู่ (category)
          affContentCtl.getAffiliateContent(
            page: 'modify',
            target: 'category',
            contentId: 0,
          );
          break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadedTabs.addAll([0, 2]);
      await Future.wait([
        affContentCtl.getAffiliateContent(
            page: 'modify', target: 'content', contentId: 0),
        affContentCtl.getAffiliateContent(
            page: 'modify', target: 'category', contentId: 0),
      ]);
      triggerForIndex(_tab.index);
    });

    _tab.addListener(() {
      if (_tab.indexIsChanging) return;
      triggerForIndex(_tab.index);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              pinned: true,
              primary: true,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: themeColorDefault,
                ),
                onPressed: Get.back,
              ),
              title: Text(
                'จัดการร้านค้า',
                style: GoogleFonts.ibmPlexSansThai(
                  color: const Color(0xFF1F1F1F),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(38),
                child: ColoredBox(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tab,
                    isScrollable: false,
                    indicatorColor: themeColorDefault,
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: themeColorDefault,
                    unselectedLabelColor: const Color(0xFF393939),
                    labelStyle: GoogleFonts.ibmPlexSansThai(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    unselectedLabelStyle: GoogleFonts.ibmPlexSansThai(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    tabs: shopTabs
                        .map((v) => Tab(height: 42, text: v['name'] as String))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],

        // เนื้อหาแต่ละแท็บ (รองรับ SliverOverlapInjector ภายใน)
        body: TabBarView(
          controller: _tab,
          children: [
            SafeArea(top: false, child: ShopEditContent(index: _tab.index)),
            SafeArea(top: false, child: ShopEditProduct(index: _tab.index)),
            SafeArea(top: false, child: ShopEditCategory(index: _tab.index)),
          ],
        ),
      ),
    );
  }
}
