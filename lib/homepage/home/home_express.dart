import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
// import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
// import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/dropship_shop/dropship_shop_controller.dart';
import '../../controller/cart/function_add_to_cart.dart';
// import '../../service/dropship_shop/dropship_shop_service.dart';
import '../../service/languages/multi_languages.dart';
import '../dropship_shop/search_dropship.dart';
import '../login/anonymous_login.dart';
import '../dropship_shop/dropship_showproduct.dart';
// import '../page_showproduct/product_detail.dart';
import '../theme/themeimage_menu.dart';

final List<Color> listColor = [
  const Color.fromRGBO(32, 190, 121, 1),
  const Color.fromRGBO(253, 127, 107, 1),
  const Color.fromARGB(255, 243, 219, 7)
];
final List<String> listText = [
  'ส่งด่วน 3 วัน',
  'เก็บเงินปลายทาง',
  'มีประกันรายได้'
];

final List<Widget> imageSliders = listColor
    .asMap()
    .entries
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Container(
                decoration: BoxDecoration(color: item.value),
                child: Center(
                    child: Text(
                  listText[item.key],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
              )),
        ))
    .toList();
const border = OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.transparent,
    width: 0,
  ),
  borderRadius: BorderRadius.all(
    Radius.circular(8.0),
  ),
);

// CarouselController _controller = CarouselController();

class HomeExpress extends StatefulWidget {
  const HomeExpress({super.key});

  @override
  State<HomeExpress> createState() => _HomeExpressState();
}

class _HomeExpressState extends State<HomeExpress>
    with TickerProviderStateMixin {
  // int? _current;
  int _selectedTabbar = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: appBarTitleCart('Friday ส่งด่วน', ""),
        body: GetBuilder<FetchDropshipShop>(builder: (shopDropship) {
          //? เช็ค loading
          if (!shopDropship.isDataLoading.value &&
              !shopDropship.isDropshipLoading.value) {
            //? เช็คสินค้าว่ามีหรือไม่
            if (shopDropship.productDropship!.isNotEmpty) {
              _tabController = TabController(
                  length: shopDropship.productDropship!.length,
                  vsync: this,
                  initialIndex: _selectedTabbar);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    //? banner
                    SizedBox(
                      height: width >= 768
                          ? MediaQuery.of(context).size.height / 3
                          : 135,
                      child: InkWell(
                          // onTap: () {
                          //   Get.to(() => const ProductDetailPage());
                          // },
                          child: CarouselSlider.builder(
                        autoSliderTransitionTime:
                            const Duration(milliseconds: 500),
                        unlimitedMode: true,
                        itemCount: shopDropship.bannerDropship!.length,
                        slideBuilder: (index) {
                          return CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl:
                                shopDropship.bannerDropship![index].contentImg,
                          );
                        },
                        slideTransform: const DefaultTransform(),
                        slideIndicator: CircularSlideIndicator(
                            indicatorRadius: 3,
                            itemSpacing: 10,
                            padding: const EdgeInsets.only(bottom: 10),
                            currentIndicatorColor: theme_color_df,
                            indicatorBackgroundColor: Colors.grey),
                        initialPage: 0,
                        enableAutoSlider: true,
                      )),
                    ),

                    //? ช่องค้นหาสินค้า
                    Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          onTap: () async {
                            await showSearch(
                                context: context,
                                delegate: DropsShipSearch(context));
                          },
                          readOnly: true, // will disable paste operation
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(2),
                            focusedBorder: border,
                            enabledBorder: border,
                            hintText: MultiLanguages.of(context)!
                                .translate('home_search'),
                            hintStyle: TextStyle(
                                fontSize: 13,
                                color: theme_color_df,
                                fontFamily: 'notoreg'),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(6),
                              child: ImageSearchbox,
                            ),
                            filled: true,
                            fillColor: const Color.fromRGBO(238, 238, 238, 1),
                          ),
                        ),
                      ),
                    ),

                    //? แถบรายการสินค้า
                    // tabControll(context),
                    Container(
                        color: Colors.transparent,
                        constraints: const BoxConstraints(maxHeight: 150.0),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: theme_color_df,
                            indicatorColor: theme_color_df,
                            unselectedLabelColor: Colors.black,
                            onTap: (index) {
                              setState(() {
                                _selectedTabbar = index;
                              });
                            },
                            tabs: [
                              ...shopDropship.productDropship!
                                  .map((e) => Tab(text: e.cate1Desc))
                            ],
                          ),
                        )),

                    //? รายการสินค้า
                    Builder(builder: (_) {
                      bool show = true;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: MasonryGridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            gridDelegate:
                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: (width >= 768.0) ? 3 : 2,
                            ),
                            itemCount: shopDropship
                                .productDropship![_selectedTabbar]
                                .product
                                .length,
                            itemBuilder: (context, index) {
                              (shopDropship.productDropship![_selectedTabbar]
                                          .product[index].imageUrl !=
                                      '')
                                  ? show = true
                                  : show = false;
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                    textScaler: const TextScaler.linear(1.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      shopDropship.fetchProductDetailDropship(
                                          shopDropship
                                              .productDropship![_selectedTabbar]
                                              .product[index]
                                              .productCode);
                                      Get.to(() => DropShipProduct());
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(14, 0, 0, 0),
                                            offset: Offset(0.0, 4.0),
                                            blurRadius: 0.2,
                                            spreadRadius: 0.2,
                                          ), //BoxShadow
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(children: [
                                        // if (show)
                                        Stack(
                                          children: <Widget>[
                                            if (show)
                                              Center(
                                                child: CachedNetworkImage(
                                                  imageUrl: shopDropship
                                                      .productDropship![
                                                          _selectedTabbar]
                                                      .product[index]
                                                      .imageUrl,
                                                  height: 150,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            if (!show)
                                              Center(
                                                  child: Image.asset(
                                                imageError,
                                                height: 150,
                                              )),
                                          ],
                                        ),
                                        // if (show)
                                        //? express
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 4,
                                              left: 14,
                                              right: 14),
                                          child: Row(children: [
                                            Expanded(
                                                child: Stack(
                                              children: [
                                                DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: theme_red),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0,
                                                            top: 4,
                                                            bottom: 2,
                                                            right: 4),
                                                    child: Text(
                                                      shopDropship
                                                          .productDropship![
                                                              _selectedTabbar]
                                                          .product[index]
                                                          .deliveryType,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    '                     ${shopDropship.productDropship![_selectedTabbar].product[index].nameTh}',
                                                    style: const TextStyle(
                                                        height: 1.7,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14)),
                                              ],
                                            )),
                                          ]),
                                        ),
                                        //? รหัสสินค้า ราคา ปุ่มหยิบใส่ตระกร้า
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 14),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //? รหัสสินค้า
                                                    Text(
                                                      "${MultiLanguages.of(context)!.translate('product_code')} ${shopDropship.productDropship![_selectedTabbar].product[index].billYup}",
                                                      style: TextStyle(
                                                        fontFamily: 'notoreg',
                                                        fontSize: 12,
                                                        color: theme_grey_text,
                                                      ),
                                                    ),
                                                    //? ราคา
                                                    Text(
                                                      "${MultiLanguages.of(context)!.translate('order_price_txt')} ${myFormat.format(double.parse(shopDropship.productDropship![_selectedTabbar].product[index].priceRegular))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'notoreg',
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //? ปุ่มหยิบใส่ตระกร้า
                                              Expanded(
                                                child: BouncingWidget(
                                                    duration: const Duration(
                                                        milliseconds: 100),
                                                    scaleFactor: 1.5,
                                                    onPressed: () async {
                                                      final Future<
                                                              SharedPreferences>
                                                          prefs0 =
                                                          SharedPreferences
                                                              .getInstance();

                                                      final SharedPreferences
                                                          prefs = await prefs0;
                                                      late String? lslogin;
                                                      lslogin = prefs
                                                          .getString("login");
                                                      var mChannel = '6';
                                                      var mChannelId = '';

                                                      if (lslogin == null) {
                                                        Get.to(() =>
                                                            const Anonumouslogin());
                                                      } else {
                                                        await fnEditCartDropship(
                                                            context,
                                                            shopDropship
                                                                .productDropship![
                                                                    _selectedTabbar]
                                                                .product[index],
                                                            'Dropship',
                                                            mChannel,
                                                            mChannelId);
                                                      }
                                                    },
                                                    child: ImageBasget),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }),
                  ],
                ),
              );
            } else {
              //? กรณีไม่มีสินค้า
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/logo/logofriday.png',
                          width: 70),
                    ),
                    const Text('ไม่พบสินค้า'),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: theme_loading_df,
            );
          }
        }),
      ),
    );
  }
}
