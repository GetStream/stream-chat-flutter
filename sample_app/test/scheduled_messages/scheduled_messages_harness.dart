import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MockClient extends Mock implements StreamChatClient {}

class MockClientState extends Mock implements ClientState {}

const testCid = 'messaging:general';

final currentUser = OwnUser(id: 'current-user', name: 'Current User');

/// A client whose state holds [scheduledMessages], all loaded unless
/// [hasLoadedAll] is false, and which knows no channels.
MockClient fakeClient({
  List<ScheduledMessage> scheduledMessages = const [],
  bool hasLoadedAll = true,
}) {
  final client = MockClient();
  final state = MockClientState();

  when(() => client.wsConnectionStatus).thenReturn(ConnectionStatus.connected);
  when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));
  when(() => client.state).thenReturn(state);
  when(() => state.currentUser).thenReturn(currentUser);
  when(() => state.channels).thenReturn({});
  when(() => state.users).thenReturn({});
  when(() => state.scheduledMessages).thenReturn(scheduledMessages);
  when(() => state.scheduledMessagesStream).thenAnswer((_) => Stream.value(scheduledMessages));
  final listState = ScheduledMessageListState(scheduledMessages: scheduledMessages, hasLoadedAll: hasLoadedAll);
  when(() => state.scheduledMessageListState).thenReturn(listState);
  when(() => state.scheduledMessageListStateStream).thenAnswer((_) => Stream.value(listState));
  when(client.loadScheduledMessages).thenAnswer((_) async => listState);

  return client;
}

/// A scheduled message of [text] to [testCid] in [status].
ScheduledMessage fakeScheduledMessage(
  String id, {
  String text = 'Hello',
  ScheduledMessageStatus status = .scheduled,
  ScheduledMessageFailureReason? failureReason,
  DateTime? scheduledAt,
  String? parentId,
  Message? quotedMessage,
  List<Attachment> attachments = const [],
  List<User> mentionedUsers = const [],
}) {
  return ScheduledMessage(
    id: id,
    cid: testCid,
    channel: ChannelModel(cid: testCid, extraData: const {'name': 'General'}),
    user: currentUser,
    message: Message(
      id: id,
      text: text,
      parentId: parentId,
      quotedMessageId: quotedMessage?.id,
      quotedMessage: quotedMessage,
      attachments: attachments,
      mentionedUsers: mentionedUsers,
    ),
    scheduledAt: scheduledAt ?? DateTime.utc(2026, 10, 21, 8),
    status: status,
    failureReason: failureReason,
  );
}

/// Shows [child] within a [StreamChat] for [client], in US English on a
/// 24-hour clock.
Future<void> pumpScheduledMessages(
  WidgetTester tester,
  Widget child, {
  StreamChatClient? client,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, app) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: app!,
      ),
      home: StreamChat(
        client: client ?? fakeClient(),
        connectivityStream: Stream.value([ConnectivityResult.wifi]),
        child: StreamSnackbarScope(
          child: Builder(
            builder: (context) => Scaffold(
              backgroundColor: context.streamColorScheme.backgroundApp,
              body: child,
            ),
          ),
        ),
      ),
    ),
  );
  // Lets the list load what the client holds.
  await tester.pump();
}
