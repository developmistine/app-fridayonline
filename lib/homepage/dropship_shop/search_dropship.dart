// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_local_variable, camel_case_types, use_build_context_synchronously

// import 'dart:convert';
// import 'dart:developer';

import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
// import 'package:fridayonline/homepage/pageactivity/search/search_items.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substring_highlight/substring_highlight.dart';

// import '../../../controller/search_product/search_controller.dart';
// import '../../../model/search_bar/getkeyword.dart';
import '../../../service/languages/multi_languages.dart';
import '../../../service/logapp/logapp_service.dart';
// import '../../../service/search_bar/search_service.dart';
import '../../controller/cart/function_add_to_cart.dart';
import '../../controller/dropship_shop/dropship_shop_controller.dart';
import '../../model/dropship/dropship_search_model.dart';
import '../../service/dropship_shop/dropship_shop_service.dart';
import '../login/anonymous_login.dart';
import 'dropship_showproduct.dart';
import '../theme/theme_color.dart';
import '../theme/themeimage_menu.dart';
import 'dropship_search_product.dart';

class DropsShipSearch extends SearchDelegate {
  DropsShipSearch(
    BuildContext context, {
    String hintText = "home_search",
    final InputDecorationTheme? searchFieldDecorationTheme,
  }) : super(
          searchFieldLabel: MultiLanguages.of(context)!.translate(hintText),
          searchFieldDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.all(8.0),
              isDense: true,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: BorderSide.none,
              ),
              fillColor: Color.fromRGBO(238, 238, 238, 1),
              labelStyle: TextStyle(fontSize: 14),
              hintStyle: TextStyle(fontSize: 14, color: theme_color_df)),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      textTheme: TextTheme(
          titleLarge: TextStyle(
              fontFamily: 'notoreg', fontSize: 16, color: theme_color_df)),
      // AppBarTheme copies from the context making use of the overall theme.
      appBarTheme: AppBarTheme.of(context).copyWith(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        toolbarTextStyle: theme.textTheme.bodyMedium,
        titleTextStyle: theme.textTheme.titleLarge,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  // API list

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        color: theme_color_df,
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            // showSuggestions(context);
          }
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios, color: theme_color_df),
    );
  }

  //? show ผลลััพธ์เมื่อกดปุ่มค้นหา
  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      LogAppSearchCall("Search_home", query);
      var mChannel = '10';
      return FutureBuilder(
          future: getDropshipSearchProduct(query),
          builder: (BuildContext context,
              AsyncSnapshot<List<GetDropshipSearchProduct>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var searchItemsDropship = snapshot.data;
              if (searchItemsDropship!.isNotEmpty) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: MasonryGridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (Get.width >= 768.0) ? 3 : 2,
                      ),
                      itemCount: searchItemsDropship.length,
                      itemBuilder: (context, index) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaler: const TextScaler.linear(1.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                Get.put(FetchDropshipShop())
                                    .fetchProductDetailDropship(
                                        searchItemsDropship[index].productCode);
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
                                          imageUrl: searchItemsDropship[index]
                                              .imageUrl,
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
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: theme_red),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0,
                                                  top: 4,
                                                  bottom: 2,
                                                  right: 4),
                                              child: Text(
                                                searchItemsDropship[index]
                                                    .deliveryType,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Text(
                                              '                     ${searchItemsDropship[index].nameTh}',
                                              style: const TextStyle(
                                                  color: Colors.black,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //? รหัสสินค้า
                                              Text(
                                                "${MultiLanguages.of(context)!.translate('product_code')} ${searchItemsDropship[index].billYup}",
                                                style: TextStyle(
                                                  fontFamily: 'notoreg',
                                                  fontSize: 12,
                                                  color: theme_grey_text,
                                                ),
                                              ),
                                              //? ราคา
                                              Text(
                                                "${MultiLanguages.of(context)!.translate('order_price_txt')} ${myFormat.format(double.parse(searchItemsDropship[index].price))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'notoreg',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //? ปุ่มหยิบใส่ตระกร้า
                                        Expanded(
                                          child: BouncingWidget(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              scaleFactor: 1.5,
                                              onPressed: () async {
                                                final Future<SharedPreferences>
                                                    prefs0 = SharedPreferences
                                                        .getInstance();

                                                final SharedPreferences prefs =
                                                    await prefs0;
                                                late String? lslogin;
                                                lslogin =
                                                    prefs.getString("login");
                                                var mChannel = '6';
                                                var mChannelId = '';

                                                if (lslogin == null) {
                                                  Get.to(() =>
                                                      const Anonumouslogin());
                                                } else {
                                                  await fnEditCartDropship(
                                                      context,
                                                      searchItemsDropship[
                                                          index],
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
                );
              } else {
                return null_product();
              }
            } else {
              return Center(
                child: theme_loading_df,
              );
            }
          });
    }
    return null_product();
  }

  //? show ผลลััพธ์เมื่อพิมพ์
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: getDropshipSearchProduct(query),
      builder: (BuildContext context,
          AsyncSnapshot<List<GetDropshipSearchProduct>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (query.isEmpty) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: SubstringHighlight(
                    text: snapshot.data![index].nameTh,
                    term: query,
                    textStyle:
                        TextStyle(fontFamily: 'notoreg', color: Colors.black),
                    textStyleHighlight: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: theme_color_df,
                        fontFamily: 'notoreg'),
                  ),
                  onTap: () async {
                    LogAppTisCall("10", "");
                    LogAppSearchCall(
                        "Search_home", snapshot.data![index].nameTh);
                    List<GetDropshipSearchProduct>? search =
                        await getDropshipSearchProduct(
                            snapshot.data![index].nameTh);
                    Get.to(
                        () => DropshipSearchItems(searchItemsDropship: search));
                  },
                );
              },
            );
          }
        } else {
          return Center(
            child: theme_loading_df,
          );
        }
      },
    );
  }
}

// ? หน้าแสดงเมื่อไม่พบสินค้า
class null_product extends StatelessWidget {
  const null_product({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo/logofriday.png', width: 70),
            Text(
              'ไม่พบสินค้า',
              style: TextStyle(color: Colors.black, fontFamily: 'notoreg'),
            ),
          ],
        ),
      ),
    );
  }
}
