// Pins what still reaches a message row that `StreamMessageListView` reuses
// across rebuilds: inherited values, the page's scaffold, replaced callbacks,
// the highlight and a change in the message's content kind.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../test_utils/data_generator.dart';
import '../mocks.dart';

void main() {
  final other = User(id: 'otherid');

  testWidgets('StreamMessageListView shows a theme change in a custom system message', (tester) async {
    final chat = _FakeChat();
    final system = Message(id: 'system', text: 'Joined', type: MessageType.system, createdAt: DateTime.now());
    var brightness = Brightness.light;
    late StateSetter setHost;

    await chat.pumpMessages(
      tester,
      [
        ...generateConversation(5, users: [other]).reversed,
        system,
      ],
      wrap: (list) => StatefulBuilder(
        builder: (context, setState) {
          setHost = setState;
          return Theme(
            data: ThemeData(brightness: brightness),
            child: list,
          );
        },
      ),
      list: StreamMessageListView(
        builders: StreamMessageListViewBuilders(
          systemMessage: (context, message) => Text('system ${Theme.of(context).brightness.name}'),
        ),
      ),
    );
    setHost(() => brightness = Brightness.dark);
    await tester.pump();

    expect(find.text('system dark'), findsOneWidget);
  });

  testWidgets('StreamMessageListView lets a custom system message show a snackbar on the page', (tester) async {
    final chat = _FakeChat();
    final system = Message(id: 'system', text: 'Joined', type: MessageType.system, createdAt: DateTime.now());

    await chat.pumpMessages(
      tester,
      [system],
      wrap: (list) => Scaffold(body: list),
      list: StreamMessageListView(
        builders: StreamMessageListViewBuilders(
          systemMessage: (context, message) => TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Snack'))),
            child: const Text('Show'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();

    expect(find.text('Snack'), findsOneWidget);
  });

  testWidgets('StreamMessageListView updates a row when an inherited value its builder reads changes', (tester) async {
    final chat = _FakeChat();
    final messages = generateConversation(5, users: [other]).reversed.toList();
    var label = 'before';
    late StateSetter setHost;

    await chat.pumpMessages(
      tester,
      messages,
      wrap: (list) => StatefulBuilder(
        builder: (context, setState) {
          setHost = setState;
          return _Label(value: label, child: list);
        },
      ),
      list: const StreamMessageListView(messageBuilder: _labelBuilder),
    );
    setHost(() => label = 'after');
    await tester.pump();

    expect(find.text('after ${messages.last.id}'), findsOneWidget);
  });

  testWidgets('StreamMessageListView calls the latest onMessageTap after it is rebuilt with a new one', (tester) async {
    final chat = _FakeChat();
    final messages = generateConversation(5, users: [other]).reversed.toList();
    final taps = <String>[];
    var tapLabel = 'first';
    late StateSetter setHost;

    await chat.pumpMessages(
      tester,
      messages,
      wrap: (list) => StatefulBuilder(
        builder: (context, setState) {
          setHost = setState;
          final label = tapLabel;
          return StreamMessageListView(messageBuilder: _tapBuilder, onMessageTap: (_) => taps.add(label));
        },
      ),
    );
    setHost(() => tapLabel = 'second');
    await tester.pump();
    await tester.tap(find.text('tap ${messages.last.id}'));

    expect(taps, ['second']);
  });

  testWidgets('StreamMessageListView highlights a reused row it scrolls to', (tester) async {
    final chat = _FakeChat();
    final messages = generateConversation(10, users: [other]).reversed.toList();
    final target = messages[messages.length - 2];

    await chat.pumpMessages(tester, messages, list: const StreamMessageListView(messageBuilder: _quoteTapBuilder));
    await chat.emitMessages(tester, [
      ...messages,
      Message(id: 'new', text: 'New', user: other, createdAt: DateTime.now()),
    ]);
    await tester.tap(find.text('quote ${target.id}'));
    await _pumpFrames(tester, const Duration(milliseconds: 500));

    final highlight = find.byType(TweenAnimationBuilder<Color?>);
    expect(find.descendant(of: highlight, matching: find.text('quote ${target.id}')), findsOneWidget);
  });

  testWidgets('StreamMessageListView lays out a message edited to emoji only as jumbomoji', (tester) async {
    final chat = _FakeChat();
    final messages = generateConversation(5, users: [other]).reversed.toList();

    await chat.pumpMessages(tester, messages, list: const StreamMessageListView(messageBuilder: _contentKindBuilder));
    final edited = messages.last.copyWith(text: '😀');
    await chat.emitMessages(tester, [...messages.take(messages.length - 1), edited]);

    expect(find.text('jumbomoji ${edited.id}'), findsOneWidget);
  });
}

class _Label extends InheritedWidget {
  const _Label({required this.value, required super.child});

  final String value;

  static String of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_Label>()!.value;

  @override
  bool updateShouldNotify(_Label oldWidget) => value != oldWidget.value;
}

Widget _labelBuilder(BuildContext context, Message message, StreamMessageItemProps props) {
  return Text('${_Label.of(context)} ${message.id}');
}

Widget _tapBuilder(BuildContext context, Message message, StreamMessageItemProps props) {
  return GestureDetector(
    onTap: () => props.onMessageTap?.call(message),
    child: Text('tap ${message.id}'),
  );
}

Widget _quoteTapBuilder(BuildContext context, Message message, StreamMessageItemProps props) {
  return GestureDetector(
    onTap: () => props.onQuotedMessageTap?.call(message),
    child: SizedBox(height: 40, child: Text('quote ${message.id}')),
  );
}

Widget _contentKindBuilder(BuildContext context, Message message, StreamMessageItemProps props) {
  return Text('${StreamMessageLayout.contentKindOf(context).name} ${message.id}');
}

// Pumps frame by frame for [duration], so animations run as they would live.
Future<void> _pumpFrames(WidgetTester tester, Duration duration) async {
  const frame = Duration(milliseconds: 16);
  for (var elapsed = Duration.zero; elapsed < duration; elapsed += frame) {
    await tester.pump(frame);
  }
}

// A channel whose messages a test controls, for pumping a message list.
class _FakeChat {
  _FakeChat() {
    final clientState = MockClientState();
    final ownUser = OwnUser(id: 'ownid');
    when(() => client.state).thenAnswer((_) => clientState);
    when(() => clientState.currentUser).thenReturn(ownUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));

    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelState);
    when(() => channel.markRead(messageId: any(named: 'messageId'))).thenAnswer((_) async => EmptyResponse());

    when(() => channelState.threadsStream).thenAnswer((_) => const Stream.empty());
    when(() => channelState.isUpToDate).thenReturn(true);
    when(() => channelState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
    when(() => channelState.unreadCount).thenReturn(0);
    when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));
    when(() => channelState.readStream).thenAnswer((_) => const Stream.empty());
    when(() => channelState.read).thenReturn([]);
    when(() => channelState.membersStream).thenAnswer((_) => const Stream.empty());
    when(() => channelState.members).thenReturn([]);
    when(() => channelState.currentUserRead).thenReturn(null);
    when(() => channelState.currentUserReadStream).thenAnswer((_) => const Stream.empty());
    when(() => channelState.messagesStream).thenAnswer((_) => _messages.stream);
  }

  final client = MockClient();
  final channel = MockChannel();
  final channelState = MockChannelState();
  final _messages = StreamController<List<Message>>.broadcast();

  // Pumps [list], or the widget [wrap] builds around it, below a channel
  // showing [messages].
  Future<void> pumpMessages(
    WidgetTester tester,
    List<Message> messages, {
    Widget list = const StreamMessageListView(),
    Widget Function(Widget list)? wrap,
  }) async {
    addTearDown(_messages.close);
    when(() => channelState.messages).thenReturn(messages);
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: rootBundle,
            child: StreamChat(
              client: client,
              child: StreamChannel(channel: channel, child: wrap?.call(list) ?? list),
            ),
          ),
        ),
      );
      _messages.add(messages);
      await tester.pumpAndSettle();
    });
  }

  // Replaces the channel's messages with [messages] and lets the list rebuild.
  Future<void> emitMessages(WidgetTester tester, List<Message> messages) async {
    when(() => channelState.messages).thenReturn(messages);
    await tester.runAsync(() async {
      _messages.add(messages);
      await tester.pumpAndSettle();
    });
  }
}
