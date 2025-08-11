// // ignore_for_file: must_be_immutable, unnecessary_null_comparison

// import 'package:shimmer/shimmer.dart';

// import '../../../controller/home/home_controller.dart';
// import '../../theme/theme_color.dart';
// import '../../../service/languages/multi_languages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controller/category/category_controller.dart';
// import '../../../service/logapp/logapp_service.dart';
// import '../../page_showproduct/List_product.dart';
// import '../../theme/constants.dart';
// import '../../widget/appbar_cart.dart';
// import '../cache_image.dart';
// import '../content_list.dart';

// class HomeSpecialDiscount extends StatefulWidget {
//   const HomeSpecialDiscount({Key? key}) : super(key: key);

//   @override
//   State<HomeSpecialDiscount> createState() => _HomeSpecialDiscountState();
// }

// class _HomeSpecialDiscountState extends State<HomeSpecialDiscount> {
//   ProductFromBanner bannerProduct = Get.put(ProductFromBanner());

//   @override
//   Widget build(BuildContext context) {
//     return GetX<SpecialDiscountController>(
//       builder: ((discount) {
//         if (!discount.isDataLoading.value) {
//           if (discount.discount!.content.isNotEmpty) {
//             return Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       discount.discount!.textHeader,
//                       style: TextStyle(
//                           fontFamily: 'notoreg',
//                           color: theme_color_df,
//                           fontSize: 18),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Get.find<SpecialDiscountLoadMoreController>()
//                             .fetch_special_discount();
//                         Get.to(() => content_list(
//                               mparamType: 'content',
//                               mparamTitleName: discount.discount!.textHeader,
//                             ));
//                       },
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: theme_color_df,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 30, vertical: 5),
//                           textStyle: const TextStyle(
//                               fontSize: 15, fontFamily: 'notoreg')),
//                       child: Text(
//                         MultiLanguages.of(context)!
//                             .translate('home_page_see_more'),
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//                 ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: discount.discount!.content.length,
//                   itemBuilder: (context, index) {
//                     if (discount.discount!.content[index].id == "") {
//                       return Container();
//                     } else {
//                       return Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               print("LogApp Special Discount");
//                               //LogApp
//                               var mchannel = '5';
//                               var mchannelId =
//                                   discount.discount!.content[index].id;
//                               LogAppTisCall(mchannel, mchannelId);
//                               //  End
//                               // ignore: avoid_print
//                               print(discount.discount!.content[index].toJson());
//                               if (discount.discount!.content[index].keyindex !=
//                                   'sku') {
//                                 bannerProduct.fetch_product_banner(
//                                     discount
//                                         .discount!.content[index].contentIndcx,
//                                     discount.discount!.content[index].campaign);
//                                 Get.to(() => Scaffold(
//                                     appBar: appBarTitleCart(
//                                         MultiLanguages.of(context)!.translate(
//                                             'home_page_list_products'),
//                                         ""),
//                                     body: Obx(() => bannerProduct
//                                             .isDataLoading.value
//                                         ? const Center(
//                                             child: CircularProgressIndicator(),
//                                           )
//                                         : showList(
//                                             context,
//                                             bannerProduct
//                                                 .BannerProduct!.skucode,
//                                             mchannel,
//                                             mchannelId))));
//                               } else {
//                                 Get.find<CategoryProductDetailController>()
//                                     .fetchproductdetail(
//                                         discount
//                                             .discount!.content[index].campaign,
//                                         discount.discount!.content[index]
//                                             .contentIndcx,
//                                         discount.discount!.content[index].band,
//                                         discount
//                                             .discount!.content[index].fsCode,
//                                         mchannel,
//                                         mchannelId,
//                                         '');
//                                 Get.toNamed('/my_detail', parameters: {
//                                   'mchannel': mchannel,
//                                   'mchannelId': mchannelId
//                                 });
//                               }
//                             },
//                             child: CacheImageDiscount(
//                                 url: discount
//                                     .discount!.content[index].contentImg),
//                             // child: CachedNetworkImage(
//                             //   imageUrl:
//                             //       discount.discount!.content[index].contentImg,
//                             //   fit: BoxFit.cover,
//                             //   width: MediaQuery.of(context).size.width,
//                             // ),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(
//                 //       left: 10, right: 10, bottom: 10, top: 20),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.start,
//                 //     children: [
//                 //       Text(
//                 //         MultiLanguages.of(context)!.translate('header_title'),
//                 //         style: const TextStyle(
//                 //             fontFamily: 'notoreg',
//                 //             color: Color(0xFF2EA9E1),
//                 //             fontSize: 15),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             );
//           } else {
//             return Container();
//           }
//         }
//         return Column(
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: SizedBox(
//                 width: 120,
//                 child: Shimmer.fromColors(
//                   highlightColor: kBackgroundColor,
//                   baseColor: const Color(0xFFE0E0E0),
//                   child: ElevatedButton(
//                     child: const SizedBox(),
//                     onPressed: () {},
//                   ),
//                 ),
//               ),
//             ),
//             Shimmer.fromColors(
//               highlightColor: kBackgroundColor,
//               baseColor: const Color(0xFFE0E0E0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Container(
//                   height: 200,
//                   color: Colors.grey[400],
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
