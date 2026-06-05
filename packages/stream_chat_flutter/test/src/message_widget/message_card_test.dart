import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

/// Always-handles attachment builder used to inject a known-size widget into
/// the attachments slot of [MessageCard]. Lets each test control the size that
/// `_updateWidthLimit` will read off the rendered RenderBox.
class _FixedSizeAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  const _FixedSizeAttachmentBuilder({required this.size});

  final Size size;

  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) =>
      true;

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    return SizedBox.fromSize(size: size);
  }
}

MessageCard _buildCard({
  required bool hasNonUrlAttachments,
  StreamAttachmentWidgetBuilder? attachmentBuilder,
}) {
  return MessageCard(
    message: Message(
      id: 'm1',
      text: 'hi',
      attachments: [Attachment(type: AttachmentType.file)],
    ),
    isFailedState: false,
    showUserAvatar: DisplayWidget.show,
    messageTheme: const StreamMessageThemeData(),
    hasQuotedMessage: false,
    hasUrlAttachments: false,
    hasNonUrlAttachments: hasNonUrlAttachments,
    hasPoll: false,
    isOnlyEmoji: false,
    isGiphy: false,
    attachmentBuilders: attachmentBuilder == null ? null : [attachmentBuilder],
    attachmentPadding: const EdgeInsets.all(4),
    attachmentShape: null,
    onAttachmentTap: (_, __) {},
    onShowMessage: (_, __) {},
    onReplyTap: (_) {},
    attachmentActionsModalBuilder: null,
    textPadding: const EdgeInsets.all(8),
    reverse: false,
  );
}

/// Wraps [child] in a minimal [StreamChat] + [MaterialApp] so descendant
/// widgets like [StreamMessageText] can resolve `StreamChat.of(context)`.
Widget _wrap(Widget child) {
  final client = MockClient();
  final clientState = MockClientState();
  final user = OwnUser(id: 'user-id');
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(user);
  when(() => clientState.currentUserStream)
      .thenAnswer((_) => Stream.value(user));

  return MaterialApp(
    home: StreamChat(
      client: client,
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('MessageCard._updateWidthLimit', () {
    testWidgets(
      'applies width limit from laid-out attachments render box',
      (tester) async {
        const attachmentSize = Size(220, 80);

        await tester.pumpWidget(
          _wrap(
            _buildCard(
              hasNonUrlAttachments: true,
              attachmentBuilder:
                  const _FixedSizeAttachmentBuilder(size: attachmentSize),
            ),
          ),
        );
        // Allow the post-frame callback scheduled in didChangeDependencies to
        // fire and apply the width limit via setState.
        await tester.pump();

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(MessageCard),
            matching: find.byType(Container),
          ),
        );
        expect(container.constraints?.maxWidth, attachmentSize.width);
      },
    );

    testWidgets(
      'does not throw when the message card is unmounted before '
      'the post-frame callback fires',
      (tester) async {
        const attachmentSize = Size(120, 60);

        await tester.pumpWidget(
          _wrap(
            _buildCard(
              hasNonUrlAttachments: true,
              attachmentBuilder:
                  const _FixedSizeAttachmentBuilder(size: attachmentSize),
            ),
          ),
        );
        // Replace the MessageCard with an empty tree BEFORE pumping the next
        // frame. The post-frame callback queued in didChangeDependencies will
        // fire against an unmounted state — the new `if (!mounted) return;`
        // guard must keep it from throwing.
        await tester.pumpWidget(_wrap(const SizedBox.shrink()));

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'leaves width limit unset when attachment reports zero width',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            _buildCard(
              hasNonUrlAttachments: true,
              attachmentBuilder:
                  const _FixedSizeAttachmentBuilder(size: Size.zero),
            ),
          ),
        );
        await tester.pump();

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(MessageCard),
            matching: find.byType(Container),
          ),
        );
        // The early-return on `attachmentsWidth == 0` means widthLimit stays
        // null and the constraints stay unconstrained on the width axis.
        expect(container.constraints?.maxWidth, double.infinity);
      },
    );

    testWidgets(
      'skips width measurement entirely when there are no attachments',
      (tester) async {
        await tester.pumpWidget(
          _wrap(_buildCard(hasNonUrlAttachments: false)),
        );
        await tester.pump();

        // No exception — the post-frame callback is not scheduled at all when
        // hasAttachments is false.
        expect(tester.takeException(), isNull);
      },
    );
  });
}
