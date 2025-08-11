// เป็นหน้า หน้าแคดตาล็อก
// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:fridayonline/homepage/theme/theme_color.dart';
import '../../analytics/analytics_engine.dart';
import '../../homepage/catelog/catelog_ecatalog_detail.dart';
import '../../homepage/catelog/catelog_hand_bill_detail.dart';
import '../../model/set_data/set_data.dart';
import '../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';

class Catalog extends StatelessWidget {
  Catalog({super.key, this.index});
  var index;
  SetData data = SetData();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: DefaultTabController(
        initialIndex: index ?? 0,
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: const Color(0xff2ffffff),
                child: GestureDetector(
                  child: TabBar(
                    labelColor: theme_color_df,
                    indicatorColor: theme_color_df,
                    unselectedLabelColor: Colors.black,
                    onTap: (tabIndex) async => await _trackTabClick(tabIndex),
                    tabs: [
                      Tab(
                        text: MultiLanguages.of(context)!
                            .translate('catalog_tab'),
                      ),
                      Tab(
                          text: MultiLanguages.of(context)!
                              .translate('catalog_special_price')),
                    ],
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Center(child: Catelog_Ecatalog_Detail()),
                    Center(child: Catelog_Hand_Bill_Detail()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _trackTabClick(int tabIndex) async {
    String tabName;
    switch (tabIndex) {
      case 0:
        tabName = 'click_catalog_tab';
        break;
      case 1:
        tabName = 'click_special_discount_tab';
        break;
      default:
        return;
    }

    AnalyticsEngine.sendAnalyticsEvent(
        tabName, await data.repCode, await data.repSeq, await data.repType);
  }
}
