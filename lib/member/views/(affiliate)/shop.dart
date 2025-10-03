import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fridayonline/member/components/utils/share.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.category.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.content.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.product.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.product.ctr.dart';
import 'package:fridayonline/member/views/(affiliate)/edit.dart';
import 'package:fridayonline/member/views/(affiliate)/setting/setting.account.dart';
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
    final affAccountCtl = Get.find<AffiliateAccountCtr>();

    return Obx(() {
      final data = affAccountCtl.profileData.value;
      final avatarUrl = data?.account.image ?? '';

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
                  image: NetworkImage(avatarUrl),
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
                  data?.storeName ?? 'ไม่ระบุ',
                  style: GoogleFonts.ibmPlexSansThai(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  "เข้าร่วมเมื่อ ${data?.account.dateJoined ?? '-'} | รายการสินค้า (${data?.itemCountDisplay ?? '0'})",
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
            onPressed: () async {
              Get.to(() => SettingAffAccount());
              await affAccountCtl.getProfile();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('แก้ไข',
                style: GoogleFonts.ibmPlexSansThai(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      );
    });
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

  final affContentCtl = Get.find<AffiliateContentCtr>();
  final affProductCtl = Get.find<AffiliateProductCtr>();
  final affAccountCtl = Get.find<AffiliateAccountCtr>();

  final Set<int> _loadedTabs = <int>{};

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

    void triggerForIndex(int i, {bool force = false}) {
      if (!force && _loadedTabs.contains(i)) return;
      _loadedTabs.add(i);

      switch (i) {
        case 0: // ร้านค้า (content)
          affContentCtl.getAffiliateContent(
            page: 'view',
            target: 'content',
            contentId: 0,
          );
          break;
        case 1:
          affProductCtl.refreshDefaultProducts(page: 'view');
          break;

        case 2: // หมวดหมู่ (category)
          affContentCtl.getAffiliateContent(
            page: 'view',
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
            page: 'view', target: 'content', contentId: 0),
        affContentCtl.getAffiliateContent(
            page: 'view', target: 'category', contentId: 0),
      ]);

      triggerForIndex(_tab.index, force: false);
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
      bottomNavigationBar: AnimatedBuilder(
        animation: _tab.animation!,
        builder: (context, _) {
          final idx = (_tab.animation?.value ?? _tab.index).round();

          final onPressed = _actionFor(idx);
          if (onPressed == null) return const SizedBox.shrink();
          return buildBottomButton(_textFor(idx), onPressed);
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ร้านค้าของฉัน',
                    style: GoogleFonts.ibmPlexSansThai(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  InkWell(
                    onTap: () async {
                      await shareDialog(
                        shareType: 'store',
                        shareTitle: 'แชร์ร้านค้าของฉัน',
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: themeColorDefault,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          SvgPicture.asset(
                            'assets/images/affiliate/share.svg',
                            width: 18,
                            height: 18,
                          ),
                          Text(
                            'แชร์ร้านค้า',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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

                  return Obx(() {
                    final bg = Get.find<AffiliateAccountCtr>()
                            .profileData
                            .value
                            ?.cover ??
                        '';

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                          child: bg.isNotEmpty
                              ? Image.network(bg,
                                  fit: BoxFit.cover, width: double.infinity)
                              : Container(color: const Color(0xFFEEEEEE)),
                        ),
                        Container(color: Colors.black.withValues(alpha: .30)),
                        SafeArea(
                          top: false,
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10, kToolbarHeight + 8, 10, 48 + 8),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Opacity(
                                opacity: t,
                                child: Transform.translate(
                                  offset: Offset(0, 16 * (1 - t)),
                                  child: const _ProfileRow(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
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
