// import 'package:fridayonline/controller/home/home_controller.dart';
// import 'package:fridayonline/homepage/page_showproduct/List_product.dart';
// import 'package:fridayonline/homepage/widget/appbar_cart.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../../service/languages/multi_languages.dart';
// import '../../../../service/logapp/logapp_service.dart';
// import '../../theme/constants.dart';
// import '../cache_image.dart';

// class HomeFavorite extends StatefulWidget {
//   const HomeFavorite({Key? key}) : super(key: key);

//   @override
//   State<HomeFavorite> createState() => _HomeFavoriteState();
// }

// class _HomeFavoriteState extends State<HomeFavorite> {
//   @override
//   Widget build(BuildContext context) {
//     return GetX<FavoriteController>(
//       builder: ((favorite) {
//         if (!favorite.isDataLoading.value) {
//           if (favorite.favorite!.favorite.isNotEmpty) {
//             return MediaQuery(
//               data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
//               child: GridView.builder(
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: favorite.favorite!.favorite.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                     onTap: () {
//                       print("LogApp Favorite Icon");
//                       var mchannel = '2';
//                       var mchannelId = favorite.favorite!.favorite[index].id;
//                       //LogApp
//                       LogAppTisCall(mchannel, mchannelId);
//                       //  End

//                       Get.put(FavoriteGetProductController())
//                           .fetch_favorite_product(favorite
//                               .favorite!.favorite[index].favoritedataindex);
//                       Get.to(() => Scaffold(
//                           appBar: appBarTitleCart(
//                               MultiLanguages.of(context)!
//                                   .translate('home_page_list_products'),
//                               ""),
//                           body: GetX<FavoriteGetProductController>(
//                               builder: (favoriteproduct) =>
//                                   favoriteproduct.isDataLoading.value
//                                       ? const Center(
//                                           child: CircularProgressIndicator(),
//                                         )
//                                       : showList(
//                                           context,
//                                           favoriteproduct.favoriteProduct!
//                                               .listProductDetail,
//                                           mchannel,
//                                           mchannelId))));
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         CacheImageFavorite(
//                             url: favorite
//                                 .favorite!.favorite[index].favoriteimgapp),
//                         // CachedNetworkImage(
//                         //   height: 50,
//                         //   imageUrl:
//                         //       favorite.favorite!.favorite[index].favoriteimgapp,
//                         // ),
//                         Text(
//                           textAlign: TextAlign.center,
//                           favorite.favorite!.favorite[index].favoritename,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 2,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             fontFamily: 'notoreg',
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     mainAxisSpacing: 10, crossAxisCount: 5, mainAxisExtent: 90),
//               ),
//             );
//           } else {
//             return Container();
//           }
//         }
//         return GridView.builder(
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: 10,
//           itemBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Shimmer.fromColors(
//                     highlightColor: kBackgroundColor,
//                     baseColor: const Color(0xFFE0E0E0),
//                     child: SizedBox(
//                       height: 60,
//                       width: 60,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[400],
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                         //color: Colors.grey[400],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5),
//                     child: Shimmer.fromColors(
//                       highlightColor: kBackgroundColor,
//                       baseColor: const Color(0xFFE0E0E0),
//                       child: Container(
//                         height: 15,
//                         color: Colors.grey[400],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               mainAxisSpacing: 10, crossAxisCount: 5, mainAxisExtent: 100),
//         );
//       }),
//     );
//   }
// }
