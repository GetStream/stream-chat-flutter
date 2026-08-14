import 'dart:async';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_text.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide StreamMessageText;
import 'package:stream_core_flutter/chat.dart' as core;

import '../mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenReturn(clientState);
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  Widget wrap(Widget child) {
    return MaterialApp(
      home: StreamChat(
        client: client,
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('StreamMessageText renders message text', (tester) async {
    final user = OwnUser(id: 'test-user', language: 'en');
    when(() => clientState.currentUser).thenReturn(user);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));

    final message = Message(text: 'Hello world');

    await tester.pumpWidget(wrap(StreamMessageText(message: message)));
    await tester.pump();

    expect(find.text('Hello world'), findsOneWidget);
    expect(find.byType(core.StreamMessageText), findsOneWidget);
  });

  testWidgets('StreamMessageText is selectable on desktop and web', (tester) async {
    final user = OwnUser(id: 'test-user', language: 'en');
    when(() => clientState.currentUser).thenReturn(user);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));

    final message = Message(text: 'Hello world');

    // Desktop
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.macOS;
    await tester.pumpWidget(wrap(StreamMessageText(message: message)));
    await tester.pump();
    expect(find.byType(SelectionArea), findsOneWidget);

    // Web
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;
    await tester.pumpWidget(wrap(StreamMessageText(message: message)));
    await tester.pump();
    expect(find.byType(SelectionArea), findsOneWidget);
  });

  testWidgets('StreamMessageText is not selectable on mobile', (tester) async {
    final user = OwnUser(id: 'test-user', language: 'en');
    when(() => clientState.currentUser).thenReturn(user);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));

    final message = Message(text: 'Hello world');

    // iOS
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    await tester.pumpWidget(wrap(StreamMessageText(message: message)));
    await tester.pump();
    expect(find.byType(SelectionArea), findsNothing);

    // Android
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    await tester.pumpWidget(wrap(StreamMessageText(message: message)));
    await tester.pump();
    expect(find.byType(SelectionArea), findsNothing);
  });

  testWidgets(
    'StreamMessageText allows selecting text on desktop',
    (tester) async {
      addTearDown(() {
        CurrentPlatform.debugCurrentPlatformOverride = null;
      });

      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.macOS;

      SelectedContent? content;

      final user = OwnUser(id: 'test-user', language: 'en');
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));

      const text = '- Item 1\n- Item 2\n- Item 3';

      await tester.pumpWidget(
        wrap(
          StreamMessageText(
            message: Message(text: text),
            onSelectionChanged: (selectedContent) {
              content = selectedContent;
            },
          ),
        ),
      );

      final target = find.byType(StreamMessageText);
      expect(target, findsOneWidget);

      final gesture = await tester.startGesture(
        tester.getTopLeft(target),
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getBottomRight(target));
      await gesture.up();
      await tester.pump();

      expect(content, isNotNull);
      expect(content!.plainText, '•Item 1•Item 2•Item 3');
    },
  );

  testWidgets('StreamMessageText renders translated message text', (tester) async {
    final user = OwnUser(id: 'test-user', language: 'fr');
    when(() => clientState.currentUser).thenReturn(user);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));

    final message = Message(
      text: 'Hello world',
      i18n: const {
        'fr_text': 'Bonjour le monde',
      },
    );

    await tester.pumpWidget(wrap(StreamMessageText(message: message)));
    await tester.pump();

    expect(find.text('Bonjour le monde'), findsOneWidget);
  });

  testWidgets('StreamMessageText renders empty when text is null or empty', (tester) async {
    final user = OwnUser(id: 'test-user', language: 'en');
    when(() => clientState.currentUser).thenReturn(user);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));

    await tester.pumpWidget(wrap(StreamMessageText(message: Message())));
    await tester.pump();

    expect(find.byType(core.StreamMessageText), findsNothing);
  });

  testWidgets('StreamMessageText replaces mentions', (tester) async {
    final user = OwnUser(id: 'test-user', language: 'en');
    when(() => clientState.currentUser).thenReturn(user);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));

    final mentionedUser = User(id: 'u1', name: 'Alice');
    final message = Message(
      text: 'Hello @u1',
      mentionedUsers: [mentionedUser],
    );

    await tester.pumpWidget(wrap(StreamMessageText(message: message)));
    await tester.pump();

    // replaceMentions() should change "@u1" to "[@Alice](mention:u1)"
    // core.StreamMessageText renders this as markdown.
    expect(find.textContaining('Alice'), findsOneWidget);
  });

  testWidgets('StreamMessageText rebuilds when user language changes', (tester) async {
    final userEn = OwnUser(id: 'test-user', language: 'en');
    final userFr = OwnUser(id: 'test-user', language: 'fr');

    final userStreamController = StreamController<OwnUser?>.broadcast()..add(userEn);

    when(() => clientState.currentUser).thenReturn(userEn);
    when(() => clientState.currentUserStream).thenAnswer((_) => userStreamController.stream);

    final message = Message(
      text: 'Hello world',
      i18n: const {
        'fr_text': 'Bonjour le monde',
      },
    );

    await tester.pumpWidget(wrap(StreamMessageText(message: message)));
    await tester.pump();

    expect(find.text('Hello world'), findsOneWidget);

    when(() => clientState.currentUser).thenReturn(userFr);
    userStreamController.add(userFr);

    // BetterStreamBuilder needs to process the stream event and trigger a rebuild.
    // pumpAndSettle ensures all scheduled frames and microtasks are handled.
    await tester.pumpAndSettle();

    expect(find.text('Bonjour le monde'), findsOneWidget);

    await userStreamController.close();
  });
}
