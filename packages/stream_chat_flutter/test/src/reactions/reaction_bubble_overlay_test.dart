import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/reactions/reaction_bubble_overlay.dart';

void main() {
  testWidgets(
    'returns child directly when not visible',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Portal(
            child: Scaffold(
              body: ReactionBubbleOverlay(
                visible: false,
                reaction: Text('reaction'),
                child: Text('child'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('child'), findsOneWidget);
      expect(find.text('reaction'), findsNothing);
      expect(find.byType(PortalTarget), findsNothing);
    },
  );

  testWidgets(
    'shows portal target when visible',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Portal(
            child: Scaffold(
              body: ReactionBubbleOverlay(
                visible: true,
                reaction: Text('reaction'),
                child: Text('child'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('child'), findsOneWidget);
      expect(find.text('reaction'), findsOneWidget);
      expect(find.byType(PortalTarget), findsOneWidget);
    },
  );

  testWidgets(
    'supports custom anchor',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Portal(
            child: Scaffold(
              body: ReactionBubbleOverlay(
                visible: true,
                anchor: ReactionBubbleAnchor.topStart(offset: Offset(4, -8)),
                reaction: Text('reaction'),
                child: Text('child'),
              ),
            ),
          ),
        ),
      );

      final portalTarget = tester.widget<PortalTarget>(find.byType(PortalTarget));
      final anchor = portalTarget.anchor as Aligned;

      expect(anchor.target, Alignment.topLeft);
      expect(anchor.follower, Alignment.bottomCenter);
      expect(anchor.offset, const Offset(4, -8));
      expect(anchor.shiftToWithinBound.x, isTrue);
      expect(anchor.shiftToWithinBound.y, isFalse);
      expect(find.text('child'), findsOneWidget);
    },
  );

  testWidgets(
    'forwards payload and callback to custom builder',
    (tester) async {
      String? capturedPayload;
      ValueSetter<String>? capturedCallback;
      String? pickedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Portal(
            child: Scaffold(
              body: GenericBubbleOverlay(
                payload: 'payload-value',
                onPicked: (value) {
                  pickedValue = value;
                },
                reactionBuilder: (context, payload, onPicked) {
                  capturedPayload = payload;
                  capturedCallback = onPicked;
                  return const Text('reaction');
                },
                child: const Text('child'),
              ),
            ),
          ),
        ),
      );

      expect(capturedPayload, 'payload-value');
      expect(capturedCallback, isNotNull);

      capturedCallback?.call('picked-value');
      expect(pickedValue, 'picked-value');
    },
  );

  testWidgets(
    'uses start anchor when reverse is false in LTR',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Portal(
            child: Scaffold(
              body: GenericBubbleOverlay(
                payload: 'payload',
                reverse: false,
                anchorOffset: Offset(12, -6),
                reactionBuilder: _defaultReactionBuilder,
                child: Text('child'),
              ),
            ),
          ),
        ),
      );

      final portalTarget = tester.widget<PortalTarget>(find.byType(PortalTarget));
      final anchor = portalTarget.anchor as Aligned;

      expect(anchor.target, Alignment.topLeft);
      expect(anchor.follower, Alignment.bottomLeft);
      expect(anchor.offset, const Offset(12, -6));
    },
  );

  testWidgets(
    'uses end anchor when reverse is true in LTR',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Portal(
            child: Scaffold(
              body: GenericBubbleOverlay(
                payload: 'payload',
                reverse: true,
                anchorOffset: Offset(-3, 9),
                reactionBuilder: _defaultReactionBuilder,
                child: Text('child'),
              ),
            ),
          ),
        ),
      );

      final portalTarget = tester.widget<PortalTarget>(find.byType(PortalTarget));
      final anchor = portalTarget.anchor as Aligned;

      expect(anchor.target, Alignment.topRight);
      expect(anchor.follower, Alignment.bottomRight);
      expect(anchor.offset, const Offset(-3, 9));
    },
  );
}

typedef GenericReactionBuilder = Widget Function(BuildContext context, String payload, ValueSetter<String>? onPicked);

class GenericBubbleOverlay extends StatelessWidget {
  const GenericBubbleOverlay({
    super.key,
    required this.payload,
    required this.reactionBuilder,
    required this.child,
    this.onPicked,
    this.visible = true,
    this.reverse = false,
    this.anchorOffset = Offset.zero,
  });

  final String payload;
  final GenericReactionBuilder reactionBuilder;
  final ValueSetter<String>? onPicked;
  final Widget child;
  final bool visible;
  final bool reverse;
  final Offset anchorOffset;

  @override
  Widget build(BuildContext context) {
    return ReactionBubbleOverlay(
      visible: visible,
      anchor: ReactionBubbleAnchor(
        offset: anchorOffset,
        follower: AlignmentDirectional(reverse ? 1 : -1, 1),
        target: AlignmentDirectional(reverse ? 1 : -1, -1),
      ),
      reaction: reactionBuilder(context, payload, onPicked),
      child: child,
    );
  }
}

Widget _defaultReactionBuilder(
  BuildContext context,
  String payload,
  ValueSetter<String>? onPicked,
) {
  return const SizedBox.shrink();
}
