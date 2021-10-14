import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:studing_test_project/src/app.dart';

void main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      useCountryCode: false,
      fallbackFile: 'en',
      forcedLocale: new Locale('en'),
      basePath: 'assets/locales',
    ),
    missingTranslationHandler: (key, locale) {
      print("--- Missing Key: $key, languageCode: ${locale?.languageCode}");
    },
  );

  await flutterI18nDelegate.load(Locale("en"));
  runApp(App(flutterI18nDelegate));
}
