import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_app/scheduled_messages/screens/scheduled_messages_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  setUpAll(() => registerFallbackValue(_scheduledMessage('fallback')));

  testWidgets('ScheduledMessagesPage shows the actions of a tapped scheduled message', (tester) async {
    final scheduledMessage = _scheduledMessage('a', text: '#scheduled');
    await _pumpPage(tester, client: _client(scheduledMessages: [scheduledMessage]));

    await tester.tap(find.textContaining('#scheduled', findRichText: true));
    await tester.pumpAndSettle();

    expect(find.text('Reschedule'), findsOneWidget);
  });

  testWidgets('ScheduledMessagesPage says a deleted one was sent or deleted when it is gone', (tester) async {
    final scheduledMessage = _scheduledMessage('a', text: '#sent');
    final client = _client(scheduledMessages: [scheduledMessage]);
    when(() => client.deleteScheduledMessage(any())).thenAnswer((_) async => throw _notFound());
    await _pumpPage(tester, client: client);
    await tester.tap(find.textContaining('#sent', findRichText: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete').last);
    await tester.pump();

    expect(find.text('This message was already sent or deleted'), findsOneWidget);
  });
}

class _MockClient extends Mock implements StreamChatClient {}

class _MockClientState extends Mock implements ClientState {}

const _cid = 'messaging:general';

final _currentUser = OwnUser(id: 'current-user', name: 'Current User');

// A client whose state holds all of [scheduledMessages] and which knows no
// channels.
_MockClient _client({List<ScheduledMessage> scheduledMessages = const []}) {
  final client = _MockClient();
  final state = _MockClientState();
  final listState = ScheduledMessageListState(
    scheduledMessages: scheduledMessages,
    hasLoadedAll: true,
  );

  when(() => client.wsConnectionStatus).thenReturn(ConnectionStatus.connected);
  when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));
  when(() => client.state).thenReturn(state);
  when(() => state.currentUser).thenReturn(_currentUser);
  when(() => state.channels).thenReturn({});
  when(() => state.users).thenReturn({});
  when(() => state.scheduledMessageListState).thenReturn(listState);
  when(() => state.scheduledMessages).thenReturn(scheduledMessages);
  when(() => state.scheduledMessagesStream).thenAnswer((_) => Stream.value(scheduledMessages));
  when(client.loadScheduledMessages).thenAnswer((_) async => listState);

  return client;
}

// A scheduled message of [text] to [_cid].
ScheduledMessage _scheduledMessage(String id, {String text = 'Hello'}) {
  return ScheduledMessage(
    id: id,
    cid: _cid,
    channel: ChannelModel(cid: _cid, extraData: const {'name': 'General'}),
    user: _currentUser,
    message: Message(id: id, text: text),
    scheduledAt: DateTime.utc(2026, 10, 21, 8),
    status: ScheduledMessageStatus.scheduled,
  );
}

// The error of a request for a scheduled message that no longer exists.
StreamChatNetworkError _notFound() {
  return StreamChatNetworkError(ChatErrorCode.doesNotExist, statusCode: 404);
}

// Shows a [ScheduledMessagesPage] within a [StreamChat] for [client].
Future<void> _pumpPage(WidgetTester tester, {required StreamChatClient client}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.wifi]),
        child: StreamSnackbarScope(
          child: Builder(
            builder: (context) => Scaffold(
              backgroundColor: context.streamColorScheme.backgroundApp,
              body: const ScheduledMessagesPage(),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
