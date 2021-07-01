import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show StreamChatLocalizations;

const kStreamChatSupportedLanguages = [];

/// Implementation of localized strings for the stream chat widgets
///
/// ## Supported languages
///
/// This class supports locales with the following [Locale.languageCode]s:
///
/// {@macro flutter.localizations.material.languages}
///
/// This list is available programmatically via [kStreamChatSupportedLanguages].
///
/// ## Sample code
///
/// To include the localizations provided by this class in a [MaterialApp],
/// add [GlobalStreamChatLocalizations.delegates] to
/// [MaterialApp.localizationsDelegates], and specify the locales your
/// app supports with [MaterialApp.supportedLocales]:
///
/// ```dart
/// new MaterialApp(
///   localizationsDelegates: GlobalStreamChatLocalizations.delegates,
///   supportedLocales: [
///     const Locale('en', 'US'), // American English
///     const Locale('he', 'IL'), // Israeli Hebrew
///     // ...
///   ],
///   // ...
/// )
/// ```
///
class GlobalStreamChatLocalizations implements StreamChatLocalizations {
  /// Construct an object that defines the localized values for the widgets
  /// library for US English (only).
  ///
  /// [LocalizationsDelegate] implementations typically call the static [load]
  const GlobalStreamChatLocalizations(this.locale, this.translations);

  final Locale locale;

  final Map<String, String?> translations;

  static String getLocalePath(Locale locale) =>
      'packages/stream_chat_localizations/i18n/${locale.languageCode}.json';

  /// Creates an object that provides US English resource values for the
  /// lowest levels of the widgets library.
  ///
  /// The [locale] parameter is ignored.
  ///
  /// This method is typically used to create a [LocalizationsDelegate].
  /// The [WidgetsApp] does so by default.
  static Future<StreamChatLocalizations> load(Locale locale) async {
    final localePath = getLocalePath(locale);
    final rawTranslations = await rootBundle.loadString(localePath);
    Map<String, String?> translations = json.decode(rawTranslations);
    translations = translations.map(
      (key, value) => MapEntry(key, value?.toString()),
    );
    return GlobalStreamChatLocalizations(locale, translations);
  }

  /// A [LocalizationsDelegate] for [StreamChatLocalizations].
  ///
  /// Most internationalized apps will use [GlobalStreamChatLocalizations.delegates]
  /// as the value of [MaterialApp.localizationsDelegates] to include
  /// the localizations for both the flutter and stream chat widget libraries.
  static const LocalizationsDelegate<StreamChatLocalizations> delegate =
      _StreamChatLocalizationsDelegate();

  /// A value for [MaterialApp.localizationsDelegates] that's typically used by
  /// internationalized apps.
  ///
  /// ## Sample code
  ///
  /// To include the localizations provided by this class and by
  /// [GlobalWidgetsLocalizations] in a [MaterialApp],
  /// use [GlobalStreamChatLocalizations.delegates] as the value of
  /// [MaterialApp.localizationsDelegates], and specify the locales your
  /// app supports with [MaterialApp.supportedLocales]:
  ///
  /// ```dart
  /// new MaterialApp(
  ///   localizationsDelegates: GlobalStreamChatLocalizations.delegates,
  ///   supportedLocales: [
  ///     const Locale('en', 'US'), // English
  ///     const Locale('he', 'IL'), // Hebrew
  ///   ],
  ///   // ...
  /// )
  /// ```
  static const List<LocalizationsDelegate> delegates = [
    delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  @override
  String? translate(String key) => translations[key];
}

class _StreamChatLocalizationsDelegate
    extends LocalizationsDelegate<StreamChatLocalizations> {
  const _StreamChatLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      kStreamChatSupportedLanguages.contains(locale.languageCode);

  @override
  Future<StreamChatLocalizations> load(Locale locale) =>
      GlobalStreamChatLocalizations.load(locale);

  @override
  bool shouldReload(_StreamChatLocalizationsDelegate old) => false;

  @override
  String toString() => 'StreamChatLocalizations.delegate('
      '${kStreamChatSupportedLanguages.length} locales)';
}
