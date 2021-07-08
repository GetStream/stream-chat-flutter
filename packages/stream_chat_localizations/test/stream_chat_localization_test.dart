import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:stream_chat_localizations/stream_chat_localizations.dart';

void main() {
  for (final language in kStreamChatSupportedLanguages) {
    test('translations exist for $language', () async {
      final locale = Locale(language);
      expect(
        GlobalStreamChatLocalizations.delegate.isSupported(locale),
        isTrue,
      );
      final localizations =
          await GlobalStreamChatLocalizations.delegate.load(locale);
      expect(localizations.launchUrlError, isNotNull);
    });
  }
}
