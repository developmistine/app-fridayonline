// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:fridayonline/homepage/pageactivity/search/popular.dart';
import 'package:fridayonline/homepage/pageactivity/search/search_list.dart';
import 'package:fridayonline/homepage/pageinitial/category.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../service/languages/multi_languages.dart';
// import '../../myhomepage.dart';
import '../../theme/theme_color.dart';

class ShowCaseSearchProduct extends StatefulWidget {
  const ShowCaseSearchProduct({super.key, required this.ChangeLanguage});
  final MultiLanguages ChangeLanguage;

  @override
  State<ShowCaseSearchProduct> createState() => _ShowCaseSearchProductState();
}

class _ShowCaseSearchProductState extends State<ShowCaseSearchProduct> {
  final GlobalKey _one = GlobalKey();
  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase([_one]),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
    );
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
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
                print("Ton CH");
                await showSearch(
                    context: context, delegate: DataSearch(context));
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
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Showcase.withWidget(
                    disableMovingAnimation: true,
                    width: width,
                    height: height / 1.4,
                    container: MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: SizedBox(
                        width: width / 1.1,
                        height: height / 1.4,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 40.0, top: 50),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                    color: theme_color_df,
                                    width: 250,
                                    height: 80,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          widget.ChangeLanguage.translate(
                                              'search_guides'),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 200.0),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          WidgetStateProperty.all<Color>(
                                              theme_color_df),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.white),
                                      shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              side: BorderSide(
                                                  color: theme_color_df)))),
                                  onPressed: () {
                                    ShowCaseWidget.of(context).next();
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                          maxLines: 1,
                                          widget.ChangeLanguage.translate(
                                              'btn_end_guide'),
                                          style: TextStyle(fontSize: 16)),
                                    ),
                                  )),
                            ),
                            Expanded(
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        ShowCaseWidget.of(context).next();
                                      })),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //overlayColor: theme_color_df,
                    // targetPadding: const EdgeInsets.all(20),
                    key: _one,
                    child: tab_controll(context)),
                // child: Showcase(
                //     //overlayColor: theme_color_df,
                //
                //     targetPadding: const EdgeInsets.all(20),
                //     descTextStyle:
                //         const TextStyle(fontSize: 16, color: Colors.white),
                //     key: _one,
                //     //title: 'Menu',
                //     description:
                //         widget.ChangeLanguage.translate('search_guides'),
                //     child: tab_controll(context))
              ),
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
      ),
    );
  }
}

Widget tab_controll(BuildContext context) {
  return Container(
    constraints: BoxConstraints(maxHeight: 150.0),
    width: MediaQuery.of(context).size.width,
    child: TabBar(
      labelColor: theme_color_df,
      indicatorColor: theme_color_df,
      unselectedLabelColor: Colors.black,
      tabs: [
        Tab(text: MultiLanguages.of(context)!.translate('menu_category')),
        Tab(text: MultiLanguages.of(context)!.translate('popular_words')),
      ],
    ),
  );
}
