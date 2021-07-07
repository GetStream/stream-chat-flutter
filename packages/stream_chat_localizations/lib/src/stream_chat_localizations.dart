import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show StreamChatLocalizations;

const kStreamChatSupportedLanguages = ['en','it'];

class LocaleConfig {
  // /// {@template stringify}
  // /// Global [stringify] setting for all [Equatable] instances.
  // ///
  // /// If [stringify] is overridden for a particular [Equatable] instance,
  // /// then the local [stringify] value takes precedence
  // /// over [EquatableConfig.stringify].
  // ///
  // /// This value defaults to true in debug mode and false in release mode.
  // /// {@endtemplate}
  // static bool get stringify {
  //   if (_stringify == null) {
  //     assert(() {
  //       _stringify = true;
  //       return true;
  //     }());
  //   }
  //   return _stringify ??= false;
  // }
  //
  // /// {@macro stringify}
  // static set path(String value) => _path = value;

  static String? path;
}

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

  final Map<String, String> translations;

  static String getLocalePath(Locale locale) {
    return LocaleConfig.path ??
        'packages/stream_chat_localizations/src/l10n/${locale.languageCode}.json';
  }

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
    final Map<String, dynamic> translationsJson = json.decode(rawTranslations);
    final translations = translationsJson.map(
      (key, value) => MapEntry(key, value.toString()),
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
  String translate(String key) {
    final value = translations[key];
    if (value == null) throw '';
    return value;
  }
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
