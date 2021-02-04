import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {

  static final AppLocalizations _singleton = new AppLocalizations._internal();
  AppLocalizations._internal();
  static AppLocalizations get instance => _singleton;

  Map<dynamic, dynamic> _localisedValues;

  Future<AppLocalizations> load(Locale locale) async {
    String jsonContent =
    await rootBundle.loadString("lang/${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);
    return this;
  }

  String translate(String key) {
    return _localisedValues[key];
  }
}


class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pt', 'es', 'fr', 'ko', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale)  {
    return AppLocalizations.instance.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}