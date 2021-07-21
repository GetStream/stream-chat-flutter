import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show StreamChatLocalizations, User;

part 'stream_chat_localizations_en.dart';
part 'stream_chat_localizations_fr.dart';
part 'stream_chat_localizations_it.dart';
part 'stream_chat_localizations_hi.dart';

/// The set of supported languages, as language code strings.
///
/// The [GlobalStreamChatLocalizations.delegate] can generate localizations for
/// any [Locale] with a language code from this set.
///
/// See also:
///
///  * [getStreamChatTranslation], whose documentation describes these values.
const kStreamChatSupportedLanguages = {
  'en',
  'hi',
  'fr',
  'it',
};

/// Creates a [GlobalStreamChatLocalizations] instance for the given `locale`.
///
/// All of the function's arguments except `locale` will be passed to the
/// [GlobalStreamChatLocalizations] constructor. (The `localeName` argument of that
/// constructor is specified by the actual subclass constructor by this
/// function.)
///
/// The following locales are supported by this package:
///
///  * `en` - English
///
/// Generally speaking, this method is only intended to be used by
/// [GlobalStreamChatLocalizations.delegate].
GlobalStreamChatLocalizations? getStreamChatTranslation(Locale locale) {
  final languageCode = locale.languageCode;
  assert(
    kStreamChatSupportedLanguages.contains(languageCode),
    'getStreamChatTranslation() called for unsupported locale "$locale"',
  );
  switch (locale.languageCode) {
    case 'en':
      return const StreamChatLocalizationsEn();
    case 'hi':
      return const StreamChatLocalizationsHi();
    case 'fr':
      return const StreamChatLocalizationsFr();
    case 'it':
      return const StreamChatLocalizationsIt();
  }
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
///     // ...
///   ],
///   // ...
/// )
/// ```
///
abstract class GlobalStreamChatLocalizations
    implements StreamChatLocalizations {
  /// Initializes an object that defines the StreamChat widget's localized
  /// strings for the given `localeName`.
  const GlobalStreamChatLocalizations({
    required String localeName,
  }) : _localeName = localeName;

  final String _localeName;

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
  ///   ],
  ///   // ...
  /// )
  /// ```
  static const List<LocalizationsDelegate> delegates = [
    GlobalStreamChatLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

class _StreamChatLocalizationsDelegate
    extends LocalizationsDelegate<StreamChatLocalizations> {
  const _StreamChatLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      kStreamChatSupportedLanguages.contains(locale.languageCode);

  static final _loadedTranslations =
      <Locale, Future<StreamChatLocalizations>>{};

  @override
  Future<StreamChatLocalizations> load(Locale locale) {
    assert(isSupported(locale), '');
    return _loadedTranslations.putIfAbsent(
      locale,
      () => SynchronousFuture<StreamChatLocalizations>(
        getStreamChatTranslation(locale)!,
      ),
    );
  }

  @override
  bool shouldReload(_StreamChatLocalizationsDelegate old) => false;

  @override
  String toString() => 'GlobalStreamChatLocalizations.delegate('
      '${kStreamChatSupportedLanguages.length} locales)';
}
