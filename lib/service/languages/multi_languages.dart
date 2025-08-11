// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

class MultiLanguages {
  final Locale locale;
  MultiLanguages({this.locale = const Locale.fromSubtags(languageCode: 'my')});

  static MultiLanguages? of(BuildContext context) {
    return Localizations.of<MultiLanguages>(context, MultiLanguages);
  }

  void keepLocaleKey(String localeKey) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.remove(localeKey);
    await _prefs.setString("localeKey", localeKey);
  }

  Future<String> readLocaleKey() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString("localeKey") ?? 'th';
  }

  void setLocale(BuildContext context, Locale locale) async {
    keepLocaleKey(locale.languageCode);

    MyApp.setLocale(context, locale);
  }

  static const LocalizationsDelegate<MultiLanguages> delegate =
      _MultiLanguagesDelegate();

  late Map<String, String> _localizedSetrings;

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/language/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    _localizedSetrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  String translate(String key) {
    return _localizedSetrings[key]!;
  }
}

class _MultiLanguagesDelegate extends LocalizationsDelegate<MultiLanguages> {
  // This delegate instance will never change
  // It can provide a constant constructor.
  const _MultiLanguagesDelegate();
  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['my', 'th', 'km'].contains(locale.languageCode);
  }

  /// read Json
  @override
  Future<MultiLanguages> load(Locale locale) async {
    // MultiLanguages class is where the JSON loading actually runs

    MultiLanguages localizations = MultiLanguages(locale: locale);
    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(_MultiLanguagesDelegate old) => false;
}
