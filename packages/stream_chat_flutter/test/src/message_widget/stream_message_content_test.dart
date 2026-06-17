import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_content.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' hide StreamMessageContent;

// A deterministic attachment renderer so the post-frame width measurement
// returns a known, non-zero value regardless of asset loading. Without this
// the default builders render Image.network/etc., whose render boxes are
// not laid out synchronously in tests.
class _FixedSizeAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  const _FixedSizeAttachmentBuilder();

  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) {
    return attachments.isNotEmpty;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    return const SizedBox(width: 200, height: 50);
  }
}

// Hosts a mutable [StreamMessageLayout] so the test can flip an inherited
// dependency that the message content already listens to. Acts as a stand-in
// for the production triggers (theme swap, MediaQuery insets from a
// keyboard, StreamChannel state churn) without dragging that machinery in.
class _LayoutHolder extends StatefulWidget {
  const _LayoutHolder({super.key, required this.child});

  final Widget child;

  @override
  State<_LayoutHolder> createState() => _LayoutHolderState();
}

class _LayoutHolderState extends State<_LayoutHolder> {
  StreamMessageAlignment _alignment = StreamMessageAlignment.start;

  void flipAlignment() {
    setState(() {
      _alignment = _alignment == StreamMessageAlignment.start
          ? StreamMessageAlignment.end
          : StreamMessageAlignment.start;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamMessageLayout(
      data: StreamMessageLayoutData(alignment: _alignment),
      child: widget.child,
    );
  }
}

Future<void> pumpContent(
  WidgetTester tester, {
  required Message message,
  required Key layoutKey,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: StreamChatConfiguration(
        data: StreamChatConfigurationData(
          attachmentBuilders: const [_FixedSizeAttachmentBuilder()],
        ),
        child: StreamChatTheme(
          data: StreamChatThemeData(),
          child: _LayoutHolder(
            key: layoutKey,
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 300,
                  child: StreamMessageContent(message: message),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  // Regression test for https://github.com/GetStream/stream-chat-flutter/issues/2761.
  //
  // StreamMessageContent measures the rendered width of its attachments in
  // a post-frame callback and assigns it to widthLimit via setState. The
  // callback is scheduled from didChangeDependencies, which fires on every
  // inherited-widget change (MediaQuery from the keyboard, theme swaps,
  // StreamChannel state updates). Without a diff guard, setState is called
  // every time even when the measured width has not changed, leaving the
  // tile dirty and scheduling another frame. In iOS Release AOT builds the
  // resulting churn manifests as a blank message list and immediate
  // keyboard dismissal on first-message transitions.
  testWidgets(
    'does not schedule another frame when an unrelated dependency changes',
    (tester) async {
      final layoutKey = GlobalKey<_LayoutHolderState>();

      // Empty text avoids pulling StreamMessageText into the tree (which
      // calls StreamChat.of()). The bug is about the post-frame
      // measurement, not the text renderer, so this is sufficient.
      final message = Message(
        attachments: [
          Attachment(
            type: 'image',
            imageUrl: 'https://example.com/x.png',
          ),
        ],
        user: User(id: 'u1', name: 'Alice'),
      );

      await pumpContent(tester, message: message, layoutKey: layoutKey);

      // First pump lets the post-frame callback measure the attachment and
      // setState widthLimit to 200. The follow-up frame paints the bubble
      // with that constraint.
      await tester.pumpAndSettle();

      // Sanity check: the bubble inherited the measured width.
      final constrainedBoxes = tester
          .widgetList<ConstrainedBox>(
            find.descendant(
              of: find.byType(StreamMessageContent),
              matching: find.byType(ConstrainedBox),
            ),
          )
          .where((box) => box.constraints.maxWidth == 200);
      expect(
        constrainedBoxes,
        isNotEmpty,
        reason:
            'Expected the bubble to be constrained to the attachment '
            'width (200) after the initial post-frame measurement.',
      );

      // Flip the inherited StreamMessageLayout. The message content state
      // depends on this via core.StreamMessageLayout.crossAxisAlignmentOf,
      // so didChangeDependencies fires on it — the same trigger path as a
      // MediaQuery viewInsets change in production.
      layoutKey.currentState!.flipAlignment();

      // Pump exactly one frame so didChangeDependencies fires and its
      // post-frame callback runs. The callback re-measures the attachment,
      // finds the same width (200) as the cached widthLimit, and — with a
      // proper diff guard — short-circuits without calling setState.
      await tester.pump();

      // Checking the StreamMessageContent element's dirty flag isolates the
      // signal to this widget. setState inside _updateWidthLimit marks the
      // element dirty after the post-frame callback runs; nothing else in
      // this tree should touch it. hasScheduledFrame would also catch the
      // bug, but it picks up unrelated frame scheduling from theme
      // animations and Material ripples that the alignment flip kicks off.
      final element = tester.element(find.byType(StreamMessageContent));
      expect(
        element.dirty,
        isFalse,
        reason:
            'StreamMessageContent re-ran setState on an unchanged '
            'measured width, leaving the element dirty. This is the '
            'runaway-rebuild pattern from issue #2761.',
      );
    },
  );
}
