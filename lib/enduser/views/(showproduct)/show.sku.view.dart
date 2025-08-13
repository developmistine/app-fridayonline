import 'dart:async';

import 'package:appfridayecommerce/enduser/components/appbar/appbar.sku.dart';
import 'package:appfridayecommerce/enduser/components/flashdeal/flashdeal.timer.dart';
import 'package:appfridayecommerce/enduser/components/shimmer/shimmer.productdetail.dart';
import 'package:appfridayecommerce/enduser/components/showproduct/nodata.dart';
import 'package:appfridayecommerce/enduser/components/showproduct/showproduct.category.dart';
import 'package:appfridayecommerce/enduser/components/showproduct/sku.addtocart.dart';
import 'package:appfridayecommerce/enduser/components/showproduct/sku.related.dart';
import 'package:appfridayecommerce/enduser/components/showproduct/sku.review.dart';
import 'package:appfridayecommerce/enduser/controller/brand.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/enduser.home.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/showproduct.sku.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/track.ctr.dart';
import 'package:appfridayecommerce/enduser/models/brands/shopfilter.model.dart';
import 'package:appfridayecommerce/enduser/models/showproduct/product.sku.model.dart'
    as product_model;
import 'package:appfridayecommerce/enduser/services/brands/brands.service.dart';
import 'package:appfridayecommerce/enduser/utils/format.dart';
import 'package:appfridayecommerce/enduser/views/(showproduct)/medias.sku.dart';
import 'package:appfridayecommerce/enduser/widgets/animated.product.dart';
import 'package:appfridayecommerce/enduser/widgets/arrow_totop.dart';
import 'package:appfridayecommerce/enduser/widgets/gap.dart';
import 'package:appfridayecommerce/enduser/widgets/seeall.button.dart';
import 'package:appfridayecommerce/print.dart';
import 'package:appfridayecommerce/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

final ShowProductSkuCtr showProductCtr = Get.find();
final EndUserHomeCtr endUserHomeCtr = Get.find();

class ShowProductSku extends StatefulWidget {
  const ShowProductSku({super.key});

  @override
  State<ShowProductSku> createState() => _ShowProductCategoryState();
}

class _ShowProductCategoryState extends State<ShowProductSku>
    with TickerProviderStateMixin {
  final String productId = Get.parameters['id'] ?? '0';
  bool _isAnimating = false;
  Offset _startPosition = const Offset(0, 0);
  Offset _endPosition = const Offset(0, 0);
  String animatedImg = '';
  double maxHeight = Get.height / 1.5;

  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _opacityAnimation;

  final GlobalKey _cartIconKey = GlobalKey();
  final GlobalKey _startImageKey = GlobalKey();

  List<String> videoUrls = [];
  List<String> imageUrls = [];
  List<String> imageKey = [];
  List<String> mediaUrls = [];

  CarouselSliderController carouselController = CarouselSliderController();

  final scrollerController = ScrollController();

  Offset getCartIconPosition() {
    final RenderBox renderBox =
        _cartIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    return position;
  }

  void startAnimation(BuildContext context, Offset startPosition, String url) {
    if (_isAnimating || !mounted) return; // หยุดแอนิเมชันถ้ากำลังทำงาน

    // final cartIconPosition = Offset(Get.width - 80, 50);
    final cartIconPosition = getCartIconPosition();

    setState(() {
      animatedImg = url;
      _isAnimating = true;
      _startPosition = Offset(startPosition.dx, startPosition.dy - 50);
      _endPosition = cartIconPosition;
    });

    _animation =
        Tween<Offset>(begin: _startPosition, end: _endPosition).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInBack),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.reset();
    _controller.forward().then((value) {
      setState(() {
        _isAnimating = false;
        Get.back();
        Get.back();
      });
    });
  }

  int count = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    printWhite('init');

    mediaUrls.clear();
    showProductCtr.activeSlide.value = 0;
    showProductCtr.activeKey.value = "";
    showProductCtr.itemId.value = 0;
    showProductCtr.indexPrdOption.value = -1;
    showProductCtr.stock.value = 0;
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    scrollerController.addListener(() {
      // กำหนดเงื่อนไขเมื่อ scroll เลื่อนลงหรือขึ้น
      bool shouldSetAppbar = scrollerController.offset > 100;
      if (showProductCtr.productDetail.value != null) {
        if (shouldSetAppbar != showProductCtr.isSetAppbar.value) {
          if (!mounted) return;
          setState(() {
            showProductCtr.isSetAppbar.value = shouldSetAppbar;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (!mounted) return;
    // printWhite('dispose ${showProductCtr.productDetail.value!.data.title}');
    scrollerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (!mounted) return;
        mediaUrls.clear();
        showProductCtr.itemId.value = 0;
        showProductCtr.activeSlide.value = 0;
        showProductCtr.activeKey.value = "";
        showProductCtr.indexPrdOption.value = -1;
        showProductCtr.stock.value = 0;
        showProductCtr.isExpanded.value = false;
        showProductCtr.isOptionOutStock.value = false;
        showProductCtr.indexActive = (-1).obs;
        showProductCtr.isOptionOutStock = false.obs;
        showProductCtr.shopProductsFuture = fetchShopProductFilterServices(
          0,
          showProductCtr.productDetail.value!.data.shopDetailed.shopId,
          'sales',
          '',
          0,
        );
      },
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                body: Obx(() {
                  if (showProductCtr.isLoadingProduct.value) {
                    return const LoadingProductDetail();
                  } else {
                    if (showProductCtr.productDetail.value == null ||
                        showProductCtr.productDetail.value!.code == "-9") {
                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.white,
                          centerTitle: false,
                          titleSpacing: 8,
                          automaticallyImplyLeading: false,
                          leading: null,
                          title: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Get.back();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'ย้อนกลับ',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                        body: nodata(context),
                      );
                    }

                    videoUrls = List<String>.from(showProductCtr
                        .productDetail.value!.data.productImages.video
                        .map((e) => e.image)).toList();
                    imageUrls = List<String>.from(showProductCtr
                        .productDetail.value!.data.productImages.image
                        .map((e) => e.image)).toList();
                    imageKey = List<String>.from(showProductCtr
                        .productDetail.value!.data.productImages.image
                        .map((e) => e.keyImage)).toList();

                    mediaUrls = [...videoUrls, ...imageUrls];
                    product_model.ProductPrice productPrices =
                        showProductCtr.productDetail.value!.data.productPrice;
                    List<product_model.ProductDatail> productDetail =
                        showProductCtr.productDetail.value!.data.productDatail;

                    return Stack(
                      children: [
                        SingleChildScrollView(
                          controller: scrollerController,
                          child: SingleChildScrollView(
                            controller: showProductCtr.scrollController,
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    SizedBox(
                                        height: Get.height * 0.4,
                                        width: Get.width,
                                        child: CarouselSlider.builder(
                                          carouselController:
                                              carouselController,
                                          options: CarouselOptions(
                                            padEnds: false,
                                            aspectRatio: 1,
                                            viewportFraction: 1,
                                            onPageChanged: (index, reason) {
                                              showProductCtr.activeSlide.value =
                                                  index;
                                              product_model.Data data =
                                                  showProductCtr.productDetail
                                                      .value!.data;
                                              bool haveVideo = data.haveVideo;
                                              if (haveVideo) {
                                                showProductCtr.activeKey.value =
                                                    imageKey[index == 0
                                                        ? index
                                                        : index - 1];
                                              } else {
                                                showProductCtr.activeKey.value =
                                                    imageKey[index];
                                              }
                                              showProductCtr.indexActive.value =
                                                  data.productDatail.indexWhere(
                                                      (element) =>
                                                          element.keyImage ==
                                                          imageKey[index]);
                                              if (data.tierVariations.isEmpty) {
                                                if (data.stock == 0) {
                                                  showProductCtr
                                                      .isOptionOutStock
                                                      .value = true;
                                                } else {
                                                  showProductCtr
                                                      .isOptionOutStock
                                                      .value = false;
                                                }
                                              } else if (showProductCtr
                                                      .indexActive.value !=
                                                  -1) {
                                                if (data
                                                        .tierVariations[0]
                                                        .options[showProductCtr
                                                            .indexActive.value]
                                                        .displayIndicators ==
                                                    2) {
                                                  showProductCtr
                                                      .isOptionOutStock
                                                      .value = true;
                                                } else {
                                                  showProductCtr
                                                      .isOptionOutStock
                                                      .value = false;
                                                }
                                              } else {
                                                showProductCtr.isOptionOutStock
                                                    .value = false;
                                              }

                                              showProductCtr
                                                      .indexPrdOption.value =
                                                  (showProductCtr.productDetail
                                                      .value!.data.productDatail
                                                      .indexWhere((element) =>
                                                          element.keyImage ==
                                                          imageKey[index == 0
                                                              ? index
                                                              : index - 1]));
                                            },
                                          ),
                                          itemCount: mediaUrls.length,
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            final url = mediaUrls[index];
                                            return InkWell(
                                              onTap: () async {
                                                if (showProductCtr
                                                        .productDetail
                                                        .value!
                                                        .data
                                                        .haveVideo &&
                                                    index == 0) {
                                                  if (showProductCtr
                                                      .videoCtr![productId]!
                                                      .value
                                                      .isPlaying) {
                                                    showProductCtr
                                                        .videoCtr![productId]!
                                                        .pause();
                                                    showProductCtr
                                                        .videoCtr![productId]!
                                                        .seekTo(Duration.zero);

                                                    Map<String, Object>?
                                                        continuePosition =
                                                        await Get.to(() =>
                                                            EndUserProductMedias(
                                                                mediaUrls:
                                                                    mediaUrls,
                                                                index: index));

                                                    if (continuePosition ==
                                                        null) {
                                                      setState(() {});
                                                      return;
                                                    }
                                                    bool isPlaying =
                                                        continuePosition[
                                                                "isPlaying"]
                                                            as bool;
                                                    Duration position =
                                                        continuePosition[
                                                                "postion"]
                                                            as Duration;
                                                    if (showProductCtr
                                                            .activeSlide
                                                            .value ==
                                                        0) {
                                                      showProductCtr
                                                          .videoCtr![productId]!
                                                          .seekTo(position);
                                                      if (isPlaying) {
                                                        showProductCtr
                                                            .videoCtr![
                                                                productId]!
                                                            .play();
                                                      }
                                                      setState(() {});
                                                      return;
                                                    } else {
                                                      carouselController
                                                          .jumpToPage(
                                                              showProductCtr
                                                                  .activeSlide
                                                                  .value);
                                                      return;
                                                    }
                                                  } else {
                                                    showProductCtr
                                                        .videoCtr![productId]!
                                                        .play();
                                                    setState(() {});
                                                    return;
                                                  }
                                                }
                                                await Get.to(() =>
                                                        EndUserProductMedias(
                                                            mediaUrls:
                                                                mediaUrls,
                                                            index: index))!
                                                    .then((_) => {
                                                          carouselController
                                                              .jumpToPage(
                                                                  showProductCtr
                                                                      .activeSlide
                                                                      .value)
                                                        });
                                              },
                                              child: videoUrls.contains(url)
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      color:
                                                          Colors.grey.shade100,
                                                      child: VideoWidget(
                                                          productId: productId,
                                                          videoUrl: url,
                                                          thumbnail:
                                                              showProductCtr
                                                                  .productDetail
                                                                  .value!
                                                                  .data
                                                                  .productImages
                                                                  .image
                                                                  .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .defaultFlag ==
                                                                        1,
                                                                    orElse: () => showProductCtr
                                                                        .productDetail
                                                                        .value!
                                                                        .data
                                                                        .productImages
                                                                        .image[0],
                                                                  )
                                                                  .image),
                                                    )
                                                  : CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: url,
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color: Colors
                                                              .grey.shade200,
                                                          size: 100,
                                                        );
                                                      },
                                                    ),
                                            );
                                          },
                                        )),
                                    if (showProductCtr.productDetail.value!.data
                                            .isImageOverlayed &&
                                        showProductCtr.activeSlide.value == 0)
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        child: IgnorePointer(
                                          child: CachedNetworkImage(
                                              height: 280,
                                              imageUrl: showProductCtr
                                                  .productDetail
                                                  .value!
                                                  .data
                                                  .imageOverlay),
                                        ),
                                      ),
                                    Container(
                                      margin: const EdgeInsets.all(12),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 6),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5)),
                                      child: Obx(() {
                                        return Text(
                                          '${showProductCtr.activeSlide.value + 1}/${mediaUrls.length}',
                                          style: GoogleFonts.notoSansThaiLooped(
                                              height: 1.2,
                                              color: Colors.grey.shade700,
                                              fontSize: 12),
                                        );
                                      }),
                                    ),
                                    if (showProductCtr.isOptionOutStock.value)
                                      Positioned(
                                        top: 150,
                                        left: 150,
                                        child: IgnorePointer(
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 18),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  color: Colors.black54),
                                              child: const Text(
                                                'สินค้าหมด',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              )),
                                        ),
                                      )
                                  ],
                                ),
                                SizedBox(
                                  width: Get.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (showProductCtr.productDetail.value!
                                          .data.productDatail.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            '${showProductCtr.productDetail.value!.data.productDatail.length} ตัวเลือกสินค้า',
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontSize: 12,
                                                    color:
                                                        Colors.grey.shade600),
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(children: [
                                            ...List.generate(
                                                showProductCtr
                                                    .productDetail
                                                    .value!
                                                    .data
                                                    .productDatail
                                                    .length, (index) {
                                              product_model.Data data =
                                                  showProductCtr.productDetail
                                                      .value!.data;
                                              String keyImg = data
                                                  .productDatail[index]
                                                  .keyImage;
                                              int tier =
                                                  data.tierVariations.isEmpty
                                                      ? data.stock == 0
                                                          ? 2
                                                          : 0
                                                      : data
                                                          .tierVariations[0]
                                                          .options[index]
                                                          .displayIndicators;
                                              bool activeDetail = showProductCtr
                                                      .activeKey.value ==
                                                  keyImg;

                                              bool isOutStock =
                                                  activeDetail && tier == 2;
                                              // print(isOutStock);

                                              return InkWell(
                                                onTap: () {
                                                  if (activeDetail) {
                                                    showProductCtr
                                                        .isOptionOutStock
                                                        .value = false;
                                                    carouselController
                                                        .jumpToPage(0);
                                                    showProductCtr
                                                        .activeKey.value = "";
                                                    showProductCtr
                                                        .activeSlide.value = 0;
                                                    showProductCtr
                                                        .indexPrdOption
                                                        .value = -1;
                                                    showProductCtr
                                                        .selectedOptions
                                                        .clear();
                                                  } else {
                                                    showProductCtr
                                                        .isOptionOutStock
                                                        .value = isOutStock;
                                                    bool haveVideo =
                                                        showProductCtr
                                                            .productDetail
                                                            .value!
                                                            .data
                                                            .haveVideo;
                                                    showProductCtr
                                                            .selectedOptions[
                                                        0] = index;
                                                    carouselController.jumpToPage(haveVideo
                                                        ? showProductCtr
                                                                .productDetail
                                                                .value!
                                                                .data
                                                                .productImages
                                                                .image
                                                                .indexWhere(
                                                                    (element) =>
                                                                        element
                                                                            .keyImage ==
                                                                        keyImg) +
                                                            1
                                                        : showProductCtr
                                                            .productDetail
                                                            .value!
                                                            .data
                                                            .productImages
                                                            .image
                                                            .indexWhere((element) =>
                                                                element
                                                                    .keyImage ==
                                                                keyImg));
                                                    showProductCtr
                                                        .indexPrdOption
                                                        .value = index;
                                                  }
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  clipBehavior: Clip.antiAlias,
                                                  margin: const EdgeInsets.only(
                                                      top: 2,
                                                      bottom: 2,
                                                      left: 2,
                                                      right: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          strokeAlign: BorderSide
                                                              .strokeAlignOutside,
                                                          width: activeDetail
                                                              ? 1.5
                                                              : 0.5,
                                                          color: activeDetail
                                                              ? Colors
                                                                  .deepOrange
                                                                  .shade700
                                                              : Colors.grey
                                                                  .shade300)),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: showProductCtr
                                                        .productDetail
                                                        .value!
                                                        .data
                                                        .productDatail[index]
                                                        .image,
                                                    errorWidget:
                                                        (context, url, error) {
                                                      return Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors
                                                            .grey.shade200,
                                                        size: 24,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }),
                                          ]),
                                        ),
                                      ),
                                      if (showProductCtr
                                                  .productDetail
                                                  .value!
                                                  .data
                                                  .ongoingFlashsale
                                                  .promotionId !=
                                              0 &&
                                          !endUserHomeCtr
                                              .isCloseFlashSale.value)
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: const BoxDecoration(
                                                color: Color(0xFFD80A0A)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.bolt,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      'SUPER DAYFAIR',
                                                      style: GoogleFonts
                                                          .notoSansThaiLooped(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'สิ้นสุดใน',
                                                      style: GoogleFonts
                                                          .notoSansThaiLooped(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    flashDealTimer(),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: productDetail
                                                          .indexWhere((e) =>
                                                              e.keyImage ==
                                                              showProductCtr
                                                                  .activeKey
                                                                  .value) !=
                                                      -1
                                                  ? productPriceDetail(
                                                      productDetail: productDetail[
                                                          productDetail
                                                              .indexWhere((e) =>
                                                                  e.keyImage ==
                                                                  showProductCtr
                                                                      .activeKey
                                                                      .value)],
                                                      showPercent: true)
                                                  : productPriceMain(
                                                      productPrices:
                                                          productPrices,
                                                      showPercent: true),
                                            ),
                                            Text(
                                              showProductCtr.productDetail
                                                  .value!.data.unitSales,
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
                                                      fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                      if (showProductCtr
                                              .productDetail
                                              .value!
                                              .data
                                              .teaserFlashsale
                                              .promotionId !=
                                          0)
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 8),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFD80A0A),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.bolt,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                    Text(
                                                      'SUPER DAYFAIR',
                                                      style: GoogleFonts
                                                          .notoSansThaiLooped(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text(
                                                      showProductCtr
                                                          .productDetail
                                                          .value!
                                                          .data
                                                          .teaserFlashsale
                                                          .startTime,
                                                      style: GoogleFonts
                                                          .notoSansThaiLooped(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Stack(
                                          children: [
                                            if (showProductCtr.productDetail
                                                    .value!.data.icon !=
                                                "")
                                              Text(
                                                '        ${showProductCtr.productDetail.value!.data.title}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            else
                                              Text(
                                                showProductCtr.productDetail
                                                    .value!.data.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            if (showProductCtr.productDetail
                                                    .value!.data.icon !=
                                                "")
                                              Container(
                                                height: 24,
                                                width: 24,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: CachedNetworkImage(
                                                    imageUrl: showProductCtr
                                                        .productDetail
                                                        .value!
                                                        .data
                                                        .icon),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.local_shipping,
                                              color: themeColorDefault,
                                              size: 16,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              showProductCtr
                                                  .productDetail
                                                  .value!
                                                  .data
                                                  .shippingEstimated,
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
                                                      fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(height: 10),
                                shopDetails(),
                                const Gap(height: 10),
                                const SizedBox(
                                  height: 8,
                                ),
                                const ReViewSku(),
                                FutureBuilder(
                                  future: showProductCtr.shopProductsFuture,
                                  builder: (context,
                                      AsyncSnapshot<ShopProductFilter?>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox();
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.none) {
                                      return const SizedBox();
                                    } else {
                                      if (snapshot.data == null) {
                                        return const SizedBox();
                                      }
                                      var data = snapshot.data!.data.products;

                                      if (data.isEmpty) {
                                        return const SizedBox();
                                      }

                                      List<Widget> productList = List.generate(
                                        data.length > 14 ? 14 : data.length,
                                        (index) {
                                          return SizedBox(
                                            width: 124,
                                            child: ProductCategoryComponents(
                                              item: data[index],
                                              width: 80,
                                              heigth: 90,
                                              referrer: 'product_detail_shop',
                                            ),
                                          );
                                        },
                                      );
                                      productList.add(InkWell(
                                        onTap: () {
                                          Get.find<TrackCtr>()
                                              .clearLogContent();
                                          Get.put(BrandCtr()).fetchShopData(
                                              showProductCtr.productDetail
                                                  .value!.data.shopId);
                                          Get.put(BrandCtr()).resetVal();
                                          // Get.to(() => const BrandStore(), arguments: 1);
                                          Get.toNamed(
                                              '/BrandStore/${showProductCtr.productDetail.value!.data.shopId}',
                                              arguments: 1);
                                        },
                                        child: SizedBox(
                                          width: 124,
                                          height: 170,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                          color:
                                                              themeColorDefault)),
                                                  child: Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      color:
                                                          themeColorDefault)),
                                              Text(
                                                'ดูเพิ่มเติม',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: themeColorDefault,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'จากร้านเดียวกัน',
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Get.find<TrackCtr>()
                                                        .clearLogContent();
                                                    Get.put(BrandCtr())
                                                        .fetchShopData(
                                                            showProductCtr
                                                                .productDetail
                                                                .value!
                                                                .data
                                                                .shopId);
                                                    Get.put(BrandCtr())
                                                        .resetVal();
                                                    // Get.to(() => const BrandStore(), arguments: 1);
                                                    Get.toNamed(
                                                        '/BrandStore/${showProductCtr.productDetail.value!.data.shopId}',
                                                        arguments: 1);
                                                  },
                                                  child: buttonSeeAll(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(children: productList),
                                          ),
                                        ],
                                      );

                                      // return Row(
                                      //   children: List.generate(data.length, (index) {

                                      //   }),
                                      // );
                                    }
                                  },
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'รายละเอียด',
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontWeight: FontWeight.bold),
                                    )),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Obx(() {
                                    return ConstrainedBox(
                                      constraints:
                                          showProductCtr.isExpanded.value
                                              ? const BoxConstraints()
                                              : const BoxConstraints(
                                                  maxHeight: 200),
                                      child: SingleChildScrollView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        child: HtmlWidget(
                                          // key: showProductCtr.htmlKeys ?? null,
                                          textStyle:
                                              GoogleFonts.notoSansThaiLooped(
                                                  fontSize: 14),
                                          ''' 
                                          ${showProductCtr.productDetail.value!.data.description}
                                                ''',
                                          onErrorBuilder:
                                              (context, element, error) {
                                            return Container();
                                          },
                                          customWidgetBuilder: (element) {
                                            if (element.localName == 'img') {
                                              var src =
                                                  element.attributes['src'];
                                              // check image error status code 404
                                              if (src != null) {
                                                // ตรวจสอบ URL และจัดการเมื่อเกิดข้อผิดพลาด เช่น 404 (Not Found)
                                                return CachedNetworkImage(
                                                  imageUrl: src,
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const SizedBox(), // ตัวอย่างการกำหนด Widget ที่แสดงเมื่อเกิดข้อผิดพลาด
                                                );
                                              }
                                            }

                                            if (element.localName == 'div') {
                                              // check children is iframe
                                              for (var element2
                                                  in element.children) {
                                                if (element2.localName ==
                                                    'iframe') {
                                                  element.attributes
                                                      .remove('style');
                                                }
                                              }
                                            }

                                            return null;
                                          },
                                          enableCaching: true,
                                          onLoadingBuilder: (context, element,
                                                  loadingProgress) =>
                                              Container(),
                                          // webView: true,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const Divider(),
                                Obx(() {
                                  return Container(
                                    decoration: BoxDecoration(
                                        boxShadow:
                                            !showProductCtr.isExpanded.value
                                                ? [
                                                    const BoxShadow(
                                                      color: Color.fromARGB(
                                                          182, 255, 255, 255),
                                                      offset: Offset(0.0, -2.0),
                                                      blurRadius: 50,
                                                      spreadRadius: 40,
                                                    ),
                                                  ]
                                                : []),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showProductCtr.isExpanded.value =
                                              !showProductCtr.isExpanded.value;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            showProductCtr.isExpanded.value
                                                ? 'ดูน้อยลง'
                                                : 'เพิ่มเติม',
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontSize: 14),
                                          ),
                                          Icon(
                                            !showProductCtr.isExpanded.value
                                                ? Icons
                                                    .keyboard_arrow_down_rounded
                                                : Icons
                                                    .keyboard_arrow_up_rounded,
                                            color: Colors.grey.shade400,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(
                                  height: 12,
                                ),
                                RalatedProduct(
                                  productId: productId,
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: appbarSku(
                              ctx: context,
                              title: 'รายละเอียดสินค้า',
                              isSetAppbar: showProductCtr.isSetAppbar.value,
                              keyCart: _cartIconKey,
                              scrollController: scrollerController,
                            )),
                      ],
                    );
                  }
                }),
                floatingActionButton:
                    showProductCtr.productDetail.value == null ||
                            showProductCtr.productDetail.value!.code == "-9"
                        ? const SizedBox()
                        : arrowToTop(
                            scrCtrl: scrollerController,
                            isShowArrow: showProductCtr.isSetAppbar.value),
                bottomNavigationBar: Obx(() {
                  return showProductCtr.isLoadingProduct.value
                      ? const SizedBox()
                      : showProductCtr.productDetail.value == null ||
                              showProductCtr.productDetail.value!.code == "-9"
                          ? const SizedBox()
                          : BottomAddToCart(
                              context: context,
                              startAnimation: startAnimation,
                              startImageKey: _startImageKey,
                            );
                }),
              ),
              if (_isAnimating)
                buildAnimatedProduct(
                        _animation, context, _opacityAnimation, animatedImg) ??
                    const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget shopDetails() {
    return Builder(builder: (context) {
      var data = showProductCtr.productDetail.value!.data;
      var shopDetailed = data.shopDetailed;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(50)),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: shopDetailed.account.image,
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.shopify);
                          },
                        ),
                      ),
                    ),
                    if (shopDetailed.isShopOfficial)
                      Positioned(
                        top: 40,
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.red.shade600,
                            ),
                            child: const Text(
                              'Mall',
                              style: TextStyle(
                                  inherit: false,
                                  color: Colors.white,
                                  fontSize: 10),
                            )),
                      )
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopDetailed.shopName,
                        style: GoogleFonts.notoSansThaiLooped(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w900),
                      ),
                      Row(
                        children: [
                          Text(
                            "รายการสินค้า",
                            style: GoogleFonts.notoSansThaiLooped(
                                color: Colors.grey.shade700, fontSize: 12),
                          ),
                          Text(
                            " ${myFormat.format(shopDetailed.itemCount)} รายการ",
                            style: GoogleFonts.notoSansThaiLooped(
                                color: Colors.grey.shade900, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Get.find<TrackCtr>().clearLogContent();
                    Get.put(BrandCtr()).fetchShopData(data.shopId);
                    Get.put(BrandCtr()).resetVal();
                    // Get.to(() => const BrandStore());
                    Get.toNamed('/BrandStore/${data.shopId}');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: themeColorDefault)),
                      child: Text(
                        'ดูร้านค้า',
                        style: GoogleFonts.notoSansThaiLooped(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: themeColorDefault),
                      )),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}

productPriceMain(
    {required product_model.ProductPrice productPrices,
    required bool showPercent}) {
  if (!productPrices.haveDiscount) {
    return [
      Text(
        productPrices.priceBeforeDiscount.singleValue > 0
            ? '฿${myFormat.format(productPrices.priceBeforeDiscount.singleValue)} '
            : "฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMin)} - ${myFormat.format(productPrices.priceBeforeDiscount.rangeMax)}",
        style: GoogleFonts.notoSansThaiLooped(
          color: Colors.deepOrange.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      )
    ];
  } else {
    return [
      if (productPrices.price.singleValue > 0)
        Row(
          children: [
            Text(
              '฿${myFormat.format(productPrices.price.singleValue)} ',
              style: GoogleFonts.notoSansThaiLooped(
                  color: Colors.deepOrange.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  height: 1.2),
            ),
            if (productPrices.priceBeforeDiscount.singleValue > 0)
              Text(
                '฿${myFormat.format(productPrices.priceBeforeDiscount.singleValue)}',
                style: GoogleFonts.notoSansThaiLooped(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 14,
                    height: 2.6,
                    color: Colors.grey.shade400),
              )
            else
              Text(
                '฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMin)} - ฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMax)}',
                style: GoogleFonts.notoSansThaiLooped(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 14,
                    height: 2.6,
                    color: Colors.grey.shade400),
              ),
          ],
        )
      else
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '฿${myFormat.format(productPrices.price.rangeMin)} - ฿${myFormat.format(productPrices.price.rangeMax)}',
              style: GoogleFonts.notoSansThaiLooped(
                  color: Colors.deepOrange.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  height: 1.2),
            ),
            Text(
              '฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMin)} - ฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMax)}',
              style: GoogleFonts.notoSansThaiLooped(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 14,
                  height: 2.6,
                  color: Colors.grey.shade400),
            ),
          ],
        ),
      if (productPrices.discount > 0 && showPercent)
        Container(
          margin: const EdgeInsets.only(left: 2, top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.red.shade50,
          ),
          child: Text(
            '${productPrices.discount} %',
            style: GoogleFonts.notoSansThaiLooped(
                color: Colors.deepOrange, fontSize: 10, height: 1.4),
          ),
        )
    ];
  }
}

productPriceDetail(
    {required product_model.ProductDatail productDetail,
    required bool showPercent}) {
  if (!productDetail.haveDiscount) {
    // if (productDetail.discount <= 0) {
    return [
      Text(
        productDetail.priceBeforeDiscount.singleValue > 0
            ? '฿${myFormat.format(productDetail.priceBeforeDiscount.singleValue)} '
            : "฿${myFormat.format(productDetail.priceBeforeDiscount.rangeMin)} - ${myFormat.format(productDetail.priceBeforeDiscount.rangeMax)}",
        style: GoogleFonts.notoSansThaiLooped(
          color: Colors.deepOrange.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          height: 1.2,
        ),
      )
    ];
  } else {
    return [
      if (productDetail.price.singleValue > 0)
        Row(
          children: [
            Text(
              '฿${myFormat.format(productDetail.price.singleValue)} ',
              style: GoogleFonts.notoSansThaiLooped(
                color: Colors.deepOrange.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 24,
                height: 1.2,
              ),
            ),
            if (productDetail.priceBeforeDiscount.singleValue > 0)
              Text(
                '฿${myFormat.format(productDetail.priceBeforeDiscount.singleValue)}',
                style: GoogleFonts.notoSansThaiLooped(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 14,
                    height: 2.6,
                    color: Colors.grey.shade400),
              )
            else
              Text(
                '฿${myFormat.format(productDetail.priceBeforeDiscount.rangeMin)} - ฿${myFormat.format(productDetail.priceBeforeDiscount.rangeMax)}',
                style: GoogleFonts.notoSansThaiLooped(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 14,
                    height: 2.6,
                    color: Colors.grey.shade400),
              ),
          ],
        )
      else
        Row(
          children: [
            Text(
              '฿${myFormat.format(productDetail.price.rangeMin)} - ฿${myFormat.format(productDetail.price.rangeMax)}',
              style: GoogleFonts.notoSansThaiLooped(
                color: Colors.deepOrange.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 24,
                height: 1.2,
              ),
            ),
            Text(
              '฿${myFormat.format(productDetail.priceBeforeDiscount.rangeMin)} - ฿${myFormat.format(productDetail.priceBeforeDiscount.rangeMax)}',
              style: GoogleFonts.notoSansThaiLooped(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 14,
                  height: 2.6,
                  color: Colors.grey.shade400),
            ),
          ],
        ),

      //?
      if (productDetail.haveDiscount && showPercent)
        Container(
          margin: const EdgeInsets.only(left: 2, top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.red.shade50,
          ),
          child: Text(
            '${productDetail.discount} %',
            style: GoogleFonts.notoSansThaiLooped(
                color: Colors.deepOrange, fontSize: 10, height: 1.4),
          ),
        )
    ];
  }
}

class VideoWidget extends StatefulWidget {
  final String productId;
  final String videoUrl;
  final String thumbnail;

  const VideoWidget({
    super.key,
    required this.productId,
    required this.videoUrl,
    required this.thumbnail,
  });

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  void didUpdateWidget(covariant VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeVideo();
      _initVideo();
    }
  }

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _initVideo();
  }

  void _initVideo() {
    if (showProductCtr.videoCtr?[widget.productId] == null) {
      showProductCtr.videoCtr![widget.productId] =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
            ..initialize().then((_) {
              if (!mounted) return;
              setState(() {});
            })
            ..addListener(() {
              final isAtEnd = showProductCtr
                      .videoCtr![widget.productId]!.value.position >=
                  showProductCtr.videoCtr![widget.productId]!.value.duration;
              final isPlaying =
                  showProductCtr.videoCtr![widget.productId]!.value.isPlaying;

              if (!isPlaying &&
                  isAtEnd &&
                  showProductCtr.videoCtr![widget.productId]!.value.position
                          .inMilliseconds !=
                      0) {
                setState(() {});
              }
            });
    }
  }

  void _disposeVideo() {
    if (!mounted) return;
    final controller = showProductCtr.videoCtr![widget.productId];

    if (controller != null && controller.value.isInitialized) {
      controller.dispose();
      showProductCtr.videoCtr?.remove(widget.productId); // ลบออกจาก map
    }
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (showProductCtr.videoCtr != null &&
            showProductCtr.videoCtr![widget.productId] != null &&
            showProductCtr.videoCtr![widget.productId]!.value.isPlaying)
          Center(
            child: AspectRatio(
                aspectRatio: showProductCtr
                    .videoCtr![widget.productId]!.value.aspectRatio,
                child:
                    VideoPlayer(showProductCtr.videoCtr![widget.productId]!)),
          )
        else
          CachedNetworkImage(
            height: 350,
            imageUrl: widget.thumbnail,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return Icon(
                Icons.image_not_supported,
                color: Colors.grey.shade200,
                size: 100,
              );
            },
          ),
        if (showProductCtr.videoCtr != null &&
            showProductCtr.videoCtr![widget.productId] != null &&
            !showProductCtr.videoCtr![widget.productId]!.value.isPlaying)
          Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  if (showProductCtr
                      .videoCtr![widget.productId]!.value.isPlaying) {
                    showProductCtr.videoCtr![widget.productId]!.pause();
                  } else {
                    showProductCtr.videoCtr![widget.productId]!.play();
                  }
                });
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white, width: 0.5),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          )
      ],
    );
  }
}
