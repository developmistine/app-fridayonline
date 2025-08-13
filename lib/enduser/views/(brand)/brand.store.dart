import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/appbar/appbar.brand.dart';
import 'package:fridayonline/enduser/components/home/flashdeal.dart';
import 'package:fridayonline/enduser/components/profile/myreview/myrating.card.dart';
import 'package:fridayonline/enduser/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/enduser/components/shimmer/shimmer.product.dart';
import 'package:fridayonline/enduser/components/showproduct/showproduct.category.dart';
import 'package:fridayonline/enduser/controller/brand.ctr.dart';
import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/controller/category.ctr.dart';
import 'package:fridayonline/enduser/controller/chat.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/enduser/models/chat/seller.list.model.dart';
import 'package:fridayonline/enduser/models/home/home.content.model.dart';
import 'package:fridayonline/enduser/services/chat/chat.service.dart';
import 'package:fridayonline/enduser/services/coupon/coupon.services.dart';
import 'package:fridayonline/enduser/utils/cached_image.dart';
import 'package:fridayonline/enduser/utils/event.dart';
import 'package:fridayonline/enduser/utils/format.dart';
import 'package:fridayonline/enduser/views/(anonymous)/signin.dart';
import 'package:fridayonline/enduser/views/(brand)/brand.category.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.main.dart';
import 'package:fridayonline/enduser/views/(chat)/chat.seller.dart';
import 'package:fridayonline/enduser/views/(coupon)/coupon.detail.dart';
import 'package:fridayonline/enduser/views/(flashdeal)/shop.flashdeal.deail.dart';
import 'package:fridayonline/enduser/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/safearea.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:fridayonline/enduser/models/brands/shopcontent.model.dart'
    as shop;
import 'package:fridayonline/enduser/models/category/sort.model.dart' as sort;

// final ShowProductCategoryCtr showProductCtr = Get.find();
final BrandCtr brandCtr = Get.find<BrandCtr>();
final CategoryCtr categoryCtr = Get.find();

class Store extends StatefulWidget {
  final String storeId;
  const Store({super.key, required this.storeId});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  void initState() {
    super.initState();
    brandCtr.resetVal();
  }

  @override
  void dispose() {
    // brandCtr.resetVal();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: BrandStore());
  }
}

class BrandStore extends StatefulWidget {
  const BrandStore({super.key});

  @override
  State<BrandStore> createState() => _BrandStoreState();
}

class _BrandStoreState extends State<BrandStore>
    with SingleTickerProviderStateMixin {
  final scrCtrl = ScrollController();
  int tapActive = 0;
  int offset = 40;
  final CarouselSliderController carouselCtr = CarouselSliderController();

  setTapActive(tap) {
    if (tap == tapActive) return;
    var tapParams = Get.parameters;
    var sectionId = int.tryParse(tapParams["sectionId"] ?? "") ?? 0;
    if (tap != 1) {
      Get.parameters.clear();
    }

    if (Get.arguments == 1 || tap == 999) {
      brandCtr.fetchShopProductFilter(
          sectionId,
          brandCtr.shopIdVal,
          categoryCtr.sortData == null
              ? "ctime"
              : categoryCtr.sortData!.data.first.sortBy,
          "",
          0);
    } else {
      brandCtr.fetchShopProductFilter(
          brandCtr.sectionIdVal,
          brandCtr.shopIdVal,
          categoryCtr.sortData == null
              ? "ctime"
              : categoryCtr.sortData!.data.first.sortBy,
          "",
          0);
    }

    setState(() {
      if (tap == 999) {
        tap = 1;
      }
      tapActive = tap;
      sectionId = 0;
    });
    setPauseVideo();
  }

  tapSort(int index, sort.Datum items) {
    brandCtr.setActiveTab(index);
    offset = 40;
    if (items.subLevels.isNotEmpty) {
      brandCtr.isPriceUp.value = !brandCtr.isPriceUp.value;
      brandCtr
          .fetchShopProductFilter(
              brandCtr.sectionIdVal,
              brandCtr.shopIdVal,
              items.sortBy,
              brandCtr.isPriceUp.value
                  ? items.subLevels.last.order
                  : items.subLevels.first.order,
              0)
          .then((res) {
        scrCtrl.animateTo(151,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      });
    } else {
      brandCtr.orderByVal = "";
      brandCtr
          .fetchShopProductFilter(
              brandCtr.sectionIdVal, brandCtr.shopIdVal, items.sortBy, "", 0)
          .then((res) {
        scrCtrl.animateTo(151,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      });
    }
  }

  Map<String, VideoPlayerController> videoControllers = {};

  Future<VideoPlayerController> setVideoContent(
      shop.ContentDetail content) async {
    // ตรวจสอบว่า VideoPlayerController ถูกสร้างแล้วหรือยัง
    if (videoControllers.containsKey(content.image)) {
      return videoControllers[content.image]!;
    }

    // สร้าง VideoPlayerController ใหม่หากยังไม่มี
    VideoPlayerController videoCtr = VideoPlayerController.networkUrl(
      Uri.parse(content.image),
    );

    await videoCtr.initialize().then((value) {
      videoCtr.setVolume(0);
      videoCtr.play();
    });

    // เก็บ controller นี้ไว้ใน map สำหรับใช้งานครั้งต่อไป
    videoControllers[content.image] = videoCtr;

    return videoCtr;
  }

  int count = 0;

  @override
  void initState() {
    super.initState();
    var tapArg = Get.arguments;
    var tapParams = Get.parameters;
    var viewType = int.tryParse(tapParams["viewType"] ?? "") ?? 0;
    var sectionId = int.tryParse(tapParams["sectionId"] ?? "") ?? 0;
    if (tapParams["viewType"] != null && viewType == 0) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        brandCtr.scrollToSection(brandCtr.shopIdVal, sectionId);
      });
    } else if (tapArg != null && tapArg != 0) {
      Future.delayed(const Duration(microseconds: 500), () async {
        setTapActive(tapArg);
      });
    }

    scrCtrl.addListener(() {
      if (scrCtrl.position.pixels == scrCtrl.position.maxScrollExtent &&
          tapActive == 1) {
        fetchMoreProductContent();
      }

      // คำนวณค่า opacity ตาม scroll offset
      double offset = scrCtrl.offset;
      final double mobileHeight = Get.height;
      bool shouldSetAppbar;
      if (tapActive == 0) {
        if (mobileHeight >= 784) {
          shouldSetAppbar = offset > 135;
        } else {
          shouldSetAppbar = offset > 120;
        }
      } else {
        if (mobileHeight >= 784) {
          shouldSetAppbar = offset > 150;
        } else {
          shouldSetAppbar = offset > 111.5;
        }
      }

      double newValue =
          offset / 80; // ค่าของ opacity จะเพิ่มขึ้นตาม scroll offset
      if (newValue < 0) newValue = 0; // ไม่ให้ค่าเกิน 1
      if (newValue > 1) newValue = 1; // ไม่ให้ค่าเกิน 1

      // เพิ่มเงื่อนไขการตรวจสอบการเปลี่ยนแปลงค่าที่สำคัญ
      bool opacityChanged = (newValue != brandCtr.opacity.value);
      bool appbarChanged = (shouldSetAppbar != brandCtr.showSort.value);

      if (opacityChanged || appbarChanged) {
        brandCtr.opacity.value = newValue; // อัปเดตค่า opacity
        brandCtr.isSetAppbar.value = brandCtr.opacity.value == 1;
        if (shouldSetAppbar != brandCtr.showSort.value) {
          brandCtr.showSort.value = shouldSetAppbar;
        }
      }
    });
  }

  void fetchMoreProductContent() async {
    brandCtr.isLoadingMore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newProductFilter = await brandCtr.fetchMoreShopProductFilter(
          brandCtr.sectionIdVal,
          brandCtr.shopIdVal,
          brandCtr.sortByVal,
          brandCtr.orderByVal,
          offset);

      if (newProductFilter!.data.products.isNotEmpty) {
        brandCtr.shopProductFilter!.data.products
            .addAll(newProductFilter.data.products);
        offset += 40;
      }
    } finally {
      brandCtr.isLoadingMore.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!mounted) {
      return;
    }

    scrCtrl.dispose();
    brandCtr.resetShopProductFilter();
    // categoryCtr.activeCat.value = -9;
    // brandCtr.resetVal();
    videoControllers.forEach((key, value) {
      value.dispose();
    });
  }

  setPauseVideo() {
    if (!mounted) return;
    videoControllers.forEach((key, value) {
      value.pause();
    });
  }

  final ChatController chatController = Get.put(ChatController());

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
                )),
            child: SafeAreaProvider(
              child: Scaffold(
                backgroundColor: Colors.grey.shade100,
                body: Obx(() {
                  if (brandCtr.isLoadingShop.value) {
                    return loadingShop(context);
                  }
                  if (brandCtr.shopInfo!.code == "-9") {
                    return nodataStore();
                  }
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        controller: scrCtrl,
                        physics: const ClampingScrollPhysics(),
                        child: Stack(
                          clipBehavior: Clip.antiAlias,
                          children: [
                            Stack(
                              children: [
                                backgroundStore(),
                                detailStore(),
                                Positioned(
                                  top: 110,
                                  right: 20,
                                  child: InkWell(
                                    onTap: () async {
                                      final webSocketController =
                                          Get.put(WebSocketController());
                                      SetData data = SetData();

                                      // ตั้ง listener
                                      var custId = await data.b2cCustID;
                                      if (custId == 0) {
                                        Get.to(() => const SignInScreen());
                                        return;
                                      }

                                      // webSocketController.onClose();
                                      // await webSocketController
                                      //     .connectWebSocket();

                                      var res = await addChatRoomService(
                                          brandCtr.shopInfo!.data.shopId);
                                      chatController.openChatRoom.value =
                                          res.data.chatRoomId;
                                      final message = {
                                        "event": "customer_readall_message",
                                        "receiver_id": res.data.sellerId,
                                        "is_me": true,
                                        "message_data": {
                                          "chat_room_id": res.data.chatRoomId,
                                          "sender_role": "customer",
                                          "sender_id": await data.b2cCustID
                                        }
                                      };
                                      webSocketController.channel!.sink
                                          .add(jsonEncode(message));
                                      Get.to(() => ChatAppWithSeller(
                                            shop: SellerChat(
                                                chatRoomId: res.data.chatRoomId,
                                                customerId: custId,
                                                customerName: '',
                                                customerImage: '',
                                                sellerId: res.data.sellerId,
                                                sellerName: brandCtr
                                                    .shopInfo!.data.shopName,
                                                sellerImage: brandCtr.shopInfo!
                                                    .data.account.image,
                                                messageType: 1,
                                                messageText: '',
                                                lastSend: '',
                                                unRead: 0),
                                            channel:
                                                webSocketController.channel!,
                                          ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/b2c/chat/chat-white.png",
                                            width: 18,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Text(
                                            'พูดคุย',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 164),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8))),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    tabBar(setTapActive, tapActive),
                                    if (tapActive == 0) listCoupon(),
                                    if (tapActive == 0) flashSale(),
                                    if (tapActive == 0) shopContent(),
                                    if (tapActive == 1) sortProduct(),
                                    if (tapActive == 1) listProduct(),
                                    if (tapActive == 2) shopCategory(),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      // if (brandCtr.opacity.value > 0)
                      Positioned(
                        top: -10,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Obx(() {
                              return appbarBrand(
                                  ctx: context,
                                  title: 'รายละเอียดสินค้า',
                                  isSetAppbar: brandCtr.isSetAppbar.value,
                                  opacity: brandCtr.opacity.value,
                                  showSort: brandCtr.showSort.value,
                                  tabbar: tabBar(setTapActive, tapActive));
                            }),
                            if (tapActive == 1 && brandCtr.opacity.value > 0)
                              Obx(() {
                                return AnimatedOpacity(
                                  opacity: brandCtr.showSort.value ? 1 : 0,
                                  duration: const Duration(milliseconds: 100),
                                  child: sortProduct(),
                                );
                              }),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            )));
  }

  Widget shopCategory() {
    return Obx(() {
      if (brandCtr.isLoadingShopCategory.value) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
      if (brandCtr.shopCategory!.data.isEmpty) {
        return SizedBox(
          height: Get.height / 1.5,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/search/zero_search.png',
                width: 150,
              ),
              const Text('ไม่พบข้อมูล'),
            ],
          )),
        );
      }
      var items = brandCtr.shopCategory!.data;
      return Column(
        children: [
          InkWell(
            onTap: () {
              setTapActive(999);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "สินค้าทั้งหมด",
                        style: GoogleFonts.notoSansThaiLooped(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade400,
                      size: 14,
                    )
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              primary: false,
              itemCount: items.length,
              itemBuilder: (context, index) {
                var data = items[index];
                return Container(
                    padding: const EdgeInsets.all(8),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            brandCtr.fetchShopProductFilter(
                                data.catid,
                                brandCtr.shopIdVal,
                                categoryCtr.sortData!.data.first.sortBy,
                                "",
                                0);
                            setTapActive(1);
                            //     .then((res) async {
                            //   await Get.to(() => const ShowProductBrands());
                            // });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    data.catname,
                                    style: GoogleFonts.notoSansThaiLooped(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey.shade400,
                                  size: 14,
                                )
                              ],
                            ),
                          ),
                        ),
                        if (data.subCategories.isNotEmpty) const Divider(),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: data.subCategories.length,
                          itemBuilder: (context, subIndex) {
                            var sub = data.subCategories[subIndex];
                            return InkWell(
                              onTap: () async {
                                brandCtr
                                    .fetchShopProductFilter(
                                        sub.subcatId,
                                        brandCtr.shopIdVal,
                                        categoryCtr.sortData!.data.first.sortBy,
                                        "",
                                        0)
                                    .then((res) async {
                                  await Get.to(() => const ShowProductBrands());
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CachedNetworkImage(
                                        imageUrl: sub.image,
                                        errorWidget: (context, url, error) {
                                          return const Icon(Icons.shopify);
                                        },
                                      )),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                sub.displayName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts
                                                    .notoSansThaiLooped(
                                                        fontSize: 13),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey.shade400,
                                                size: 14,
                                              )
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ));
              }),
        ],
      );
    });
  }

  Widget shopContent() {
    return Obx(() {
      if (brandCtr.isLoadingShopContent.value) {
        return loadingShopContent();
      }

      if (brandCtr.shopContent!.data.isEmpty) {
        return Container(
          width: Get.width,
          height: Get.height / 1.4,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/search/zero_search.png',
                  width: 150,
                ),
                const Text('ไม่พบข้อมูล'),
              ]),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 40),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: brandCtr.shopContent!.data.length,
        itemBuilder: (context, index) {
          var items = brandCtr.shopContent!.data[index];
          // ใช้ keys จาก cache
          // final keys = brandCtr
          //     .sectionKeysCache[brandCtr.shopInfo!.data.shopId.toString()];
          // final key = keys != null && index < keys.length ? keys[index] : null;
          return Builder(
            // key: key,
            key: ValueKey(
                'shop_${brandCtr.shopInfo!.data.shopId}_section_${items.contentDetail.first.contentId}'),

            builder: (context) {
              if (items.contentType == 1) {
                //? แสดงเป็น list บนลงล่าง
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  ...List.generate(items.contentDetail.length, (idx) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (items.contentDetail[idx].actionType != 1) {
                          setPauseVideo();
                        }
                        eventshopContent(items.contentDetail[idx]);
                      },
                      child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          child: CacheImageContentShop(
                            url: items.contentDetail[idx].image,
                          )),
                    );
                  }),
                ]);
              } else if (items.contentType == 2) {
                //? แสดงเป็น list slide ซ้าย-ขวา
                return Stack(
                  children: [
                    Container(
                      width: Get.width,
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: CarouselSlider.builder(
                        carouselController: carouselCtr,
                        itemCount: items.contentDetail.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          var data = items.contentDetail[itemIndex];
                          return InkWell(
                            onTap: () {
                              if (data.actionType != 1) {
                                setPauseVideo();
                              }
                              eventshopContent(data);
                            },
                            child: CacheImageContentShop(
                              url: data.image,
                              // fit: BoxFit.cover,
                            ),
                          );
                        },
                        options: CarouselOptions(
                            aspectRatio: 2.4,
                            viewportFraction: 1,
                            autoPlay: items.contentDetail.length > 1,
                            onPageChanged: (index, reason) {
                              brandCtr.current.value = index;
                            }),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(items.contentDetail.length, (index) {
                          return GestureDetector(
                            onTap: () => carouselCtr.animateToPage(index),
                            child: Obx(() {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: (brandCtr.current.value == index
                                            ? Colors.white
                                            : Colors.grey.shade400)
                                        .withOpacity(
                                            brandCtr.current.value == index
                                                ? 0.9
                                                : 0.5)),
                              );
                            }),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              } else if (items.contentType == 3) {
                //? แสดงเป็น banner และ รายการสินค้าแบบ slide
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 4),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: items.contentDetail.length,
                    itemBuilder: (BuildContext context, int index) {
                      var detail = items.contentDetail[index];
                      if (detail.productContent.isEmpty) {
                        return const SizedBox();
                      }
                      List<Widget> productList = List.generate(
                        detail.productContent.length > 14
                            ? 14
                            : detail.productContent.length,
                        (productItemIndex) {
                          return ProductItems(
                              product: detail.productContent[productItemIndex],
                              setPauseVideo: setPauseVideo);
                        },
                      );
                      productList.addIf(
                          detail.productContent.length >= 9,
                          InkWell(
                            onTap: () {
                              brandCtr.fetchShopProductFilter(
                                  detail.contentId,
                                  brandCtr.shopIdVal,
                                  categoryCtr.sortData!.data.first.sortBy,
                                  "",
                                  0);
                              setState(() {
                                tapActive = 1;
                              });
                            },
                            child: Container(
                              width: 104,
                              height: 158,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              color: themeColorDefault)),
                                      child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: themeColorDefault)),
                                  Text(
                                    'ดูเพิ่มเติม',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: themeColorDefault,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ));
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (detail.showContentName)
                              Text(
                                detail.contentName,
                                style: GoogleFonts.notoSansThaiLooped(
                                    fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: productList,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else if (items.contentType == 4) {
                // return Text('type 4');
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          items.contentDetail.length,
                          (index) => InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  if (items.contentDetail[index].actionType !=
                                      1) {
                                    setPauseVideo();
                                  }
                                  eventshopContent(items.contentDetail[index]);
                                },
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  width: 100,
                                  margin: const EdgeInsets.only(
                                      bottom: 8, right: 8),
                                  child: CacheImageContentShop(
                                      url: items.contentDetail[index].image),
                                ),
                              ))),
                );
              } else if (items.contentType == 5) {
                //? แสดงเป็น video
                return Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    ...List.generate(items.contentDetail.length, (index) {
                      return FutureBuilder<VideoPlayerController>(
                        future: setVideoContent(items.contentDetail[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 200,
                            );
                          }
                          if (snapshot.hasError) {
                            return const SizedBox();
                          }
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          }

                          final controller = snapshot.data!;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (controller.value.isPlaying) {
                                        controller.pause();
                                      } else {
                                        controller.play();
                                      }
                                    },
                                    child: VideoPlayer(controller),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        constraints:
                                            const BoxConstraints(maxWidth: 28),
                                        icon: const Icon(Icons.fullscreen),
                                        color: Colors.white,
                                        onPressed: () {
                                          Get.to(() => FullScreenVideoPlayer(
                                              videoUrl: items
                                                  .contentDetail[index].image));
                                        },
                                      ),
                                      Obx(() {
                                        return IconButton(
                                          icon: Icon(
                                            brandCtr.volume.value == 0
                                                ? Icons.volume_off
                                                : Icons.volume_down,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            // เปลี่ยนค่าของ volume ตามที่กด
                                            controller.setVolume(
                                                controller.value.volume != 0
                                                    ? 0
                                                    : 1);
                                            brandCtr.volume.value =
                                                controller.value.volume;
                                          },
                                        );
                                      })
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(items.contentDetail.length, (index) {
                      var text = items.contentDetail[index];
                      return HtmlWidget(
                        text.contentName,
                        // style: GoogleFonts.notoSansThaiLooped(fontSize: 13),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      );
    });
  }

  Widget loadingShopContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(width: 0.2, color: Colors.grey.shade300)),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    width: Get.width,
                    height: 140,
                  ),
                ),
                Icon(
                  Icons.shopify,
                  color: Colors.grey.shade300,
                )
              ],
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List.generate(12, (index) {
                  return SizedBox(
                    width: 140,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                height: 120,
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 50,
                                  color: Colors.grey.shade100,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ShimmerCard(
                              width: Get.width,
                              height: 8,
                              radius: 8,
                              color: Colors.grey.shade100,
                            ),
                            const SizedBox(height: 4),
                            ShimmerCard(
                              width: Get.width,
                              height: 8,
                              radius: 8,
                              color: Colors.grey.shade100,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  );
                }))),
            const SizedBox(
              height: 4,
            ),
            for (var i = 0; i < 2; i++)
              Stack(
                alignment: Alignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizedBox(
                      width: Get.width,
                      height: 140,
                    ),
                  ),
                  Icon(
                    Icons.shopify,
                    color: Colors.grey.shade300,
                  )
                ],
              ),
          ],
        ),
      ),
    ]);
  }

  Widget detailStore() {
    return Positioned(
      top: 110,
      left: 10,
      child: Builder(builder: (context) {
        var items = brandCtr.shopInfo!.data;
        return Row(
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
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(50)),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: items.account.image,
                      errorWidget: (context, url, error) {
                        return const Icon(Icons.shopify);
                      },
                    ),
                  ),
                ),
                if (items.isShopOfficial)
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 230),
                  child: Text(
                    items.shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansThaiLooped(
                        color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "เข้าร่วมเมื่อ ${items.account.dateJoined}",
                      style: GoogleFonts.notoSansThaiLooped(
                          color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      " |  รายการสินค้า (${items.itemCount})",
                      style: GoogleFonts.notoSansThaiLooped(
                          color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget backgroundStore() {
    return Builder(builder: (context) {
      return Stack(
        children: [
          SizedBox(
            width: Get.width,
            child: CachedNetworkImage(
              imageUrl: brandCtr.shopInfo!.data.cover,
              height: 170,
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                color: Colors.black.withOpacity(0.4), // สีขาวโปร่งแสง 50%
              ),
            ),
          )
        ],
      );
    });
  }

  Widget listProduct() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (brandCtr.isLoadingShopProductFilter.value) {
              return MasonryGridView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  shrinkWrap: true,
                  primary: false,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
                  ),
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return const ShimmerProductItem();
                  });
            } else if (brandCtr.shopProductFilter!.data.products.isEmpty) {
              return SizedBox(
                  height: Get.height / 1.5,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/search/zero_search.png',
                        width: 150,
                      ),
                      const Text('ไม่พบข้อมูล'),
                    ],
                  ));
            }
            return MasonryGridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                shrinkWrap: true,
                primary: false,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
                ),
                itemCount: brandCtr.shopProductFilter!.data.products.length +
                    (brandCtr.isLoadingMore.value ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index ==
                          brandCtr.shopProductFilter!.data.products.length &&
                      brandCtr.isLoadingMore.value) {
                    return const SizedBox.shrink();
                  }
                  return ProductCategoryComponents(
                      item: brandCtr.shopProductFilter!.data.products[index],
                      referrer: 'shop_product');
                });
          }),
        ],
      ),
    );
  }

  Widget listCoupon() {
    return Obx(() {
      if (brandCtr.isLoadingShopVouchers.value) {
        return Container(
          margin: const EdgeInsets.all(4),
          color: Colors.white,
          height: 90,
        );
      }
      if (brandCtr.shopVouchers!.code == "-9") {
        return const SizedBox();
      }
      return Container(
        color: Colors.white,
        margin: const EdgeInsets.all(4),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  ...List.generate(
                      brandCtr.shopVouchers!.data.voucherList.length, (index) {
                    var coupon = brandCtr.shopVouchers!.data.voucherList[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: Row(children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  width: 65,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        coupon.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.notoSansThaiLooped(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      "ขั้นต่ำ ฿${myFormat.format(coupon.rewardInfo.minSpend)}",
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          coupon.timeInfo.timeFormat,
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => CouponDetail(
                                                couponId: coupon.couponId));
                                          },
                                          child: Text(
                                            'เงื่อนไข',
                                            style: TextStyle(
                                              color: themeColorDefault,
                                              fontSize: 10,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Builder(builder: (context) {
                                if (coupon.quotaInfo.fullyClaimed ||
                                    coupon.quotaInfo.fullyUsed) {
                                  return SizedBox(
                                      width: 70,
                                      child: Image.asset(
                                          'assets/images/coupon/coupon_sold_out.png'));
                                } else if (coupon.userStatus.isUsed) {
                                  return SizedBox(
                                      width: 70,
                                      child: Image.asset(
                                          'assets/images/coupon/coupon_used.png'));
                                } else if (!coupon.userStatus.isClaimed) {
                                  return InkWell(
                                    onTap: () async {
                                      SetData data = SetData();
                                      if (await data.b2cCustID == 0) {
                                        Get.to(() => const SignInScreen());
                                        return;
                                      }
                                      var res = await addVoucherItemsService(
                                          coupon.couponId);
                                      if (res.code == '100') {
                                        if (brandCtr.selectedCoupon[
                                                coupon.shopId] ==
                                            index) {
                                          brandCtr.selectedCoupon[
                                              coupon.shopId] = -1;
                                        } else {
                                          brandCtr.selectedCoupon[
                                              coupon.shopId] = index;
                                        }
                                        brandCtr
                                            .shopVouchers!
                                            .data
                                            .voucherList[index]
                                            .userStatus
                                            .isClaimed = true;
                                        brandCtr.setshowClaimedCoupon();
                                        setState(() {});
                                      } else {
                                        if (!Get.isDialogOpen!) {
                                          dialogAlert([
                                            Text(
                                              res.message,
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                            )
                                          ]);
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            Get.back();
                                            Get.back();
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                          color: themeColorDefault,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      child: const Text(
                                        'เก็บ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }

                                return Obx(() {
                                  if (brandCtr.showClaimedCoupon.value &&
                                      brandCtr.selectedCoupon[coupon.shopId] ==
                                          index) {
                                    return Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                          ),
                                          Positioned(
                                            top: -18,
                                            right: -12,
                                            child: Lottie.asset(
                                                width: 50,
                                                height: 50,
                                                'assets/images/lottie/checked.json'),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  return InkWell(
                                    onTap: () {
                                      Get.find<EndUserCartCtr>()
                                          .fetchCartItems();
                                      Get.to(() => const EndUserCart());
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: themeColorDefault),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      child: Text(
                                        'ใช้โค้ด',
                                        style: TextStyle(
                                            color: themeColorDefault,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                });
                              }),
                            ]),
                          ),
                          Positioned(
                            top: 4,
                            left: -5,
                            child: CachedNetworkImage(
                              width: 78,
                              imageUrl: coupon.image,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
            )),
      );
    });
  }

  Widget flashSale() {
    return Obx(() {
      return brandCtr.isCloseFlashSale.value
          ? const SizedBox.shrink()
          : Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return !brandCtr.isLoadingShopFlashSale.value
                          ? Column(
                              children: [
                                FlashDealCountDownHomePage(
                                    data: brandCtr.countdown.value,
                                    seemoreText: seemoreText),
                              ],
                            )
                          : const SizedBox();
                    }),
                    Obx(() {
                      if (!brandCtr.isLoadingShopFlashSale.value) {
                        List<Widget> productList = List.generate(
                          brandCtr.shopFlashSale!.data.productContent.length > 9
                              ? 9
                              : brandCtr
                                  .shopFlashSale!.data.productContent.length,
                          (index) {
                            return FlashDealProductItem(
                              product: brandCtr
                                  .shopFlashSale!.data.productContent[index],
                              referrer: "shop_flashsale",
                              height: 128,
                            );
                          },
                        );
                        productList.add(seeMoreFlashSale());
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: Get.width,
                              height: 248,
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
                                  'assets/images/b2c/background/bg-red.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 8, top: 4),
                                    child: Row(children: productList),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: List.generate(12, (index) {
                            return const SizedBox();
                          })),
                        );
                      }
                    }),
                    if (!brandCtr.isLoadingShopFlashSale.value)
                      const SizedBox(
                        height: 8,
                      ),
                  ],
                ),
              ],
            );
    });
  }

  Widget seemoreText() {
    return InkWell(
      onTap: () {
        Get.to(() => const ShopFlashSale());
      },
      child: const Row(
        children: [
          Text(
            'ดูเพิ่มเติม',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          SizedBox(
            width: 4,
          ),
          SizedBox(
            width: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget seeMoreFlashSale() {
    return InkWell(
      onTap: () {
        Get.to(() => const ShopFlashSale());
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          height: 200,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ดูเพิ่มเติม',
                style: TextStyle(color: themeColorDefault),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: themeColorDefault,
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget sortProduct() {
    return Obx(
      () {
        if (categoryCtr.isLoadingSort.value) {
          return const SizedBox();
        } else {
          return Container(
            color: Colors.white,
            width: Get.width,
            child: Row(children: [
              ...List.generate(
                categoryCtr.sortData!.data.length,
                (index) {
                  var items = categoryCtr.sortData!.data[index];
                  return Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        InkWell(
                          onTap: () {
                            tapSort(index, items);
                          },
                          child: Container(
                              // width: 100,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color:
                                              brandCtr.activeTab.value == index
                                                  ? themeColorDefault
                                                  : Colors.grey.shade300))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    items.text,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.notoSansThaiLooped(
                                        fontSize: 12,
                                        fontWeight:
                                            brandCtr.activeTab.value == index
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color: brandCtr.activeTab.value == index
                                            ? themeColorDefault
                                            : Colors.grey.shade700),
                                  ),
                                  Obx(() {
                                    if (index == brandCtr.activeTab.value) {
                                      if (categoryCtr.sortData!.data.length ==
                                          index + 1) {
                                        if (brandCtr.isPriceUp.value) {
                                          return Icon(
                                              Icons.arrow_upward_outlined,
                                              size: 12,
                                              color: themeColorDefault);
                                        }
                                        return Icon(
                                            Icons.arrow_downward_outlined,
                                            size: 12,
                                            color: themeColorDefault);
                                      }
                                    }
                                    return const SizedBox();
                                  })
                                ],
                              )),
                        ),
                        Text(
                          "|",
                          style: TextStyle(color: Colors.grey.shade300),
                        )
                      ],
                    ),
                  );
                },
              ),
            ]),
          );
        }
      },
    );
  }
}

Widget nodataStore() {
  return Stack(
    children: [
      SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/search/zero_search.png',
                      width: 150,
                    ),
                    const Text('ไม่พบข้อมูล'),
                  ]),
            )
          ],
        ),
      ),
      Positioned(
          top: -10, left: 0, right: 0, child: appBarMasterEndUser('แบรนด์')),
    ],
  );
}

Widget loadingShop(BuildContext context) {
  return Stack(
    children: [
      SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.grey.shade300,
                    Colors.grey.shade100,
                  ])),
                ),
                Positioned(
                  top: 110,
                  left: 10,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        child: ClipOval(
                            child: Icon(
                          Icons.shopify,
                          color: Colors.grey.shade700,
                        )),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 170,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: Get.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        top: -10,
        left: 0,
        right: 0,
        child: Column(
          children: [
            Obx(() {
              return appbarBrand(
                  ctx: context,
                  title: 'รายละเอียดสินค้า',
                  isSetAppbar: brandCtr.isSetAppbar.value,
                  opacity: brandCtr.opacity.value,
                  showSort: brandCtr.showSort.value,
                  tabbar: const SizedBox());
            }),
          ],
        ),
      ),
    ],
  );
}

Widget tabBar(setTapActive, tapActive) {
  return Obx(() {
    if (brandCtr.isLoadingShopCategory.value) {
      return const SizedBox();
    }
    var listTap = ["ร้านค้า", "รายการสินค้า", "หมวดหมู่"];
    if (brandCtr.shopCategory!.data.isEmpty) {
      listTap.removeLast();
    }
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(width: 0.2, color: Colors.grey.shade300)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(listTap.length, (index) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: InkWell(
                    onTap: () {
                      setTapActive(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: tapActive == index
                                  ? BorderSide(
                                      width: 2, color: themeColorDefault)
                                  : const BorderSide(
                                      width: 0, color: Colors.transparent))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 12.0, left: 12, right: 12),
                        child: Text(
                          listTap[index],
                          textAlign: TextAlign.center,
                          style: tapActive == index
                              ? TextStyle(
                                  color: themeColorDefault,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)
                              : GoogleFonts.notoSansThaiLooped(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  });
}

class ProductItems extends StatelessWidget {
  final ProductContent product;
  final Function() setPauseVideo;
  const ProductItems(
      {super.key, required this.product, required this.setPauseVideo});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: () {
            Get.find<ShowProductSkuCtr>()
                .fetchB2cProductDetail(product.productId, 'shop_content');
            setPauseVideo();
            Get.toNamed(
              '/ShowProductSku/${product.productId}',
            );
          },
          child: Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(width: 0.2, color: Colors.grey.shade300)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 90,
                          child: CacheImageProducts(
                            url: product.image,
                            height: 80,
                          ),
                        ),
                      ),
                      if (product.isImageOverlayed)
                        Positioned(
                            bottom: 0,
                            left: -7,
                            child: IgnorePointer(
                              child: SizedBox(
                                  width: 120,
                                  child: CacheImageOverlay(
                                      url: product.imageOverlay)),
                            )),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansThaiLooped(
                          color: Colors.black87, fontSize: 11),
                    ),
                  ),
                  if (product.discount > 0)
                    Row(
                      children: [
                        Text(
                          '฿${myFormat.format(product.price)}',
                          style: TextStyle(
                              color: Colors.deepOrange.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '฿${myFormat.format(product.priceBeforeDiscount)}',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 11),
                        ),
                      ],
                    )
                  else
                    Text(
                      '฿ ${myFormat.format(product.priceBeforeDiscount)}',
                      style: TextStyle(
                          color: Colors.deepOrange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (product.discount > 0)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
              ),
              child: Text(
                '-${myFormat.format(product.discount)}%',
                style: GoogleFonts.notoSansThaiLooped(
                    color: Colors.deepOrange, fontSize: 11),
              ),
            ),
          ),
        if (product.isOutOfStock)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SizedBox(
                width: 55,
                height: 55,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Center(
                    child: Text(
                      'สินค้าหมด',
                      style: GoogleFonts.notoSansThaiLooped(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
