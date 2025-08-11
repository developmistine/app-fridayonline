// ignore_for_file: use_key_in_widget_constructors

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../controller/cart/function_add_to_cart.dart';
import '../../homepage/login/anonymous_login.dart';
import '../../homepage/theme/themeimage_menu.dart';
import '../../model/home/product_hot_item_loadmore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/languages/multi_languages.dart';
import 'cache_image.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item);
  final HotItemasLoadMore item;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            /*
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(14, 0, 0, 0),
                offset: Offset(0.0, 4.0),
                blurRadius: 0.2,
                spreadRadius: 0.2,
              ), //BoxShadow
            ],
            */

            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: [
            // if (show)
            GestureDetector(
              onTap: () {
                // !Get.to(() => DetailProduct() ใช้ได้
                // print("object+++");
                var mChannel = '6';
                var mChannelId = '';
                Get.find<ProductDetailController>().productDetailController(
                  item.campaign,
                  item.billcode,
                  item.media,
                  item.sku,
                  mChannel,
                  mChannelId,
                );
                Get.to(() => const ProductDetailPage(
                      ref: 'product',
                      contentId: '',
                    ));
              },
              child: Stack(
                children: <Widget>[
                  if (item.image == '')
                    Image.asset(imageError, height: 160, fit: BoxFit.contain)
                  else
                    Center(
                      child: CacheImageProduct(url: item.image),
                      // child: CachedNetworkImage(
                      //   imageUrl: item.image,
                      //   height: 160,
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    child: CacheImagePrice(
                        url: item.imgNetPrice, flagNetPrice: item.flagNetPrice),
                    // child: CachedNetworkImage(
                    //   imageUrl: item.imgNetPrice,
                    //   height: (item.flagNetPrice == 'Y') ? 60 : 0,
                    // ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: CachedNetworkImage(
                        imageUrl: item.imgAppend,
                        height: (item.isInStock == false) ? 80 : 0,
                      )),
                ],
              ),
            ),
            // if (show)
            Flexible(
              child: Wrap(
                children: [
                  SizedBox(
                    height: 60.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${MultiLanguages.of(context)!.translate('product_code')} ${item.billcode}",
                                style: TextStyle(
                                  fontFamily: 'notoreg',
                                  fontSize: 12,
                                  color: setBillColor(item.color),
                                ),
                              ),
                              Text(
                                "${MultiLanguages.of(context)!.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(item.price))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'notoreg',
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.5,
                              onPressed: () async {
                                final Future<SharedPreferences> prefs0 =
                                    SharedPreferences.getInstance();

                                final SharedPreferences prefs = await prefs0;
                                late String? lslogin;
                                lslogin = prefs.getString("login");
                                var mChannel = '6';
                                var mChannelId = '';

                                if (lslogin == null) {
                                  Get.to(() => const Anonumouslogin());
                                } else {
                                  await fnEditCart(context, item,
                                      'loadmore_page', mChannel, mChannelId,
                                      ref: 'product', contentId: '');
                                }
                              },
                              child: ImageBasget),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
