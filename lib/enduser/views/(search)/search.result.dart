import 'package:fridayonline/enduser/components/shimmer/shimmer.product.dart';
import 'package:fridayonline/enduser/components/showproduct/nodata.dart';
import 'package:fridayonline/enduser/components/showproduct/showproduct.category.dart';
import 'package:fridayonline/enduser/controller/search.ctr.dart';
import 'package:fridayonline/enduser/views/(search)/search.view.dart';
import 'package:fridayonline/enduser/widgets/arrow_totop.dart';
import 'package:fridayonline/enduser/widgets/gap.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final SearchProductCtr searchCtr = Get.find();

final OutlineInputBorder border = OutlineInputBorder(
  borderSide: BorderSide(
    color: theme_color_df,
    width: 1,
  ),
  borderRadius: const BorderRadius.all(
    Radius.circular(8),
  ),
);

class EndUserSearchResult extends StatefulWidget {
  const EndUserSearchResult({super.key});

  @override
  State<EndUserSearchResult> createState() => _EndUserSearchResultState();
}

class _EndUserSearchResultState extends State<EndUserSearchResult> {
  final ScrollController _scrollController = ScrollController();
  bool isShowArrow = false;
  int offset = 20;

  @override
  void initState() {
    super.initState();
    // ตรวจสอบการเลื่อนถึงท้ายรายการ
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMoreProductContent();
      }
      bool shouldSetArrow = _scrollController.offset > 205;

      if (shouldSetArrow != isShowArrow) {
        setState(() {
          isShowArrow = shouldSetArrow;
        });
      }
    });
  }

  void fetchMoreProductContent() async {
    searchCtr.isLoadingMore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newSearchItems = await searchCtr.fetchMoreProductSearch(
        searchCtr.keyword.value,
        offset,
        searchCtr.orderByVal.value,
        searchCtr.sortByVal.value,
      );

      if (newSearchItems!.data.isNotEmpty) {
        searchCtr.productCategory!.data.addAll(newSearchItems.data);
        offset += 20;
      }
    } finally {
      searchCtr.isLoadingMore.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!mounted) return;
    offset = 0;
    _scrollController.dispose();
    searchCtr.resetProductCategory();
    searchCtr.orderByVal.value = "";
    searchCtr.sortByVal.value = "";
    searchCtr.activeTab.value = 0;
    searchCtr.isPriceUp.value = false;
  }

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
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 4,
              elevation: 0,
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
                        color: theme_color_df,
                      )),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      autofocus: true,
                      style: const TextStyle(fontSize: 12),
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        focusedBorder: border,
                        enabledBorder: border,
                        isDense: true,
                        hintText: 'ค้นหาสินค้า',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: theme_color_df,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onTap: () {
                        Get.find<SearchProductCtr>().fetchSort();
                        Get.find<SearchProductCtr>().fetchProductSuggust(0);
                        Get.to(
                          () => const EndUserSearch(),
                          transition: Transition.fade,
                        );
                      },
                    ),
                  ),
                ],
              ),
              // actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 8.0),
              //   child: Builder(builder: (context) {
              //     return InkWell(
              //       splashColor: Colors.transparent,
              //       highlightColor: Colors.transparent,
              //       onTap: () {
              //         Scaffold.of(context).openEndDrawer();
              //       },
              //       child: Row(
              //         children: [
              //           Icon(
              //             Icons.filter_alt_outlined,
              //             color: theme_color_df,
              //             size: 20,
              //           ),
              //           Text(
              //             'ตัวกรอง',
              //             style: GoogleFonts.notoSansThaiLooped(
              //                 color: theme_color_df,
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.normal),
              //           ),
              //         ],
              //       ),
              //     );
              //   }),
              // ),
              // ],
            ),
            body: Stack(
              children: [
                MediaQuery(
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
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              const Gap(height: 34),
                              showProductItems(),
                            ],
                          ),
                        ))),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Obx(
                    () {
                      if (searchCtr.isLoadingSort.value) {
                        return const SizedBox();
                      } else {
                        return Container(
                          color: Colors.white,
                          width: Get.width,
                          child: Row(children: [
                            ...List.generate(
                              searchCtr.sortData!.data.length,
                              (index) {
                                var items = searchCtr.sortData!.data[index];
                                return Expanded(
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          searchCtr.setActiveTab(index);
                                          setState(() {
                                            offset = 0;
                                            _scrollController.jumpTo(0);
                                          });

                                          if (items.subLevels.isNotEmpty) {
                                            searchCtr.isPriceUp.value =
                                                !searchCtr.isPriceUp.value;
                                            searchCtr.fetchProductByKeyword(
                                              searchCtr.keyword.value,
                                              0,
                                              searchCtr.isPriceUp.value
                                                  ? items.subLevels.last.order
                                                  : items.subLevels.first.order,
                                              items.sortBy,
                                            );
                                          } else {
                                            searchCtr.orderByVal.value = "";
                                            searchCtr.fetchProductByKeyword(
                                              searchCtr.keyword.value,
                                              0,
                                              "",
                                              items.sortBy,
                                            );
                                          }
                                        },
                                        child: Container(
                                            // width: 100,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: searchCtr
                                                                    .activeTab
                                                                    .value ==
                                                                index
                                                            ? theme_color_df
                                                            : Colors.grey
                                                                .shade300))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  items.text,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontSize: 12,
                                                          fontWeight: searchCtr
                                                                      .activeTab
                                                                      .value ==
                                                                  index
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                          color: searchCtr
                                                                      .activeTab
                                                                      .value ==
                                                                  index
                                                              ? theme_color_df
                                                              : Colors.grey
                                                                  .shade700),
                                                ),
                                                Obx(() {
                                                  if (index ==
                                                      searchCtr
                                                          .activeTab.value) {
                                                    if (searchCtr.sortData!.data
                                                            .length ==
                                                        index + 1) {
                                                      if (searchCtr
                                                          .isPriceUp.value) {
                                                        return Icon(
                                                            Icons
                                                                .arrow_upward_outlined,
                                                            size: 12,
                                                            color:
                                                                theme_color_df);
                                                      }
                                                      return Icon(
                                                          Icons
                                                              .arrow_downward_outlined,
                                                          size: 12,
                                                          color:
                                                              theme_color_df);
                                                    }
                                                  }
                                                  return const SizedBox();
                                                })
                                              ],
                                            )),
                                      ),
                                      Text(
                                        "|",
                                        style: TextStyle(
                                            color: Colors.grey.shade300),
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
                  ),
                ),
              ],
            ),
            // endDrawer: Drawer(
            //     width: Get.width - 50,
            //     child: Scaffold(
            //       appBar: AppBar(
            //         automaticallyImplyLeading: false,
            //         backgroundColor: Colors.grey.shade300,
            //         title: const Text(
            //           'ค้นหาแบบระเอียด',
            //           style: TextStyle(
            //               fontSize: 12,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black),
            //         ),
            //       ),
            //       body: SingleChildScrollView(
            //           child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text(
            //               'ยี่ห้อ',
            //               style: TextStyle(fontSize: 14),
            //             ),
            //             const SizedBox(
            //               height: 12,
            //             ),
            //             GridView.builder(
            //               shrinkWrap: true,
            //               physics: const NeverScrollableScrollPhysics(),
            //               padding: EdgeInsets.zero,
            //               itemCount: brands.length,
            //               gridDelegate:
            //                   const SliverGridDelegateWithFixedCrossAxisCount(
            //                       childAspectRatio: 4,
            //                       mainAxisSpacing: 8,
            //                       crossAxisSpacing: 8,
            //                       crossAxisCount: 2),
            //               itemBuilder: (context, index) {
            //                 return filterButton(
            //                     widget: Text(
            //                   brands[index],
            //                   maxLines: 1,
            //                   overflow: TextOverflow.ellipsis,
            //                   style: const TextStyle(fontSize: 12),
            //                 ));
            //               },
            //             ),
            //             const Divider(),
            //             const Text(
            //               'คะแนน',
            //               style: TextStyle(fontSize: 14),
            //             ),
            //             const SizedBox(
            //               height: 12,
            //             ),
            //             GridView.builder(
            //               shrinkWrap: true,
            //               physics: const NeverScrollableScrollPhysics(),
            //               padding: EdgeInsets.zero,
            //               itemCount: 5,
            //               gridDelegate:
            //                   const SliverGridDelegateWithFixedCrossAxisCount(
            //                       childAspectRatio: 4,
            //                       mainAxisSpacing: 8,
            //                       crossAxisSpacing: 8,
            //                       crossAxisCount: 2),
            //               itemBuilder: (context, index) {
            //                 return filterButton(
            //                     widget: Text(
            //                   '${5 - index} ${index > 0 ? 'ดาวขึ้นไป' : 'ดาว'}',
            //                   style: const TextStyle(fontSize: 12),
            //                 ));
            //               },
            //             ),
            //             const Divider(),
            //             const Text(
            //               'ช่วงราคา (฿)',
            //               style: TextStyle(fontSize: 14),
            //             ),
            //             const SizedBox(
            //               height: 12,
            //             ),
            //             Container(
            //                 padding: const EdgeInsets.all(8),
            //                 decoration: BoxDecoration(
            //                     color: Colors.grey.shade200,
            //                     borderRadius: BorderRadius.circular(4)),
            //                 alignment: Alignment.center,
            //                 child: Row(
            //                   children: [
            //                     Expanded(
            //                         child: SizedBox(
            //                       height: 34,
            //                       child: TextField(
            //                           keyboardType: TextInputType.number,
            //                           textAlignVertical:
            //                               TextAlignVertical.center,
            //                           textAlign: TextAlign.center,
            //                           style: const TextStyle(fontSize: 12),
            //                           decoration: InputDecoration(
            //                             contentPadding: EdgeInsets.zero,
            //                             filled: true,
            //                             fillColor: Colors.grey.shade50,
            //                             border: OutlineInputBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(8.0),
            //                               borderSide: BorderSide.none,
            //                             ),
            //                             hintText:
            //                                 "ใส่ราคาสูงสุด", // ข้อความลายน้ำ
            //                             hintStyle: const TextStyle(
            //                                 color: Colors.grey, fontSize: 12),
            //                           )),
            //                     )),
            //                     Padding(
            //                       padding: const EdgeInsets.symmetric(
            //                           horizontal: 4.0),
            //                       child: Text(
            //                         '-',
            //                         style: TextStyle(
            //                           inherit: false,
            //                           fontSize: 30,
            //                           color: Colors.grey.shade400,
            //                         ),
            //                       ),
            //                     ),
            //                     Expanded(
            //                         child: SizedBox(
            //                       height: 34,
            //                       child: TextField(
            //                           keyboardType: TextInputType.number,
            //                           textAlignVertical:
            //                               TextAlignVertical.center,
            //                           textAlign: TextAlign.center,
            //                           style: const TextStyle(fontSize: 12),
            //                           decoration: InputDecoration(
            //                             contentPadding: EdgeInsets.zero,
            //                             filled: true,
            //                             fillColor: Colors.grey.shade50,
            //                             border: OutlineInputBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(8.0),
            //                               borderSide: BorderSide.none,
            //                             ),
            //                             hintText:
            //                                 "ใส่ราคาต่ำสุด", // ข้อความลายน้ำ
            //                             hintStyle: const TextStyle(
            //                                 color: Colors.grey, fontSize: 12),
            //                           )),
            //                     )),
            //                   ],
            //                 )),
            //             const SizedBox(
            //               height: 8,
            //             ),
            //             GridView.builder(
            //               shrinkWrap: true,
            //               physics: const NeverScrollableScrollPhysics(),
            //               padding: EdgeInsets.zero,
            //               itemCount: 3,
            //               gridDelegate:
            //                   const SliverGridDelegateWithFixedCrossAxisCount(
            //                       childAspectRatio: 4,
            //                       mainAxisSpacing: 8,
            //                       crossAxisSpacing: 8,
            //                       crossAxisCount: 3),
            //               itemBuilder: (context, index) {
            //                 return filterButton(
            //                     widget: Text(
            //                   '${index + 1}50 - ${index + 2}00',
            //                   style: const TextStyle(fontSize: 12),
            //                 ));
            //               },
            //             )
            //           ],
            //         ),
            //       )),
            //       bottomNavigationBar: SafeArea(
            //         child: Container(
            //             decoration: BoxDecoration(
            //                 border: Border(
            //                     top: BorderSide(
            //                         color: Colors.grey.shade100, width: 2))),
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //               child: Row(
            //                 children: [
            //                   Expanded(
            //                     child: OutlinedButton(
            //                         style: OutlinedButton.styleFrom(
            //                             foregroundColor: theme_color_df,
            //                             side: BorderSide(color: theme_color_df),
            //                             shape: RoundedRectangleBorder(
            //                                 borderRadius:
            //                                     BorderRadius.circular(2))),
            //                         onPressed: () {},
            //                         child: const Text('ล้าง')),
            //                   ),
            //                   const SizedBox(
            //                     width: 8,
            //                   ),
            //                   Expanded(
            //                     child: ElevatedButton(
            //                         style: ElevatedButton.styleFrom(
            //                             backgroundColor: theme_color_df,
            //                             foregroundColor: Colors.white,
            //                             side: BorderSide(color: theme_color_df),
            //                             shape: RoundedRectangleBorder(
            //                                 borderRadius:
            //                                     BorderRadius.circular(2))),
            //                         onPressed: () {
            //                           Get.back();
            //                         },
            //                         child: const Text('ตกลง')),
            //                   )
            //                 ],
            //               ),
            //             )),
            //       ),
            //     )),
            floatingActionButton: arrowToTop(
                scrCtrl: _scrollController, isShowArrow: isShowArrow),
          ),
        ),
      ),
    );
  }

  filterButton({required Widget widget}) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4)),
        alignment: Alignment.center,
        child: widget);
  }

  showProductItems() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Obx(() {
          if (searchCtr.isLoadingSearch.value) {
            return MasonryGridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                shrinkWrap: true,
                primary: false,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
                ),
                itemCount: 12,
                itemBuilder: (BuildContext context, int index) {
                  return const ShimmerProductItem();
                });
          } else {
            if (searchCtr.productCategory!.data.isEmpty) {
              return SizedBox(
                height: Get.height / 1.5,
                child: nodata(context),
              );
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
                itemCount: searchCtr.productCategory!.data.length +
                    (searchCtr.isLoadingMore.value ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == searchCtr.productCategory!.data.length &&
                      searchCtr.isLoadingMore.value) {
                    return const SizedBox.shrink();
                  }
                  return ProductCategoryComponents(
                    item: searchCtr.productCategory!.data[index],
                    referrer: 'search_product',
                  );
                });
          }
        }),
      ],
    );
  }
}
