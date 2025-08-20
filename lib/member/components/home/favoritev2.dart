import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/webview/webview_full.dart';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/category.ctr.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/models/home/home.short.model.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/member/views/(category)/subcategory.view.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.all.dart';
import 'package:fridayonline/member/views/(profile)/myorder.dart';
import 'package:flutter/material.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ShortCutMenusV2 extends StatefulWidget {
  const ShortCutMenusV2({super.key});

  @override
  State<ShortCutMenusV2> createState() => _ShortCutMenusV2State();
}

class _ShortCutMenusV2State extends State<ShortCutMenusV2> {
  final _scrollCtr = ScrollController();
  double _progress = 0.0; // 0.0 -> 1.0

  @override
  void initState() {
    super.initState();
    _scrollCtr.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollCtr.hasClients) return;
    final max = _scrollCtr.position.maxScrollExtent;
    final off = _scrollCtr.offset;
    final p = (max <= 0) ? 0.0 : (off / max).clamp(0.0, 1.0);
    if (p != _progress) setState(() => _progress = p);
  }

  @override
  void dispose() {
    _scrollCtr.removeListener(_onScroll);
    _scrollCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EndUserHomeCtr endUserHomeCtr = Get.find();

    return Obx(() {
      if (endUserHomeCtr.isLoadingShortMenu.value) {
        return Container(
          width: Get.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 14,
                  mainAxisExtent: 90,
                ),
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    left: 12, top: 6, right: 12, bottom: 2),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.grey.shade400, width: 0.25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300.withOpacity(0.5),
                              offset: const Offset(0, 6),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/b2c/logo/friday_online_loading.png',
                          width: 40,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }

      final rawItems = endUserHomeCtr.homeShortMenu?.data
              .where((item) => item.menuType != 'coupon')
              .toList() ??
          [];

      final items = rawItems.take(6).toList();

      return Container(
        padding: const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 4),
        child: Container(
          width: 562,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: SizedBox(
                  height: 120,
                  child: ListView.separated(
                    controller: _scrollCtr,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemCount: items.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 4),
                    itemBuilder: (context, index) {
                      if (index < items.length) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: ShortItems(shortMenu: items[index]),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ShortMenuAll(
                                  items: endUserHomeCtr.homeShortMenu!.data,
                                ));
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.50, -0.00),
                                    end: Alignment(0.50, 1.00),
                                    colors: [
                                      Color(0xFFF5FAFE),
                                      Color(0xFFDEF0FF)
                                    ],
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x1EA3A3A3),
                                      blurRadius: 24,
                                      offset: Offset(0, 3.57),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/icon/seemore.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              Text(
                                "ดูเพิ่มเติม",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.ibmPlexSansThai(
                                  height: 1.2,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              _ScrollProgressBar(progress: _progress),
            ],
          ),
        ),
      );
    });
  }
}

class ShortItems extends StatelessWidget {
  final Datum shortMenu;
  const ShortItems({
    super.key,
    required this.shortMenu,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        keyTapAction(shortMenu);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.50, -0.00),
                end: Alignment(0.50, 1.00),
                colors: [Color(0xFFF5FAFE), Color(0xFFDEF0FF)],
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1EA3A3A3),
                  blurRadius: 24,
                  offset: Offset(0, 3.57),
                  spreadRadius: 0,
                )
              ],
            ),
            child: CacheFavoriteIcons(
              url: shortMenu.image,
            ),
          ),
          Text(
            shortMenu.displayName.replaceAll(r'\n', '\n'),
            textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.ibmPlexSansThai(
                height: 1.2, fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

Future<void> keyTapAction(Datum shortMenu) async {
  switch (shortMenu.menuType) {
    case "orders":
      {
        Get.find<TrackCtr>().setDataTrack(
            shortMenu.menuId, shortMenu.displayName, "home_favorite");
        orderCtr.fetchOrderList(0, 0);
        orderCtr.fetchNotifyOrderTracking(10627, 0);
        Get.to(() => const MyOrderHistory());
        break;
      }
    case "coupon":
      {
        Get.find<TrackCtr>().setDataTrack(
            shortMenu.menuId, shortMenu.displayName, "home_favorite");
        Get.to(() => const CouponAll());
        break;
      }
    case "category":
      {
        Get.find<TrackCtr>()
            .setLogContentAddToCart(shortMenu.menuId, "home_favorite");
        Get.find<TrackCtr>().setDataTrack(
            shortMenu.menuId, shortMenu.displayName, "home_favorite");
        Get.find<CategoryCtr>()
            .fetchSubCategory(int.parse(shortMenu.menuValue));

        Get.find<ShowProductCategoryCtr>().fetchProductByCategoryIdWithSort(
            int.parse(shortMenu.menuValue), 0, "ctime", "", 40, 0);
        await Get.to(() => const SubCategory())!.then((res) {
          Get.find<TrackCtr>().clearLogContent();
        });

        break;
      }
    case "url":
      {
        Get.find<TrackCtr>().setDataTrack(
            shortMenu.menuId, shortMenu.displayName, "home_favorite");
        Get.to(() => WebViewFullScreen(
              mparamurl: shortMenu.menuValue,
            ));
        break;
      }
    case "mall":
      {
        Get.find<TrackCtr>()
            .setLogContentAddToCart(shortMenu.menuId, 'home_favorite');
        Get.find<TrackCtr>().setDataTrack(
          shortMenu.menuId,
          shortMenu.displayName,
          "home_favorite",
        );
        Get.find<BrandCtr>().fetchShopData(
          shortMenu.menuId,
        );
        await Get.toNamed('/BrandStore/${shortMenu.menuValue}',
                arguments: 0,
                parameters: {
              "sectionId": '0',
              "viewType": '0',
            })!
            .then((res) {
          Get.find<TrackCtr>().clearLogContent();
        });
      }

    default:
      break;
  }
}

class ShortMenuAll extends StatefulWidget {
  const ShortMenuAll({super.key, required this.items});
  final List<Datum> items;

  @override
  State<ShortMenuAll> createState() => _ShortMenuAllState();
}

class _ShortMenuAllState extends State<ShortMenuAll> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: Scaffold(
          appBar: appBarMasterEndUser('เพิ่มเติม'),
          body: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1)),
            child: Container(
              color: Colors.grey.shade100,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8),
                    child: Text(
                      'เพิ่มเติม',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5, mainAxisExtent: 110),
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        return ShortItems(
                          shortMenu: widget.items[index],
                        );
                      },
                    ),
                  )
                ],
              )),
            ),
          )),
    );
  }
}

class _ScrollProgressBar extends StatelessWidget {
  const _ScrollProgressBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    const totalWidth = 54.0;
    const height = 6.0;
    const thumbWidth = 25.0;
    const radiusTrack = 8.0;
    const radiusThumb = 38.0;

    final p = progress.clamp(0.0, 1.0);
    const maxLeft = totalWidth - thumbWidth;
    final left = maxLeft * p;

    return SizedBox(
      width: totalWidth,
      height: height,
      child: Stack(
        children: [
          Container(
            width: totalWidth,
            height: height,
            decoration: ShapeDecoration(
              color: const Color(0xFFECECED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radiusTrack),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            left: left,
            top: 0,
            child: Container(
              width: thumbWidth,
              height: height,
              decoration: ShapeDecoration(
                color: themeColorDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusThumb),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
