import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  testWidgets('closes the command suggestions on a tap outside the composer', (tester) async {
    await _pumpComposer(tester);
    await _typeText(tester, '/');
    expect(_commandSuggestions, findsOneWidget);

    await tester.tap(_outside);
    await tester.pumpAndSettle();

    expect(_commandSuggestions, findsNothing);
    expect(_composerHasFocus(tester), isTrue);
  });

  testWidgets('keeps the command suggestions open on a tap on the field', (tester) async {
    await _pumpComposer(tester);
    await _typeText(tester, '/');

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(_commandSuggestions, findsOneWidget);
  });

  testWidgets('shows the command suggestions again on the next keystroke', (tester) async {
    await _pumpComposer(tester);
    await _typeText(tester, '/');
    await tester.tap(_outside);
    await tester.pumpAndSettle();

    await _typeText(tester, '/gi');

    expect(_commandSuggestions, findsOneWidget);
  });
}

const _outsideKey = ValueKey('outside');

final _outside = find.byKey(_outsideKey);

final _commandSuggestions = find.byType(StreamCommandAutocompleteOptions);

bool _composerHasFocus(WidgetTester tester) {
  return tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus;
}

Future<void> _typeText(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  // Suggestions update behind a 300ms debounce; advance past it.
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

Future<void> _pumpComposer(WidgetTester tester) async {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(ownCapabilities: const [ChannelCapability.sendMessage]);
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(() => channel.config).thenReturn(
    ChannelConfig(
      commands: [Command(name: 'giphy', description: 'Post a random gif', args: '[text]')],
    ),
  );
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channelState.members).thenReturn([]);
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.messages).thenReturn([]);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.draft).thenReturn(null);
  when(() => channelState.draftStream).thenAnswer((_) => Stream.value(null));

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          channel: channel,
          child: Scaffold(
            body: Column(
              children: [
                const Expanded(child: SizedBox.expand(key: _outsideKey)),
                StreamMessageComposer(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
