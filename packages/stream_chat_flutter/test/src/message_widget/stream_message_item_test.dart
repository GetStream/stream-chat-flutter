import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  // Drives the real flow: long-press a message to open the actions modal, tap
  // "Pin", and assert the resulting success/error snackbar. StreamChat sits
  // above the Navigator (as in a real app) so the snackbar host is reachable
  // once the modal route pops.
  group('StreamMessageItem action snackbars', () {
    final currentUser = OwnUser(id: 'current-user');
    final message = Message(
      id: 'test-message',
      text: 'Pin me',
      createdAt: DateTime(2026),
      user: User(id: 'other-user'),
      state: MessageState.sent,
    );

    late MockClient client;
    late MockClientState clientState;
    late MockChannel channel;
    late MockChannelState channelState;

    setUp(() {
      client = MockClient();
      clientState = MockClientState();
      channel = MockChannel(
        ownCapabilities: const [
          ChannelCapability.sendMessage,
          ChannelCapability.pinMessage,
        ],
      );
      channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
      when(() => channel.client).thenReturn(client);
      when(() => channel.state).thenReturn(channelState);
    });

    Widget buildHarness() => MaterialApp(
      builder: (context, child) => StreamChat(client: client, child: child),
      home: StreamChannel(
        channel: channel,
        child: Scaffold(body: StreamMessageItem(message: message)),
      ),
    );

    Future<void> openActionsAndTapPin(WidgetTester tester) async {
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(StreamMessageItem).first),
      );
      await tester.pump(const Duration(milliseconds: 700));
      await gesture.up();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pin to Conversation'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows a success snackbar when pinning succeeds', (tester) async {
      when(() => channel.pinMessage(message)).thenAnswer((_) async => UpdateMessageResponse());

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      await openActionsAndTapPin(tester);

      verify(() => channel.pinMessage(message)).called(1);
      expect(find.text('Message pinned'), findsOneWidget);
    });

    testWidgets('shows an error snackbar when pinning fails', (tester) async {
      when(() => channel.pinMessage(message)).thenThrow(Exception('failed to pin'));

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      await openActionsAndTapPin(tester);

      expect(find.text('Error pinning message'), findsOneWidget);
    });

    testWidgets('confirms with a snackbar when copying a message', (tester) async {
      // Stub the clipboard platform channel so Clipboard.setData resolves.
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async => null,
      );
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        );
      });

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(StreamMessageItem).first),
      );
      await tester.pump(const Duration(milliseconds: 700));
      await gesture.up();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Copy Message'));
      await tester.pumpAndSettle();

      expect(find.text('Message copied to clipboard'), findsOneWidget);
    });
  });
}
