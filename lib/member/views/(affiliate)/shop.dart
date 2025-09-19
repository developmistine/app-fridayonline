import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.category.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.content.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.product.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.header.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate.ctr.dart';
import 'package:fridayonline/member/views/(affiliate)/edit.dart';
import 'package:fridayonline/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

// ----- Tab config -----
final shopTabs = [
  {"name": "ร้านค้า", "key": "content"},
  {"name": "รายการสินค้า", "key": "product_list"},
  {"name": "หมวดหมู่", "key": "category"},
];

class _ProfileRow extends StatelessWidget {
  const _ProfileRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 55,
          height: 55,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Container(
            margin: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(userProfile['image'] as String),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userProfile['shop_name'] as String,
                style: GoogleFonts.ibmPlexSansThai(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "เข้าร่วมเมื่อ ${userProfile['shop_active']} | รายการสินค้า (${userProfile['shop_items']})",
                style: GoogleFonts.ibmPlexSansThai(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white, width: 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('แก้ไข',
              style: GoogleFonts.ibmPlexSansThai(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

class AffiliateShop extends StatefulWidget {
  const AffiliateShop({super.key});

  @override
  State<AffiliateShop> createState() => _AffiliateShopState();
}

class _AffiliateShopState extends State<AffiliateShop>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  AffiliateController affiliateCtl = Get.find<AffiliateController>();

  String _textFor(int i) {
    switch (i) {
      case 0:
        return 'จัดการเนื้อหา';
      case 1:
        return 'จัดการรายการสินค้า';
      case 2:
        return 'จัดการหมวดหมู่';
      default:
        return '';
    }
  }

  VoidCallback? _actionFor(int i) {
    return () {
      Get.to(() => AffiliateEdit(
            index: i,
          ));
    };
  }

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: shopTabs.length, vsync: this);

    void refresh() {
      if (mounted) setState(() {});
    }

    _tab.addListener(refresh);
    _tab.animation?.addListener(refresh);

    final _ = affiliateCtl;
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
      bottomNavigationBar: AnimatedBuilder(
        animation: _tab.animation!,
        builder: (context, _) {
          final idx = (_tab.animation?.value ?? _tab.index).round();

          final onPressed = _actionFor(idx);
          if (onPressed == null) return const SizedBox.shrink();
          return Obx(() {
            final isEmptyNow = switch (idx) {
              0 => affiliateCtl.contentEmpty.value,
              1 => affiliateCtl.productEmpty.value,
              2 => affiliateCtl.categoryEmpty.value,
              _ => true,
            };

            if (isEmptyNow) return const SizedBox.shrink();

            return buildBottomButton(_textFor(idx), onPressed);
          });
        },
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              pinned: true,
              primary: true,
              backgroundColor: Colors.white,
              elevation: 0,
              expandedHeight: 175,
              leading: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      shape: BoxShape.circle),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                    onPressed: Get.back,
                  ),
                ),
              ),
              centerTitle: false,
              title: Text(
                'ตกแต่งร้านค้า',
                style: GoogleFonts.ibmPlexSansThai(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final double topPad = MediaQuery.of(context).padding.top;
                  const double tabH = 48.0;
                  const double profileH = 72.0;
                  final double min = topPad + kToolbarHeight + tabH;
                  final double curr = constraints.biggest.height;

                  final double fadeStart = min + profileH;
                  final double t =
                      ((curr - min) / (fadeStart - min)).clamp(0.0, 1.0);

                  final bg = userProfile['background_image'] as String?;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                        child: Image.network(
                          bg ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Container(color: Colors.black.withValues(alpha: 0.30)),
                      SafeArea(
                        top: false,
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              10, kToolbarHeight + 8, 10, 48 + 8),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Opacity(
                              opacity: t, // ค่อย ๆ หายตอนยุบ
                              child: Transform.translate(
                                offset: Offset(0, 16 * (1 - t)),
                                child: _ProfileRow(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
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
                          .map(
                              (v) => Tab(height: 42, text: v['name'] as String))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            ShopContent(index: _tab.index),
            ShopProduct(index: _tab.index),
            ShopCategory(index: _tab.index),
          ],
        ),
      ),
    );
  }
}
