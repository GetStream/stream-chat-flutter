import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../mocks.dart';

void main() {
  group('DefaultStreamMessageHeader translation annotation', () {
    Future<void> pumpHeader(
      WidgetTester tester, {
      required Message message,
      String? userLanguage,
      StreamMessageTranslationConfiguration? translationConfig,
      bool showTranslatedText = true,
    }) {
      final currentUser = OwnUser(id: 'current-user', language: userLanguage);

      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

      return tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            configData: StreamChatConfigurationData(
              messageTranslation: translationConfig ?? const StreamMessageTranslationConfiguration(),
            ),
            child: Scaffold(
              body: core.StreamMessageLayout(
                data: const core.StreamMessageLayoutData(),
                child: DefaultStreamMessageHeader(
                  props: StreamMessageHeaderProps(
                    message: message,
                    showTranslatedText: showTranslatedText,
                    onToggleTranslatedText: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final translated = Message(
      id: 'translated',
      text: 'Hola, mundo!',
      createdAt: DateTime(2026),
      user: User(id: 'other-user'),
      i18n: const {
        'language': 'es',
        'es_text': 'Hola, mundo!',
        'en_text': 'Hello, world!',
      },
    );

    testWidgets('is hidden by default, matching the SDK behaviour before it existed', (tester) async {
      await pumpHeader(tester, message: translated, userLanguage: 'en');

      expect(find.textContaining('Translated'), findsNothing);
      expect(find.text('Show original'), findsNothing);
    });

    testWidgets('is shown once annotationEnabled is set', (tester) async {
      await pumpHeader(
        tester,
        message: translated,
        userLanguage: 'en',
        translationConfig: const StreamMessageTranslationConfiguration(annotationEnabled: true),
      );

      expect(find.text('Translated from Spanish ·'), findsOneWidget);
      expect(find.text('Show original'), findsOneWidget);
    });

    testWidgets('flips to "Original" while the original text is shown', (tester) async {
      await pumpHeader(
        tester,
        message: translated,
        userLanguage: 'en',
        translationConfig: const StreamMessageTranslationConfiguration(annotationEnabled: true),
        showTranslatedText: false,
      );

      expect(find.text('Original ·'), findsOneWidget);
      expect(find.text('Show translation'), findsOneWidget);
    });

    testWidgets('stays hidden when translations are disabled entirely', (tester) async {
      await pumpHeader(
        tester,
        message: translated,
        userLanguage: 'en',
        translationConfig: const StreamMessageTranslationConfiguration(
          enabled: false,
          annotationEnabled: true,
        ),
      );

      expect(find.textContaining('Translated'), findsNothing);
    });

    testWidgets('stays hidden when the user has no language set', (tester) async {
      await pumpHeader(
        tester,
        message: translated,
        translationConfig: const StreamMessageTranslationConfiguration(annotationEnabled: true),
      );

      expect(find.textContaining('Translated'), findsNothing);
    });

    testWidgets('stays hidden when the user language is empty', (tester) async {
      // Stream's API reports an unset `User.language` as `''` rather than
      // omitting it, so the empty string must not be looked up as `_text`.
      await pumpHeader(
        tester,
        message: translated,
        userLanguage: '',
        translationConfig: const StreamMessageTranslationConfiguration(annotationEnabled: true),
      );

      expect(find.textContaining('Translated'), findsNothing);
    });

    testWidgets('stays hidden for a user whose language is the source language', (tester) async {
      // The server echoes the message's own language back in `i18n`, so
      // `es_text` exists but equals the original text — there is nothing to
      // toggle between.
      await pumpHeader(
        tester,
        message: translated,
        userLanguage: 'es',
        translationConfig: const StreamMessageTranslationConfiguration(annotationEnabled: true),
      );

      expect(find.textContaining('Translated'), findsNothing);
    });
  });

  group('StreamMessageText translated text', () {
    Future<void> pumpText(
      WidgetTester tester, {
      required Message message,
      String? userLanguage = 'en',
      StreamMessageTranslationConfiguration? translationConfig,
      bool showTranslatedText = true,
    }) {
      final currentUser = OwnUser(id: 'current-user', language: userLanguage);

      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

      return tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            configData: StreamChatConfigurationData(
              messageTranslation: translationConfig ?? const StreamMessageTranslationConfiguration(),
            ),
            child: Scaffold(
              body: StreamMessageText(
                message: message,
                showTranslatedText: showTranslatedText,
              ),
            ),
          ),
        ),
      );
    }

    final translated = Message(
      id: 'translated',
      text: 'Hola, mundo!',
      createdAt: DateTime(2026),
      user: User(id: 'other-user'),
      i18n: const {
        'language': 'es',
        'es_text': 'Hola, mundo!',
        'en_text': 'Hello, world!',
      },
    );

    testWidgets('shows the translation by default', (tester) async {
      await pumpText(tester, message: translated);

      expect(find.text('Hello, world!'), findsOneWidget);
    });

    testWidgets('shows the original text when showTranslatedText is false', (tester) async {
      await pumpText(tester, message: translated, showTranslatedText: false);

      expect(find.text('Hola, mundo!'), findsOneWidget);
    });

    testWidgets('shows the original text when translations are disabled', (tester) async {
      await pumpText(
        tester,
        message: translated,
        translationConfig: const StreamMessageTranslationConfiguration(enabled: false),
      );

      expect(find.text('Hola, mundo!'), findsOneWidget);
    });

    testWidgets('shows the original text when the user has no language', (tester) async {
      await pumpText(tester, message: translated, userLanguage: null);

      expect(find.text('Hola, mundo!'), findsOneWidget);
    });
  });
}
