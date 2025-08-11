import 'package:fridayonline/enduser/components/home/loadmore.enduser.dart';
import 'package:fridayonline/enduser/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/enduser/components/shimmer/shimmer.product.dart';
import 'package:fridayonline/enduser/controller/brand.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/utils/cached_image.dart';
import 'package:fridayonline/enduser/utils/event.dart';
import 'package:fridayonline/enduser/views/(brand)/allbrand.dart';
// import 'package:fridayonline/enduser/views/(brand)/brand.store.dart';
import 'package:fridayonline/enduser/widgets/arrow_totop.dart';
import 'package:fridayonline/enduser/widgets/gap.dart';
import 'package:fridayonline/enduser/widgets/seeall.button.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandB2C extends StatefulWidget {
  const BrandB2C({super.key});

  @override
  State<BrandB2C> createState() => _BrandCategoryState();
}

class _BrandCategoryState extends State<BrandB2C>
    with TickerProviderStateMixin {
  bool isShowMore = false;
  final ShowProductCategoryCtr showProductCtr = Get.find();
  final EndUserHomeCtr homeCtr = Get.find();
  final BrandCtr brandCtr = Get.find<BrandCtr>();
  final ScrollController _scrollController = ScrollController();
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  bool isShowArrow = false;
  int offset = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMoreRecommend();
      }

      bool shouldSetArrow = _scrollController.offset > 205;

      if (shouldSetArrow != isShowArrow) {
        setState(() {
          isShowArrow = shouldSetArrow;
        });
      }
    });
  }

  void fetchMoreRecommend() async {
    homeCtr.isFetchingLoadmore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newRecommend = await homeCtr.fetchMoreRecommend(offset);

      if (newRecommend!.data.isNotEmpty) {
        homeCtr.recommend!.data.addAll(newRecommend.data);
        offset += 20;
      }
    } finally {
      homeCtr.isFetchingLoadmore.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    offset = 20;
    _scrollController.dispose();
    homeCtr.resetRecommend();
    showProductCtr.resetProductCategory();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.notoSansThaiLooped())),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.notoSansThaiLooped())),
          textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryTextTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.grey.shade100,
              body: Obx(() {
                return !showProductCtr.isLoadingProductCategory.value &&
                        !brandCtr.isLoadingShopBanner.value
                    ? SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (brandCtr.shopBanner!.data.isNotEmpty ||
                                brandCtr.shopBanner!.code != '-9')
                              Stack(
                                children: [
                                  CarouselSlider.builder(
                                    carouselController: _controller,
                                    itemCount: brandCtr.shopBanner!.data.length,
                                    itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) {
                                      var items =
                                          brandCtr.shopBanner!.data[itemIndex];
                                      return SizedBox(
                                        width: Get.width,
                                        child: InkWell(
                                          onTap: () {
                                            eventBanner(items, 'mall_banner');
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: items.image,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                        aspectRatio: 3.4,
                                        viewportFraction: 1,
                                        autoPlay: true,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                  ),
                                  Positioned(
                                    bottom: -6,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                          brandCtr.shopBanner!.data.length,
                                          (index) {
                                        return GestureDetector(
                                          onTap: () =>
                                              _controller.animateToPage(index),
                                          child: Container(
                                            width: 8.0,
                                            height: 8.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 2.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: (_current == index
                                                        ? Colors.white
                                                        : Colors.grey.shade400)
                                                    .withOpacity(
                                                        _current == index
                                                            ? 0.9
                                                            : 0.5)),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Color(0xFF0588CD),
                                Color(0xFF4FBBF3),
                                // Colors.blue.shade600,
                                // theme_color_df,
                              ])),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "FRIDAY MALL",
                                    style: GoogleFonts.notoSansThaiLooped(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 2.0, right: 2),
                                            child: Icon(
                                              Icons.verified_outlined,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                          Text(
                                            'สินค้าแบรนด์แท้ 100%',
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 11),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, right: 2),
                                            child: Image.asset(
                                              'assets/images/b2c/icon/coupon.png',
                                              width: 14,
                                            ),
                                          ),
                                          Text(
                                            'โปรโมชั่นสุดพิเศษ',
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.grey.shade100,
                                        Colors.grey.shade50,
                                      ]),
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/b2c/background/bg-blue.png'))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 0, top: 4),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('แบรนด์ดังสำหรับคุณ',
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              brandCtr.fetchBrads("all", 0);
                                              Get.to(() => const AllBrandB2C());
                                            },
                                            child: buttonSeeAll(),
                                          )
                                        ]),
                                  ),
                                  SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      scrollDirection: Axis.horizontal,
                                      physics: const ClampingScrollPhysics(),
                                      child: Row(
                                        children: List.generate(
                                            brandCtr.brandsList!.data.length,
                                            (index) {
                                          var items =
                                              brandCtr.brandsList!.data[index];
                                          return InkWell(
                                            onTap: () async {
                                              Get.find<TrackCtr>()
                                                  .setLogContentAddToCart(
                                                      items.brandId,
                                                      'mall_brands');
                                              Get.find<TrackCtr>().setDataTrack(
                                                items.brandId,
                                                items.brandName,
                                                "mall_brands",
                                              );
                                              brandCtr.fetchShopData(
                                                  items.sellerId);

                                              await Get.toNamed(
                                                      '/BrandStore/${items.sellerId}',
                                                      arguments:
                                                          items.sectionId == 0
                                                              ? 0
                                                              : 1,
                                                      parameters: {
                                                    "sectionId": items.sectionId
                                                        .toString(),
                                                    "viewType":
                                                        items.sectionId == 0
                                                            ? '0'
                                                            : "1",
                                                  })!
                                                  .then((res) {
                                                Get.find<TrackCtr>()
                                                    .clearLogContent();
                                              });
                                            },
                                            child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.white,
                                                ),
                                                width: Get.width >= 768
                                                    ? 180
                                                    : 145,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 2,
                                                              bottom: 38.0,
                                                              left: 18,
                                                              right: 18),
                                                      child: CachedNetworkImage(
                                                        height: Get.width >= 768
                                                            ? 140
                                                            : 120,
                                                        // fit: BoxFit.contain,
                                                        imageUrl:
                                                            items.productImage,
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return Icon(
                                                              Icons.image,
                                                              color: Colors.grey
                                                                  .shade800,
                                                              size: 32);
                                                        },
                                                      ),
                                                    ),
                                                    Positioned(
                                                        bottom: 4,
                                                        child: BrandItem(
                                                            url: items.icon,
                                                            shopId:
                                                                items.sellerId,
                                                            radius: 30,
                                                            isLoading: false)),
                                                  ],
                                                )),
                                          );
                                        }),
                                      )),
                                ],
                              ),
                            ),
                            const LoadmoreEndUser(),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ShimmerCard(
                                    width: Get.width,
                                    height: Get.width >= 768
                                        ? Get.height / 2
                                        : Get.height / 5.2,
                                    radius: 0),
                                Icon(
                                  Icons.image,
                                  size: 40,
                                  color: icon_color_loading,
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 8,
                              ),
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Color(0xFF0588CD),
                                Color(0xFF4FBBF3),
                                // Colors.blue.shade600,
                                // theme_color_df,
                              ])),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "FRIDAY MALL",
                                    style: GoogleFonts.notoSansThaiLooped(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 2.0, right: 2),
                                            child: Icon(
                                              Icons.verified_outlined,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                          Text(
                                            'สินค้าแบรนด์แท้ 100%',
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 11),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, right: 2),
                                            child: Image.asset(
                                              'assets/images/b2c/icon/coupon.png',
                                              width: 14,
                                            ),
                                          ),
                                          Text(
                                            'โปรโมชั่นสุดพิเศษ',
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: theme_color_df,
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(173, 226, 255, 1),
                                    Color.fromRGBO(255, 255, 255, 1),
                                  ],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('แบรนด์ดังสำหรับคุณ',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: buttonSeeAll(),
                                          )
                                        ]),
                                  ),
                                  SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      scrollDirection: Axis.horizontal,
                                      physics: const ClampingScrollPhysics(),
                                      child: Row(
                                        children: List.generate(
                                            5,
                                            (index) => Container(
                                                clipBehavior: Clip.antiAlias,
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.white,
                                                ),
                                                width: 160,
                                                child: const Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    SizedBox(
                                                      height: 150,
                                                    ),
                                                    Positioned(
                                                        bottom: 4,
                                                        child: BrandItem(
                                                            url: "",
                                                            shopId: 0,
                                                            radius: 30,
                                                            isLoading: true)),
                                                  ],
                                                ))),
                                      )),
                                ],
                              ),
                            ),
                            const Gap(height: 10),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, bottom: 2, top: 8),
                              child: Text(
                                'สินค้าแนะนำสำหรับคุณ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            MasonryGridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                shrinkWrap: true,
                                primary: false,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
                                ),
                                itemCount: 6,
                                itemBuilder: (BuildContext context, int index) {
                                  return const ShimmerProductItem();
                                }),
                          ],
                        ),
                      );
              }),
              floatingActionButton: arrowToTop(
                  scrCtrl: _scrollController, isShowArrow: isShowArrow),
            ),
          ],
        ),
      ),
    );
  }
}

class BrandItem extends StatelessWidget {
  const BrandItem(
      {super.key,
      required this.url,
      required this.shopId,
      required this.radius,
      required this.isLoading});
  final String url;
  final int shopId;
  final double radius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(3),
        clipBehavior: Clip.antiAlias,
        width: Get.width >= 768 ? 170 : 140,
        height: Get.width >= 768 ? 65 : 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Center(
            child: isLoading
                ? const Icon(Icons.shopify)
                : CacheImageLogoShop(
                    url: url,
                  )));
  }
}
