// ignore_for_file: use_build_context_synchronously

import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:fridayonline/model/dropship/dropship_search_model.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/cart/function_add_to_cart.dart';
import '../../controller/dropship_shop/dropship_shop_controller.dart';
import '../../service/languages/multi_languages.dart';
import '../login/anonymous_login.dart';
import 'dropship_showproduct.dart';
import '../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../theme/themeimage_menu.dart';

class DropshipSearchItems extends StatelessWidget {
  const DropshipSearchItems({super.key, this.searchItemsDropship});
  final List<GetDropshipSearchProduct>? searchItemsDropship;
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    return Scaffold(
        appBar: appBarTitleCart('รานการสินค้าส่งด่วน', ""),
        body: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: MasonryGridView.builder(
              shrinkWrap: true,
              primary: false,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (width >= 768.0) ? 3 : 2,
              ),
              itemCount: searchItemsDropship!.length,
              itemBuilder: (context, index) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Get.put(FetchDropshipShop()).fetchProductDetailDropship(
                            searchItemsDropship![index].productCode);
                        Get.to(() => DropShipProduct(),
                            preventDuplicates: false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(14, 0, 0, 0),
                              offset: Offset(0.0, 4.0),
                              blurRadius: 0.2,
                              spreadRadius: 0.2,
                            ), //BoxShadow
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(children: [
                          // if (show)
                          Stack(
                            children: <Widget>[
                              Center(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      searchItemsDropship![index].imageUrl,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                          // if (show)
                          //? express
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 4, left: 14, right: 14),
                            child: Row(children: [
                              Expanded(
                                  child: Stack(
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: theme_red),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0,
                                          top: 4,
                                          bottom: 2,
                                          right: 4),
                                      child: Text(
                                        searchItemsDropship![index]
                                            .deliveryType,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Text(
                                      '                     ${searchItemsDropship![index].nameTh}',
                                      style: const TextStyle(
                                          height: 1.7,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ],
                              )),
                            ]),
                          ),
                          //? รหัสสินค้า ราคา ปุ่มหยิบใส่ตระกร้า
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //? รหัสสินค้า
                                      Text(
                                        "${MultiLanguages.of(context)!.translate('product_code')} ${searchItemsDropship![index].billYup}",
                                        style: TextStyle(
                                          fontFamily: 'notoreg',
                                          fontSize: 12,
                                          color: theme_grey_text,
                                        ),
                                      ),
                                      //? ราคา
                                      Text(
                                        "${MultiLanguages.of(context)!.translate('order_price_txt')} ${myFormat.format(double.parse(searchItemsDropship![index].price))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'notoreg',
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                    ],
                                  ),
                                ),
                                //? ปุ่มหยิบใส่ตระกร้า
                                Expanded(
                                  child: BouncingWidget(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scaleFactor: 1.5,
                                      onPressed: () async {
                                        final Future<SharedPreferences> prefs0 =
                                            SharedPreferences.getInstance();

                                        final SharedPreferences prefs =
                                            await prefs0;
                                        late String? lslogin;
                                        lslogin = prefs.getString("login");
                                        var mChannel = '6';
                                        var mChannelId = '';

                                        if (lslogin == null) {
                                          Get.to(() => const Anonumouslogin());
                                        } else {
                                          await fnEditCartDropship(
                                              context,
                                              searchItemsDropship![index],
                                              'Dropship',
                                              mChannel,
                                              mChannelId);
                                        }
                                      },
                                      child: ImageBasget),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}
