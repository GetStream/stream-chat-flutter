// Pins which message rows `StreamMessageListView` rebuilds when its message
// list changes: only rows whose message or place in a run of messages changed,
// so the cost of a new message doesn't grow with the number of rows on screen.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../test_utils/data_generator.dart';
import '../mocks.dart';

void main() {
  late StreamChatClient client;
  late Channel channel;
  late ChannelClientState channelClientState;
  late StreamController<List<Message>> messagesController;

  final other = User(id: 'otherid');

  setUp(() {
    client = MockClient();
    final clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    final ownUser = OwnUser(id: 'ownid');
    when(() => clientState.currentUser).thenReturn(ownUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));

    messagesController = StreamController<List<Message>>.broadcast();
    addTearDown(messagesController.close);

    channel = MockChannel();
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);

    when(() => channelClientState.threadsStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.isUpToDate).thenReturn(true);
    when(() => channelClientState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
    when(() => channelClientState.unreadCount).thenReturn(0);
    when(() => channelClientState.unreadCountStream).thenAnswer((_) => Stream.value(0));
    when(() => channelClientState.readStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
    when(() => channelClientState.currentUserRead).thenReturn(null);
    when(() => channelClientState.currentUserReadStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messagesStream).thenAnswer((_) => messagesController.stream);

    when(() => channel.markRead(messageId: any(named: 'messageId'))).thenAnswer((_) async => EmptyResponse());
  });

  Widget buildApp({required StreamMessageItemBuilder messageBuilder}) {
    return MaterialApp(
      home: DefaultAssetBundle(
        bundle: rootBundle,
        child: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: StreamMessageListView(messageBuilder: messageBuilder),
          ),
        ),
      ),
    );
  }

  Future<void> pumpMessageList(
    WidgetTester tester, {
    required List<Message> messages,
    required StreamMessageItemBuilder messageBuilder,
  }) async {
    when(() => channelClientState.messages).thenReturn(messages);
    await tester.runAsync(() async {
      await tester.pumpWidget(buildApp(messageBuilder: messageBuilder));
      messagesController.add(messages);
      await tester.pumpAndSettle();
    });
  }

  Future<void> emitMessages(WidgetTester tester, List<Message> messages) async {
    when(() => channelClientState.messages).thenReturn(messages);
    await tester.runAsync(() async {
      messagesController.add(messages);
      await tester.pumpAndSettle();
    });
  }

  Widget recordingBuilder(List<String> builtIds, BuildContext context, Message message, StreamMessageItemProps _) {
    builtIds.add(message.id);
    return SizedBox(height: 40, child: Text(message.text ?? ''));
  }

  testWidgets('a new message rebuilds only the new row and the row it lands next to', (tester) async {
    final messages = generateConversation(20, users: [other]).reversed.toList();
    final builtIds = <String>[];
    await pumpMessageList(
      tester,
      messages: messages,
      messageBuilder: (context, message, props) => recordingBuilder(builtIds, context, message, props),
    );
    builtIds.clear();

    final newMessage = Message(id: 'new-message', text: 'Hello', user: other, createdAt: DateTime.now());
    await emitMessages(tester, [...messages, newMessage]);

    expect(builtIds.toSet(), {newMessage.id, messages.last.id});
  });

  testWidgets('an updated message rebuilds its own row', (tester) async {
    final messages = generateConversation(20, users: [other]).reversed.toList();
    final builtIds = <String>[];
    await pumpMessageList(
      tester,
      messages: messages,
      messageBuilder: (context, message, props) => recordingBuilder(builtIds, context, message, props),
    );
    builtIds.clear();

    final edited = messages.last.copyWith(text: 'Edited');
    await emitMessages(tester, [...messages.take(messages.length - 1), edited]);

    expect(builtIds, contains(edited.id));
    expect(find.text('Edited'), findsOneWidget);
  });

  testWidgets('an edited message does not rebuild the rows next to it', (tester) async {
    final messages = generateConversation(20, users: [other]).reversed.toList();
    final builtIds = <String>[];
    await pumpMessageList(
      tester,
      messages: messages,
      messageBuilder: (context, message, props) => recordingBuilder(builtIds, context, message, props),
    );
    builtIds.clear();

    final editedIndex = messages.length - 3;
    final edited = messages[editedIndex].copyWith(text: 'Edited');
    await emitMessages(tester, [...messages]..[editedIndex] = edited);

    expect(builtIds.toSet(), {edited.id});
  });

  testWidgets('rebuilding the list with a new message builder rebuilds every visible row', (tester) async {
    final messages = generateConversation(20, users: [other]).reversed.toList();
    await pumpMessageList(
      tester,
      messages: messages,
      messageBuilder: (context, message, props) => Text(message.text ?? ''),
    );

    await tester.pumpWidget(
      buildApp(messageBuilder: (context, message, props) => Text('replaced ${message.id}')),
    );

    expect(find.text('replaced ${messages.last.id}'), findsOneWidget);
  });

  testWidgets('rebuilding the list without changing what its rows use keeps every row', (tester) async {
    final messages = generateConversation(20, users: [other]).reversed.toList();
    final builtIds = <String>[];
    Widget messageBuilder(BuildContext context, Message message, StreamMessageItemProps props) =>
        recordingBuilder(builtIds, context, message, props);
    late StateSetter rebuildParent;

    when(() => channelClientState.messages).thenReturn(messages);
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: rootBundle,
            child: StreamChat(
              client: client,
              child: StatefulBuilder(
                builder: (context, setState) {
                  rebuildParent = setState;
                  return StreamChannel(
                    channel: channel,
                    child: StreamMessageListView(
                      messageBuilder: messageBuilder,
                      builders: StreamMessageListViewBuilders(empty: (_) => const Text('No messages')),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      messagesController.add(messages);
      await tester.pumpAndSettle();
    });
    builtIds.clear();

    rebuildParent(() {});
    await tester.pump();

    expect(builtIds, isEmpty);
  });
}
