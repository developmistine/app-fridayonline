// import 'dart:developer';

// import 'package:fridayonline/homepage/theme/theme_loading.dart';

// import '../../homepage/widget/appbar_cart.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/category/category_controller.dart';
// import '../../controller/home/home_controller.dart';
// import '../../service/languages/multi_languages.dart';
// import '../../service/logapp/logapp_service.dart';
// import '../page_showproduct/List_product.dart';
// import 'cache_image.dart';

// class content_list extends StatelessWidget {
//   content_list(
//       {super.key, required this.mparamType, required this.mparamTitleName});
//   String mparamType, mparamTitleName;
//   ProductFromBanner bannerProduct = Get.put(ProductFromBanner());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarTitleCart(mparamTitleName, ""),
//       body: SingleChildScrollView(
//         physics: const ScrollPhysics(),
//         child: GetX<SpecialDiscountLoadMoreController>(
//           builder: ((dataController) {
//             if (!dataController.isDataLoading.value) {
//               return ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: dataController.discount!.listProductDetail.length,
//                 itemBuilder: (context, index) {
//                   if (dataController.discount!.listProductDetail[index].id !=
//                       "") {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 5, horizontal: 5),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: GestureDetector(
//                           onTap: () {
//                             print("LogApp Special Discount List");

//                             var mchannel = '5';
//                             var mchannelId = dataController
//                                 .discount!.listProductDetail[index].id;
//                             //LogApp
//                             LogAppTisCall(mchannel, mchannelId);
//                             //  End
//                             // print(dataController.discount!.listProductDetail[index].toJson());
//                             if (dataController.discount!
//                                     .listProductDetail[index].keyindex !=
//                                 'sku') {
//                               bannerProduct.fetch_product_banner(
//                                   dataController.discount!
//                                       .listProductDetail[index].contentIndcx,
//                                   dataController.discount!
//                                       .listProductDetail[index].campaign);
//                               Get.to(() => Scaffold(
//                                   appBar: appBarTitleCart(
//                                       MultiLanguages.of(context)!
//                                           .translate('home_page_list_products'),
//                                       ""),
//                                   body: Obx(() => bannerProduct
//                                           .isDataLoading.value
//                                       ? const Center(
//                                           child: CircularProgressIndicator(),
//                                         )
//                                       : showList(
//                                           context,
//                                           bannerProduct.BannerProduct!.skucode,
//                                           mchannel,
//                                           mchannelId))));
//                             } else {
//                               Get.find<CategoryProductDetailController>()
//                                   .fetchproductdetail(
//                                       dataController.discount!
//                                           .listProductDetail[index].campaign,
//                                       dataController
//                                           .discount!
//                                           .listProductDetail[index]
//                                           .contentIndcx,
//                                       dataController.discount!
//                                           .listProductDetail[index].band,
//                                       dataController.discount!
//                                           .listProductDetail[index].fsCode,
//                                       '',
//                                       '',
//                                       '');
//                               Get.toNamed('my_detail');
//                             }
//                           },
//                           child: CachedNetworkImage(
//                             imageUrl: dataController
//                                 .discount!.listProductDetail[index].contentImg,
//                             fit: BoxFit.cover,
//                             width: MediaQuery.of(context).size.width,
//                           ),
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               );
//             } else {
//               return Center(
//                 heightFactor: 15,
//                 child: theme_loading_df,
//               );
//             }
//           }),
//         ),
//       ),
//     );
//   }
// }
