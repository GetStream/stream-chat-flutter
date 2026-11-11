import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

/// A client holding [scheduledMessages], all loaded unless [hasLoadedAll] is
/// false. Later lists come from [updates].
MockClient mockClient({
  List<ScheduledMessage> scheduledMessages = const [],
  bool hasLoadedAll = true,
  Stream<List<ScheduledMessage>> updates = const Stream.empty(),
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final state = ScheduledMessageListState(
    scheduledMessages: scheduledMessages,
    hasLoadedAll: hasLoadedAll,
  );

  when(() => client.state).thenReturn(clientState);
  when(() => client.logger).thenReturn(Logger.detached('test'));
  when(client.loadScheduledMessages).thenAnswer((_) async => state);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));
  when(() => clientState.channels).thenReturn({});
  when(() => clientState.scheduledMessageListState).thenReturn(state);
  when(() => clientState.scheduledMessages).thenReturn(scheduledMessages);
  when(() => clientState.scheduledMessagesStream).thenAnswer((_) => updates);

  return client;
}

ScheduledMessage first() {
  return fakeScheduledMessage('first', text: 'Message from the scheduled list');
}

ScheduledMessage other() {
  return fakeScheduledMessage('other', text: 'In another channel', cid: 'messaging:other');
}

ScheduledMessage fakeScheduledMessage(
  String id, {
  required String text,
  String cid = 'messaging:general',
  String? parentId,
}) {
  return ScheduledMessage(
    cid: cid,
    channel: ChannelModel(cid: cid, extraData: const {'name': 'General'}),
    user: User(id: 'current-user-id'),
    message: Message(id: id, text: text, parentId: parentId),
    scheduledAt: DateTime(2026, 10, 21, 8),
    status: ScheduledMessageStatus.scheduled,
  );
}

Widget wrapWithMaterialApp({
  required StreamChatClient client,
  required Widget child,
  StreamComponentBuilders? componentBuilders,
}) {
  return MaterialApp(
    home: StreamChat(
      client: client,
      componentBuilders: componentBuilders,
      configData: StreamChatConfigurationData(),
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      child: Scaffold(body: child),
    ),
  );
}

/// A broadcast stream of scheduled messages that counts how often it's listened to.
class CountingStream {
  late final _controller = StreamController<List<ScheduledMessage>>.broadcast(onListen: () => listens += 1);

  int listens = 0;

  Stream<List<ScheduledMessage>> get stream => _controller.stream;

  bool get hasListener => _controller.hasListener;

  Future<void> close() => _controller.close();
}
