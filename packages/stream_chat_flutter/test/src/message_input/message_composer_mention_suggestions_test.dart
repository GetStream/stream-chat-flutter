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

  testWidgets('suggests users outside the channel when mentionAllAppUsers is enabled', (tester) async {
    final client = MockClient();
    final alice = User(id: 'alice-id', name: 'Alice');
    _stubAppUsers(client, [alice]);

    await _pumpComposer(tester, client: client);
    await _typeText(tester, '@ali');

    expect(find.descendant(of: _mentionSuggestions, matching: find.text('Alice')), findsOneWidget);
  });
}

final _mentionSuggestions = find.byType(StreamMentionAutocompleteOptions);

void _stubAppUsers(MockClient client, List<User> users) {
  when(
    () => client.queryUsers(
      presence: any(named: 'presence'),
      filter: any(named: 'filter'),
      sort: any(named: 'sort'),
      pagination: any(named: 'pagination'),
    ),
  ).thenAnswer((_) async => QueryUsersResponse()..users = users);
}

Future<void> _typeText(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  // Suggestions update behind a 300ms debounce; advance past it.
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pumpAndSettle();
}

// Pumps a composer with mentionAllAppUsers enabled, in a channel with no
// members, so any user suggestion can only come from the app-wide user search.
Future<void> _pumpComposer(WidgetTester tester, {required MockClient client}) async {
  final clientState = MockClientState();
  final channel = MockChannel(ownCapabilities: const [ChannelCapability.sendMessage]);
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(() => channel.config).thenReturn(ChannelConfig());
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
                const Expanded(child: SizedBox.expand()),
                StreamMessageComposer(mentionAllAppUsers: true),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
