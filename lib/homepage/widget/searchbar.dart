// import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/set_data/set_data.dart';
import '../../service/languages/multi_languages.dart';

class Searchbar extends StatelessWidget {
  Searchbar({super.key});
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SetData data = SetData();

  @override
  Widget build(BuildContext context) {
    const sizeIcon = BoxConstraints(
      minWidth: 10,
      minHeight: 10,
    );

    Expanded buildSearch() {
      const border = OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      );

      return Expanded(
        child: TextField(
          readOnly: true, // will disable paste operation

          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(4),
            focusedBorder: border,
            enabledBorder: border,
            isDense: true,
            hintText: MultiLanguages.of(context)!.translate('home_search'),
            // ignore: prefer_const_constructors
            hintStyle: TextStyle(
                fontSize: 13, color: theme_color_df, fontFamily: 'notoreg'),

            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ImageSearchbox,
            ),
            prefixIconConstraints: sizeIcon,
            /*
          suffixIcon: Icon(
            MdiIcons.cameraOutline,
          ),
          suffixIconConstraints: sizeIcon,
          */
            filled: true,
            fillColor: Colors.white,
          ),

          onTap: () async {
            final SharedPreferences prefs = await _prefs;
            if (prefs.getString("ShowcaseSearch") == '1') {
              Get.toNamed('/search_activity');
            } else {
              Get.toNamed('/show_case_search_activity');
              prefs.setString("ShowcaseSearch", '1');
            }
          },
        ),
      );
    }

    return Container(
      child: buildSearch(),
    );
  }
}
