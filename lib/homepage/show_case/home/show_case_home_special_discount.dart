// // ignore_for_file: must_be_immutable, unnecessary_null_comparison

// import 'package:shimmer/shimmer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:showcaseview/showcaseview.dart';
// import '../../../controller/home/home_controller.dart';
// import '../../../service/languages/multi_languages.dart';
// import '../../home/content_list.dart';
// import '../../myhomepage.dart';
// import '../../theme/constants.dart';
// import '../../theme/theme_color.dart';

// class ShowCaseHomeSpecialDiscount extends StatefulWidget {
//   ShowCaseHomeSpecialDiscount(
//       {Key? key, required this.ChangeLanguage, this.keyFive, this.keySix})
//       : super(key: key);
//   MultiLanguages ChangeLanguage;
//   final GlobalKey<State<StatefulWidget>>? keyFive;
//   final GlobalKey<State<StatefulWidget>>? keySix;
//   @override
//   State<ShowCaseHomeSpecialDiscount> createState() =>
//       _ShowCaseHomeSpecialDiscountState();
// }

// class _ShowCaseHomeSpecialDiscountState
//     extends State<ShowCaseHomeSpecialDiscount> {
//   ProductFromBanner bannerProduct = Get.put(ProductFromBanner());

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
//       child: GetX<SpecialDiscountController>(
//         builder: ((discount) {
//           if (!discount.isDataLoading.value) {
//             if (discount.discount!.content.isNotEmpty) {
//               return Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         discount.discount!.textHeader,
//                         style: TextStyle(
//                             fontFamily: 'notoreg',
//                             color: theme_color_df,
//                             fontSize: 15),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           // Get.to(() => content_list(
//                           //       mparamType: 'content',
//                           //       mparamTitleName: discount.discount!.textHeader,
//                           //     ));
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: theme_color_df,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 30, vertical: 5),
//                             textStyle: const TextStyle(
//                                 fontSize: 15, fontFamily: 'notoreg')),
//                         child: Text(
//                           MultiLanguages.of(context)!
//                               .translate('home_page_see_more'),
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                   ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: discount.discount!.content.length,
//                     itemBuilder: (context, index) {
//                       if (discount.discount!.content[index].contentImg ==
//                           null) {
//                         return Container();
//                       } else {
//                         if (index == 0) {
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 10.0),
//                             child: Showcase.withWidget(
//                               disableMovingAnimation: true,
//                               width: width,
//                               height: height / 3,
//                               container: InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     ShowCaseWidget.of(context)
//                                         .startShowCase([widget.keySix!]);
//                                   });
//                                 },
//                                 child: MediaQuery(
//                                   data: MediaQuery.of(context)
//                                       .copyWith(textScaler: const TextScaler.linear(1.0)),
//                                   child: SizedBox(
//                                     width: width / 1.1,
//                                     height: height / 3,
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           margin:
//                                               const EdgeInsets.only(top: 20),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(8.0),
//                                             child: Container(
//                                                 color: theme_color_df,
//                                                 width: 250,
//                                                 height: 80,
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Center(
//                                                     child: Text(
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       MultiLanguages.of(
//                                                               context)!
//                                                           .translate(
//                                                               'txt_guide4'),
//                                                       style: const TextStyle(
//                                                           color: Colors.white,
//                                                           fontSize: 16),
//                                                     ),
//                                                   ),
//                                                 )),
//                                           ),
//                                         ),
//                                         Container(
//                                           margin: const EdgeInsets.only(
//                                               left: 165.0),
//                                           child: ElevatedButton(
//                                               style: ButtonStyle(
//                                                   foregroundColor:
//                                                       MaterialStateProperty.all<
//                                                               Color>(
//                                                           theme_color_df),
//                                                   backgroundColor:
//                                                       MaterialStateProperty.all<
//                                                           Color>(Colors.white),
//                                                   shape: MaterialStateProperty.all<
//                                                           RoundedRectangleBorder>(
//                                                       RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius.circular(30.0),
//                                                           side: BorderSide(color: theme_color_df)))),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   ShowCaseWidget.of(context)
//                                                       .startShowCase(
//                                                           [widget.keySix!]);
//                                                 });
//                                               },
//                                               child: SizedBox(
//                                                 width: 50,
//                                                 height: 40,
//                                                 child: Center(
//                                                   child: Text(
//                                                       maxLines: 1,
//                                                       MultiLanguages.of(
//                                                               context)!
//                                                           .translate(
//                                                               'btn_next_guide'),
//                                                       style: const TextStyle(
//                                                           fontSize: 16)),
//                                                 ),
//                                               )),
//                                         ),
//                                         Center(
//                                           child: IconButton(
//                                               icon: const Icon(
//                                                 Icons.close,
//                                                 color: Colors.white,
//                                               ),
//                                               onPressed: () {
//                                                 Navigator.pushReplacement(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             MyHomePage()));
//                                               }),
//                                         ),
//                                         // Expanded(
//                                         //   child: Align(
//                                         //       alignment: Alignment.topCenter,
//                                         //       child: TextButton(
//                                         //         onPressed: () {
//                                         //           print('ddd');
//                                         //         },
//                                         //         child: const Text(
//                                         //           'ปิดการสอน',
//                                         //           style: TextStyle(
//                                         //               color: Colors.white,
//                                         //               fontSize: 16),
//                                         //         ),
//                                         //       )),
//                                         // ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               scrollLoadingWidget:
//                                   const CircularProgressIndicator(
//                                       valueColor: AlwaysStoppedAnimation(
//                                           Colors.transparent)),
//                               overlayPadding: const EdgeInsets.all(3),
//                               key: widget.keyFive!,
//                               disposeOnTap: true,
//                               onTargetClick: () {
//                                 setState(() {
//                                   ShowCaseWidget.of(context)
//                                       .startShowCase([widget.keySix!]);
//                                 });
//                               },
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // // ignore: avoid_print
//                                     // print(
//                                     //     discount.discount!.content[index].toJson());
//                                     // if (discount
//                                     //         .discount!.content[index].keyindex !=
//                                     //     'sku') {
//                                     //   bannerProduct.fetch_product_banner(
//                                     //       discount.discount!.content[index]
//                                     //           .contentIndcx,
//                                     //       discount
//                                     //           .discount!.content[index].campaign);
//                                     //   Get.to(() => Scaffold(
//                                     //       appBar: appBarTitleCart('รายการสินค้า'),
//                                     //       body: Obx(() =>
//                                     //           bannerProduct.isDataLoading.value
//                                     //               ? const Center(
//                                     //                   child:
//                                     //                       CircularProgressIndicator(),
//                                     //                 )
//                                     //               : showList(
//                                     //                   context,
//                                     //                   bannerProduct.BannerProduct!
//                                     //                       .skucode))));
//                                     // } else {
//                                     //   Get.find<CategoryProductDetailController>()
//                                     //       .fetchproductdetail(
//                                     //           discount.discount!.content[index]
//                                     //               .campaign,
//                                     //           discount.discount!.content[index]
//                                     //               .contentIndcx,
//                                     //           discount
//                                     //               .discount!.content[index].band,
//                                     //           discount
//                                     //               .discount!.content[index].fsCode);
//                                     //   Get.toNamed('my_detail');
//                                     // }
//                                   },
//                                   child: CachedNetworkImage(
//                                     imageUrl: discount
//                                         .discount!.content[index].contentImg,
//                                     fit: BoxFit.cover,
//                                     width: MediaQuery.of(context).size.width,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // child: Showcase(
//                             //   scrollLoadingWidget: const CircularProgressIndicator(
//                             //       valueColor:
//                             //           AlwaysStoppedAnimation(Colors.transparent)),
//                             //   //overlayColor: theme_color_df,
//                             //   overlayPadding: const EdgeInsets.all(3),
//                             //   
//                             //   targetPadding: const EdgeInsets.all(20),
//                             //   descTextStyle: const TextStyle(
//                             //       fontSize: 16, color: Colors.white),
//                             //   key: widget.keyFive!,
//                             //   //title: 'Menu',
//                             //   description:
//                             //       widget.ChangeLanguage.translate('txt_guide4'),
//                             //   disposeOnTap: true,
//                             //   onTargetClick: () {
//                             //     setState(() {
//                             //       ShowCaseWidget.of(context)
//                             //           .startShowCase([widget.keySix!]);
//                             //     });
//                             //   },
//                             //   child: ClipRRect(
//                             //     borderRadius: BorderRadius.circular(8.0),
//                             //     child: GestureDetector(
//                             //       onTap: () {
//                             //         // // ignore: avoid_print
//                             //         // print(
//                             //         //     discount.discount!.content[index].toJson());
//                             //         // if (discount
//                             //         //         .discount!.content[index].keyindex !=
//                             //         //     'sku') {
//                             //         //   bannerProduct.fetch_product_banner(
//                             //         //       discount.discount!.content[index]
//                             //         //           .contentIndcx,
//                             //         //       discount
//                             //         //           .discount!.content[index].campaign);
//                             //         //   Get.to(() => Scaffold(
//                             //         //       appBar: appBarTitleCart('รายการสินค้า'),
//                             //         //       body: Obx(() =>
//                             //         //           bannerProduct.isDataLoading.value
//                             //         //               ? const Center(
//                             //         //                   child:
//                             //         //                       CircularProgressIndicator(),
//                             //         //                 )
//                             //         //               : showList(
//                             //         //                   context,
//                             //         //                   bannerProduct.BannerProduct!
//                             //         //                       .skucode))));
//                             //         // } else {
//                             //         //   Get.find<CategoryProductDetailController>()
//                             //         //       .fetchproductdetail(
//                             //         //           discount.discount!.content[index]
//                             //         //               .campaign,
//                             //         //           discount.discount!.content[index]
//                             //         //               .contentIndcx,
//                             //         //           discount
//                             //         //               .discount!.content[index].band,
//                             //         //           discount
//                             //         //               .discount!.content[index].fsCode);
//                             //         //   Get.toNamed('my_detail');
//                             //         // }
//                             //       },
//                             //       child: CachedNetworkImage(
//                             //         imageUrl: discount
//                             //             .discount!.content[index].contentImg,
//                             //         fit: BoxFit.cover,
//                             //         width: MediaQuery.of(context).size.width,
//                             //       ),
//                             //     ),
//                             //   ),
//                             // ),
//                           );
//                         } else {
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 10.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(8.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   // // ignore: avoid_print
//                                   // print(discount.discount!.content[index].toJson());
//                                   // if (discount.discount!.content[index].keyindex !=
//                                   //     'sku') {
//                                   //   bannerProduct.fetch_product_banner(
//                                   //       discount
//                                   //           .discount!.content[index].contentIndcx,
//                                   //       discount.discount!.content[index].campaign);
//                                   //   Get.to(() => Scaffold(
//                                   //       appBar: appBarTitleCart('รายการสินค้า'),
//                                   //       body: Obx(() => bannerProduct
//                                   //               .isDataLoading.value
//                                   //           ? const Center(
//                                   //               child: CircularProgressIndicator(),
//                                   //             )
//                                   //           : showList(
//                                   //               context,
//                                   //               bannerProduct
//                                   //                   .BannerProduct!.skucode))));
//                                   // } else {
//                                   //   Get.find<CategoryProductDetailController>()
//                                   //       .fetchproductdetail(
//                                   //           discount
//                                   //               .discount!.content[index].campaign,
//                                   //           discount.discount!.content[index]
//                                   //               .contentIndcx,
//                                   //           discount.discount!.content[index].band,
//                                   //           discount
//                                   //               .discount!.content[index].fsCode);
//                                   //   Get.toNamed('my_detail');
//                                   // }
//                                 },
//                                 child: CachedNetworkImage(
//                                   imageUrl: discount
//                                       .discount!.content[index].contentImg,
//                                   fit: BoxFit.cover,
//                                   width: MediaQuery.of(context).size.width,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                       }
//                     },
//                   ),
//                 ],
//               );
//             }
//             return Column(
//               children: [
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Text(
//                 //       widget.specialDiscount.textHeader,
//                 //       style: TextStyle(
//                 //           fontFamily: 'notoreg', color: theme_color_df, fontSize: 15),
//                 //     ),
//                 //     TextButton(
//                 //       onPressed: () {
//                 //         Get.to(() => content_list(
//                 //               mparamType: 'content',
//                 //               mparamTitleName: widget.specialDiscount.textHeader,
//                 //             ));
//                 //       },
//                 //       style: ElevatedButton.styleFrom(
//                 //           primary: theme_color_df,
//                 //           padding:
//                 //               const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
//                 //           textStyle:
//                 //               const TextStyle(fontSize: 15, fontFamily: 'notoreg')),
//                 //       child: Text(
//                 //         MultiLanguages.of(context)!.translate('home_page_see_more'),
//                 //         style: const TextStyle(color: Colors.white),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 Shimmer.fromColors(
//                   highlightColor: kBackgroundColor,
//                   baseColor: const Color(0xFFE0E0E0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                     child: Container(
//                       height: 200,
//                       color: Colors.grey[400],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Container();
//           }
//         }),
//       ),
//     );
//   }
// }
