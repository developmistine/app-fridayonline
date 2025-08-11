// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';

import '../../../service/languages/multi_languages.dart';
import 'show_case_catelog_ecatalog_detail.dart';
import 'show_case_catelog_hand_bill_detail.dart';

class ShowCaseCatalog extends StatefulWidget {
  ShowCaseCatalog(
      {super.key, required this.ChangeLanguage, this.keySaven, this.keyEight});
  MultiLanguages ChangeLanguage;
  final GlobalKey<State<StatefulWidget>>? keySaven;
  final GlobalKey<State<StatefulWidget>>? keyEight;

  @override
  State<ShowCaseCatalog> createState() => _ShowCaseCatalogState();
}

class _ShowCaseCatalogState extends State<ShowCaseCatalog> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: const Color(0xff2ffffff),
                child: TabBar(
                  labelColor: theme_color_df,
                  indicatorColor: theme_color_df,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: widget.ChangeLanguage.translate('catalog_tab'),
                    ),
                    Tab(
                        text: widget.ChangeLanguage.translate(
                            'catalog_special_price')),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: TabBarView(
                  children: [
                    Center(
                        child: ShowCaseCatelog_Ecatalog_Detail(
                            ChangeLanguage: widget.ChangeLanguage,
                            keySaven: widget.keySaven,
                            keyEight: widget.keyEight)),
                    Center(
                        child: ShowCaseCatelog_Hand_Bill_Detail(
                            ChangeLanguage: widget.ChangeLanguage)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
