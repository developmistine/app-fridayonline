import 'package:appfridayecommerce/enduser/components/appbar/appbar.master.dart';
import 'package:appfridayecommerce/enduser/components/webview/webview_full.dart';
import 'package:appfridayecommerce/enduser/controller/brand.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/category.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/enduser.home.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/showproduct.category.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/track.ctr.dart';
import 'package:appfridayecommerce/enduser/models/home/home.short.model.dart';
import 'package:appfridayecommerce/enduser/utils/cached_image.dart';
import 'package:appfridayecommerce/enduser/views/(category)/subcategory.view.dart';
import 'package:appfridayecommerce/enduser/views/(coupon)/coupon.all.dart';
import 'package:appfridayecommerce/enduser/views/(profile)/myorder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ShortCutMenus extends StatelessWidget {
  const ShortCutMenus({super.key});

  @override
  Widget build(BuildContext context) {
    final EndUserHomeCtr endUserHomeCtr = Get.find();

    return Obx(() {
      return !endUserHomeCtr.isLoadingShortMenu.value
          ? Container(
              padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
              child: Container(
                width: Get.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Builder(builder: (context) {
                  List<Widget> productList = List.generate(
                    endUserHomeCtr.homeShortMenu!.data.length > 4
                        ? 4
                        : endUserHomeCtr.homeShortMenu!.data.length,
                    (index) {
                      return Expanded(
                        child: ShortItems(
                            shortMenu:
                                endUserHomeCtr.homeShortMenu!.data[index]),
                      );
                    },
                  );
                  productList.add(
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ShortMenuAll(
                              items: endUserHomeCtr.homeShortMenu!.data));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
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
                                      color:
                                          Colors.grey.shade300.withOpacity(0.5),
                                      offset: const Offset(0, 6),
                                      blurRadius: 4,
                                      // spreadRadius: 1,
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
                                style: GoogleFonts.notoSansThaiLooped(
                                    height: 1.2,
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: productList),
                  );
                }),
              ),
            )
          : Container(
              width: Get.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 14,
                        // childAspectRatio: 1.0,
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
                                    color:
                                        Colors.grey.shade300.withOpacity(0.5),
                                    offset: const Offset(0, 6),
                                    blurRadius: 4,
                                    // spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/b2c/logo/logo_bg.png',
                                width: 40,
                              ),
                            ),
                            // const SizedBox(height: 24),

                            // const ShimmerCard(
                            //     width: 55, height: 8, radius: 2),
                          ],
                        );
                      }),
                ],
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400, width: 0.25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300.withOpacity(0.5),
                  offset: const Offset(0, 6),
                  blurRadius: 4,
                  // spreadRadius: 1,
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
            style: GoogleFonts.notoSansThaiLooped(
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
        textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
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
