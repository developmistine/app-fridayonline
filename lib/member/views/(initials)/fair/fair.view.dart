import 'dart:ui';

import 'package:fridayonline/member/components/showproduct/showproduct.category.dart';
import 'package:fridayonline/member/components/showproduct/sku.addtocart.dart';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/coint.ctr.dart';
import 'package:fridayonline/member/controller/fair.ctr.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/models/fair/fair.swipe.model.dart';
import 'package:fridayonline/member/models/fair/fari.content.model.dart';
import 'package:fridayonline/member/models/showproduct/option.sku.dart';
import 'package:fridayonline/member/services/fair/fair.service.dart';
import 'package:fridayonline/member/services/showproduct/showproduct.sku.service.dart';
import 'package:fridayonline/member/utils/event.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(initials)/fair/festival.dart';
import 'package:fridayonline/member/views/(showproduct)/medias.sku.dart';
import 'package:fridayonline/member/widgets/seeall.button.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fridayonline/member/models/showproduct/tier.variations.model.dart'
    as tier_variation;

class ProductData {
  ProductDataClass productData;

  ProductData({
    required this.productData,
  });
}

class ProductDataClass {
  int shopId;
  int seqNo;
  int productId;
  int itemId;
  int qty;

  ProductDataClass({
    required this.shopId,
    required this.seqNo,
    required this.productId,
    required this.itemId,
    required this.qty,
  });
}

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with TickerProviderStateMixin {
  bool isAlert = false;
  bool isFirstSwipe = true;
  final fairController = Get.find<FairController>();
  DateTime? _lastReceivedTime;
  int myUid = 0;
  final List<Map<String, dynamic>> _snackbarQueue = [];

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _lastReceivedTime = DateTime.now();
    loadShowCaseStatus();
    fetchCustId();
    listenToFeedRealtime(context);
    cleanOldNotifications();
    fairController.fetchSwipeContent();
    fairController.fetchBanner();
    fairController.fetchTopProduct();
    fairController.fetchFestival("now_teaser");
    fairController.fetchFestival("coming_soon");
  }

  @override
  void dispose() {
    if (!mounted) return;
    _snackbarQueue.clear();
    super.dispose();
  }

  fetchCustId() async {
    SetData data = SetData();
    myUid = await data.b2cCustID;
  }

  bool _isSnackbarShowing = false;
  final ref = FirebaseDatabase.instance.ref("notifications/feed");

  void listenToFeedRealtime(BuildContext context) {
    ref.onChildAdded.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data != null && data['uid'] != myUid) {
        final timestamp =
            (Timestamp.fromMillisecondsSinceEpoch(data['timestamp'])).toDate();
        if (timestamp.isAfter(_lastReceivedTime!)) {
          _snackbarQueue.add({
            'uid': data['uid'],
            'title': data['title'],
            'url': data['url'],
            'timestamp': data['timestamp'],
          });

          _processSnackbarQueue(context);
        }
      }
    });
  }

  void insertNotification(String title, String url) {
    ref.push().set({
      'uid': myUid,
      'title': title,
      'url': url,
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<void> cleanOldNotifications() async {
    final cutoff = DateTime.now()
        .subtract(const Duration(minutes: 5))
        .millisecondsSinceEpoch;
    final snapshot = await ref.get();

    for (final child in snapshot.children) {
      final data = child.value as Map;
      final ts = data['timestamp'];
      if (ts != null && ts < cutoff) {
        await child.ref.remove();
      }
    }
  }

  void _processSnackbarQueue(BuildContext context) async {
    if (_isSnackbarShowing || _snackbarQueue.isEmpty) return;

    _isSnackbarShowing = true;

    final data = _snackbarQueue.removeAt(0);
    final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    final now = DateTime.now();
    final duration = now.difference(timestamp);

    // เปลี่ยนเป็นวินาที
    final secondsAgo = duration.inSeconds;

    // สร้างข้อความแสดงเวลา
    var message = '$secondsAgo วินาทีที่แล้ว...';
    if (secondsAgo == 0) {
      message = "";
    }

    showCustomSlideSnackbar(context, data['title']!, data['url']!, message);

    _lastReceivedTime = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);

    await Future.delayed(const Duration(seconds: 3));
    _isSnackbarShowing = false;

    // รันรอบต่อไป
    _processSnackbarQueue(context);
  }

  loadShowCaseStatus() async {
    SetData data = SetData();
    var firstSwipe = await data.firstSwipe;
    if (firstSwipe != "") {
      setState(() {
        isFirstSwipe = false;
      });
    }
  }

  void showCustomSlideSnackbar(BuildContext context, String productName,
      String imageUrl, String diffTime) {
    late OverlayEntry overlayEntry;
    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 400),
    );

    // ฟังก์ชันปิด snackbar
    void closeSnackbar() {
      controller.reverse().then((_) {
        overlayEntry.remove();
        controller.dispose();
      });
    }

    final animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // เริ่มจากขวา
      end: Offset.zero, // ไปกลางจอ
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutExpo,
    ));

    overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 118,
        left: 36,
        right: 36,
        child: SlideTransition(
          position: animation,
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1)),
            child: Center(
              child: GestureDetector(
                onTap: closeSnackbar,
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              CachedNetworkImage(width: 40, imageUrl: imageUrl),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ibmPlexSansThai(
                                      color: Colors.black, fontSize: 12)),
                              if (diffTime != "")
                                Text(diffTime,
                                    style: GoogleFonts.ibmPlexSansThai(
                                        color: Colors.black, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      closeSnackbar();
    });
  }

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: MediaQuery(
        data: MediaQuery.of(Get.context!)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Stack(
              children: [
                const BackGround(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 14,
                      ),
                      Image.asset(
                        'assets/images/b2c/logo/f_fair3.png',
                        width: 190,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "ยินดีต้อนรับสู่ Friday Fair ของราคาดีมีน้อย กด เอฟก่อนหมด",
                        style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      bannerFair(),
                      const SizedBox(
                        height: 20,
                      ),
                      festival(),
                      topSaleProducts(),
                      const SizedBox(
                        height: 18,
                      ),
                      Obx(() {
                        return fairController.isLoadingSwipeContent.value
                            ? const SizedBox()
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                primary: false,
                                itemCount:
                                    fairController.swipeContent!.data.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SwipeRow(
                                          isFirstSwipe: isFirstSwipe,
                                          loadShowCaseStatus:
                                              loadShowCaseStatus,
                                          insertNotification:
                                              insertNotification,
                                          fairContent: fairController
                                              .swipeContent!.data[index]),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                    ],
                                  );
                                });
                      }),
                      // SwipeRow(
                      //   isFirstSwipe: isFirstSwipe,
                      //   loadShowCaseStatus: loadShowCaseStatus,
                      //   insertNotification: insertNotification,
                      // ),
                      comingSoonDeal(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topSaleProducts() {
    return Obx(() {
      if (fairController.isLoadingTopProduct.value) {
        return Row(
          children: [
            for (var i = 0; i < 2; i++)
              Container(
                  margin: const EdgeInsets.only(top: 28, right: 8),
                  height: 180,
                  width: 140,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Image.asset(
                      'assets/images/b2c/logo/friday_online_loading.png',
                      width: 50,
                    ),
                  )),
          ],
        );
      }
      if (fairController.topProducts == null ||
          fairController.topProducts!.code == '-9') {
        return const SizedBox();
      }
      var productTop = fairController.topProducts!.data;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productTop.title,
            style: GoogleFonts.ibmPlexSansThai(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(productTop.topProducts.length, (index) {
                return Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 200),
                      margin: const EdgeInsets.only(right: 4),
                      clipBehavior: Clip.antiAlias,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      width: 140,
                      child: ProductCategoryComponents(
                        heigth: 100,
                        item: productTop.topProducts[index],
                        referrer: 'shop_product',
                      ),
                    ),
                    Positioned(
                      top: 2,
                      left: 8,
                      child: IgnorePointer(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/b2c/icon/label_fair.png',
                                width: 30),
                            Text(
                              (index + 1).toString(),
                              style: GoogleFonts.ibmPlexSansThai(
                                  height: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      );
    });
  }

  Widget festival() {
    return Obx(() {
      if (fairController.isLoadingNowTeaser.value) {
        return const SizedBox(
          height: 200,
        );
      }
      if (fairController.nowTeaser == null) {
        return const SizedBox();
      }
      var festivalItem = fairController.nowTeaser!.data;
      if (festivalItem.isEmpty) {
        return const SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Festival',
                style: GoogleFonts.ibmPlexSansThai(fontWeight: FontWeight.bold),
              ),
              InkWell(
                  onTap: () {
                    fairController.fetchFestival('now_detail');
                    Get.to(() => Festival());
                  },
                  child: buttonSeeAll()),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(festivalItem.length, (index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    eventBanner(festivalItem[index], 'fair_festival');
                  },
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300.withOpacity(0.5),
                                offset: const Offset(0, 6),
                                blurRadius: 4,
                                // spreadRadius: 1,
                              )
                            ],
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: festivalItem[index].contentImage)),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          festivalItem[index].contentName,
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          festivalItem[index].contentDesc,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 10, color: Colors.grey.shade600),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }

  Widget comingSoonDeal() {
    return Obx(() {
      if (fairController.isLoadingComingSoon.value) {
        return const SizedBox(
          height: 200,
        );
      }
      if (fairController.comingSoon == null) {
        return const SizedBox();
      }
      var item = fairController.comingSoon!.data;
      if (item.isEmpty) return const SizedBox();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Coming soon',
                style: GoogleFonts.ibmPlexSansThai(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(item.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12, top: 12),
                      width: 120,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300.withOpacity(0.5),
                            offset: const Offset(0, 6),
                            blurRadius: 4,
                            // spreadRadius: 1,
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          eventBanner(item[index], 'fair_coming_soon');
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: item[index].contentImage)),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      item[index].contentName,
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item[index].contentDesc,
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 10, color: Colors.grey.shade600),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      );
    });
  }

  Widget bannerFair() {
    return Obx(() {
      if (fairController.isLoadingBanner.value) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: Get.width,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
            Center(
                child: Image.asset(
              'assets/images/b2c/logo/friday_online_loading.png',
              width: 50,
            )),
          ],
        );
      }
      var bannerItems = fairController.banner!.data;
      if (bannerItems.isEmpty) {
        return const SizedBox();
      }
      return Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 150,
            width: Get.width,
            child: CarouselSlider.builder(
              carouselController: _controller,
              itemCount: bannerItems.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    eventBanner(bannerItems[itemIndex], "fair_banner");
                  },
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12), // กำหนด radius ที่นี่
                    child: CachedNetworkImage(
                      imageUrl: bannerItems[itemIndex].image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                      placeholder: (context, url) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: Get.width,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            Center(
                                child: Image.asset(
                              'assets/images/b2c/logo/friday_online_loading.png',
                              width: 50,
                            )),
                          ],
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          color: Colors.grey.shade400.withOpacity(0.5),
                          child: Center(
                              child: Image.asset(
                            'assets/images/b2c/logo/friday_online_loading.png',
                            width: 50,
                          )),
                        );
                      },
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  fairController.current.value = index;
                },
              ),
            ),
          ),
          Positioned(
            bottom: -24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(bannerItems.length, (index) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(index),
                  child: Container(
                    // width: 8.0,
                    width: fairController.current.value == index ? 16 : 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: (fairController.current.value == index
                                ? Colors.white
                                : const Color(0xFF1C9AD6))
                            .withOpacity(fairController.current.value == index
                                ? 0.9
                                : 0.5)),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }
}

class SwipeRow extends StatefulWidget {
  final bool isFirstSwipe;
  final Function() loadShowCaseStatus;
  final void Function(String title, String url) insertNotification;
  final Datum fairContent;

  const SwipeRow({
    super.key,
    required this.isFirstSwipe,
    required this.loadShowCaseStatus,
    required this.insertNotification,
    required this.fairContent,
  });

  @override
  _SwipeRowState createState() => _SwipeRowState();
}

class _SwipeRowState extends State<SwipeRow> with TickerProviderStateMixin {
  int currentIndex = 0;
  double dragDistance = 0.0;
  double dragRotation = 0.0;
  bool isDragging = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  // เก็บประวัติสินค้าที่ดูแล้ว
  List<int> viewedProducts = [];
  final fairController = Get.find<FairController>();
  int b2cCustId = 0;

  @override
  void initState() {
    super.initState();
    getCustId();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(2.0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  getCustId() async {
    SetData data = SetData();
    b2cCustId = await data.b2cCustID;
  }

  Future<void> _swipeRight() async {
    if (b2cCustId == 0) {
      Get.to(() => const SignInScreen());
      return;
    }
    double startOffset = isDragging ? dragDistance : 0;
    double deviceWidth = MediaQuery.of(context).size.width;

    _slideAnimation = Tween<Offset>(
      begin: Offset(startOffset / deviceWidth, 0),
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: isDragging ? dragRotation : 0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    var product = fairController.productSwipes[widget.fairContent.promotionId]!
        .data.productListings.first;
    if (product.tierVariations.isNotEmpty) {
      fairController.productTier.value = product.tierVariations;
      loadingProductTier(context);
      var select = await fetchProductTierVariationService(EndUserProductOptions(
          productId: product.productId,
          custId: b2cCustId,
          shopId: product.shopInfo.shopId,
          quantity: 1,
          selectedTiers: []));
      Get.back();
      fairController.productPrice.value = select!.data.productPrice;
      fairController.imageFirst.value =
          product.tierVariations.first.options.first.image;

      await addToCart(widget.fairContent.promotionId).then((res) {
        fairController.selectedOptions.clear();
        fairController.imageFirst.value = "";
        if (res == null) return;
        if (res.code == "100") {
          var product = fairController
              .productSwipes[widget.fairContent.promotionId]!
              .data
              .productListings
              .first;
          // var productTitle = product.viewerText;
          // widget.insertNotification(productTitle, product.image);
          var productTitle = product.productName.length > 40
              ? "${product.productName.substring(0, 40)}..."
              : product.productName;
          widget.insertNotification(
              'มีคนซื้อสินค้า $productTitle ได้ในราคา ${product.fridayFairPrice.value}  🛍',
              product.image);
          completeDialog(popupData: res.popupResponse);
        }

        _animationController.forward().then((_) {
          fairController.fetchProductSwipe(
              'next', null, widget.fairContent.promotionId);
          _nextProduct();
        });
      });

      return;
    }
    loadingProductTier(context);
    await fetchFairProductSwipeService(
            "save",
            ProductData(
                productData: ProductDataClass(
                    shopId: product.shopInfo.shopId,
                    seqNo: product.seqNo,
                    productId: product.productId,
                    itemId: product.itemId,
                    qty: 1)),
            widget.fairContent.promotionId)
        .then((res) {
      Get.back();
      // if (res!.showPopup) {
      //   return completeDialog(popupData: res.popupResponse);
      // } else

      if (res!.code == '100') {
        Get.find<EndUserCartCtr>().fetchCartItems();
        var product = fairController
            .productSwipes[widget.fairContent.promotionId]!
            .data
            .productListings
            .first;
        // var productTitle = product.viewerText;
        var productTitle = product.productName.length > 40
            ? "${product.productName.substring(0, 40)}..."
            : product.productName;
        widget.insertNotification(
            'มีคนซื้อสินค้า $productTitle ได้ในราคา ${product.fridayFairPrice.value}  🛍',
            product.image);
        // widget.insertNotification(productTitle, product.image);

        _animationController.forward().then((_) async {
          completeDialog(popupData: res.popupResponse);
          Get.find<EndUserCartCtr>().fetchCartItems();
          _nextProduct();
          fairController.fetchProductSwipe(
              'next', null, widget.fairContent.promotionId);
        });
      }
    });
  }

  Future<void> _swipeLeft() async {
    if (b2cCustId == 0) {
      Get.to(() => const SignInScreen());
      return;
    }
    // double startOffset = isDragging ? dragDistance : 0;
    // double deviceWidth = MediaQuery.of(context).size.width;

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: isDragging ? dragRotation : 0,
      end: -0.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward().then((_) async {
      _nextProduct();
      await fairController
          .fetchProductSwipe('next', null, widget.fairContent.promotionId)
          .then((res) async {
        var productData = fairController
            .productSwipes[widget.fairContent.promotionId]!.popupResponse;
        if (fairController
            .productSwipes[widget.fairContent.promotionId]!.showPopup) {
          await limitDialog(productData: productData).then((res) async {
            if (res == null || res == 0) {
              return;
            }
            await fetchProductSwipeRedeemService(
                    "refill_daily_quota", widget.fairContent.promotionId)
                .then((res) {
              if (res!.code == "101") {
                changeCoinPopup(
                  code: "-9",
                );
              } else {
                _swipeLeft();
                changeCoinPopup(
                    code: res.code,
                    title: "คุณซื้อสิทธิเพิ่มสำเร็จแล้ว เริ่มปัดได้เลยตอนนี้!");
                Get.find<CoinCtr>().fetchCheckIn();
                Get.put(ProfileCtl()).fetchProfile();
              }
            });
          });
        }
      });
    });
  }

  void _nextProduct() {
    setState(() {
      dragDistance = 0.0;
      dragRotation = 0.0;
      isDragging = false;
    });
    _animationController.reset();

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(2.0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  // ฟังก์ชันกลับไปสินค้าก่อนหน้า
  Future<void> _goToPreviousProduct() async {
    if (!fairController
        .productSwipes[widget.fairContent.promotionId]!.data.canUndo) {
      return;
    }
    var popupData = await fetchFairProductSwipeService(
        'undo_message', null, widget.fairContent.promotionId);
    if (popupData!.showPopup) {
      var res = await previousDialog(popupData);
      if (res == 0 || res == null) {
        return;
      } else {
        int previousSeqNo = fairController
            .productSwipes[widget.fairContent.promotionId]!
            .data
            .productListings
            .first
            .seqNo;
        // printWhite("seq no is : $previousSeqNo");
        await fairController
            .fetchProductSwipe(
                'undo',
                ProductData(
                    productData: ProductDataClass(
                        shopId: 0,
                        seqNo: previousSeqNo,
                        productId: 0,
                        itemId: 0,
                        qty: 1)),
                widget.fairContent.promotionId)
            .then((res) {
          changeCoinPopup(
              code: fairController
                  .productSwipes[widget.fairContent.promotionId]!.code);
          Get.find<CoinCtr>().fetchCheckIn();
        });
      }
    }

    setState(() {
      dragDistance = 0.0;
      dragRotation = 0.0;
      isDragging = false;
    });

    // แอนิเมชั่นเข้ามาจากซ้าย (reverse direction)
    _animationController.reset();
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0), // เริ่มจากซ้าย
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragDistance += details.delta.dx;
      // จำกัดระยะทางการลาก
      dragDistance = dragDistance.clamp(-300.0, 300.0);

      // คำนวณมุมหมุนตามระยะทางการลาก
      dragRotation = (dragDistance / 300.0) * 0.3;
    });
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    setState(() {
      isDragging = false;
    });
    if (widget.isFirstSwipe == true && b2cCustId == 0) {
      Get.to(() => const SignInScreen());
      return;
    } else {
      final Future<SharedPreferences> pref = SharedPreferences.getInstance();
      final SharedPreferences prefs = await pref;
      await prefs.setString('firstSwipe', '1');
      await widget.loadShowCaseStatus();
    }
    if (widget.isFirstSwipe == true) {
      return;
    }

    // ตรวจสอบว่าลากมากพอที่จะ swipe หรือไม่
    if (dragDistance.abs() > 80) {
      if (dragDistance > 0) {
        _swipeRight();
      } else {
        _swipeLeft();
      }
    } else {
      // กลับไปตำแหน่งเดิม
      setState(() {
        dragDistance = 0.0;
        dragRotation = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (fairController
              .isLoadingProductSwipes[widget.fairContent.promotionId]! &&
          fairController.productSwipes[widget.fairContent.promotionId] ==
              null) {
        return Container(
            clipBehavior: Clip.antiAlias,
            width: Get.width,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.grey.shade400.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Image.asset(
                  'assets/images/b2c/logo/friday_online_loading.png',
                  width: 100),
            ));
      }
      var data =
          fairController.productSwipes[widget.fairContent.promotionId]!.data;
      var productList = data.productListings;
      if (productList.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.promotionName,
                        style: GoogleFonts.ibmPlexSansThai(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data.promotionDesc,
                        style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'ปัดได้อีก ',
                        style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.black, fontSize: 14),
                      ),
                      Text(
                        '${fairController.userRemainingQuota}',
                        style: GoogleFonts.ibmPlexSansThai(
                            color: const Color(0xFFF54900),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' ครั้ง',
                        style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.transparent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/order/zero_order.png',
                      width: 200,
                    ),
                    Text(
                      'สินค้าหมดแล้ว',
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'ขออภัย สินค้าประจำวันนี้หมดแล้ว\n กรุณากลับมาปัดใหม่ในวันถัดไป',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      return IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.promotionName,
                  style:
                      GoogleFonts.ibmPlexSansThai(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.promotionDesc,
                        style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 116.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'ปัดได้อีก ',
                            style: GoogleFonts.ibmPlexSansThai(
                                color: Colors.black, fontSize: 14),
                          ),
                          Text(
                            '${fairController.userRemainingQuota}',
                            style: GoogleFonts.ibmPlexSansThai(
                                color: const Color(0xFFF54900),
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' ครั้ง',
                            style: GoogleFonts.ibmPlexSansThai(
                                color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Swipe Cards
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // การ์ดด้านหลัง
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: fairController.isLoadingProductSwipes[
                            widget.fairContent.promotionId]!
                        ? 0
                        : 1,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/b2c/background/bg-swipe.png')),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ]),
                    ),
                  ),

                  // การ์ดหลัก
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onPanStart: _onPanStart,
                        onPanUpdate: _onPanUpdate,
                        onPanEnd: _onPanEnd,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            double currentOffset = isDragging
                                ? dragDistance
                                : _slideAnimation.value.dx *
                                    MediaQuery.of(context).size.width;

                            double currentRotation = isDragging
                                ? dragRotation
                                : _rotationAnimation.value;

                            double opacity = 1.0;
                            if (!isDragging &&
                                _animationController.isAnimating) {
                              opacity = 1.0 - _animationController.value;
                            }

                            return Opacity(
                              opacity: opacity,
                              child: Transform.translate(
                                offset: Offset(currentOffset, 0),
                                child: Transform.rotate(
                                  angle: currentRotation,
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: fairController
                                                    .isLoadingProductSwipes[
                                                widget.fairContent.promotionId]!
                                            ? 0
                                            : 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: const Color(0xFFf6c59f)),
                                          child: Container(
                                            padding: const EdgeInsets.all(2.5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      const Color(0xFFF86E04),
                                                      const Color(0xFFF86E04)
                                                          .withOpacity(0.1),
                                                    ])),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(2.5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  gradient:
                                                      const LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                        Color(0xFFF86E04),
                                                        Color(0xFFfce0cb)
                                                      ])),
                                              child: ProductCard(
                                                product: fairController
                                                    .productSwipes[widget
                                                        .fairContent
                                                        .promotionId]!
                                                    .data
                                                    .productListings[0],
                                                swipeLeft: _swipeLeft,
                                                swipeRight: _swipeRight,
                                                goToPrev: _goToPreviousProduct,
                                                fairId: widget
                                                    .fairContent.promotionId,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // แสดงไอคอนเมื่อลาก
                                      if (isDragging && dragDistance.abs() > 30)
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: CircleAvatar(
                                                radius: 40,
                                                backgroundColor: dragDistance >
                                                        0
                                                    ? const Color(0xFFFFCC00)
                                                        .withOpacity(0.9)
                                                    : Colors.white
                                                        .withOpacity(0.4),
                                                child: dragDistance > 0
                                                    ? Image.asset(
                                                        'assets/images/b2c/icon/bolt.png',
                                                        width: 26,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .thumb_down_off_alt_rounded,
                                                        size: 35,
                                                        color: Colors.white,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (fairController.isLoadingProductSwipes[
                          widget.fairContent.promotionId]!)
                        const Positioned.fill(child: SizedBox())
                    ],
                  ),
                  if (widget.isFirstSwipe)
                    Positioned.fill(
                        child: GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            double currentOffset = isDragging
                                ? dragDistance
                                : _slideAnimation.value.dx *
                                    MediaQuery.of(context).size.width;

                            double currentRotation = isDragging
                                ? dragRotation
                                : _rotationAnimation.value;

                            double opacity = 1.0;
                            if (!isDragging &&
                                _animationController.isAnimating) {
                              opacity = 1.0 - _animationController.value;
                            }
                            return Opacity(
                              opacity: opacity,
                              child: Transform.translate(
                                offset: Offset(currentOffset, 0),
                                child: Transform.rotate(
                                  angle: currentRotation,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.black.withOpacity(0.62),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                      child: Image.asset(
                                                        'assets/images/b2c/icon/icon_left.png',
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Image.asset(
                                                        'assets/images/b2c/icon/icon_right.png',
                                                      ),
                                                    ),
                                                  ]),
                                              const SizedBox(
                                                height: 60,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    'ปัดซ้ายหากคุณไม่สนใจสินค้านี้,\n ปัดขวาหรือกดปุ่ม “เอฟก่อน” เพื่อเพิ่มสินค้าในตระกร้า',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts
                                                        .ibmPlexSansThai(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        final Future<
                                                                SharedPreferences>
                                                            pref =
                                                            SharedPreferences
                                                                .getInstance();
                                                        final SharedPreferences
                                                            prefs = await pref;
                                                        await prefs.setString(
                                                            'firstSwipe', '1');
                                                        await widget
                                                            .loadShowCaseStatus();
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  themeColorDefault),
                                                      child: Text(
                                                          "เริ่มช้อปเลย!",
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                ],
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              for (var i = 0; i < 55; i++)
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 2),
                                                  color: Colors.white,
                                                  width: 2,
                                                  height: 5,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ))
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ProductCard extends StatefulWidget {
  final ProductListing product;
  final bool isBackground;
  final void Function() swipeLeft;
  final void Function() swipeRight;
  final void Function() goToPrev;
  final int fairId;

  const ProductCard({
    super.key,
    required this.product,
    this.isBackground = false,
    required this.swipeLeft,
    required this.swipeRight,
    required this.goToPrev,
    required this.fairId,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final fairController = Get.find<FairController>();
  final coundowCtr = Get.put(CountdownController());
  @override
  void initState() {
    super.initState();
    // if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (fairController.productSwipes[widget.fairId]!.data.endTime != "") {
        coundowCtr.startCountdown(
            fairController.productSwipes[widget.fairId]!.data.endTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minHeight: Get.width >= 768 ? Get.height * 0.8 : Get.height * 0.7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ส่วนรูปภาพ
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                height: Get.width >= 768 ? 500 : 250,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: CachedNetworkImage(
                    width: Get.width,
                    imageUrl: widget.product.image,
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  margin: const EdgeInsets.only(top: 4, right: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.access_time_outlined,
                        size: 14,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Obx(() {
                        return Text(
                          coundowCtr.timeText.value,
                          style: const TextStyle(fontSize: 12, height: 1.2),
                        );
                      }),
                    ],
                  )),
              if (widget.product.isImageOverlayed)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imageOverlay,
                    width: 240,
                  ),
                )
            ],
          ),

          // ส่วนข้อมูลสินค้า
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ชื่อสินค้า
                  if (widget.product.isSecretDeal)
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomRight,
                      children: [
                        Text(
                          "${widget.product.productName}       ",
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Positioned(
                          right: -20,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  gradient: const LinearGradient(colors: [
                                    Color(0xFFFF512F),
                                    Color(0xFFF09819),
                                  ]),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                'ดีลลับ',
                                style: GoogleFonts.ibmPlexSansThai(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 12),
                              ).paddingSymmetric(horizontal: 6, vertical: 1)),
                        )
                      ],
                    )
                  else
                    Text(
                      widget.product.productName,
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (widget.product.viewerText != "")
                    const SizedBox(height: 8),
                  // แบรนด์
                  if (widget.product.viewerText != "")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECECED),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/b2c/icon/eye.png',
                                width: 16,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.product.viewerText,
                                style: GoogleFonts.ibmPlexSansThai(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icon(
                        //   Icons.favorite_border,
                        //   color: Colors.grey.shade500,
                        // )
                      ],
                    ),
                  // ราคา
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F4),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.normalPrice.key,
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            widget.product.normalPrice.value,
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFCE9DA),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product.discount.key,
                                style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 14,
                                    color: const Color(0xFFD80A0A)),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/b2c/background/bg-label-fair.png',
                                    width: 90,
                                  ),
                                  Text(
                                    widget.product.discount.value == ""
                                        ? "฿0"
                                        : widget.product.discount.value,
                                    style: GoogleFonts.ibmPlexSansThai(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product.fridayFairPrice.key,
                                style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                widget.product.fridayFairPrice.value,
                                style: GoogleFonts.ibmPlexSansThai(
                                  color: const Color(0xFFD80A0A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // if (product.lotInfo.hasTimeLimit)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.lotInfo.displayText,
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.product.lotInfo.remainingText,
                          textAlign: TextAlign.end,
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange.shade400),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (widget.product.lotInfo.hasTimeLimit)
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      alignment: MainAxisAlignment.center,
                      animation: false,
                      lineHeight: 18.0,
                      animationDuration: 1500,
                      percent: ExpiryCalculator.calculateExpiryPercentage(
                        manufactureDate: widget.product.lotInfo.manufactureDate,
                        expireDate: widget.product.lotInfo.expireDate,
                      ),
                      backgroundColor: const Color(0xFFE2E2E4),
                      center: Text(
                        widget.product.lotInfo.displayText,
                        // getDaysSinceManufacture(
                        //     manufactureDate: product.lotInfo.manufactureDate),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
                      linearGradient: const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment(0.8, 1),
                        tileMode: TileMode.mirror,
                        colors: <Color>[
                          Color.fromARGB(255, 228, 40, 7),
                          Color.fromARGB(255, 239, 161, 36),
                        ],
                      ),
                      barRadius: const Radius.circular(10),
                    ),
                  const SizedBox(height: 4),
                  if (widget.product.lotInfo.hasTimeLimit)
                    Text(
                      widget.product.lotInfo.infoText,
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 14, color: Colors.grey.shade700),
                    ),

                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: widget.product.shopInfo.icon,
                                width: 24,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              widget.product.shopInfo.shopName.toUpperCase(),
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.find<BrandCtr>()
                              .fetchShopData(widget.product.shopInfo.shopId);
                          Get.toNamed(
                              '/BrandStore/${widget.product.shopInfo.shopId}');
                        },
                        child: Row(
                          children: [
                            Text(
                              'ดูร้านค้า',
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14, color: Colors.grey.shade600),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 16, color: Colors.grey.shade600)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  // ปุ่มเอาใส่ตะกร้า
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: OutlinedButton(
                          onPressed: !fairController
                                  .productSwipes[widget.fairId]!.data.canUndo
                              ? null
                              : () {
                                  widget.goToPrev();
                                },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade200),
                              disabledBackgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.grey.shade600,
                              disabledForegroundColor: Colors.grey.shade300,
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Icon(
                            Icons.replay,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.swipeLeft();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.grey.shade200,
                            ),
                            child: Text(
                              "ไม่สนใจ",
                              style: GoogleFonts.ibmPlexSansThai(
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            widget.swipeRight();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xFFFF512F),
                                  Color(0xFFF09819)
                                ]),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/b2c/icon/bolt.png',
                                  width: 16,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "เอฟก่อน",
                                  style: GoogleFonts.ibmPlexSansThai(
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackGround extends StatelessWidget {
  const BackGround({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: Get.width,
          height: 180,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: Image.asset(
              'assets/images/b2c/background/bg-grey.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: Get.width,
          height: 316,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: Image.asset(
              'assets/images/b2c/background/bg-blue.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

Future<dynamic> limitDialog({required PopupResponse productData}) {
  return notifyAlert([
    if (productData.icon == 'info')
      Icon(
        Icons.info,
        color: Colors.grey.shade700,
        size: 60,
      )
    else
      const Icon(
        Icons.check_circle,
        color: Color(0xFF26A464),
        size: 60,
      ),
    const SizedBox(
      height: 12,
    ),
    Text(
      productData.title,
      style: GoogleFonts.ibmPlexSansThai(
          fontWeight: FontWeight.bold, fontSize: 14),
    ),
    const SizedBox(
      height: 8,
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFF512F),
                Color(0xFFF09819),
              ])),
      child: Text(
        productData.subtitle,
        style: GoogleFonts.ibmPlexSansThai(
            fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    const SizedBox(
      height: 8,
    ),
    Text(
      "แต่คุณยังสามารถสนุกต่อได้",
      style: GoogleFonts.ibmPlexSansThai(fontSize: 13),
    ),
    const SizedBox(
      height: 8,
    ),
    ShowHtmlTag(data: productData.desc),
    const SizedBox(
      height: 12,
    ),
    const Divider(),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
                child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF1C9AD6)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: Text(
                productData.actions[0].display,
                style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 13, color: const Color(0xFF1C9AD6)),
              ),
              onPressed: () {
                Get.back(result: 0);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C9AD6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: ShowHtmlTag(
                data: productData.actions[1].display,
              ),
              onPressed: () {
                Get.back(result: 1);
              },
            )),
          ],
        ),
      ),
    )
  ]);
}

Future<dynamic> changeCoinPopup({required code, String? title}) {
  return notifyAlert([
    if (code == "-9")
      const Icon(
        Icons.cancel_sharp,
        color: Colors.red,
        size: 60,
      )
    else
      const Icon(
        Icons.check_circle,
        color: Color(0xFF26A464),
        size: 60,
      ),
    const SizedBox(
      height: 12,
    ),
    Text(
      code == "-9" ? 'ทำรายการไม่สำเร็จ' : 'เรียบร้อย',
      style: GoogleFonts.ibmPlexSansThai(
          fontWeight: FontWeight.bold, fontSize: 14),
    ),
    const SizedBox(
      height: 8,
    ),
    if (title != null)
      Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.ibmPlexSansThai(
            fontSize: 13, color: Colors.grey.shade700),
      )
    else if (code == "-9")
      Text(
        'เนื่องจาก Coin ของคุณไม่เพียงพอ\nกรุณาทำรายการอีกครั้ง',
        textAlign: TextAlign.center,
        style: GoogleFonts.ibmPlexSansThai(
            fontSize: 13, color: Colors.grey.shade700),
      )
    else
      Text(
        'ทำรายการสำเร็จ ย้อนกลับดีลลับเรียบร้อยแล้ว',
        textAlign: TextAlign.center,
        style: GoogleFonts.ibmPlexSansThai(
            fontSize: 13, color: Colors.grey.shade700),
      ),
    const SizedBox(
      height: 12,
    ),
    InkWell(
      onTap: () {
        Get.back();
      },
      child: Text(
        'ปิดหน้าต่าง',
        style: GoogleFonts.ibmPlexSansThai(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500),
      ),
    )
  ]);
}

Future<dynamic> previousDialog(FairsProductSwipe popupData) {
  var data = popupData.popupResponse;
  return notifyAlert([
    SizedBox(
      width: 50,
      height: 50,
      child: CircleAvatar(
        backgroundColor: Colors.grey.shade600,
        child: const Icon(
          Icons.replay,
          color: Colors.white,
          size: 40,
        ),
      ),
    ),
    const SizedBox(
      height: 12,
    ),
    Text(
      data.title,
      style: GoogleFonts.ibmPlexSansThai(
          fontWeight: FontWeight.bold, fontSize: 14),
    ),
    const SizedBox(
      height: 8,
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFF512F),
                Color(0xFFF09819),
              ])),
      child: Text(
        data.subtitle,
        style: GoogleFonts.ibmPlexSansThai(
            fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    const SizedBox(
      height: 8,
    ),
    SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShowHtmlTag(data: data.desc),
        ],
      ),
    ),
    const SizedBox(
      height: 12,
    ),
    const Divider(),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
                child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF1C9AD6)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: Text(
                data.actions[0].display,
                style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 13, color: const Color(0xFF1C9AD6)),
              ),
              onPressed: () {
                Get.back(result: 0);
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C9AD6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: ShowHtmlTag(
                data: data.actions[1].display,
              ),
              onPressed: () {
                Get.back(result: 1);
              },
            )),
          ],
        ),
      ),
    )
  ]);
}

class ShowHtmlTag extends StatelessWidget {
  const ShowHtmlTag({
    super.key,
    required this.data,
    this.fontsSize,
  });

  final String data;
  final double? fontsSize;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      textStyle: GoogleFonts.ibmPlexSansThai(fontSize: fontsSize ?? 14),
      data,
      onErrorBuilder: (context, element, error) {
        return Container();
      },

      customWidgetBuilder: (element) {
        if (element.localName == 'div') {
          // check children is iframe
          for (var element2 in element.children) {
            if (element2.localName == 'iframe') {
              element.attributes.remove('style');
            }
          }
        }
        if (element.localName == 'img') {
          var src = element.attributes['src'];
          // check image error status code 404
          if (src != null) {
            // ตรวจสอบ URL และจัดการเมื่อเกิดข้อผิดพลาด เช่น 404 (Not Found)
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CachedNetworkImage(
                width: 24,
                imageUrl: src,
                errorWidget: (context, url, error) =>
                    const SizedBox(), // ตัวอย่างการกำหนด Widget ที่แสดงเมื่อเกิดข้อผิดพลาด
              ),
            );
          }
        }

        return null;
      },
      enableCaching: true,
      onLoadingBuilder: (context, element, loadingProgress) => Container(),
      // webView: true,
    );
  }
}

Future<dynamic> completeDialog({required PopupResponse popupData}) {
  return notifyAlert([
    const Icon(
      Icons.check_circle,
      color: Color(0xFF26A464),
      size: 60,
    ),
    const SizedBox(
      height: 12,
    ),
    Text(
      popupData.title,
      style: GoogleFonts.ibmPlexSansThai(
          fontWeight: FontWeight.bold, fontSize: 14),
    ),
    const SizedBox(
      height: 8,
    ),
    Text(
      popupData.subtitle,
      style: GoogleFonts.ibmPlexSansThai(fontSize: 13),
    ),
    const SizedBox(
      height: 12,
    ),
    const Divider(),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
                child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF1C9AD6)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: Text(
                popupData.actions[0].display,
                style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 13, color: const Color(0xFF1C9AD6)),
              ),
              onPressed: () {
                Get.to(() => const EndUserCart());
              },
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C9AD6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: ShowHtmlTag(
                data: popupData.actions[1].display,
              ),
              onPressed: () {
                Get.back();
              },
            )),
          ],
        ),
      ),
    )
  ]);
}

Future notifyAlert(List<Widget> children) {
  return Get.dialog(
      // barrierDismissible: false,
      barrierColor: Colors.black12,
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 0),
        // contentPadding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          constraints: BoxConstraints(maxWidth: Get.width * 0.8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0C9DDE).withOpacity(0.35),
                      const Color(0xFF2EA9E1).withOpacity(0),
                    ]),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: MediaQuery(
                data: MediaQuery.of(Get.context!)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
}

class ExpiryCalculator {
  static double calculateExpiryPercentage({
    required String manufactureDate,
    required String expireDate,
    DateTime? currentDate,
  }) {
    try {
      // กำหนดรูปแบบวันที่
      final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');

      // แปลงข้อมูลเป็น DateTime
      final DateTime manufactureDateTime = formatter.parse(manufactureDate);
      final DateTime expireDateTime = formatter.parse(expireDate);
      final DateTime currentDateTime = currentDate ?? DateTime.now();

      // คำนวณระยะเวลาทั้งหมด (จากผลิตถึงหมดอายุ)
      final Duration totalDuration =
          expireDateTime.difference(manufactureDateTime);

      // คำนวณระยะเวลาที่เหลือ (จากปัจจุบันถึงหมดอายุ)
      final Duration remainingDuration =
          expireDateTime.difference(currentDateTime);

      // ถ้าหมดอายุแล้ว
      if (remainingDuration.isNegative) {
        return 0.0;
      }

      // ถ้ายังไม่ผลิต
      if (currentDateTime.isBefore(manufactureDateTime)) {
        return 1.0;
      }

      // คำนวณเปอร์เซ็นต์ที่เหลือ
      double remainingPercentage =
          remainingDuration.inMilliseconds / totalDuration.inMilliseconds;

      // จำกัดค่าให้อยู่ระหว่าง 0.0 - 1.0
      remainingPercentage = remainingPercentage.clamp(0.0, 1.0);

      return remainingPercentage;
    } catch (e) {
      print('Error calculating expiry percentage: $e');
      return 0.0;
    }
  }
}

String getDaysSinceManufacture({
  required String manufactureDate,
  DateTime? currentDate,
}) {
  try {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    final DateTime manufactureDateTime = formatter.parse(manufactureDate);
    final DateTime currentDateTime = currentDate ?? DateTime.now();

    final Duration difference = currentDateTime.difference(manufactureDateTime);

    if (difference.isNegative) {
      return "ยังไม่ผลิต";
    }

    final int days = difference.inDays;
    final int hours = difference.inHours.remainder(24);

    if (days == 0 && hours == 0) {
      return "ผลิตเมื่อสักครู่";
    } else if (days == 0) {
      return "$hours ชม.";
    } else {
      return "$days วัน $hours ชม.";
    }
  } catch (e) {
    return "ข้อมูลผิดพลาด";
  }
}

addToCart(fairId) async {
  var fairController = Get.find<FairController>();
  // fairController.itemId.value = 0;
  return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0))),
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return SafeArea(
      child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Obx(() {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    int indexOpen =
                                        fairController.selectedOptions[0] ?? 0;
                                    indexOpen > 0
                                        ? indexOpen = indexOpen + 1
                                        : 0;

                                    Get.to(() => EndUserProductMedias(
                                        mediaUrls: fairController
                                            .productSwipes[fairId]!
                                            .data
                                            .productListings
                                            .first
                                            .tierVariations
                                            .first
                                            .options
                                            .map((e) => e.image)
                                            .toList(),
                                        index: indexOpen));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          // padding: const EdgeInsets.all(8),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade100),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                fairController.imageFirst.value,
                                            errorWidget: (context, url, error) {
                                              return Icon(
                                                Icons.shopify,
                                                color: Colors.grey.shade200,
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            padding: const EdgeInsets.all(2),
                                            alignment: Alignment.topRight,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade500,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                const Icon(
                                                  Icons.arrow_outward,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                Positioned(
                                                  top: 6,
                                                  right: 6,
                                                  child: Transform.rotate(
                                                    angle: 3.2,
                                                    child: const Icon(
                                                      Icons.arrow_outward,
                                                      color: Colors.white,
                                                      size: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return Row(
                                          children: productPriceWidget(
                                              productPrices: fairController
                                                  .productPrice.value,
                                              showPercent: false));
                                    }),
                                  ],
                                )
                              ],
                            ),
                            IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                Get.back();
                              },
                              color: Colors.grey.shade700,
                            )
                          ],
                        ),
                        const Divider(),
                        Container(
                          color: Colors.grey.shade100,
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                color: Colors.white,
                                child: Obx(() {
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount:
                                        fairController.productTier.value.length,
                                    itemBuilder: (context, index) {
                                      var tierVariation = fairController
                                          .productTier.value[index];

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tierVariation.name,
                                            style: GoogleFonts.ibmPlexSansThai(
                                                fontSize: 12),
                                          ),
                                          Wrap(
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      tierVariation
                                                          .options.length;
                                                  i++)
                                                InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      loadingProductTier(
                                                          context);
                                                      await selectProduct(
                                                          index, i, fairId);
                                                      Get.back();
                                                      setState(
                                                        () {},
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              4),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                          border: fairController.selectedOptions[index] == i &&
                                                                  tierVariation
                                                                          .options[
                                                                              i]
                                                                          .displayIndicators !=
                                                                      2
                                                              ? Border.all(
                                                                  color: Colors
                                                                      .deepOrange
                                                                      .shade700)
                                                              : null,
                                                          color: tierVariation
                                                                      .options[
                                                                          i]
                                                                      .displayIndicators ==
                                                                  2
                                                              ? Colors
                                                                  .grey.shade50
                                                              : fairController.selectedOptions[index] ==
                                                                      i
                                                                  ? Colors.white
                                                                  : Colors.grey
                                                                      .shade100,
                                                          borderRadius:
                                                              BorderRadius.circular(4)),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          if (index == 0)
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 2),
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4)),
                                                              child: Stack(
                                                                children: [
                                                                  Image(
                                                                    width: 30,
                                                                    height: 25,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image:
                                                                        CachedNetworkImageProvider(
                                                                      fairController
                                                                          .productSwipes[
                                                                              fairId]!
                                                                          .data
                                                                          .productListings
                                                                          .first
                                                                          .tierVariations[
                                                                              index]
                                                                          .options[
                                                                              i]
                                                                          .image,
                                                                    ),
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return SizedBox(
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            25,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .image_not_supported,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade500,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  if (tierVariation
                                                                          .options[
                                                                              i]
                                                                          .displayIndicators ==
                                                                      2)
                                                                    Positioned
                                                                        .fill(
                                                                      child:
                                                                          BackdropFilter(
                                                                        filter: ImageFilter.blur(
                                                                            sigmaX:
                                                                                0.8,
                                                                            sigmaY:
                                                                                0.8), // ปรับค่า sigma ให้เบลอ
                                                                        child:
                                                                            Container(
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.5), // สีขาวโปร่งแสง 50%
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ConstrainedBox(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        140),
                                                            child: Text(
                                                              tierVariation
                                                                  .options[i]
                                                                  .optionValue,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts.ibmPlexSansThai(
                                                                  fontSize: 12,
                                                                  color: tierVariation.options[i].displayIndicators == 2
                                                                      ? Colors.grey.shade400
                                                                      : fairController.selectedOptions[index] == i
                                                                          ? Colors.deepOrange.shade700
                                                                          : null),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Obx(() {
                          bool isAllSelected =
                              fairController.selectedOptions.values.length ==
                                      fairController
                                          .productSwipes[fairId]!
                                          .data
                                          .productListings
                                          .first
                                          .tierVariations
                                          .length &&
                                  fairController.selectedOptions.values
                                      .every((element) => element != null);
                          return Container(
                            height: 40,
                            width: Get.width,
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  backgroundColor: isAllSelected
                                      ? themeColorDefault
                                      : Colors.grey.shade200,
                                ),
                                onPressed: () async {
                                  if (!isAllSelected) return;
                                  loadingProductStock(context);

                                  var res = await fetchFairProductSwipeService(
                                      "save",
                                      ProductData(
                                          productData: ProductDataClass(
                                              shopId: fairController
                                                  .productSwipes[fairId]!
                                                  .data
                                                  .productListings
                                                  .first
                                                  .shopInfo
                                                  .shopId,
                                              seqNo: fairController
                                                  .productSwipes[fairId]!
                                                  .data
                                                  .productListings
                                                  .first
                                                  .seqNo,
                                              productId: fairController
                                                  .productSwipes[fairId]!
                                                  .data
                                                  .productListings
                                                  .first
                                                  .productId,
                                              itemId:
                                                  fairController.itemId.value,
                                              qty: 1)),
                                      fairId);
                                  Get.back();
                                  Get.back(result: res);
                                  Get.find<EndUserCartCtr>().fetchCartItems();
                                },
                                child: Text(
                                  'เพิ่มสินค้าไปยังตะกร้า',
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontWeight: FontWeight.bold,
                                    color: isAllSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                )),
                          );
                        })
                      ],
                    ),
                  ],
                ),
              );
            }),
          )),
    );
  }));
}

Future<void> selectProduct(int index, int i, int fairId) async {
  var fairController = Get.find<FairController>();
  if (fairController.productTier.value[index].options[i].displayIndicators ==
      2) {
    return;
  }
  if (index == 0) {
    fairController.imageFirst.value = fairController.productSwipes[fairId]!.data
        .productListings.first.tierVariations[index].options[i].image;
  }

  // ถ้าไม่ใช่ตัวเลือกเดิม ให้เลือก option ใหม่
  fairController.selectedOptions[index] = i;
  List<SelectedTier> listTier = [];

  for (var entry in fairController.selectedOptions.entries.toList()) {
    if (entry.value != null) {
      int selectedIndex = entry.value!;
      var option =
          fairController.productTier.value[entry.key].options[selectedIndex];
      if (option.displayIndicators == 0) {
        listTier.add(SelectedTier(
          key: entry.key,
          value: selectedIndex,
        ));
      }
    }
  }
  SetData data = SetData();
  var custId = await data.b2cCustID;
  EndUserProductOptions optionSelected = EndUserProductOptions(
    custId: custId,
    productId: fairController
        .productSwipes[fairId]!.data.productListings.first.productId,
    shopId: fairController
        .productSwipes[fairId]!.data.productListings.first.shopInfo.shopId,
    selectedTiers: listTier,
    quantity: int.parse(qtyController.text),
  );
  tier_variation.TierVariations? res =
      await fetchProductTierVariationService(optionSelected);
  fairController.productTier.value = res!.data.tierVariations;
  fairController.itemId.value = res.data.itemId;
  fairController.productPrice.value = res.data.productPrice;
}
