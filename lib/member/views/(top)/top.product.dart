import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/controller/topproduct.ctr.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/widgets/label.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TopProductsWeekly extends StatefulWidget {
  const TopProductsWeekly({super.key});

  @override
  State<TopProductsWeekly> createState() => _TopProductsWeeklyState();
}

class _TopProductsWeeklyState extends State<TopProductsWeekly> {
  final EndUserHomeCtr endUserHomeCtr = Get.find();
  final TopProductsCtr topProductsCtr = Get.find();
  final ScrollController _scrollController = ScrollController();
  bool isShowImage = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      bool shouldSetArrow = _scrollController.offset > 100;

      if (shouldSetArrow != isShowImage) {
        setState(() {
          isShowImage = shouldSetArrow;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    isShowImage = false;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Material(
          color: Colors.white,
          child: SafeArea(
            top: false,
            left: false,
            right: false,
            child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                // appBar: AppBar(),
                appBar: appBarMasterEndUser('ขายดีประจำสัปดาห์'),
                body: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1)),
                      child: Column(children: [
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Obx(() {
                              return Row(
                                children: [
                                  ...List.generate(
                                      endUserHomeCtr.topSalesWeekly!.data
                                          .length, (index) {
                                    var items = endUserHomeCtr
                                        .topSalesWeekly!.data[index];
                                    var isActive =
                                        topProductsCtr.activeIndex.value ==
                                            index;
                                    return Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (index ==
                                                topProductsCtr
                                                    .activeIndex.value) {
                                              return;
                                            }
                                            topProductsCtr.setActiveTab(index);
                                            topProductsCtr.fetchTopProducts(
                                                items.prodlineId);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 4, right: 0, bottom: 4),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: isActive
                                                          ? themeColorDefault
                                                          : Colors.white,
                                                      width: 1)),
                                              width: 80,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AnimatedContainer(
                                                    height:
                                                        !isShowImage ? 50 : 0.0,
                                                    duration: const Duration(
                                                        milliseconds: 100),
                                                    child: Center(
                                                      child: CachedNetworkImage(
                                                        height: 50,
                                                        imageUrl: items
                                                            .image, // ใช้ URL ของภาพ
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            color: Colors.grey,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: !isShowImage
                                                        ? Colors.grey.shade100
                                                        : Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8),
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        items.displayName,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: isActive
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                          color: isActive
                                                              ? themeColorDefault
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                                ],
                              );
                            })),
                        Expanded(
                          child: Obx(() {
                            if (topProductsCtr.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else if (topProductsCtr
                                .topProducts!.data.topProducts.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/search/zero_search.png',
                                    width: 150,
                                  ),
                                  const Text('ไม่พบข้อมูล'),
                                ],
                              );
                            }
                            return ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: topProductsCtr
                                  .topProducts!.data.topProducts.length,
                              itemBuilder: (context, index) {
                                var items = topProductsCtr
                                    .topProducts!.data.topProducts[index];
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.find<ShowProductSkuCtr>()
                                            .fetchB2cProductDetail(
                                                items.productId,
                                                'top_products_page');
                                        Get.toNamed(
                                          '/ShowProductSku/${items.productId}',
                                        );
                                      },
                                      child: Container(
                                          color: Colors.white,
                                          height: 120,
                                          margin:
                                              const EdgeInsets.only(bottom: 2),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Center(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: items.image,
                                                          errorWidget: (context,
                                                              url, error) {
                                                            return Container(
                                                              width: Get.width,
                                                              height:
                                                                  Get.height,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4),
                                                              color: Colors
                                                                  .grey.shade50,
                                                              child: const Icon(
                                                                Icons.shopify,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      if (items
                                                          .isImageOverlayed)
                                                        Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          child: IgnorePointer(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: items
                                                                  .imageOverlay,
                                                              width: 170,
                                                            ),
                                                          ),
                                                        ),
                                                      if (items.isOutOfStock)
                                                        IgnorePointer(
                                                          child: IgnorePointer(
                                                            child: Container(
                                                                width: 70,
                                                                height: 70,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        18),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50),
                                                                    color: Colors
                                                                        .black54),
                                                                child:
                                                                    const Text(
                                                                  'สินค้าหมด',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ),
                                                        ),
                                                    ],
                                                  )),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                  flex: 5,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            if (items.icon !=
                                                                "")
                                                              Text(
                                                                "      ${items.title}",
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                              )
                                                            else
                                                              Text(items.title,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                  )),
                                                            if (items.icon !=
                                                                "")
                                                              Positioned(
                                                                left: 0,
                                                                top: 4,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      items
                                                                          .icon,
                                                                  width: 14,
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        if (items.unitSales !=
                                                            "")
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        8.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: index <
                                                                          3
                                                                      ? themeColorDefault
                                                                      : Colors
                                                                          .grey
                                                                          .shade300,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              child: Text(
                                                                  "  ${items.unitSales}  ",
                                                                  style: TextStyle(
                                                                      color: index < 3
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .grey
                                                                              .shade800,
                                                                      fontSize:
                                                                          13)),
                                                            ),
                                                          ),
                                                        const Spacer(),
                                                        Text(
                                                          "฿${myFormat.format(items.priceBeforeDiscount)}",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .deepOrange
                                                                .shade700,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          )),
                                    ),
                                    Positioned(
                                      left: 4,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 30,
                                            height: 35,
                                            child: CustomPaint(
                                              painter: setLabel(index),
                                            ),
                                          ),
                                          if (index < 3)
                                            RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                    text: "TOP",
                                                    style: const TextStyle(
                                                      inherit: false,
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: '\n${index + 1}',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14),
                                                      ),
                                                    ]))
                                          else
                                            Text(
                                              "${index + 1}",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  inherit: false,
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                        )
                      ]),
                    ),
                  ],
                )),
          ),
        ));
  }

  BadgePainter setLabel(int index) {
    switch (index) {
      case 0:
        {
          return BadgePainter(color: "gold");
        }
      case 1:
        {
          return BadgePainter(color: "silver");
        }
      case 2:
        {
          return BadgePainter(color: "copper");
        }

      default:
        {
          return BadgePainter(color: "grey");
        }
    }
  }
}
