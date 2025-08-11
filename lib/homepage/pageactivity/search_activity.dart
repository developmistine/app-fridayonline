// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:fridayonline/homepage/pageactivity/search/popular.dart';
import 'package:fridayonline/homepage/pageactivity/search/search_list.dart';
import 'package:fridayonline/homepage/pageinitial/category.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:flutter/material.dart';

import '../../service/languages/multi_languages.dart';
import '../theme/theme_color.dart';

class SearchProduct extends StatelessWidget {
  const SearchProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        backgroundColor: theme_color_df,
        title: InkWell(
          child: TextField(
            onTap: () async {
              await showSearch(context: context, delegate: DataSearch(context));
            },
            readOnly: true, // will disable paste operation
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(4),
              focusedBorder: border,
              enabledBorder: border,
              isDense: true,
              hintText: MultiLanguages.of(context)!.translate('home_search'),
              hintStyle: TextStyle(
                  fontSize: 13, color: theme_color_df, fontFamily: 'notoreg'),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ImageSearchbox,
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 35,
                minHeight: 35,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //       color: Colors.white,
        //       onPressed: () {
        //         showSearch(context: context, delegate: DataSearch(context));
        //       },
        //       icon: Icon(Icons.manage_search_sharp))
        // ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(alignment: Alignment.topCenter, child: tab_controll(context)),
            Expanded(
              child: Center(
                child: TabBarView(
                  children: [
                    Center(child: Category()),
                    Center(child: popular()),
                  ],
                ),
              ),
            ),
            // search_field(),
          ],
        ),
      ),
    );
  }
}

Widget tab_controll(BuildContext context) {
  return Container(
    constraints: BoxConstraints(maxHeight: 150.0),
    width: MediaQuery.of(context).size.width,
    child: MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: TabBar(
        labelColor: theme_color_df,
        indicatorColor: theme_color_df,
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(text: MultiLanguages.of(context)!.translate('menu_category')),
          Tab(text: MultiLanguages.of(context)!.translate('popular_words')),
        ],
      ),
    ),
  );
}
