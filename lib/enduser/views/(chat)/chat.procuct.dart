import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/showproduct/nodata.dart';
import 'package:fridayonline/enduser/models/brands/shopfilter.model.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/brands/brands.service.dart';

class ChatProducts extends StatefulWidget {
  final Data products;
  final int shopId;
  const ChatProducts({super.key, required this.products, required this.shopId});

  @override
  State<ChatProducts> createState() => _ChatProductsState();
}

class _ChatProductsState extends State<ChatProducts> {
  final scrollController = ScrollController();
  int offset = 40;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchMore();
      }
    });
  }

  @override
  void dispose() {
    offset = 40;
    super.dispose();
  }

  void fetchMore() async {
    setState(() {
      isLoadingMore = true;
    });
    try {
      final newsData = await fetchShopProductFilterServices(
          0, widget.shopId, "ctime", "", offset);

      if (newsData!.data.products.isNotEmpty) {
        setState(() {
          widget.products.products.addAll(newsData.data.products);
          offset += 40;
        });
      }
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Theme(
            data: Theme.of(context).copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textStyle: GoogleFonts.notoSansThaiLooped())),
              textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            child: Scaffold(
              appBar: appBarMasterEndUser('รายการสินค้า'),
              body: widget.products.products.isEmpty
                  ? Center(
                      child: nodata(context),
                    )
                  : SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: scrollController,
                      child: Column(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.all(8),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: widget.products.products.length +
                                (isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == widget.products.products.length &&
                                  isLoadingMore) {
                                return const SizedBox.shrink();
                              }
                              var items = widget.products.products[index];

                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 0.5))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: items.image,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          items.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontSize: 14),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Builder(
                                              builder: (context) {
                                                if (items.discount == 0) {
                                                  return Text(
                                                    "฿${myFormat.format(items.priceBeforeDiscount)}",
                                                    style: GoogleFonts
                                                        .notoSansThaiLooped(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .deepOrange
                                                                .shade700),
                                                  );
                                                } else {
                                                  return Row(
                                                    children: [
                                                      Text(
                                                        "฿${myFormat.format(items.price)}",
                                                        style: GoogleFonts
                                                            .notoSansThaiLooped(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .deepOrange
                                                                    .shade700),
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "฿${myFormat.format(items.priceBeforeDiscount)}",
                                                        style: GoogleFonts
                                                            .notoSansThaiLooped(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              },
                                            ),
                                            OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: theme_color_df),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8))),
                                                onPressed: () {
                                                  Get.back(result: items);
                                                },
                                                child: Text(
                                                  "ส่ง",
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              theme_color_df),
                                                ))
                                          ],
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              );
                            },
                          ),
                          isLoadingMore
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: Center(
                                    child: Text(
                                      "กำลังโหลด...",
                                      style: TextStyle(color: theme_color_df),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
            )));
  }
}
