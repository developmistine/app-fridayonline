import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_network/image_network.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/home/home_controller.dart';
import '../../../service/languages/multi_languages.dart';
import '../../../service/logapp/logapp_service.dart';
import '../../page_showproduct/List_product.dart';
import '../../theme/constants.dart';
import '../../widget/appbar_cart.dart';
import '../cache_image.dart';

class HomeFavorite extends StatelessWidget {
  HomeFavorite({super.key});
  final Color colorBg = const Color.fromARGB(255, 229, 228, 228);
  final bannerProduct = Get.put(ProductFromBanner());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 8,
          color: colorBg,
        ),
        Container(
            height: 120,
            alignment: Alignment.center,
            child: GetX<FavoriteController>(builder: ((favorite) {
              if (!favorite.isDataLoading.value) {
                if (favorite.favorite!.favorite.isNotEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            print("LogApp Favorite Icon");
                            var logData = favorite.favorite!.favorite;
                            var mchannel = '2';
                            var mchannelId = favorite.favorite!.favorite[0].id;
                            //LogApp
                            InteractionLogger.logFavorite(
                              contentId: logData[0].id,
                              contentName: logData[0].favoritename,
                              contentImage: logData[0].favoriteimgapp,
                            );
                            LogAppTisCall(mchannel, mchannelId);
                            //  End

                            Get.put(FavoriteGetProductController())
                                .fetch_favorite_product(favorite
                                    .favorite!.favorite[0].favoritedataindex);
                            bannerProduct.fetch_product_banner("", "");
                            Get.to(() => Scaffold(
                                appBar: appBarTitleCart(
                                    MultiLanguages.of(context)!
                                        .translate('home_page_list_products'),
                                    ""),
                                body: GetX<FavoriteGetProductController>(
                                    builder: (favoriteproduct) =>
                                        favoriteproduct.isDataLoading.value
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : showList(
                                                favoriteproduct.favoriteProduct!
                                                    .listProductDetail,
                                                mchannel,
                                                mchannelId,
                                                ref: 'favorite',
                                                contentId: logData[0].id,
                                              )
                                    // : showList(
                                    //     context,
                                    //     favoriteproduct.favoriteProduct!
                                    //         .listProductDetail,
                                    //     mchannel,
                                    //     mchannelId)
                                    )));
                          },
                          child: Container(
                            // width: 100,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(243, 251, 255, 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 55,
                                    child: CacheImageFavorite(
                                      url: favorite
                                          .favorite!.favorite[0].favoriteimgapp,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    favorite.favorite!.favorite[0].favoritename,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: favorite.favorite!.favorite.length - 1,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  print("LogApp Favorite Icon");
                                  var logData =
                                      favorite.favorite!.favorite[index + 1];
                                  var mchannel = '2';
                                  var mchannelId =
                                      favorite.favorite!.favorite[index + 1].id;
                                  //LogApp
                                  InteractionLogger.logFavorite(
                                    contentId: logData.id,
                                    contentName: logData.favoritename,
                                    contentImage: logData.favoriteimgapp,
                                  );
                                  LogAppTisCall(mchannel, mchannelId);
                                  //  End
                                  bannerProduct.fetch_product_banner("", "");
                                  Get.put(FavoriteGetProductController())
                                      .fetch_favorite_product(favorite
                                          .favorite!
                                          .favorite[index + 1]
                                          .favoritedataindex);
                                  Get.to(() => Scaffold(
                                      appBar: appBarTitleCart(
                                          MultiLanguages.of(context)!.translate(
                                              'home_page_list_products'),
                                          ""),
                                      body: GetX<FavoriteGetProductController>(
                                          builder: (favoriteproduct) =>
                                              favoriteproduct
                                                      .isDataLoading.value
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : showList(
                                                      favoriteproduct
                                                          .favoriteProduct!
                                                          .listProductDetail,
                                                      mchannel,
                                                      mchannelId,
                                                      ref: 'favorite',
                                                      contentId: logData.id,
                                                    )
                                          // : showList(
                                          //     context,
                                          //     favoriteproduct
                                          //         .favoriteProduct!
                                          //         .listProductDetail,
                                          //     mchannel,
                                          //     mchannelId)
                                          )));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      height: 55,
                                      child: CacheImageFavorite(
                                          url: favorite
                                              .favorite!
                                              .favorite[index + 1]
                                              .favoriteimgapp),
                                    ),
                                    Container(
                                      height: 40,
                                      margin: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        favorite.favorite!.favorite[index + 1]
                                            .favoritename,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          inherit: false,
                                          fontSize: 12,
                                          fontFamily: 'notoreg',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: 80, crossAxisCount: 1),
                          )),
                    ],
                  );
                }
              } else {
                return GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Shimmer.fromColors(
                          highlightColor: kBackgroundColor,
                          baseColor: const Color(0xFFE0E0E0),
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        Shimmer.fromColors(
                          highlightColor: kBackgroundColor,
                          baseColor: const Color(0xFFE0E0E0),
                          child: Container(
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        )
                      ],
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 80, crossAxisCount: 1),
                );
              }
              return Container();
            }))),
        Container(
          height: 6,
          color: theme_color_df,
        ),
        const SizedBox(
          height: 4,
        )
      ],
    );
  }
}
