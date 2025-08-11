import '../../homepage/theme/theme_color.dart';
import '../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';

//แสดง appbar ที่มีแค่ข้อความอย่างเดียว
AppBar header_title_only(BuildContext context, key) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.pop(context, false),
    ),
    backgroundColor: theme_color_df,
    centerTitle: true,
    title: Text(
      MultiLanguages.of(context)!.translate(key),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'notoreg',
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
