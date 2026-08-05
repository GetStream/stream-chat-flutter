import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    expect(find.byType(SelectionArea), isDesktopDeviceOrWeb ? findsOneWidget : findsNothing);
  });

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
