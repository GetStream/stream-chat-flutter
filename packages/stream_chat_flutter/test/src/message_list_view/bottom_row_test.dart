import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late Channel channel;
  late ChannelClientState channelClientState;

  setUp(() {
    channel = MockChannel();
    when(() => channel.on(any(), any(), any(), any()))
        .thenAnswer((_) => const Stream.empty());
    channelClientState = MockChannelState();
    when(() => channel.state).thenReturn(channelClientState);
    when(() => channelClientState.messages).thenReturn([
      Message(
        id: 'parentId',
      )
    ]);
  });

  setUpAll(() {
    registerFallbackValue(Message());
  });

  testWidgets('BottomRow', (tester) async {
    final theme = StreamChatThemeData.light();
    final onThreadTap = MockVoidSingleParamCallback<Message>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: StreamChannel(
              channel: channel,
              child: BottomRow(
                message: Message(
                  parentId: 'parentId',
                ),
                isDeleted: false,
                showThreadReplyIndicator: false,
                showUsername: false,
                showInChannel: true,
                showTimeStamp: false,
                showEditedLabel: false,
                reverse: false,
                showSendingIndicator: false,
                hasUrlAttachments: false,
                isGiphy: false,
                isOnlyEmoji: false,
                messageTheme: theme.otherMessageTheme,
                streamChatTheme: theme,
                hasNonUrlAttachments: false,
                streamChat: StreamChatState(),
                onThreadTap: onThreadTap,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    verify(() => onThreadTap.call(any()));
  });
}
