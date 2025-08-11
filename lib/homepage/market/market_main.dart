import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import '../../controller/app_controller.dart';
import '../../controller/badger/badger_controller.dart';
import '../../controller/market/market_controller.dart';
import '../../controller/market/market_loadmore_controller.dart';
import '../../model/set_data/set_data.dart';
import '../../service/pathapi.dart';
import '../home/cache_image.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../theme/themeimage_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import '../../../service/languages/multi_languages.dart';
import '../webview/webview_full_screen.dart';
import 'market_profile.dart';

class MarketMainPage extends StatefulWidget {
  const MarketMainPage({Key? key}) : super(key: key);

  @override
  State<MarketMainPage> createState() => _MarketMainPageState();
}

class _MarketMainPageState extends State<MarketMainPage> {
  BadgerController badger = Get.put(BadgerController());
  Widget _body = const MarketBanner();
  int _selectedIndex = 0;
  SetData data = SetData();
  var type;

  @override
  void initState() {
    super.initState();
    changeViwe(0);
  }

  changeViwe(value) async {
    type = Get.parameters['type'];
    var mdevice = await data.device;
    var mCustId = await data.customerId;

    switch (value) {
      case 0:
        {
          Get.find<MarketLoadmoreController>().resetItem();
          _body = const MarketBanner();
          break;
        }
      case 1:
        {
          if (mCustId.toString() != "") {
            var paramUrl =
                "${baseurl_web_view}main-cart?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1";
            Get.to(() => WebViewFullScreen(
                mparamurl: Uri.encodeFull(paramUrl.toString())));
          } else {
            Get.toNamed("/market_login", parameters: {'mdevice': mdevice});
          }

          break;
        }
      case 2:
        {
          if (mCustId.toString() != "") {
            _body = const MarketProfile();
          } else {
            Get.toNamed("/market_login", parameters: {'mdevice': mdevice});
          }

          break;
        }
    }
    setState(() {
      _selectedIndex = value;
      _body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: WillPopScope(
        onWillPop: () async {
          if (type == 'profile') {
            Navigator.of(context).pop();
          } else if (type == 'home') {
            Navigator.of(context).pop();
          } else {
            Get.find<AppController>().setCurrentNavInget(0);
            Get.toNamed('/index');
          }
          return false;
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(50.0), // here the desired height
              child: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_outlined),
                  color: Colors.white,
                  onPressed: () {
                    if (type == 'profile') {
                      Navigator.of(context).pop();
                    } else if (type == 'home') {
                      Navigator.of(context).pop();
                    } else {
                      Get.find<AppController>().setCurrentNavInget(0);
                      Get.toNamed('/index');
                    }
                  },
                ),
                centerTitle: true,
                backgroundColor: theme_color_df,
                title: Text(
                  MultiLanguages.of(context)!.translate('yupin_market'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'notoreg',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          body: _body,
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: const TextStyle(fontFamily: 'notobold'),
            unselectedLabelStyle: const TextStyle(fontFamily: 'notoreg'),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex, //New
            onTap: (value) async {
              changeViwe(value);
            },
            items: [
              BottomNavigationBarItem(
                  activeIcon: ImageActive,
                  icon: ImageHome,
                  label: MultiLanguages.of(context)!.translate('menu_home')),
              BottomNavigationBarItem(
                  icon: Obx(() {
                    if (!badger.isDataLoading.value) {
                      if (badger.badgerMarket!.badger != "0") {
                        return Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              cartmarket,
                              Positioned(
                                // draw a red marble
                                top: -10,
                                right: -8,
                                child: badges.Badge(
                                    badgeStyle: badges.BadgeStyle(
                                      badgeColor: Colors.red,
                                    ),
                                    badgeContent: Text(
                                        badger.badgerMarket!.badger,
                                        style: const TextStyle(
                                            inherit: false,
                                            color: Colors.white,
                                            fontSize: 10))),
                              )
                            ]);
                      } else {
                        return cartmarket;
                      }
                    } else {
                      return cartmarket;
                    }
                  }),
                  label: "ตะกร้า"),
              BottomNavigationBarItem(
                  activeIcon: ProfileActive,
                  icon: Profiles,
                  label: MultiLanguages.of(context)!.translate('menu_me')),
            ],
          ),
        ),
      ),
    );
  }
}

class MarketBanner extends StatefulWidget {
  const MarketBanner({Key? key}) : super(key: key);

  @override
  State<MarketBanner> createState() => _MarketBannerSliderState();
}

class _MarketBannerSliderState extends State<MarketBanner> {
  SetData data = SetData();
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  int test = 0;
  @override
  void initState() {
    super.initState();
    if (Get.find<MarketController>().statusReload == false) {
      Get.find<MarketController>().get_market_data();
    }

    scrollController.addListener(() {
      if (scrollController.offset >= 1500 && showbtn != true) {
        setState(() {
          showbtn = true;
        });
      }
      if (scrollController.offset < 0.1 && showbtn != false) {
        setState(() {
          showbtn = false;
        });
      }
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        Get.find<MarketLoadmoreController>().addItem();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000), //show/hide animation
        opacity: showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
        child: IconButton(
          icon: buttonToTop,
          onPressed: () {
            scrollController.animateTo(
                //go to top of scroll
                0, //scroll offset to go
                duration:
                    const Duration(milliseconds: 1000), //duration of scroll
                curve: Curves.fastOutSlowIn //scroll type
                );
          },
        ),
      ),
      body: GetX<MarketController>(
        builder: ((marketData) {
          if (!marketData.isDataLoading.value) {
            return ListView(
              controller: scrollController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () async {
                      var mdevice = await data.device;
                      var mCustId = await data.customerId;
                      var mCustType = await data.userTypeMarket;
                      // print(mdevice);

                      var paramUrl =
                          "${baseurl_web_view}searching?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=$mCustType&typeapp=$mdevice&version=1";
                      Get.to(() => WebViewFullScreen(
                          mparamurl: Uri.encodeFull(paramUrl.toString())));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(6)),
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: theme_color_df,
                            ),
                            Text(
                              MultiLanguages.of(context)!
                                  .translate('home_search'),
                              style: TextStyle(color: theme_color_df),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Card(
                                  borderOnForeground: true,
                                  color: const Color(0xff86cbf3),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () async {
                                        var mdevice = await data.device;
                                        var mCustId = await data.customerId;
                                        var mCustType =
                                            await data.userTypeMarket;

                                        var mFavoiteID = marketData
                                            .banner!
                                            .content[0]
                                            .categorySuggest[index]
                                            .categoryId;
                                        var mFavoiteName = marketData
                                            .banner!
                                            .content[0]
                                            .categorySuggest[index]
                                            .categoryName;
                                        var mpurl =
                                            "app=1&FavoiteID=$mFavoiteID&FavoiteName=$mFavoiteName&ContentType=Category&TagID=&TagCode=&CustId=$mCustId&CustType=$mCustType&typeapp=$mdevice&version=1";
                                        var paramUrl =
                                            "${baseurl_web_view}flash-category?$mpurl";
                                        Get.to(() => WebViewFullScreen(
                                            mparamurl: Uri.encodeFull(
                                                paramUrl.toString())));
                                      },
                                      child: Text(
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                          marketData
                                              .banner!
                                              .content[0]
                                              .categorySuggest[index]
                                              .categoryName),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      },
                      itemCount:
                          marketData.banner!.content[0].categorySuggest.length,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 0.9,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                  width: width,
                  child: CarouselSlider.builder(
                    //autoSliderDelay: const Duration(milliseconds: 500),
                    autoSliderTransitionTime: const Duration(milliseconds: 500),
                    unlimitedMode: true,
                    slideBuilder: (index) {
                      return InkWell(
                        onTap: () {
                          var mbannerType = marketData.banner!.content[0]
                              .banner[index].bannerActionType;
                          var mBannerValues = marketData
                              .banner!.content[0].banner[index].bannerValues;
                          var mBannerID = marketData
                              .banner!.content[0].banner[index].bannerId;
                          // var mBannerName = marketData
                          //     .banner!.content[0].banner[index].bannerName;
                          if (mbannerType == "sku" || mbannerType == "SKU") {
                            if (mBannerValues != "") {
                              // var mContentValues = "BillCode=$mBannerValues";
                              // var mContentUrl = "$baseurl_web_view/sku-product";
                            }
                          } else if (mbannerType == "Category" ||
                              mbannerType == "CATEGORY") {
                            if (mBannerID != "") {
                              // var mContentValues =
                              //     "FavoiteID=$mBannerValues&FavoiteName=$mBannerName&ContentType=Category";
                              // var mContentUrl =
                              //     "$baseurl_web_view/flash-category";
                            }
                          } else if (mbannerType == "url" ||
                              mbannerType == "URL") {
                            if (mBannerValues != "") {
                              Get.to(() =>
                                  WebViewFullScreen(mparamurl: mBannerValues));
                            }
                          } else if (mbannerType == "img" ||
                              mbannerType == "IMG") {}
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            imageUrl: marketData
                                .banner!.content[0].banner[index].bannerImg,
                            fit: BoxFit.fill,
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                          ),
                        ),
                      );
                    },
                    slideTransform: const DefaultTransform(),
                    slideIndicator: CircularSlideIndicator(
                        indicatorRadius: 3,
                        itemSpacing: 10,
                        padding: const EdgeInsets.only(bottom: 10),
                        currentIndicatorColor: theme_color_df,
                        indicatorBackgroundColor: Colors.grey),
                    itemCount: marketData.banner!.content[0].banner.length,
                    initialPage: 0,
                    enableAutoSlider: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 20,
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'สินค้าแนะนำประจำวัน',
                      style: TextStyle(
                          fontFamily: 'notoreg',
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MasonryGridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 12,
                    itemCount:
                        marketData.banner!.content[0].productRecommend.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          print(marketData.banner!.content[0]
                              .productRecommend[index].urlImg);
                          var mdevice = await data.device;
                          var mbillcode = marketData.banner!.content[0]
                              .productRecommend[index].billCode;
                          var mCustId = await data.customerId;
                          var mCustType = await data.userTypeMarket;

                          var paramUrl =
                              "${baseurl_web_view}sku-product?app=1&BillCode=$mbillcode&TagID=&TagCode=&CustId=$mCustId&CustType=$mCustType&typeapp=$mdevice&version=1";
                          Get.to(() => WebViewFullScreen(
                              mparamurl: Uri.encodeFull(paramUrl.toString())));
                        },
                        child: Container(
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              children: [
                                marketData.banner!.content[0]
                                            .productRecommend[index].urlImg ==
                                        "https://s3.catalog-yupin.com/"
                                    ? Image.asset(imageError)
                                    : CacheImageMarket(
                                        url: marketData.banner!.content[0]
                                            .productRecommend[index].urlImg),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    Expanded(
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        marketData
                                            .banner!
                                            .content[0]
                                            .productRecommend[index]
                                            .billNameThai,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1),
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        "฿${marketData.banner!.content[0].productRecommend[index].specialprice}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: theme_color_df,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        "฿${marketData.banner!.content[0].productRecommend[index].reqularprice}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black26,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ),
                                  ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                  ),
                ),
                Obx(() {
                  Get.find<MarketLoadmoreController>().itemList.length;
                  if (Get.find<MarketLoadmoreController>().itemProduct > 0) {
                    return MasonryGridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 12,
                      itemCount:
                          Get.find<MarketLoadmoreController>().itemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            var mdevice = await data.device;
                            var mbillcode = Get.find<MarketLoadmoreController>()
                                .itemList[index]
                                .billCode;
                            var mCustId = await data.customerId;
                            var mCustType = await data.userTypeMarket;

                            var paramUrl =
                                "${baseurl_web_view}sku-product?app=1&BillCode=$mbillcode&TagID=&TagCode=&CustId=$mCustId&CustType=$mCustType&typeapp=$mdevice&version=1";
                            Get.to(() => WebViewFullScreen(
                                mparamurl:
                                    Uri.encodeFull(paramUrl.toString())));
                          },
                          child: Container(
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                children: [
                                  Get.find<MarketLoadmoreController>()
                                              .itemList[index]
                                              .urlImg ==
                                          "https://s3.catalog-yupin.com/"
                                      ? Image.asset(imageError)
                                      : CacheImageMarket(
                                          url: Get.find<
                                                  MarketLoadmoreController>()
                                              .itemList[index]
                                              .urlImg),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(children: [
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          Get.find<MarketLoadmoreController>()
                                              .itemList[index]
                                              .billNameThai,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 1),
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          "฿${Get.find<MarketLoadmoreController>().itemList[index].specialprice}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: theme_color_df,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          "฿${Get.find<MarketLoadmoreController>().itemList[index].reqularprice}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black26,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                    );
                  }
                  return Container();
                }),
                Center(
                    child: Lottie.asset(
                  'assets/images/loading.json',
                  width: 80,
                  height: 80,
                )),
              ],
            );
          }
          return Center(
            heightFactor: 15,
            child: theme_loading_df,
          );
        }),
      ),
    );
  }
}
