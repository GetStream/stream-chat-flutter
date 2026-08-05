import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_sending_status.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../mocks.dart';

/// Regression tests for FLU-647: the long-press actions modal re-renders the
/// message on top of a dark scrim, so annotations and sending status must use
/// the on-scrim color instead of their muted / accent in-list colors.
///
/// The core-owned slots (timestamp, "Edited", username, plain annotations,
/// reply label) are covered in stream_core_flutter. These tests cover the two
/// chat-side widgets that hardcoded their colors and therefore bypassed the
/// theme resolution.
void main() {
  final currentUser = OwnUser(id: 'current-user');

  StreamColorScheme colorSchemeOf(WidgetTester tester) {
    return StreamTheme.of(tester.element(find.byType(Scaffold))).colorScheme;
  }

  group('DefaultStreamMessageHeader', () {
    Future<void> pumpHeader(
      WidgetTester tester, {
      required Message message,
      required core.StreamMessagePresentation presentation,
    }) {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

      return tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: core.StreamMessageLayout(
                data: core.StreamMessageLayoutData(presentation: presentation),
                child: DefaultStreamMessageHeader(
                  props: StreamMessageHeaderProps(message: message),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // A reminder without a remindAt renders the "Saved for later" annotation,
    // which is accent-colored in the list.
    final savedForLater = Message(
      id: 'saved-for-later',
      text: 'Saved',
      createdAt: DateTime(2026),
      user: User(id: 'other-user'),
      reminder: MessageReminder(
        messageId: 'saved-for-later',
        channelCid: 'messaging:test',
        userId: 'current-user',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    // showInChannel renders the annotation with a tappable "View" trailing,
    // which uses the link color in the list.
    final showInChannel = Message(
      id: 'show-in-channel',
      text: 'Replied',
      createdAt: DateTime(2026),
      user: User(id: 'other-user'),
      showInChannel: true,
    );

    Color? textColorOf(WidgetTester tester, String text) {
      return DefaultTextStyle.of(tester.element(find.text(text))).style.color;
    }

    Color? iconColorOf(WidgetTester tester, IconData icon) {
      return IconTheme.of(tester.element(find.byIcon(icon))).color;
    }

    testWidgets('saved-for-later stays accent-colored in the list', (tester) async {
      await pumpHeader(
        tester,
        message: savedForLater,
        presentation: core.StreamMessagePresentation.standard,
      );

      final colorScheme = colorSchemeOf(tester);
      expect(textColorOf(tester, 'Saved for later'), colorScheme.accentPrimary);
      expect(iconColorOf(tester, StreamIconData.save), colorScheme.accentPrimary);
    });

    testWidgets('saved-for-later turns white in a preview', (tester) async {
      await pumpHeader(
        tester,
        message: savedForLater,
        presentation: core.StreamMessagePresentation.preview,
      );

      final colorScheme = colorSchemeOf(tester);
      expect(textColorOf(tester, 'Saved for later'), colorScheme.textOnAccent);
      expect(iconColorOf(tester, StreamIconData.save), colorScheme.textOnAccent);
    });

    testWidgets('the "View" trailing keeps the link color in the list', (tester) async {
      await pumpHeader(
        tester,
        message: showInChannel,
        presentation: core.StreamMessagePresentation.standard,
      );

      expect(textColorOf(tester, 'View'), colorSchemeOf(tester).textLink);
    });

    testWidgets('the "View" trailing turns white in a preview', (tester) async {
      await pumpHeader(
        tester,
        message: showInChannel,
        presentation: core.StreamMessagePresentation.preview,
      );

      expect(textColorOf(tester, 'View'), colorSchemeOf(tester).textOnAccent);
    });
  });

  group('StreamMessageSendingStatus', () {
    final message = Message(
      id: 'own-message',
      text: 'Hello',
      createdAt: DateTime(2026),
      user: currentUser,
      state: MessageState.sent,
    );

    // A read by somebody else, after the message was sent.
    final reads = [
      Read(
        user: User(id: 'other-user'),
        lastRead: DateTime(2026, 1, 2),
        lastDeliveredAt: DateTime(2026, 1, 2),
      ),
    ];

    Future<void> pumpStatus(
      WidgetTester tester, {
      required core.StreamMessagePresentation presentation,
    }) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
      when(() => channel.client).thenReturn(client);
      when(() => channel.state).thenReturn(channelState);
      when(() => channelState.read).thenReturn(reads);
      when(() => channelState.readStream).thenAnswer((_) => Stream.value(reads));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: core.StreamMessageLayout(
                  data: core.StreamMessageLayoutData(presentation: presentation),
                  child: StreamMessageSendingStatus(message: message),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    }

    Color? indicatorColor(WidgetTester tester) {
      final icon = tester.widget<Icon>(find.byType(Icon));
      return icon.color;
    }

    testWidgets('read receipts stay accent-colored in the list', (tester) async {
      await pumpStatus(tester, presentation: core.StreamMessagePresentation.standard);
      expect(indicatorColor(tester), colorSchemeOf(tester).accentPrimary);
    });

    testWidgets('read receipts turn white in a preview', (tester) async {
      await pumpStatus(tester, presentation: core.StreamMessagePresentation.preview);
      expect(indicatorColor(tester), colorSchemeOf(tester).textOnAccent);
    });
  });
}
