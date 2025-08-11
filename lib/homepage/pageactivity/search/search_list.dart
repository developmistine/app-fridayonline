// import 'dart:developer';

import 'package:fridayonline/homepage/pageactivity/search/search_items.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../controller/search_product/search_controller.dart';
import '../../../model/search_bar/getkeyword.dart';
import '../../../service/languages/multi_languages.dart';
import '../../../service/logapp/logapp_service.dart';
import '../../../service/search_bar/search_service.dart';
import '../../theme/theme_color.dart';

class DataSearch extends SearchDelegate {
  DataSearch(
    BuildContext context, {
    String hintText = "home_search",
    final InputDecorationTheme? searchFieldDecorationTheme,
  }) : super(
          searchFieldLabel: MultiLanguages.of(context)!.translate(hintText),
          searchFieldDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.all(8.0),
              isDense: true,
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              labelStyle: const TextStyle(fontSize: 14),
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
            : theme_color_df,
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
        color: Colors.white,
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
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
      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
    );
  }

  var checkIndex = 0;
  // !show query result
  @override
  Widget buildResults(BuildContext context) {
    // check if query is not equal
    checkIndex++;
    if (checkIndex == 1) {
      print("query: $query");
      Get.put(ShowSearchProductController()).searchProduct(query);
    }
    if (query.isNotEmpty) {
      LogAppSearchCall("Search_home", query);
      var mChannel = '10';
      return ShowSearchList(
          showAppbar: false, pChannel: mChannel, contentId: query);
    }
    return const null_product();
  }

  // ! suggestions
  @override
  Widget buildSuggestions(BuildContext context) {
    checkIndex = 0;
    return FutureBuilder(
      future: SearchKeywords(query),
      builder:
          (BuildContext context, AsyncSnapshot<List<KeySearch>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (query.isEmpty) {
            return Container();
          } else {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: SubstringHighlight(
                      text: snapshot.data![index].keyWord,
                      term: query,
                      textStyle: const TextStyle(
                          fontFamily: 'notoreg', color: Colors.black),
                      textStyleHighlight: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: theme_color_df,
                          fontFamily: 'notoreg'),
                    ),
                    // trailing:
                    //     Icon(Icons.arrow_circle_right_outlined, color: theme_color_df),
                    onTap: () {
                      // print("Search_Log");
                      // Log App Search
                      LogAppTisCall("10", "");
                      LogAppSearchCall(
                          "Search_home", snapshot.data![index].keyWord);
                      // print("ton 3");
                      //End

                      Get.put(ShowSearchProductController())
                          .searchProduct(snapshot.data![index].keyWord);
                      Get.to(() => ShowSearchList(
                          showAppbar: true,
                          pChannel: '10',
                          contentId: snapshot.data![index].keyWord));
                    },
                  );
                },
              ),
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
            const Text(
              'ไม่พบสินค้า',
              style: TextStyle(color: Colors.black, fontFamily: 'notoreg'),
            ),
          ],
        ),
      ),
    );
  }
}
