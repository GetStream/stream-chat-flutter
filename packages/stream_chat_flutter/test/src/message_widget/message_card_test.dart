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

/// Mirrors the layout shape of a real image attachment: the bounded box from
/// `_kDefaultImageConstraints`, an [AspectRatio] driven by the image's own
/// ratio, and a [LayoutBuilder] at the leaf — which is where
/// [StreamImageAttachmentThumbnail] reads `constraints.biggest` and turns it
/// into a CDN `w`/`h`. Records the width seen on every layout pass.
class _RecordingAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  _RecordingAttachmentBuilder({required this.widths});

  /// Width passed to the leaf on each layout pass, in order.
  final List<double> widths;

  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) =>
      true;

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 170,
        maxWidth: 256,
        minHeight: 100,
        maxHeight: 300,
      ),
      child: AspectRatio(
        // A 3:4 portrait photo, the ratio behind the most common size pair in
        // the reported traffic.
        aspectRatio: 0.75,
        child: LayoutBuilder(
          builder: (context, constraints) {
            widths.add(constraints.biggest.width);
            return const SizedBox.expand();
          },
        ),
      ),
    );
  }
}

/// Mirrors a two-column gallery: the tight box, padding and spacing that
/// [GalleryAttachmentBuilder] lays its tiles out with. Records the width each
/// tile is given on every layout pass.
class _RecordingGalleryBuilder extends StreamAttachmentWidgetBuilder {
  _RecordingGalleryBuilder({required this.widths});

  /// Width of the first tile on each layout pass, in order.
  final List<double> widths;

  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) =>
      true;

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    return Container(
      constraints: const BoxConstraints.tightFor(width: 256, height: 195),
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                widths.add(constraints.biggest.width);
                return const SizedBox.expand();
              },
            ),
          ),
          const SizedBox(width: 2),
          const Expanded(child: SizedBox.expand()),
        ],
      ),
    );
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

/// The max width the card currently imposes on its content.
///
/// The limit lives on the outermost [ConstrainedBox] inside [MessageCard] —
/// inside the decoration, so the border does not eat into it.
double? _widthLimitOf(WidgetTester tester) {
  // Deliberately not `.first`: `tester.widget` throws on multiple matches, so
  // a second ConstrainedBox appearing above this one fails loudly instead of
  // silently asserting against the wrong box.
  final box = tester.widget<ConstrainedBox>(
    find.descendant(
      of: find.byType(MessageCard),
      matching: find.byType(ConstrainedBox),
    ),
  );
  return box.constraints.maxWidth;
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

        expect(_widthLimitOf(tester), attachmentSize.width);
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

        // The early-return on `attachmentsWidth == 0` means widthLimit stays
        // null and the constraints stay unconstrained on the width axis.
        expect(_widthLimitOf(tester), double.infinity);
      },
    );

    testWidgets(
      'lays the attachment out at the same width before and after the '
      'measured width limit is applied',
      (tester) async {
        final widths = <double>[];

        await tester.pumpWidget(
          _wrap(
            _buildCard(
              hasNonUrlAttachments: true,
              attachmentBuilder: _RecordingAttachmentBuilder(widths: widths),
            ),
          ),
        );
        // Let the post-frame callback apply the measured width limit and
        // lay the subtree out a second time.
        await tester.pump();

        // Feeding the measured width back in must not shrink the box it was
        // measured from. A narrower second pass makes the thumbnail ask the
        // CDN for a second, near-identical size for the same image.
        expect(widths, isNotEmpty);
        expect(widths.toSet(), hasLength(1), reason: 'saw widths: $widths');
      },
    );

    testWidgets(
      'lays gallery tiles out at the same width across both passes',
      (tester) async {
        final widths = <double>[];

        await tester.pumpWidget(
          _wrap(
            _buildCard(
              hasNonUrlAttachments: true,
              attachmentBuilder: _RecordingGalleryBuilder(widths: widths),
            ),
          ),
        );
        await tester.pump();

        // A gallery row splits the card's width between its tiles, so a
        // shrinking second pass costs each tile a fraction of it.
        expect(widths, isNotEmpty);
        expect(widths.toSet(), hasLength(1), reason: 'saw widths: $widths');
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
