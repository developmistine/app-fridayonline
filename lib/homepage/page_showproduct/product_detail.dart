import 'dart:async';
import 'dart:convert';

import 'package:fridayonline/homepage/dialogalert/modal_shopping.dart';
import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/page_showproduct/product_media.dart';
// import 'package:fridayonline/homepage/page_showproduct/product_media.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/review/history_review.dart';
import 'package:fridayonline/homepage/review/show_media_review.dart';
import 'package:fridayonline/homepage/review/video_thumbnails.dart';
import 'package:fridayonline/homepage/theme/constants.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/product_detail/product_detail_model.dart';
import 'package:fridayonline/model/review/review_product_model.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/service/languages/multi_languages.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/service/review/review_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../controller/product_detail/product_detail_controller.dart';
import '../home/cache_image.dart';
import '../review/list_all_review.dart';
import '../widget/cartbutton.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.ref,
    required this.contentId,
  });
  final String ref;
  final String contentId;

  @override
  ProductDetailPageState createState() => ProductDetailPageState();
}

class ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  TabController? _builderPageController;
  // List<Widget>? _tabs;
  // List<Tab>? _tabItems;
  int selectedtabIndex = 0;
  final productCtl = Get.find<ProductDetailController>();
  VideoPlayerController? _controller;
  Future<void>? setVideo;
  ScrollController scrController = ScrollController();
  List<int> offset = [];
  Future<void>? _initializeVideoPlayerFuture(String urlVideo) {
    Uri url = Uri.parse(urlVideo);
    _controller = VideoPlayerController.networkUrl(url);
    setVideo = _controller!.initialize();
    return setVideo;
  }

  int count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _initTabController();
    print("ref : ${widget.ref}");
    print("contentId : ${widget.contentId}");
    // _preprareTabItems();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        count++;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.dispose();
    }
    productCtl.onClose();
    timer!.cancel();
  }

  setLogProduct(ProductDetailModel logData) {
    InteractionLogger.logProductInteraction(
        type: widget.ref,
        catalogId: logData.catalogId,
        contentId: widget.contentId,
        catalogType: logData.catalogType,
        catalogName: logData.catalogName,
        catalogImage: logData.catalogId == "" ? "" : logData.catalogImage,
        catalogIndex: logData.billPage,
        categoryId: logData.category,
        subCategoryId: logData.subCategory,
        categoryName: logData.categoryName,
        subCategoryName: logData.subCategoryName,
        productCode: logData.billCode,
        productBrand: logData.brandId,
        productCampaign: logData.catalogCamp == ""
            ? formatYearCamp(logData.billCamp)
            : logData.catalogCamp,
        productMedia: logData.media,
        productName: logData.billName,
        productImage: logData.productImages.image[0],
        productPrice: logData.specialPrice,
        productTime: count);
  }

  Future<void> shareLink(ProductDetailController product) async {
    SetData userData = SetData();
    var campaign =
        product.cacheProductDetail![product.indexPage.value].billCode;
    var channel = product.listChannel;
    var channelId = product.listChannelId;
    var repcode = await userData.repCode;
    var repseq = await userData.repSeq;
    var billname =
        product.cacheProductDetail![product.indexPage.value].billName;
    var price =
        product.cacheProductDetail![product.indexPage.value].specialPrice;
    if (channelId == '') {
      channelId = '""';
    }
    var fscode = product.cacheProductDetail![product.indexPage.value].fsCode;
    var billcamp =
        product.cacheProductDetail![product.indexPage.value].billCode;
    var uri =
        '$pathShare/product_sku/${encryptId(fscode)}/${encryptId(campaign)}/${encryptId(billcamp)}/${encryptId(channel)}/${encryptId(channelId)}/${encryptId(repcode)}/${encryptId(repseq)}?Type=EndUser&FirstLoad=true';
    // var uri =
    //     '$pathShare/product_sku/${encryptId(fscode)}/${encryptId(campaign)}/${encryptId(billcamp)}/${encryptId(channel)}/${encryptId(channelId)}/${encryptId(repcode)}/${encryptId(repseq)}?Type=EndUser&FirstLoad=true';
    await Share.share(
        "ลองเข้ามาดู $billname ราคา $price บาท รีบซื้อเลย ที่ฟรายเดย์เท่านั้น! 🔥 ${Uri.parse(uri)}");
  }

  encryptId(String id) {
    String encode = base64Encode(utf8.encode(id));
    return encode;
  }

  decryptId(String id) {
    String decode = utf8.decode(base64Decode(id));
    return decode;
  }

  _showWidgets(ProductDetailController detail) {
    double width = Get.width;
    late List<String> mediaUrls;
    late List<String> videoUrls;
    late List<String> imageUrls;

    return GetBuilder<ProductDetailController>(builder: (detail) {
      videoUrls = List<String>.from(detail.productDetail!.productImages.video);
      // videoUrls.addAll([
      //   "https://cdn.pixabay.com/video/2022/03/31/112468-694704563_large.mp4"
      // ]);
      imageUrls = List<String>.from(detail.productDetail!.productImages.image);
      // imageUrls.addAll([
      //   "https://gratisography.com/wp-content/uploads/2024/03/gratisography-funflower-800x525.jpg"
      // ]);

      mediaUrls = [...videoUrls, ...imageUrls];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 350,
            child: CarouselSlider.builder(
              itemCount: mediaUrls.length,
              autoSliderTransitionTime: const Duration(milliseconds: 500),
              unlimitedMode: mediaUrls.length > 1,
              slideBuilder: (index) {
                final url = mediaUrls[index];

                return InkWell(
                  onTap: () {
                    Get.to(() {
                      return ProductMedias(mediaUrls: mediaUrls, index: index);
                    });
                    // printWhite(mediaUrls);
                  },
                  child: videoUrls.contains(url)
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 350,
                              width: Get.width,
                              color: const Color(0XFFF5F5F5),
                            ),
                            VideoWidget(videoUrl: url)
                          ],
                        )
                      : Stack(
                          children: [
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: url,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            CacheImageNetPriceDetails(
                              url: detail.productDetail!.imgNetPrice,
                              flagNetPrice: detail.productDetail!.isNetprice,
                            ),
                            Positioned(
                                right: 14,
                                top: 10,
                                child: CacheImageAppendDetails(
                                  url: detail.productDetail!.imgOutOfStock,
                                  flagInstock: detail.productDetail!.isInStock,
                                )),
                          ],
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
            ),
          ),
          if (detail.productDetail!.productGroups.length > 1)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 2),
                  child: Text(
                    "${detail.productDetail!.productGroups.length} ตัวเลือก",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme_grey_text),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SizedBox(
                    height: 70,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: detail.productDetail!.productGroups.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              ProductGroup prdGroup =
                                  detail.productDetail!.productGroups[index];

                              productCtl.setProductDetailByProductGroup(
                                  prdGroup, index);
                            },
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: index ==
                                              detail.indexProductGroup.value
                                          ? 2
                                          : 1,
                                      color: index ==
                                              detail.indexProductGroup.value
                                          ? theme_color_df
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  width: 50,
                                  imageUrl: detail
                                      .productDetail!
                                      .productGroups[index]
                                      .productImages
                                      .image[0],
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          Container(
            height: 60,
            color: theme_color_df,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ราคา ${myFormat.format(detail.productDetail!.specialPrice)} บาท',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  // ?fade share
                  detail.productDetail!.isShareFlag
                      ? SizedBox(
                          height: 45,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                            ),
                            onPressed: () {
                              shareLink(detail);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  textAlign: TextAlign.center,
                                  'แชร์ให้เพื่อน ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Image.asset(
                                      'assets/images/icon/share.png',
                                      width: 25),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.productDetail!.billName,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      'รหัสสินค้า ${detail.productDetail!.billCode}',
                      style: TextStyle(
                          height: 1.8,
                          fontSize: 16,
                          color: setBillColor(detail.productDetail!.billColor)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    detail.productDetail!.isHousebrand
                        ? Image.asset(scale: 23, 'assets/images/home/HB.png')
                        : const SizedBox()
                  ],
                ),
                if (detail.productDetail!.limitDesc != '')
                  const SizedBox(
                    height: 4,
                  ),
                if (detail.productDetail!.limitDesc != '')
                  Text(
                    detail.productDetail!.limitDesc,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                detail.productDetail!.reviews.totalRatingCount == 0
                    ? const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text('ยังไม่มีคะแนน'),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: RichText(
                                  text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      text: detail
                                          .productDetail!.reviews.ratingStar
                                          .toString(),
                                      children: const [
                                    TextSpan(
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                        text: " / 5 ")
                                  ])),
                            ),
                            RatingBarIndicator(
                              itemSize: 18,
                              rating: detail.productDetail!.reviews.ratingStar,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, index) => Image.asset(
                                'assets/images/review/fullStar.png',
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
          Container(
            height: 8,
            color: const Color(0XFFF5F5F5),
          ),
          Container(
            height: 8,
            color: const Color(0XFFF5F5F5),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            selectedtabIndex = 0;
                          });
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'รายละเอียดสินค้า',
                                style: TextStyle(
                                    fontWeight: selectedtabIndex == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selectedtabIndex == 0
                                        ? theme_color_df
                                        : Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: selectedtabIndex == 0 ? 4 : 1,
                              width: Get.width,
                              color: selectedtabIndex == 0
                                  ? theme_color_df
                                  : Colors.black,
                              margin: const EdgeInsets.only(bottom: 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            selectedtabIndex = 1;
                          });
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'รีวิว (${detail.productDetail!.reviews.totalRatingCount})',
                                style: TextStyle(
                                    fontWeight: selectedtabIndex == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selectedtabIndex == 1
                                        ? theme_color_df
                                        : Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: selectedtabIndex == 1 ? 4 : 1,
                              width: Get.width,
                              color: selectedtabIndex == 1
                                  ? theme_color_df
                                  : Colors.black,
                              margin: const EdgeInsets.only(bottom: 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // _tabs![selectedtabIndex],
                selectedtabIndex == 0
                    ? const DetailWidgetProduct()
                    : ReviewWidget(
                        product: detail,
                        ref: widget.ref,
                        contentId: widget.contentId),
              ],
            ),
          ),
          Container(
            height: 8,
            color: const Color(0XFFF5F5F5),
          ),
          if (detail.productDetail!.relatedProducts.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width / 3.5,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0XFFD9D9D9),
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                    child: Text(
                      textAlign: TextAlign.center,
                      'สินค้าแนะนำ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    width: width / 3.5,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0XFFD9D9D9),
                    ),
                  )
                ],
              ),
            ),
          if (detail.productDetail!.relatedProducts.isNotEmpty)
            MasonryGridView.builder(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (Get.width >= 768.0) ? 3 : 2,
                ),
                itemCount: detail.productDetail!.relatedProducts.length,
                itemBuilder: (context, index) {
                  List<RelatedProduct>? prodcutJust =
                      detail.productDetail!.relatedProducts;
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            offset.add(scrController.offset.toInt());
                          });
                          selectedtabIndex = 0;
                          productCtl.indexPage.value += 1;
                          productCtl.indexProductGroup.value = 0;
                          productCtl.productDetailController(
                              prodcutJust[index].billCamp,
                              prodcutJust[index].billCode,
                              prodcutJust[index].media,
                              prodcutJust[index].fsCode,
                              productCtl.listChannel,
                              productCtl.listChannelId);
                          setLogProduct(productCtl.productDetail!);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: CacheImageProduct(
                                      url: prodcutJust[index].image),
                                ),
                                // if (show)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14.0, right: 14, bottom: 4, top: 8),
                                  child: Text(prodcutJust[index].billName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16)),
                                ),
                                //! fade review
                                if (prodcutJust[index]
                                        .reviews
                                        .totalRatingCount >
                                    0)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14.0,
                                        right: 14,
                                        bottom: 12,
                                        top: 0),
                                    child: Wrap(
                                      runAlignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          prodcutJust[index]
                                              .reviews
                                              .ratingStar
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'notoreg',
                                              inherit: false,
                                              color: theme_color_df,
                                              fontSize: 14),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0, left: 4, right: 4),
                                          child: Image.asset(
                                              scale: 1.8,
                                              'assets/images/home/star.png'),
                                        ),
                                        Text(
                                          '(${prodcutJust[index].reviews.totalRatingCount})',
                                          style: TextStyle(
                                              fontFamily: 'notoreg',
                                              inherit: false,
                                              color: theme_color_df,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  )
                              ]),
                        ),
                      ),
                    ),
                  );
                })
        ],
      );
    });
  }

  void _initTabController() {
    int arg = Get.arguments ?? 0;
    selectedtabIndex = arg == 0 ? 0 : arg;
    _builderPageController = TabController(
      length: 2,
      vsync: this,
      initialIndex: selectedtabIndex,
    );
    _builderPageController!.addListener(() {
      selectedtabIndex = _builderPageController!.index;
      setState(() {
        _builderPageController!.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: WillPopScope(
        onWillPop: () async {
          var indexc = 0;
          if (productCtl.indexPage.value > 0) {
            productCtl.removeLastId();
            productCtl.indexPage.value -= 1;
            indexc = productCtl.indexPage.value;
            productCtl.isDataLoading.value = true;
            productCtl.productDetail = productCtl.cacheProductDetail![indexc];
            List<ProductGroup> prdGroup =
                productCtl.productDetail!.productGroups;
            if (prdGroup.isNotEmpty) {
              productCtl.setProductDetailByProductGroup(prdGroup[0], 0);
            }
            scrController.jumpTo(offset[indexc].toDouble());
            productCtl.isDataLoading.value = false;
            productCtl.update();
            offset.removeLast();
            return false;
          } else {
            offset.clear();
            productCtl.removeAllArray();
            return true;
          }
        },
        child: SafeAreaProvider(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  var indexc = 0;
                  setLogProduct(productCtl.productDetail!);
                  if (productCtl.indexPage.value > 0) {
                    // setLogProduct(productCtl.productDetail!);
                    productCtl.removeLastId();
                    productCtl.indexPage.value -= 1;
                    indexc = productCtl.indexPage.value;
                    productCtl.isDataLoading.value = true;
                    productCtl.productDetail =
                        productCtl.cacheProductDetail![indexc];
                    List<ProductGroup> prdGroup =
                        productCtl.productDetail!.productGroups;
                    if (prdGroup.isNotEmpty) {
                      productCtl.setProductDetailByProductGroup(prdGroup[0], 0);
                    }
                    scrController.jumpTo(offset[indexc].toDouble());
                    productCtl.isDataLoading.value = false;
                    productCtl.update();
                    offset.removeLast();
                  } else {
                    offset.clear();
                    // setLogProduct(productCtl.productDetail!);
                    productCtl.removeAllArray();
                    Get.back();
                  }
                  // }
                },
              ),
              centerTitle: true,
              backgroundColor: theme_color_df,
              title: const Text(
                "รายการสินค้า",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CartIconButton(),
                ),
              ],
            ),
            // body: Center(child: Text('run'),),
            body: GetX<ProductDetailController>(builder: (detail) {
              if (!detail.isDataLoading.value) {
                if (detail.productDetail != null &&
                    detail.productDetail!.billCode != "") {
                  return SingleChildScrollView(
                      controller: scrController, child: _showWidgets(detail));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/logo/logofriday.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      const Text('ขออภัย สินค้าไม่มีการขาย'),
                      const Text('ในรอบนี้ค่ะ'),
                    ],
                  );
                }
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 350,
                        width: Get.width,
                        color: Colors.grey.withOpacity(0.1),
                        child: SizedBox(
                          width: 100,
                          child: Shimmer.fromColors(
                            highlightColor: kBackgroundColor,
                            baseColor: const Color(0xFFE0E0E0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.withOpacity(0.4)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: 60,
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Shimmer.fromColors(
                                highlightColor: kBackgroundColor,
                                baseColor: const Color(0xFFE0E0E0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.withOpacity(0.4)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Shimmer.fromColors(
                                highlightColor: kBackgroundColor,
                                baseColor: const Color(0xFFE0E0E0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.withOpacity(0.4)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 20,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      Container(
                          height: 100,
                          width: Get.width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                shimmerLoading(140, 14, 20),
                                const SizedBox(
                                  height: 10,
                                ),
                                shimmerLoading(140, 14, 20),
                                const SizedBox(
                                  height: 10,
                                ),
                                shimmerLoading(200, 14, 20),
                              ],
                            ),
                          )),
                      Divider(
                        thickness: 1,
                        height: 20,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerLoading(120, 18, 20),
                            Divider(
                              thickness: 1,
                              height: 20,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            shimmerLoading(Get.width, 100, 4),
                            const SizedBox(
                              height: 10,
                            ),
                            shimmerLoading(Get.width, 200, 4),
                            const SizedBox(
                              height: 10,
                            ),
                            shimmerLoading(Get.width, 200, 4),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              thickness: 1,
                              height: 20,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            shimmerLoading((Get.width / 2) - 15, 100, 4),
                            const SizedBox(
                              width: 10,
                            ),
                            shimmerLoading((Get.width / 2) - 15, 100, 4),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
            bottomNavigationBar:
                GetX<ProductDetailController>(builder: (detail) {
              return detail.isDataLoading.value
                  ? Container(
                      width: Get.width,
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 18),
                    )
                  : detail.productDetail != null &&
                          detail.productDetail!.billCode == ""
                      ? const SizedBox()
                      : Container(
                          height: 60,
                          color: theme_color_df,
                          child: InkWell(
                            onTap: () async {
                              // call เพื่อนำรูปและรายละเอียดมาโชว์
                              SetData userData = SetData();
                              String? lslogin;
                              lslogin = await userData.loginStatus;
                              if (lslogin == '1') {
                                Get.find<ProductDetailController>().countItems =
                                    1.obs;
                                // เรียกใช้งาน modal ตระกร้า
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  modalAddtoCart(
                                      context,
                                      detail.productDetail!,
                                      detail.listChannel,
                                      detail.listChannelId,
                                      widget.ref,
                                      widget.contentId);
                                });
                              } else {
                                Get.to(
                                    transition: Transition.rightToLeft,
                                    () => const Anonumouslogin());
                              }
                            },
                            child: Center(
                                child: Text(
                              MultiLanguages.of(context)!
                                  .translate('btn_add_to_cart'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'notoreg',
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        );
            }),
          ),
        ),
      ),
    );
  }

  SizedBox shimmerLoading(double width, double height, double radius) {
    return SizedBox(
      height: height,
      width: width,
      child: Shimmer.fromColors(
        highlightColor: kBackgroundColor,
        baseColor: const Color(0xFFE0E0E0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: Colors.grey.withOpacity(0.4)),
        ),
      ),
    );
  }
}

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    super.key,
    required this.product,
    required this.ref,
    required this.contentId,
  });
  final ProductDetailController product;
  final String ref;
  final String contentId;
  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  final subtitleText = TextStyle(fontSize: 12, color: theme_color_df);
  List<ReviewMedia>? reviewMedia = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getReview(widget.product.productDetail!.fsCode,
            widget.product.productDetail!.fsCodeTemp),
        builder: (context, AsyncSnapshot<ReviewsProduct?> snapshot) {
          if (snapshot.hasError) {
            return const SizedBox();
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Lottie.asset(
                'assets/images/loading.json',
                width: 80,
                height: 80,
              ));
            } else {
              final reviewsProduct = snapshot.data;
              if (reviewsProduct!.allRating.productReview.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                      'ยังไม่มีการรีวิว',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            RichText(
                                text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    text: reviewsProduct.totalRating.toString(),
                                    children: const [
                                  TextSpan(
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                      text: " / 5 ")
                                ])),
                            RatingBarIndicator(
                              itemSize: 18,
                              rating: reviewsProduct.totalRating,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, index) => Image.asset(
                                'assets/images/review/fullStar.png',
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => ListReview(
                                allReview: reviewsProduct,
                                ref: widget.ref,
                                contentId: widget.contentId));
                          },
                          child: Row(
                            children: [
                              const Text("ดูรีวิวทั้งหมด"),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: theme_color_df,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    ListView.builder(
                        itemCount:
                            reviewsProduct.allRating.productReview.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // primary: true,
                        itemBuilder: (context, index) {
                          if (index >= 4) {
                            return const SizedBox();
                          }
                          var review = reviewsProduct.allRating.productReview;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review[index].repName,
                                  style: TextStyle(
                                      height: 2,
                                      fontWeight: FontWeight.bold,
                                      color: theme_color_df),
                                ),
                                RatingBarIndicator(
                                  itemSize: 12,
                                  rating: review[index].productRating,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  itemBuilder: (context, index) => Image.asset(
                                    'assets/images/review/fullStar.png',
                                    color: Colors.amber,
                                  ),
                                ),
                                review[index].comment == ""
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          '- ไม่มีเนื้อหา -',
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          review[index].comment,
                                        ),
                                      ),
                                SizedBox(
                                  height: review[index].medialist.isNotEmpty
                                      ? 65
                                      : 0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: review[index].medialist.length,
                                    itemBuilder: (context, indexMedia) {
                                      final media = review[index]
                                          .medialist[indexMedia]
                                          .split('.')
                                          .last;
                                      var listImgType = [
                                        'jpg',
                                        'jpeg',
                                        'png',
                                        'webp'
                                      ];
                                      reviewMedia!.add(ReviewMedia(
                                          mediaType: !listImgType.contains(
                                                  review[index]
                                                      .medialist[indexMedia]
                                                      .split(".")
                                                      .last)
                                              ? "2" // video
                                              : "1", //imgage
                                          url: review[index]
                                              .medialist[indexMedia],
                                          key: index));

                                      if (indexMedia < 3) {
                                        return !listImgType.contains(media)
                                            ? InkWell(
                                                onTap: () {
                                                  Get.to(() => ShowMediaReview(
                                                      indexMedia,
                                                      review[index]
                                                          .medialist
                                                          .length,
                                                      reviewMedia!
                                                          .where((element) =>
                                                              element.key ==
                                                              index)
                                                          .toList()));
                                                },
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      width: 65,
                                                      height: 65,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 4),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                      ),
                                                      child: AspectRatio(
                                                        aspectRatio: 1,
                                                        child: VideoThumbnails(
                                                          path: review[index]
                                                                  .medialist[
                                                              indexMedia],
                                                        ),
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.play_arrow_rounded,
                                                      color: Colors.white,
                                                      size: 30,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4.0),
                                                child: Container(
                                                  width: 65,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8)),
                                                      border: Border.all(
                                                          color:
                                                              theme_color_df)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.to(() => ShowMediaReview(
                                                            indexMedia,
                                                            review[index]
                                                                .medialist
                                                                .length,
                                                            reviewMedia!
                                                                .where((element) =>
                                                                    element
                                                                        .key ==
                                                                    index)
                                                                .toList()));
                                                      },
                                                      child: CachedNetworkImage(
                                                          imageUrl: review[
                                                                      index]
                                                                  .medialist[
                                                              indexMedia]),
                                                    ),
                                                  ),
                                                ),
                                              );
                                      } else if (indexMedia == 3) {
                                        return !listImgType.contains(media)
                                            ? InkWell(
                                                onTap: () {
                                                  Get.to(() => ShowMediaReview(
                                                      indexMedia,
                                                      review[index]
                                                          .medialist
                                                          .length,
                                                      reviewMedia!
                                                          .where((element) =>
                                                              element.key ==
                                                              index)
                                                          .toList()));
                                                },
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    ColorFiltered(
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                              Colors.grey
                                                                  .shade400,
                                                              BlendMode.darken),
                                                      child: Container(
                                                        width: 55,
                                                        margin: const EdgeInsets
                                                            .only(right: 4),
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                        ),
                                                        child: AspectRatio(
                                                          aspectRatio: 1,
                                                          child:
                                                              VideoThumbnails(
                                                            path: review[index]
                                                                    .medialist[
                                                                indexMedia],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '+ ${review[index].medialist.length - indexMedia}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 24),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  Get.to(() => ShowMediaReview(
                                                      indexMedia,
                                                      review[index]
                                                          .medialist
                                                          .length,
                                                      reviewMedia!
                                                          .where((element) =>
                                                              element.key ==
                                                              index)
                                                          .toList()));
                                                },
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    ColorFiltered(
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                              Colors.grey
                                                                  .shade400,
                                                              BlendMode
                                                                  .modulate),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 4.0),
                                                        child: Container(
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          width: 55,
                                                          height: 55,
                                                          decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          child: InkWell(
                                                            onTap: () {
                                                              Get.to(() => ShowMediaReview(
                                                                  indexMedia,
                                                                  review[index]
                                                                      .medialist
                                                                      .length,
                                                                  reviewMedia!
                                                                      .where((element) =>
                                                                          element
                                                                              .key ==
                                                                          index)
                                                                      .toList()));
                                                            },
                                                            child: CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                imageUrl: review[
                                                                            index]
                                                                        .medialist[
                                                                    indexMedia]),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '+ ${review[index].medialist.length - indexMedia}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 24),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "จำนวน ${reviewsProduct.allRating.productReview[index].unit} ชิ้น",
                                          style: subtitleText,
                                        ),
                                        const VerticalDivider(
                                          thickness: 1,
                                        ),
                                        Text(
                                          "คุณภาพ ${reviewsProduct.allRating.productReview[index].productRating}",
                                          style: subtitleText,
                                        ),
                                        RatingBar(
                                          ignoreGestures: true,
                                          itemSize: 12,
                                          initialRating: 1,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          glow: false,
                                          itemCount: 1,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                          onRatingUpdate: (_) {},
                                          ratingWidget: RatingWidget(
                                            full: Image.asset(
                                                'assets/images/review/fullStar.png'),
                                            half: Image.asset(
                                                'assets/images/review/halfStar.png'),
                                            empty: Image.asset(
                                                'assets/images/review/emptyStar.png'),
                                          ),
                                        ),
                                        Text(
                                          "ขนส่ง ${reviewsProduct.allRating.productReview[index].deliveryRating}",
                                          style: subtitleText,
                                        ),
                                        RatingBar(
                                          ignoreGestures: true,
                                          itemSize: 12,
                                          initialRating: 1,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          glow: false,
                                          itemCount: 1,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                          onRatingUpdate: (_) {},
                                          ratingWidget: RatingWidget(
                                            full: Image.asset(
                                                'assets/images/review/fullStar.png'),
                                            half: Image.asset(
                                                'assets/images/review/halfStar.png'),
                                            empty: Image.asset(
                                                'assets/images/review/emptyStar.png'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //? การคอมเม้นตอบกลับ
                                AdminReply(
                                  paddingReviewLeft: 8.0,
                                  listReview: reviewsProduct
                                      .allRating.productReview[index],
                                )
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              );
            }
          }
        });
  }
}

class DetailWidgetProduct extends StatelessWidget {
  const DetailWidgetProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetBuilder<ProductDetailController>(builder: (detail) {
        return Column(
          children: [
            HtmlWidget(
              '''
              ${detail.productDetail!.description}
              ''',
              customStylesBuilder: (element) {
                if (element.classes.contains('foo')) {
                  return {'color': 'red'};
                }

                return null;
              },
              onErrorBuilder: (context, element, error) {
                return Container();
              },
              customWidgetBuilder: (element) {
                if (element.localName == 'img') {
                  var src = element.attributes['src'];
                  // check image error status code 404
                  if (src != null) {
                    // ตรวจสอบ URL และจัดการเมื่อเกิดข้อผิดพลาด เช่น 404 (Not Found)
                    return CachedNetworkImage(
                      imageUrl: src,
                      errorWidget: (context, url, error) =>
                          const SizedBox(), // ตัวอย่างการกำหนด Widget ที่แสดงเมื่อเกิดข้อผิดพลาด
                    );
                  }
                }

                if (element.localName == 'div') {
                  // check children is iframe
                  for (var element2 in element.children) {
                    if (element2.localName == 'iframe') {
                      element.attributes.remove('style');
                    }
                  }
                }

                return null;
              },
              enableCaching: true,
              onLoadingBuilder: (context, element, loadingProgress) =>
                  Container(),
              textStyle: const TextStyle(fontSize: 16),
              // webView: true,
            ),
          ],
        );
      }),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  const VideoWidget({super.key, required this.videoUrl});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {}); // เรียก setState เพื่ออัพเดท UI หลังจากวิดีโอโหลดเสร็จ
        // _controller.play(); // เล่นวิดีโออัตโนมัติ
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                if (!_controller.value.isPlaying)
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    child: Center(
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
                else
                  Center(
                    child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                        )),
                  )
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator.adaptive());
  }
}
