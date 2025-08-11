import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/controller/update_app_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/category/category_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../homepage/home/home_loadmore_product.dart';
import '../../homepage/home/home_banner_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/logapp/logapp_service.dart';
import '../../service/pathapi.dart';
import '../flashsale/flashsale_home.dart';
import '../home/home_content_specialList.dart';
import '../home/home_popup.dart';
import '../home/home_hotitem_hoursband.dart';
import '../home/home_new/home_favorite.dart';
import '../home/home_new/home_keyIcon.dart';
import '../home/home_new/home_show_point.dart';
import '../home/home_new/home_special_discount.dart';
import '../login/login_by_phone.dart';
import '../webview/webview_app.dart';
import '../webview/webview_full_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UpdateAppController update = Get.put(UpdateAppController());
  PopUpStatusController popup = Get.put(PopUpStatusController());
  ProductFromBanner bannerProduct = Get.put(ProductFromBanner());
  CartItemsEdit shoppingCart = Get.put(CartItemsEdit());
  ScrollController scrollController = ScrollController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool showbtn = false;
  var loginStatus;
  var Istype;
  String? typeCheck;
  bool showTranfer = false;
  SetData data = SetData();

  getType() async {
    var getSetdata = await data.repType;
    setState(() {
      typeCheck = getSetdata;
    });
  }

  // getPopupTranfer() async {
  //   loginStatus = await data.loginStatus;
  //   Istype = await data.repType;
  //   var tranfer_dist = await call_check_transfer_dist();
  //   // print(' type user page home $Istype');
  //   Get.find<PopUpStatusController>().changeStatusViewPopupTranfer(true);
  //   if (tranfer_dist!.flagTransfer.toLowerCase() == 'y' &&
  //       (loginStatus == "1") &&
  //       Istype == '2' &&
  //       (popup.isViewPopupTranfer.value)) {
  //     Future.delayed(const Duration(milliseconds: 1000), () {
  //       if (!mounted) {
  //         return;
  //       } else {
  //         // setState(() {});
  //         showpopUptranfer(context, tranfer_dist);
  //       }
  //     });
  //   }
  // }

  checkShowPopUp() async {
    DateTime now = DateTime.now();
    String date = '${now.year}-${now.month}-${now.day}';
    final SharedPreferences prefs = await _prefs;
    String showPopupStatus = prefs.getString("ShowPopupStatus") ?? "";
    if (update.statusUpdate != true) {
      if (showPopupStatus != date) {
        if (popup.isViewPopup != true) {
          Future.delayed(const Duration(milliseconds: 2000), () {
            try {
              return showPopUp(context);
            } catch (e) {
              debugPrint('checkShowPopUp Error');
            }
          });
          // .then((value) {
          //   if (value == null || value == false) {
          //     getPopupTranfer();
          //   }
          // });
        }
      }
      // else {
      //   getPopupTranfer();
      // }
    }
  }

  @override
  void initState() {
    getType();
    checkShowPopUp();
    super.initState();
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
        Get.find<ProductHotIutemLoadmoreController>().addItem();
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      try {
        setState(() {});
      } catch (e) {
        debugPrint('setState Error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        var shouldPop = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              actionsPadding:
                  const EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
              contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: const SizedBox(
                width: 250,
                child: Center(
                  child: Text(
                    'คุณต้องการออกจากแอปฯ หรือไม่',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        'ยกเลิก',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        'ออก',
                        style: TextStyle(
                            color: Color(0xFFFD7F6B),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: AnimatedOpacity(
                duration:
                    const Duration(milliseconds: 1000), //show/hide animation
                opacity:
                    showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
                child: IconButton(
                  icon: buttonToTop,
                  onPressed: () {
                    scrollController.animateTo(0, //scroll offset to go
                        duration: const Duration(
                            milliseconds: 1000), //duration of scroll
                        curve: Curves.fastOutSlowIn //scroll type
                        );
                  },
                ),
              ),
            ),
            GetBuilder<DraggableFabController>(builder: (controller) {
              if (controller.draggableFab.isFalse) {
                if (!controller.isDataLoading.value) {
                  if (controller.popUpData!.modernPopup.popupList.isNotEmpty) {
                    return Align(
                      alignment: const Alignment(1.0, 0.7),
                      child: DraggableFab(
                        securityBottom: 160,
                        child: SizedBox(
                          height: 150,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: 25,
                                child: SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                      onPressed: () async {
                                        var mchannel = "19";
                                        var mchannelId = controller.popUpData!
                                            .modernPopup.popupList[0].popupSeq;

                                        //LogApp
                                        InteractionLogger.logPopupSmall(
                                            contentId: controller
                                                .popUpData!
                                                .modernPopup
                                                .popupList[0]
                                                .popupSeq,
                                            contentName: controller
                                                .popUpData!
                                                .modernPopup
                                                .popupList[0]
                                                .popupCode,
                                            contentImage: controller
                                                .popUpData!
                                                .modernPopup
                                                .popupList[0]
                                                .popupImg);
                                        LogAppTisCall(mchannel, mchannelId);
                                        controller.draggableFabUpdate();
                                        if (controller.popUpData!.modernPopup
                                                .popupList[0].popupType
                                                .toLowerCase() ==
                                            "url") {
                                          Get.to(() => WebViewFullScreen(
                                              mparamurl: controller
                                                  .popUpData!
                                                  .modernPopup
                                                  .popupList[0]
                                                  .popupParam));
                                        } else if (controller
                                                .popUpData!
                                                .modernPopup
                                                .popupList[0]
                                                .popupType
                                                .toLowerCase() ==
                                            'coupon_rewards') {
                                          String? urlContent =
                                              "${base_url_web_fridayth}bwpoint/product?billCode=${controller.popUpData!.modernPopup.popupList[0].popupParam}";

                                          Get.to(() => webview_app(
                                              mparamurl: urlContent,
                                              mparamTitleName:
                                                  MultiLanguages.of(context)!
                                                      .translate(
                                                          'point_titleView'),
                                              mparamType: "rewards_detail",
                                              mparamValue: controller
                                                  .popUpData!
                                                  .modernPopup
                                                  .popupList[0]
                                                  .popupParam));
                                        } else if (controller
                                                .popUpData!
                                                .modernPopup
                                                .popupList[0]
                                                .popupType
                                                .toLowerCase() ==
                                            'category') {
                                          bannerProduct.fetch_product_banner(
                                              controller.popUpData!.modernPopup
                                                  .popupList[0].popupParam,
                                              '');
                                          Get.find<
                                                  CategoryProductlistController>()
                                              .fetch_product_category_byperson(
                                                  controller
                                                      .popUpData!
                                                      .modernPopup
                                                      .popupList[0]
                                                      .popupParam,
                                                  "");
                                          Get.toNamed('/my_list_category',
                                              parameters: {
                                                'mChannel': mchannel,
                                                'mChannelId': mchannelId,
                                                'mTypeBack': '',
                                                'mTypeGroup': 'category',
                                                'ref': 'popup_small',
                                                'contentId': controller
                                                    .popUpData!
                                                    .modernPopup
                                                    .popupList[0]
                                                    .popupSeq
                                              });
                                        } else if (controller
                                                .popUpData!
                                                .modernPopup
                                                .popupList[0]
                                                .popupType
                                                .toLowerCase() ==
                                            'sku') {
                                          Get.find<ProductDetailController>()
                                              .productDetailController(
                                            "",
                                            controller.popUpData!.modernPopup
                                                .popupList[0].popupParam,
                                            "",
                                            controller.popUpData!.modernPopup
                                                .popupList[0].popupParam,
                                            mchannel,
                                            mchannelId,
                                          );
                                          Get.to(() => ProductDetailPage(
                                                ref: 'popup_small',
                                                contentId: mchannelId,
                                              ));
                                        } else if (controller
                                                .popUpData!
                                                .modernPopup
                                                .popupList[0]
                                                .popupType
                                                .toLowerCase() ==
                                            'phonelogin') {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginByPhone()));
                                        } else if (controller
                                                .popUpData!
                                                .modernPopup
                                                .popupList[0]
                                                .popupType
                                                .toLowerCase() ==
                                            'sharecatalog') {
                                          Get.toNamed("/sharecatalog");
                                        } else if (controller
                                                .popUpData!
                                                .modernPopup
                                                .popupList[0]
                                                .popupType
                                                .toLowerCase() ==
                                            "coupon_popup") {
                                          SetData userData = SetData();
                                          var repCode = await userData.repCode;
                                          var repSeq = await userData.repSeq;
                                          var repType = await userData.repType;
                                          var tokenApp = await userData.tokenId;
                                          var couponId = controller
                                              .popUpData!
                                              .modernPopup
                                              .popupList[0]
                                              .popupParam;
                                          var url =
                                              "${sp_fridayth}webnew/RecieveCoupon?couponId=$couponId&RepCode=$repCode&RepSeq=$repSeq&RepType=$repType&Token=$tokenApp";
                                          Get.to(() => WebViewFullScreen(
                                              mparamurl: url));
                                        } else {
                                          return;
                                        }
                                      },
                                      icon: CachedNetworkImage(
                                        imageUrl: controller.popUpData!
                                            .modernPopup.popupList[0].popupImg,
                                        fit: BoxFit.contain,
                                        height: 150,
                                        width: 150,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 94.0, bottom: 50),
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    onPressed: () {
                                      controller.draggableFabUpdate();
                                    },
                                    icon: Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0XFF000000),
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.clear_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center();
                  }
                } else {
                  return const Center();
                }
              } else {
                return const Center();
              }
            })
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          child: Column(
            children: [
              const HomeBannerSlider(),
              Container(
                color: theme_color_df,
                child: Column(
                  children: [
                    typeCheck == '0' ? const SizedBox() : const HomeShowPoint(),
                    typeCheck == '2' || typeCheck == '3'
                        ? const HomeKeyIcon()
                        : const SizedBox(),
                  ],
                ),
              ),
              const FlashsaleHome(),
              HomeSpecial(),
              const HomeContentSpecialList(),
              // Column(
              //   children: [
              //     const Padding(
              //       padding: EdgeInsets.only(
              //           left: 10, right: 10, bottom: 10, top: 20),
              //       child: HomeSpecialDiscount(),
              //     ),
              //     Container(
              //       height: 8,
              //       color: const Color.fromARGB(255, 229, 228, 228),
              //     )
              //   ],
              // ),
              // const HomeExpressBanner(),
              HomeFavorite(),
              const Padding(
                padding: EdgeInsets.only(left: 6, right: 6),
                child: HomeProductHotItemHoursBrand(),
                // child: HomeProductHotItem(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: Home_loadmore(width: width),
              ),
              Center(
                  child: Lottie.asset(
                'assets/images/loading.json',
                width: 80,
                height: 80,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
