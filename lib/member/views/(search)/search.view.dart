import 'dart:async';

import 'package:fridayonline/member/components/shimmer/shimmer.product.dart';
import 'package:fridayonline/member/controller/search.ctr.dart';
// import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
// import 'package:fridayonline/enduser/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/member/models/search/serach.hint.model.dart';
import 'package:fridayonline/member/services/search/search.service.dart';
import 'package:fridayonline/member/views/(search)/search.result.dart';
import 'package:fridayonline/member/widgets/gap.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:fridayonline/enduser/widgets/gap.dart';
// import 'package:fridayonline/theme.dart';import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndUserSearch extends StatefulWidget {
  const EndUserSearch({super.key});

  @override
  State<EndUserSearch> createState() => _EndUserSearchState();
}

class _EndUserSearchState extends State<EndUserSearch> {
  final searchCtr = Get.find<SearchProductCtr>();
  final scrollController = ScrollController();
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: themeColorDefault,
      width: 1,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(8),
    ),
  );

  bool isTypeing = false;
  final TextEditingController searchTextCtr = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<SearchData> response = [];
  Timer? debounce;
  bool isLoading = false;
  int offset = 20;
  var isShowAll = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchMoreProductContent();
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      searchFocus.requestFocus();
    });
  }

  void fetchMoreProductContent() async {
    searchCtr.isLoadingMore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newSearchItems = await searchCtr.fetchMoreProductSuggest(offset);

      if (newSearchItems!.data.isNotEmpty) {
        searchCtr.suggest!.data.addAll(newSearchItems.data);
        offset += 20;
      }
    } finally {
      searchCtr.isLoadingMore.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    offset = 20;
    scrollController.dispose();
    searchCtr.resetProductSuggest();
    isTypeing = false;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: themeColorDefault,
                      )),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextField(
                          controller: searchTextCtr,
                          // focusNode: searchFocus,
                          autofocus: false,
                          style: const TextStyle(fontSize: 12),
                          onSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              await saveSearchHistoryService(value);
                              searchCtr.fetchProductByKeyword(
                                  value, 0, "", "ctime");
                              await Get.to(() => const EndUserSearchResult())!
                                  .then((value) {
                                setState(() {});
                              });
                            }
                          },
                          onChanged: (value) async {
                            if (value != "") {
                              setState(() {
                                isTypeing = true;
                              });

                              if (debounce?.isActive ?? false) {
                                debounce!.cancel();
                              }
                              debounce = Timer(
                                  const Duration(milliseconds: 500), () async {
                                var res = await searchHintService(value);
                                setState(() {
                                  response = res!.data;
                                });
                              });
                            } else {
                              setState(() {
                                isTypeing = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            focusedBorder: border,
                            enabledBorder: border,
                            isDense: true,
                            hintText: 'ค้นหาสินค้า',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: themeColorDefault,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onTap: () async {},
                        ),
                        Positioned(
                          right: 50,
                          child: SizedBox(
                            width: 20,
                            child: InkWell(
                              onTap: () {
                                if (searchTextCtr.text == "") {
                                  return;
                                }
                                searchTextCtr.clear();
                                isTypeing = false;
                                setState(() {});
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (searchTextCtr.text.isNotEmpty) {
                              await saveSearchHistoryService(
                                  searchTextCtr.text);
                              searchCtr.fetchProductByKeyword(
                                  searchTextCtr.text, 0, "", "ctime");
                              await Get.to(() => const EndUserSearchResult())!
                                  .then((value) {
                                setState(() {});
                              });
                            }
                          },
                          child: Container(
                              height: 36,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  color: themeColorDefault,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  )),
                              child: const Icon(Icons.search)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    isTypeing
                        ? Column(
                            children: [
                              for (int i = 0; i < response.length; i++)
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await saveSearchHistoryService(
                                              response[i].keyword);
                                          searchCtr.fetchProductByKeyword(
                                              response[i].keyword,
                                              0,
                                              "",
                                              "ctime");

                                          await Get.to(() =>
                                                  const EndUserSearchResult())!
                                              .then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: SizedBox(
                                          width: Get.width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Wrap(
                                              children: [
                                                Text(response[i].keyword,
                                                    style: const TextStyle(
                                                        fontSize: 13)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 4,
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          )
                        // : const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    FutureBuilder(
                                        future: getSearchHistoryService(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox();
                                          }
                                          if (snapshot.hasData &&
                                              snapshot.data!.isNotEmpty) {
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                primary: false,
                                                padding: EdgeInsets.zero,
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, i) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          await saveSearchHistoryService(
                                                              snapshot
                                                                  .data![i]);
                                                          searchCtr
                                                              .fetchProductByKeyword(
                                                                  snapshot
                                                                      .data![i],
                                                                  0,
                                                                  "",
                                                                  "ctime");

                                                          await Get.to(() =>
                                                                  const EndUserSearchResult())!
                                                              .then((value) {
                                                            setState(() {});
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12.0,
                                                                  vertical: 8),
                                                          child: Text(
                                                              snapshot.data![i],
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13)),
                                                        ),
                                                      ),
                                                      const Divider(
                                                        height: 4,
                                                      ),
                                                      if (snapshot.data!
                                                              .isNotEmpty &&
                                                          snapshot.data!
                                                                  .length ==
                                                              i + 1)
                                                        Center(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              await prefs.remove(
                                                                  'search_history');
                                                              setState(() {});
                                                            },
                                                            child: const Text(
                                                              'ลบประวัติการค้นหา',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  height: 2,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                });
                                          }
                                          return const SizedBox();
                                        }),
                                  ],
                                ),
                              ),
                              const Gap(
                                height: 8,
                              ),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(8),
                                child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'หรือคุณต้องการหาสิ่งนี้',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Obx(() {
                                          if (searchCtr
                                              .isLoadingSuggest.value) {
                                            return MasonryGridView.builder(
                                                shrinkWrap: true,
                                                primary: false,
                                                gridDelegate:
                                                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2),
                                                itemCount: 12,
                                                itemBuilder: (context, index) {
                                                  return const ShimmerProductItem();
                                                });
                                          } else {
                                            return MasonryGridView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              gridDelegate:
                                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2),
                                              itemCount: searchCtr
                                                      .suggest!.data.length +
                                                  (searchCtr.isLoadingMore.value
                                                      ? 1
                                                      : 0),
                                              itemBuilder: (context, index) {
                                                if (index ==
                                                        searchCtr.suggest!.data
                                                            .length &&
                                                    searchCtr
                                                        .isLoadingMore.value) {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                                var items = searchCtr
                                                    .suggest!.data[index];
                                                return InkWell(
                                                  onTap: () async {
                                                    await saveSearchHistoryService(
                                                        items.keyword);
                                                    searchCtr
                                                        .fetchProductByKeyword(
                                                            items.keyword,
                                                            0,
                                                            "",
                                                            "ctime");
                                                    await Get.to(() =>
                                                            const EndUserSearchResult())!
                                                        .then((value) {
                                                      setState(() {});
                                                    });
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade200)),
                                                      child: Column(
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.image,
                                                                    size: 48,
                                                                    color: themeColorDefault
                                                                        .withOpacity(
                                                                            0.2),
                                                                  ),
                                                                ],
                                                              ),
                                                              Image(
                                                                height: 140,
                                                                image: CachedNetworkImageProvider(
                                                                    items
                                                                        .image),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              items.keyword,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                );
                                              },
                                            );
                                          }
                                        })
                                      ]),
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
