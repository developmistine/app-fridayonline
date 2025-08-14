import 'package:fridayonline/controller/update_app_controller.dart';
import 'package:fridayonline/member/components/appbar/appbar.enduser.dart';
import 'package:fridayonline/member/components/home/banner.enduser.dart';
import 'package:fridayonline/member/components/home/checkin.dart';
import 'package:fridayonline/member/components/home/coupon.newuser.dart';
import 'package:fridayonline/member/components/home/fridaymall.dart';
import 'package:fridayonline/member/components/home/newproduct.dart';
import 'package:fridayonline/member/components/home/supperdeal.dart';
import 'package:fridayonline/member/components/home/topsales.dart';
import 'package:fridayonline/member/components/home/category.dart';
import 'package:fridayonline/member/components/home/coupon.enduser.dart';
import 'package:fridayonline/member/components/home/flashdeal.dart';
import 'package:fridayonline/member/components/home/loadmore.enduser.dart';
import 'package:fridayonline/member/components/home/popup.enduser.dart';
import 'package:fridayonline/member/components/home/favorite.dart';
import 'package:fridayonline/member/utils/event.dart';
import 'package:fridayonline/member/widgets/arrow_totop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/enduser.home.ctr.dart';

class EndUserHomePage extends StatefulWidget {
  const EndUserHomePage({super.key});

  @override
  State<EndUserHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<EndUserHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  EndUserHomeCtr homeCtr = Get.find();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UpdateAppController update = Get.put(UpdateAppController());
  final scrCtrl = ScrollController();
  bool isSetAppbar = false;

  Offset? buttonPosition;
  int offset = 20;

  @override
  void initState() {
    super.initState();
    checkShowPopUp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      setState(() {
        buttonPosition =
            Offset(screenSize.width - 100, screenSize.height - 300);
      });
    });

    scrCtrl.addListener(() {
      if (scrCtrl.position.pixels == scrCtrl.position.maxScrollExtent &&
          !homeCtr.isFetchingLoadmore.value) {
        fetchMoreRecommend();
      }
      // กำหนดเงื่อนไขเมื่อ scroll เลื่อนลงหรือขึ้น
      bool shouldSetAppbar = scrCtrl.offset > 205;

      if (shouldSetAppbar != isSetAppbar) {
        setState(() {
          isSetAppbar = shouldSetAppbar;
        });
      }
    });
  }

  checkShowPopUp() async {
    final prefs = await _prefs;
    final now = DateTime.now();
    final date = '${now.year}-${now.month}-${now.day}';
    final showPopupStatus = prefs.getString("ClosePopupDay") ?? "";

    if (update.statusUpdate != true) {
      if (showPopupStatus != date) {
        if (homeCtr.isViewPopup.value != true) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (!mounted) return;
            showPopupEndUser(context);
          });
        }
      }
    }
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
    offset = 20;
    scrCtrl.dispose();
    homeCtr.resetRecommend();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrCtrl,
              physics: const ClampingScrollPhysics(),
              // physics:
              //     const ClampingScrollPhysics(parent: BouncingScrollPhysics()),
              padding: EdgeInsets.zero,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BannerEndUser(),
                  ShortCutMenus(),
                  SupperDeal(),
                  CouponNewUser(),
                  CouponEndUser(),
                  Coin(),
                  CategoryB2C(),
                  NewCollection(),
                  FlashDealFriday(),
                  FridayMall(),
                  BestSellingProducts(),
                  LoadmoreEndUser(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: appbarEnduser(ctx: context, isSetAppbar: isSetAppbar),
            ),
            if (buttonPosition != null)
              // Draggable Floating Button
              Positioned(
                left: buttonPosition!.dx,
                top: buttonPosition!.dy,
                child: Draggable(
                  feedback: _buildPopupSmall(),
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    setState(() {
                      // Update the position of the button
                      buttonPosition = details.offset;
                    });
                  },
                  child: _buildPopupSmall(),
                ),
              ),
          ],
        ),
        floatingActionButton:
            arrowToTop(scrCtrl: scrCtrl, isShowArrow: isSetAppbar),
      ),
    );
  }

  Widget _buildPopupSmall() {
    return Material(
      color: Colors.transparent,
      child: Obx(() {
        if (homeCtr.isLoadingPopup.value || homeCtr.popupSmall!.code == "-9") {
          return const SizedBox();
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CarouselSlider.builder(
                itemCount: homeCtr.popupSmall!.data.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      var bannerItem = homeCtr.popupSmall!.data[itemIndex];
                      eventBanner(bannerItem, 'home_popup_small');
                    },
                    child: CachedNetworkImage(
                      imageUrl: homeCtr.popupSmall!.data[itemIndex].image,
                    ),
                  );
                },
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  aspectRatio: 1,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                ),
              ),
            ),
            // close icon
            Positioned(
              right: -10,
              top: -10,
              child: InkWell(
                splashColor: const Color.fromARGB(0, 18, 15, 15),
                highlightColor: Colors.transparent,
                child: const Icon(
                  Icons.cancel,
                  color: Colors.black,
                ),
                onTap: () {
                  // Close the draggable button
                  setState(() {
                    buttonPosition = null;
                  });
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
