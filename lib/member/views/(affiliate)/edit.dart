import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.category.edit.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.content.edit.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.product.edit.dart';
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

  @override
  void initState() {
    super.initState();
    _tab = TabController(
      length: shopTabs.length,
      vsync: this,
      initialIndex: widget.index.clamp(0, shopTabs.length - 1),
    );

    void refresh() {
      if (mounted) setState(() {});
    }

    _tab.addListener(refresh);
    _tab.animation?.addListener(refresh);
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
