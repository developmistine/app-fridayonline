// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/theme_color.dart';

Color theme_red = const Color.fromRGBO(253, 127, 107, 1);
Color DividerThemeColor = const Color.fromRGBO(164, 214, 241, 1);
NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
NumberFormat myFormat2Digits =
    NumberFormat.currency(locale: "en_us", decimalDigits: 2, symbol: "");
Color theme_grey_bg = const Color.fromRGBO(217, 217, 217, 1);
Color theme_grey_text = const Color.fromRGBO(123, 123, 123, 1);
Color text_color_orange = const Color.fromARGB(255, 253, 128, 111);
EdgeInsets edgeInsets = const EdgeInsets.symmetric(horizontal: 20, vertical: 8);
TextStyle setTextColordf =
    TextStyle(color: theme_color_df, fontWeight: FontWeight.bold);
FontWeight boldText = FontWeight.w700;
var textStyle16 = const TextStyle(fontSize: 16, height: 2);

void printWhite(msg) {
  log('\x1B[37m$msg\x1B[0m');
}

void printJSON(Object msg) {
  final jsonString = const JsonEncoder.withIndent('  ').convert(msg);

  const resetColor = '\x1B[0m';
  const keyColor = '\x1B[33m'; // สีเหลืองสำหรับ key
  const valueColor = '\x1B[32m'; // สีเขียวสำหรับ value

  final coloredJson = jsonString.replaceAllMapped(
    RegExp(r'("(.*?)")(\s*:\s*)(.*?)(,?)$',
        multiLine: true), // จับ key, separator (:), และ value
    (match) {
      final key = match.group(1); // Key เช่น "shop_id"
      final separator = match.group(3); // Separator เช่น ":"
      final value = match.group(4); // Value เช่น 23001
      final trailingComma = match.group(5) ?? ''; // Trailing comma เช่น ','

      return '$keyColor$key$resetColor'
          '$separator'
          '$valueColor$value$resetColor'
          '$trailingComma';
    },
  );

  log(coloredJson);
}

// void printJSON(msg) {
//   final prettyJson = const JsonEncoder.withIndent('  ').convert(msg);
//   const resetColor = '\x1B[0m';
//   const greenColor = '\x1B[32m';
//   log('$greenColor$prettyJson$resetColor');
// }
