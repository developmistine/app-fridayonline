// import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
// import 'package:fridayonline/homepage/login/anonymous_login.dart';
// import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
// import 'package:fridayonline/homepage/theme/setbillcolor.dart';
// import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
// import 'package:bouncing_widget/bouncing_widget.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';

// import '../../controller/cart/function_add_to_cart.dart';
// import '../../service/languages/multi_languages.dart';
// import '../theme/theme_color.dart';

// // showList( List<Skucode>items) {
// showListBackup(context, items, mchannel, mchannelId) {
//   bool show;
//   double width = MediaQuery.of(context).size.width;

//   return items.length < 1
//       ? Center(
//           child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child:
//                   Image.asset('assets/images/logo/logofriday.png', width: 70),
//             ),
//             const Text('ไม่พบสินค้า'),
//           ],
//         ))
//       : GridView.builder(
//           scrollDirection: Axis.vertical,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: (width >= 768.0) ? 3 : 2,
//               mainAxisSpacing: 1.0,
//               crossAxisSpacing: 1.0,
//               mainAxisExtent: 280),
//           // itemCount: 10,
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             (items[index].img != '') ? show = true : show = false;
//             return MediaQuery(
//               data: MediaQuery.of(context)
//                   .copyWith(textScaler: const TextScaler.linear(1.0)),
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color.fromARGB(14, 0, 0, 0),
//                         offset: Offset(0.0, 4.0),
//                         blurRadius: 0.2,
//                         spreadRadius: 0.2,
//                       ), //BoxShadow
//                     ],
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(children: [
//                     // if (show)
//                     GestureDetector(
//                       onLongPress: (() {
//                         Get.to(() => const ProductDetailPage());
//                       }),
//                       onTap: () {
//                         // !Get.to(() => DetailProduct() ใช้ได้
//                         Get.find<ProductDetailController>()
//                             .productDetailController(
//                           items[index].campaign,
//                           items[index].billCode,
//                           items[index].mediaCode,
//                           items[index].sku,
//                           mchannel,
//                           mchannelId,
//                         );
//                         Get.to(() => const ProductDetailPage());
//                         // Get.find<CategoryProductDetailController>()
//                         //     .fetchproductdetail(
//                         //         items[index].campaign,
//                         //         items[index].billCode,
//                         //         items[index].brand,
//                         //         items[index].sku,
//                         //         mchannel,
//                         //         mchannelId,
//                         //         '');
//                         // Get.toNamed('/my_detail', parameters: {
//                         //   'mchannel': mchannel,
//                         //   'mchannelId': mchannelId
//                         // });
//                       },
//                       child: Stack(
//                         children: <Widget>[
//                           if (show)
//                             Center(
//                               child: CachedNetworkImage(
//                                 imageUrl: items[index].img,
//                                 height: 150,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           if (!show)
//                             Center(
//                                 child: Image.asset(
//                               imageError,
//                               height: 150,
//                             )),
//                           Positioned(
//                             top: 0.0,
//                             left: 0.0,
//                             child: CachedNetworkImage(
//                               imageUrl: items[index].imgNetPrice,
//                               height:
//                                   (items[index].flagNetPrice == 'Y') ? 60 : 0,
//                               // fit: BoxFit.contain,
//                             ),
//                           ),
//                           Positioned(
//                               top: 0.0,
//                               right: 0.0,
//                               child: CachedNetworkImage(
//                                 imageUrl: items[index].imgAppend,
//                                 height:
//                                     (items[index].isInStock == false) ? 80 : 0,
//                                 // fit: BoxFit.contain,
//                               )),
//                         ],
//                       ),
//                     ),
//                     // if (show)
//                     Flexible(
//                       child: Wrap(
//                         children: [
//                           SizedBox(
//                             height: 50.0,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 2, horizontal: 14),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(items[index].name,
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       textAlign: TextAlign.start,
//                                       style: const TextStyle(fontSize: 12)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 2, horizontal: 14),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   flex: 4,
//                                   child: Column(
//                                     // direction: Axis.vertical,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "${MultiLanguages.of(context)!.translate('product_code')} ${items[index].billCode}",
//                                         style: TextStyle(
//                                             fontFamily: 'notoreg',
//                                             fontSize: 12,
//                                             color: setBillColor(
//                                                 items[index].color)),
//                                       ),
//                                       Text(
//                                         "${MultiLanguages.of(context)!.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(items[index].specialPrice))} ${MultiLanguages.of(context)!.translate('order_baht')}",
//                                         style: const TextStyle(
//                                             fontSize: 14,
//                                             fontFamily: 'notoreg',
//                                             color:
//                                                 Color.fromARGB(255, 0, 0, 0)),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: BouncingWidget(
//                                       duration:
//                                           const Duration(milliseconds: 100),
//                                       scaleFactor: 1.5,
//                                       onPressed: () async {
//                                         final Future<SharedPreferences> _prefs =
//                                             SharedPreferences.getInstance();

//                                         final SharedPreferences prefs =
//                                             await _prefs;
//                                         late String? lslogin;
//                                         lslogin = prefs.getString("login");

//                                         if (lslogin == null) {
//                                           Get.to(() => const Anonumouslogin());
//                                         } else {
//                                           await fnEditCart(
//                                               context,
//                                               items[index],
//                                               'CategoryList',
//                                               mchannel,
//                                               mchannelId);
//                                         }
//                                       },
//                                       child: ImageBasget),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//             );
//           });
// }

// showCaseShowList(
//     context,
//     items,
//     mchannel,
//     mchannelId,
//     MultiLanguages ChangeLanguage,
//     GlobalKey<State<StatefulWidget>> keyOne,
//     GlobalKey<State<StatefulWidget>> keyTwo) {
//   double scale = 1.0;
//   bool show;
//   double height = Get.height;
//   double width = MediaQuery.of(context).size.width;

//   return items.length < 1
//       ? Center(
//           child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child:
//                   Image.asset('assets/images/logo/logofriday.png', width: 70),
//             ),
//             const Text('ไม่พบสินค้า'),
//           ],
//         ))
//       : Stack(
//           children: [
//             GridView.builder(
//                 scrollDirection: Axis.vertical,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: (width >= 768.0) ? 3 : 2,
//                     mainAxisSpacing: 1.0,
//                     crossAxisSpacing: 1.0,
//                     mainAxisExtent: 280),
//                 // itemCount: 10,
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   (items[index].img != '') ? show = true : show = false;
//                   if (index == 0) {
//                     return Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Showcase.withWidget(
//                         disableMovingAnimation: true,
//                         width: width,
//                         height: height / 1.4,
//                         container: InkWell(
//                           onTap: () {
//                             ShowCaseWidget.of(context).next();
//                           },
//                           child: MediaQuery(
//                             data: MediaQuery.of(context).copyWith(
//                                 textScaler: const TextScaler.linear(1.0)),
//                             child: SizedBox(
//                               width: width / 1.1,
//                               height: height / 2.2,
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.max,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     margin: const EdgeInsets.only(
//                                         left: 10.0, top: 30),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(8.0),
//                                       child: Container(
//                                           color: theme_color_df,
//                                           width: 250,
//                                           height: 80,
//                                           child: Center(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Text(
//                                                 textAlign: TextAlign.center,
//                                                 ChangeLanguage.translate(
//                                                     'guide_product_category2'),
//                                                 style: const TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 16),
//                                               ),
//                                             ),
//                                           )),
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: const EdgeInsets.only(left: 190.0),
//                                     child: ElevatedButton(
//                                         style: ButtonStyle(
//                                             foregroundColor:
//                                                 MaterialStateProperty.all<Color>(
//                                                     theme_color_df),
//                                             backgroundColor:
//                                                 MaterialStateProperty.all<Color>(
//                                                     Colors.white),
//                                             shape: MaterialStateProperty.all<
//                                                     RoundedRectangleBorder>(
//                                                 RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             30.0),
//                                                     side: BorderSide(
//                                                         color: theme_color_df)))),
//                                         onPressed: () {
//                                           ShowCaseWidget.of(context).next();
//                                         },
//                                         child: SizedBox(
//                                           width: 50,
//                                           height: 40,
//                                           child: Center(
//                                             child: Text(
//                                                 maxLines: 1,
//                                                 ChangeLanguage.translate(
//                                                     'btn_end_guide'),
//                                                 style: const TextStyle(
//                                                     fontSize: 16)),
//                                           ),
//                                         )),
//                                   ),
//                                   Expanded(
//                                     child: Align(
//                                         alignment: Alignment.bottomCenter,
//                                         child: IconButton(
//                                             icon: const Icon(
//                                               Icons.close,
//                                               color: Colors.white,
//                                             ),
//                                             onPressed: () {
//                                               ShowCaseWidget.of(context).next();
//                                             })),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         //overlayColor: theme_color_df,
//                         targetPadding: const EdgeInsets.all(20),
//                         key: keyTwo,
//                         disposeOnTap: true,
//                         onTargetClick: () {
//                           ShowCaseWidget.of(context).next();
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Color.fromARGB(14, 0, 0, 0),
//                                 offset: Offset(0.0, 4.0),
//                                 blurRadius: 0.2,
//                                 spreadRadius: 0.2,
//                               ), //BoxShadow
//                             ],
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Column(children: [
//                             // if (show)
//                             GestureDetector(
//                               onTap: () {
//                                 // !Get.to(() => DetailProduct() ใช้ได้
//                                 Get.find<ProductDetailController>()
//                                     .productDetailController(
//                                   items[index].campaign,
//                                   items[index].billCode,
//                                   items[index].mediaCode,
//                                   items[index].sku,
//                                   mchannel,
//                                   mchannelId,
//                                 );
//                                 Get.to(() => const ProductDetailPage());
//                                 // Get.find<CategoryProductDetailController>()
//                                 //     .fetchproductdetail(
//                                 //         items[index].campaign,
//                                 //         items[index].billCode,
//                                 //         items[index].brand,
//                                 //         items[index].sku,
//                                 //         mchannel,
//                                 //         mchannelId,
//                                 //         '');
//                                 // Get.toNamed('/my_detail', parameters: {
//                                 //   'mchannel': mchannel,
//                                 //   'mchannelId': mchannelId
//                                 // });
//                               },
//                               child: Stack(
//                                 children: <Widget>[
//                                   if (show)
//                                     Center(
//                                       child: CachedNetworkImage(
//                                         imageUrl: items[index].img,
//                                         height: 150,
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                   if (!show)
//                                     Center(
//                                         child: Image.asset(
//                                       imageError,
//                                       height: 150,
//                                     )),
//                                   Positioned(
//                                     top: 0.0,
//                                     left: 0.0,
//                                     child: CachedNetworkImage(
//                                       imageUrl: items[index].imgNetPrice,
//                                       height: (items[index].flagNetPrice == 'Y')
//                                           ? 60
//                                           : 0,
//                                       // fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                   Positioned(
//                                       top: 0.0,
//                                       right: 0.0,
//                                       child: CachedNetworkImage(
//                                         imageUrl: items[index].imgAppend,
//                                         height:
//                                             (items[index].isInStock == false)
//                                                 ? 80
//                                                 : 0,
//                                         // fit: BoxFit.contain,
//                                       )),
//                                 ],
//                               ),
//                             ),
//                             // if (show)
//                             Flexible(
//                               child: Wrap(
//                                 children: [
//                                   SizedBox(
//                                     height: 50.0,
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 2, horizontal: 14),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(items[index].name,
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.start,
//                                               style: const TextStyle(
//                                                   fontSize: 12)),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   ListTile(
//                                     title: RichText(
//                                       textAlign: TextAlign.left,
//                                       text: TextSpan(
//                                           text:
//                                               "${ChangeLanguage.translate('product_code')} ${items[index].billCode}\n",
//                                           style: TextStyle(
//                                             fontFamily: 'notoreg',
//                                             fontSize: 12,
//                                             color: setBillColor(
//                                                 items[index].color),
//                                           ),
//                                           children: [
//                                             TextSpan(
//                                               text:
//                                                   "${ChangeLanguage.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(items[index].specialPrice))}",
//                                               style: const TextStyle(
//                                                   fontSize: 14,
//                                                   fontFamily: 'notoreg',
//                                                   color: Color.fromARGB(
//                                                       255, 0, 0, 0)),
//                                             )
//                                           ]),
//                                     ),
//                                     trailing: BouncingWidget(
//                                       duration:
//                                           const Duration(milliseconds: 100),
//                                       scaleFactor: 1.5,
//                                       onPressed: () async {
//                                         final Future<SharedPreferences> _prefs =
//                                             SharedPreferences.getInstance();

//                                         final SharedPreferences prefs =
//                                             await _prefs;
//                                         late String? lslogin;
//                                         lslogin = prefs.getString("login");

//                                         if (lslogin == null) {
//                                           Get.to(
//                                               transition:
//                                                   Transition.rightToLeft,
//                                               () => const Anonumouslogin());
//                                         } else {
//                                           await fnEditCart(
//                                               context,
//                                               items[index],
//                                               'CategoryList',
//                                               mchannel,
//                                               mchannelId);
//                                         }
//                                       },
//                                       child: Showcase.withWidget(
//                                         targetShapeBorder: const CircleBorder(),
//                                         disableMovingAnimation: true,
//                                         width: width,
//                                         height: height / 1.4,
//                                         container: InkWell(
//                                           onTap: () {
//                                             ShowCaseWidget.of(context)
//                                                 .startShowCase([keyTwo]);
//                                           },
//                                           child: MediaQuery(
//                                             data: MediaQuery.of(context)
//                                                 .copyWith(
//                                                     textScaler:
//                                                         const TextScaler.linear(
//                                                             1.0)),
//                                             child: SizedBox(
//                                               width: width / 1.1,
//                                               height: height / 2.1,
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: [
//                                                   Container(
//                                                     margin:
//                                                         const EdgeInsets.only(
//                                                             left: 20.0,
//                                                             top: 30),
//                                                     child: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               8.0),
//                                                       child: Container(
//                                                           color: theme_color_df,
//                                                           width: 250,
//                                                           height: 80,
//                                                           child: Center(
//                                                             child: Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .all(8.0),
//                                                               child: Text(
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .center,
//                                                                 ChangeLanguage
//                                                                     .translate(
//                                                                         'guide_product_category'),
//                                                                 style: const TextStyle(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     fontSize:
//                                                                         16),
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                     margin:
//                                                         const EdgeInsets.only(
//                                                             left: 190.0),
//                                                     child: ElevatedButton(
//                                                         style: ButtonStyle(
//                                                             foregroundColor:
//                                                                 MaterialStateProperty.all<Color>(
//                                                                     theme_color_df),
//                                                             backgroundColor:
//                                                                 MaterialStateProperty
//                                                                     .all<Color>(
//                                                                         Colors
//                                                                             .white),
//                                                             shape: MaterialStateProperty.all<
//                                                                     RoundedRectangleBorder>(
//                                                                 RoundedRectangleBorder(
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(30.0),
//                                                                     side: BorderSide(color: theme_color_df)))),
//                                                         onPressed: () {
//                                                           ShowCaseWidget.of(
//                                                                   context)
//                                                               .startShowCase(
//                                                                   [keyTwo]);
//                                                         },
//                                                         child: SizedBox(
//                                                           width: 50,
//                                                           height: 40,
//                                                           child: Center(
//                                                             child: Text(
//                                                                 maxLines: 1,
//                                                                 ChangeLanguage
//                                                                     .translate(
//                                                                         'btn_next_guide'),
//                                                                 style:
//                                                                     const TextStyle(
//                                                                         fontSize:
//                                                                             16)),
//                                                           ),
//                                                         )),
//                                                   ),
//                                                   Expanded(
//                                                     child: Align(
//                                                         alignment: Alignment
//                                                             .bottomCenter,
//                                                         child: IconButton(
//                                                             icon: const Icon(
//                                                               Icons.close,
//                                                               color:
//                                                                   Colors.white,
//                                                             ),
//                                                             onPressed: () {
//                                                               ShowCaseWidget.of(
//                                                                       context)
//                                                                   .next();
//                                                               ShowCaseWidget.of(
//                                                                       context)
//                                                                   .next();
//                                                             })),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         //overlayColor: theme_color_df,
//                                         targetPadding: const EdgeInsets.all(20),
//                                         key: keyOne,
//                                         disposeOnTap: true,
//                                         onTargetClick: () {
//                                           ShowCaseWidget.of(context)
//                                               .startShowCase([keyTwo]);
//                                         },
//                                         child: AnimatedScale(
//                                             scale: scale,
//                                             duration:
//                                                 const Duration(seconds: 2),
//                                             child: ImageBasget),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ]),
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Color.fromARGB(14, 0, 0, 0),
//                               offset: Offset(0.0, 4.0),
//                               blurRadius: 0.2,
//                               spreadRadius: 0.2,
//                             ), //BoxShadow
//                           ],
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Column(children: [
//                           // if (show)
//                           GestureDetector(
//                             onTap: () {
//                               // !Get.to(() => DetailProduct() ใช้ได้
//                               Get.find<ProductDetailController>()
//                                   .productDetailController(
//                                 items[index].campaign,
//                                 items[index].billCode,
//                                 items[index].mediaCode,
//                                 items[index].sku,
//                                 mchannel,
//                                 mchannelId,
//                               );
//                               Get.to(() => const ProductDetailPage());
//                               // Get.find<CategoryProductDetailController>()
//                               //     .fetchproductdetail(
//                               //         items[index].campaign,
//                               //         items[index].billCode,
//                               //         items[index].brand,
//                               //         items[index].sku,
//                               //         mchannel,
//                               //         mchannelId,
//                               //         '');
//                               // Get.toNamed('/my_detail', parameters: {
//                               //   'mchannel': mchannel,
//                               //   'mchannelId': mchannelId
//                               // });
//                             },
//                             child: Stack(
//                               children: <Widget>[
//                                 if (show)
//                                   Center(
//                                     child: CachedNetworkImage(
//                                       imageUrl: items[index].img,
//                                       height: 150,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 if (!show)
//                                   Center(
//                                       child: Image.asset(
//                                     imageError,
//                                     height: 150,
//                                   )),
//                                 Positioned(
//                                   top: 0.0,
//                                   left: 0.0,
//                                   child: CachedNetworkImage(
//                                     imageUrl: items[index].imgNetPrice,
//                                     height: (items[index].flagNetPrice == 'Y')
//                                         ? 60
//                                         : 0,
//                                     // fit: BoxFit.contain,
//                                   ),
//                                 ),
//                                 Positioned(
//                                     top: 0.0,
//                                     right: 0.0,
//                                     child: CachedNetworkImage(
//                                       imageUrl: items[index].imgAppend,
//                                       height: (items[index].isInStock == false)
//                                           ? 80
//                                           : 0,
//                                       // fit: BoxFit.contain,
//                                     )),
//                               ],
//                             ),
//                           ),
//                           // if (show)
//                           Flexible(
//                             child: Wrap(
//                               children: [
//                                 SizedBox(
//                                   height: 50.0,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 2, horizontal: 14),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(items[index].name,
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.start,
//                                             style:
//                                                 const TextStyle(fontSize: 12)),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 ListTile(
//                                   title: RichText(
//                                     textAlign: TextAlign.left,
//                                     text: TextSpan(
//                                         text:
//                                             "${ChangeLanguage.translate('product_code')} ${items[index].billCode}\n",
//                                         style: TextStyle(
//                                           fontFamily: 'notoreg',
//                                           fontSize: 12,
//                                           color:
//                                               setBillColor(items[index].color),
//                                         ),
//                                         children: [
//                                           TextSpan(
//                                             text:
//                                                 "${ChangeLanguage.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(items[index].specialPrice))}",
//                                             style: const TextStyle(
//                                                 fontSize: 14,
//                                                 fontFamily: 'notoreg',
//                                                 color: Color.fromARGB(
//                                                     255, 0, 0, 0)),
//                                           )
//                                         ]),
//                                   ),
//                                   trailing: BouncingWidget(
//                                     duration: const Duration(milliseconds: 100),
//                                     scaleFactor: 1.5,
//                                     onPressed: () async {
//                                       final Future<SharedPreferences> _prefs =
//                                           SharedPreferences.getInstance();

//                                       final SharedPreferences prefs =
//                                           await _prefs;
//                                       late String? lslogin;
//                                       lslogin = prefs.getString("login");

//                                       if (lslogin == null) {
//                                         Get.to(
//                                             transition: Transition.rightToLeft,
//                                             () => const Anonumouslogin());
//                                       } else {
//                                         await fnEditCart(
//                                             context,
//                                             items[index],
//                                             'CategoryList',
//                                             mchannel,
//                                             mchannelId);
//                                       }
//                                     },
//                                     child: AnimatedScale(
//                                         scale: scale,
//                                         duration: const Duration(seconds: 2),
//                                         child: ImageBasget),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ]),
//                       ),
//                     );
//                   }
//                 }),
//           ],
//         );
// }
