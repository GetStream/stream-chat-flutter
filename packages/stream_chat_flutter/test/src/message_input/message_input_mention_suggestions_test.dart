import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'suggests users outside the channel when mentionAllAppUsers is enabled',
    (tester) async {
      final client = MockClient();
      final alice = User(id: 'alice-id', name: 'Alice');
      _stubAppUsers(client, [alice]);

      await _pumpMessageInput(tester, client: client);
      await _typeText(tester, '@ali');

      expect(
        find.descendant(of: _mentionSuggestions, matching: find.text('Alice')),
        findsOneWidget,
      );

      // Close the suggestions before teardown: disposing StreamAutocomplete
      // while they are open trips a setState-in-dispose assertion on v9.
      await _typeText(tester, '');
    },
  );
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

// Pumps a message input with mentionAllAppUsers enabled, in a channel that
// holds no users, so any user suggestion can only come from the app-wide user
// search.
Future<void> _pumpMessageInput(
  WidgetTester tester, {
  required MockClient client,
}) async {
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(channel.getRemainingCooldown).thenReturn(0);

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        child: StreamChannel(
          channel: channel,
          child: const Scaffold(
            body: StreamMessageInput(mentionAllAppUsers: true),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
