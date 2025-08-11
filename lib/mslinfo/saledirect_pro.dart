// import 'dart:developer';

// import 'package:fridayonline/homepage/page_showproduct/List_product.dart';
// import 'package:fridayonline/homepage/theme/theme_loading.dart';
// import 'package:fridayonline/model/set_data/set_data_saledirect.dart';
// import 'package:fridayonline/service/profileuser/getsaledirect.dart';

// import '../../homepage/widget/appbar_cart.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/category/category_controller.dart';
// import '../../controller/home/home_controller.dart';
// import '../model/set_data/set_data_saledirect_pro.dart';
// import '../service/languages/multi_languages.dart';

// class saledirect_pro extends StatelessWidget {
//   saledirect_pro(
//       {super.key,
//       required this.mparamType,
//       required this.keyindex,
//       required this.contentIndcx,
//       required this.mparamTitleName,
//       required this.band,
//       required this.imgurl});
//   String mparamType, mparamTitleName, keyindex, contentIndcx, band, imgurl;

//   // SpecialDiscountController dataController =
//   //     Get.put(SpecialDiscountController());
//   ProductFromBanner bannerProduct = Get.put(ProductFromBanner());

//   @override
//   Widget build(BuildContext context) {
//     // log(imgurl.toString());
//     return FutureBuilder(
//       future: getSaleDirectPro(),
//       builder:
//           (BuildContext context, AsyncSnapshot<GetSaleDirectPro?> snapshot) {
//         if (snapshot.hasData) {
//           var mparmMenu = snapshot.data;
//           if(mparmMenu!.content.isNotEmpty){
//             return Scaffold(
//             appBar: appBarTitleCart(mparamTitleName, ""),
//             body: SafeArea(
//               child: ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: mparmMenu.content.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 5, horizontal: 5),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           // print(mpaหrmMenu.content[index].toJson());
//                           if (mparmMenu.content[index].keyindex != 'sku') {
//                             // bannerProduct.fetch_product_banner(
//                             mparmMenu.content[index].contentIndcx;
//                             mparmMenu.content[index].campaign;
//                             Get.to(() => Scaffold(
//                                 appBar: appBarTitleCart(
//                                     MultiLanguages.of(context)!
//                                         .translate('home_page_list_products'),
//                                     ""),
//                                 body: Obx(() => bannerProduct
//                                         .isDataLoading.value
//                                     ? const Center(
//                                         child: CircularProgressIndicator(),
//                                       )
//                                     : showList(
//                                         context,
//                                         mparmMenu.content[index].fsCode,
//                                         '',
//                                         ''))));
//                           } else {
//                             Get.find<CategoryProductDetailController>()
//                                 .fetchproductdetail(
//                                     mparmMenu.content[index].campaign,
//                                     mparmMenu.content[index].contentIndcx,
//                                     mparmMenu.content[index].band,
//                                     mparmMenu.content[index].fsCode,
//                                     '',
//                                     '',
//                                     '');
//                             Get.toNamed('my_detail');
//                           }
//                         },
//                         child: CachedNetworkImage(
//                           imageUrl: mparmMenu.content[index].contentImg,
//                           fit: BoxFit.cover,
//                           width: MediaQuery.of(context).size.width,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
       
//           }else{
//             return Center(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/logo/logofriday.png',
//                   width: 50,
//                   height: 50,
//                 ),
//                 Text(MultiLanguages.of(context)!.translate('alert_no_datas')),
//               ],
//             ));
//           }
//            }else{
//             return theme_loading_df;
//            }
        
//       },
//     );
//   }
// }
