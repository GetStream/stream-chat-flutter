import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:stream_chat_localizations/stream_chat_localizations.dart';

void main() {
  for (final language in kStreamChatSupportedLanguages) {
    testWidgets('translations exist for $language', (tester) async {
      final locale = Locale(language);
      final globalStreamChatLocalizations = GlobalStreamChatLocalizations();

      expect(
        globalStreamChatLocalizations.delegate.isSupported(locale),
        isTrue,
      );

      final localizations =
          await globalStreamChatLocalizations.delegate.load(locale);

      expect(
        localizations.translate(LocalizedKeys.launchUrlErrorLabel),
        isNotNull,
      );
    });
  }
}
