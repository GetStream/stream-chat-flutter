import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../mocks.dart';

/// Guards the wiring for FLU-647: the long-press actions modal must re-render
/// the message under [core.StreamMessagePresentation.preview], which is what
/// flips its metadata and annotations to the on-scrim color.
///
/// The golden group below pins down the resulting pixels: the same two messages
/// rendered in the list and as an on-scrim preview, so a regression that brings
/// back the muted or accent-colored metadata shows up as an image diff.
void main() {
  testWidgets(
    'long-pressing a message renders the modal copy as a preview',
    (tester) async {
      final currentUser = OwnUser(id: 'current-user');

      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(
        ownCapabilities: const [
          ChannelCapability.sendMessage,
          ChannelCapability.sendReply,
        ],
      );
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
      when(() => channel.client).thenReturn(client);
      when(() => channel.state).thenReturn(channelState);

      final message = Message(
        id: 'test-message',
        text: 'Long press me',
        createdAt: DateTime(2026),
        // Somebody else's message, so no sending status is involved.
        user: User(id: 'other-user'),
        state: MessageState.sent,
      );

      await tester.pumpWidget(
        MaterialApp(
          // StreamChat has to sit above the Navigator: the actions modal is
          // pushed as a route and re-provides StreamChannel, but relies on
          // StreamChat being an ancestor of the navigator, as in a real app.
          builder: (context, child) => StreamChat(client: client, child: child),
          home: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: StreamMessageItem(message: message),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The in-list copy renders with the standard presentation.
      expect(
        core.StreamMessageLayout.presentationOf(
          tester.element(find.text('Long press me')),
        ),
        core.StreamMessagePresentation.standard,
      );

      // Held past kLongPressTimeout — tester.longPress pumps exactly the
      // timeout, which does not reliably cross the recognizer's deadline.
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(StreamMessageItem)),
      );
      await tester.pump(const Duration(milliseconds: 700));
      await gesture.up();
      await tester.pumpAndSettle();

      // The modal's copy is keyed 'MessageItem'; it must report a preview so the
      // core style defaults resolve to their on-scrim colors.
      final modalItem = find.byKey(const Key('MessageItem'));
      expect(modalItem, findsOneWidget);
      expect(
        core.StreamMessageLayout.presentationOf(tester.element(modalItem)),
        core.StreamMessagePresentation.preview,
      );
    },
  );

  group('StreamMessageItem preview golden tests', () {
    final currentUser = OwnUser(id: 'current-user', name: 'Current User');
    final otherUser = User(id: 'other-user', name: 'Other User');

    // A fixed local timestamp, so the rendered time stays stable.
    final createdAt = DateTime(2026, 1, 1, 14, 30);

    // Somebody else's message, carrying the annotations that are accent- or
    // link-colored in the list ("Saved for later", "Replied to a thread ·
    // View"), plus a username, timestamp, "Edited" label and reply count.
    final incoming = Message(
      id: 'incoming-message',
      text: 'Are we still on for tomorrow?',
      createdAt: createdAt,
      messageTextUpdatedAt: createdAt,
      user: otherUser,
      state: MessageState.sent,
      showInChannel: true,
      replyCount: 3,
      threadParticipants: [otherUser, currentUser],
      // A reminder without a remindAt renders as "Saved for later".
      reminder: MessageReminder(
        messageId: 'incoming-message',
        channelCid: 'messaging:test',
        userId: currentUser.id,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );

    // The current user's own message, so the footer renders the read receipt,
    // which is accent-colored in the list. Pinned and reminded for the two
    // annotations whose colors come from the core defaults.
    final outgoing = Message(
      id: 'outgoing-message',
      text: 'Yes, see you at noon!',
      createdAt: createdAt,
      user: currentUser,
      state: MessageState.sent,
      pinned: true,
      pinnedBy: otherUser,
      reminder: MessageReminder(
        messageId: 'outgoing-message',
        channelCid: 'messaging:test',
        userId: currentUser.id,
        remindAt: DateTime(2026, 1, 1, 18),
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );

    // Read by the other user after the message was sent, so the own message
    // shows the read receipt instead of the muted sent one.
    final reads = [
      Read(
        user: otherUser,
        lastRead: createdAt.add(const Duration(minutes: 1)),
        lastDeliveredAt: createdAt.add(const Duration(minutes: 1)),
      ),
    ];

    Widget buildScene({
      required Brightness brightness,
      required core.StreamMessagePresentation presentation,
    }) {
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

      final isPreview = presentation == core.StreamMessagePresentation.preview;

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: brightness, platform: TargetPlatform.android),
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
          child: StreamChannel(
            channel: channel,
            child: Builder(
              builder: (context) {
                final colorScheme = context.streamColorScheme;

                return Scaffold(
                  backgroundColor: colorScheme.backgroundApp,
                  body: ColoredBox(
                    // The preview is drawn against the same scrim the actions
                    // modal uses; that contrast is what this golden guards.
                    color: isPreview ? colorScheme.backgroundScrim : colorScheme.backgroundApp,
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        for (final (message, alignment) in [
                          (incoming, core.StreamMessageAlignment.start),
                          (outgoing, core.StreamMessageAlignment.end),
                        ])
                          core.StreamMessageLayout(
                            data: core.StreamMessageLayoutData(
                              alignment: alignment,
                              presentation: presentation,
                            ),
                            // Mirrors how the modal renders its copy: without
                            // padding and on a transparent background.
                            child: switch (isPreview) {
                              true => StreamMessageItem(
                                message: message,
                                padding: EdgeInsets.zero,
                                backgroundColor: core.StreamColors.transparent,
                              ),
                              false => StreamMessageItem(message: message),
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    for (final brightness in Brightness.values) {
      final theme = brightness.name;

      goldenTest(
        'StreamMessageItem in the list in $theme theme',
        fileName: 'stream_message_item_in_list_$theme',
        constraints: const BoxConstraints.tightFor(width: 400, height: 400),
        builder: () => buildScene(
          brightness: brightness,
          presentation: core.StreamMessagePresentation.standard,
        ),
      );

      goldenTest(
        'StreamMessageItem as an on-scrim preview in $theme theme',
        fileName: 'stream_message_item_preview_$theme',
        constraints: const BoxConstraints.tightFor(width: 400, height: 400),
        builder: () => buildScene(
          brightness: brightness,
          presentation: core.StreamMessagePresentation.preview,
        ),
      );
    }
  });
}
