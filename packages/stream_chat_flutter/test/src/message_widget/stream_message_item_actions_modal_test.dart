import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('keeps the actions modal working after its message leaves the tree', (tester) async {
    final client = MockClient();
    final channel = _mockChannel(client);

    await tester.pumpWidget(_app(client: client, channel: channel, showMessage: true));
    await tester.pumpAndSettle();
    await _longPress(tester, find.byType(StreamMessageItem));

    // Rebuilding the app rebuilds the navigator's routes, the open modal among them.
    await tester.pumpWidget(_app(client: client, channel: channel, showMessage: false));

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('MessageItem')), findsOneWidget);
  });
}

MockChannel _mockChannel(MockClient client) {
  final currentUser = OwnUser(id: 'current-user');
  final clientState = MockClientState();
  final channel = MockChannel(ownCapabilities: const [ChannelCapability.sendMessage, ChannelCapability.sendReply]);
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);

  return channel;
}

Widget _app({required MockClient client, required MockChannel channel, required bool showMessage}) {
  final message = Message(
    id: 'test-message',
    text: 'Long press me',
    createdAt: DateTime(2026),
    user: User(id: 'other-user'),
    state: MessageState.sent,
  );

  return MaterialApp(
    builder: (context, child) => StreamChat(client: client, child: child),
    home: StreamChannel(
      channel: channel,
      child: Scaffold(
        body: showMessage ? StreamMessageItem(message: message) : const SizedBox.shrink(),
      ),
    ),
  );
}

// Holds past kLongPressTimeout, which a plain tester.longPress does not
// reliably cross.
Future<void> _longPress(WidgetTester tester, Finder finder) async {
  final gesture = await tester.startGesture(tester.getCenter(finder));
  await tester.pump(const Duration(milliseconds: 700));
  await gesture.up();
  await tester.pumpAndSettle();
}
