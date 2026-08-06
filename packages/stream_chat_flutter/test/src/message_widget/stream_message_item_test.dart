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
          ChannelCapability.deleteAnyMessage,
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

    Future<void> openActionsAndTap(WidgetTester tester, String actionLabel) async {
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(StreamMessageItem).first),
      );
      await tester.pump(const Duration(milliseconds: 700));
      await gesture.up();
      await tester.pumpAndSettle();

      await tester.tap(find.text(actionLabel));
      await tester.pumpAndSettle();
    }

    testWidgets('shows a success snackbar when pinning succeeds', (tester) async {
      when(() => channel.pinMessage(message)).thenAnswer((_) async => UpdateMessageResponse());

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      await openActionsAndTap(tester, 'Pin to Conversation');

      verify(() => channel.pinMessage(message)).called(1);
      expect(find.text('Message pinned'), findsOneWidget);
    });

    testWidgets('shows an error snackbar when pinning fails', (tester) async {
      when(() => channel.pinMessage(message)).thenThrow(Exception('failed to pin'));

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      await openActionsAndTap(tester, 'Pin to Conversation');

      verify(() => channel.pinMessage(message)).called(1);
      expect(find.text('Error pinning message'), findsOneWidget);
    });

    testWidgets('shows a success snackbar when a confirmed delete succeeds', (tester) async {
      when(() => channel.deleteMessage(message)).thenAnswer((_) async => EmptyResponse());

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      // Opens the actions modal and taps "Delete Message", surfacing the
      // confirmation dialog; then confirm via "Delete".
      await openActionsAndTap(tester, 'Delete Message');
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(() => channel.deleteMessage(message)).called(1);
      expect(find.text('Message deleted'), findsOneWidget);
    });

    testWidgets('shows an error snackbar when a confirmed delete fails', (tester) async {
      when(() => channel.deleteMessage(message)).thenThrow(Exception('failed to delete'));

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      await openActionsAndTap(tester, 'Delete Message');
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Error deleting message'), findsOneWidget);
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

      await openActionsAndTap(tester, 'Copy Message');

      expect(find.text('Message copied to clipboard'), findsOneWidget);
    });
  });
}
