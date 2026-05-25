import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('StreamChatTheme.of', () {
    testWidgets('returns ancestor data when wrapped', (tester) async {
      const backgroundColor = Color(0xFF112233);
      late StreamChatThemeData captured;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(
              messageListViewTheme: const StreamMessageListViewThemeData(
                backgroundColor: backgroundColor,
              ),
            ),
            child: Builder(
              builder: (context) {
                captured = StreamChatTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(captured.messageListViewTheme.backgroundColor, backgroundColor);
    });

    testWidgets(
      'returns default StreamChatThemeData when no ancestor is present',
      (tester) async {
        late StreamChatThemeData captured;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                captured = StreamChatTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        );

        // Should not throw; should return a default theme.
        expect(captured, isA<StreamChatThemeData>());
        expect(captured, equals(StreamChatThemeData()));
      },
    );

    testWidgets('triggers a rebuild when data changes', (tester) async {
      const colorA = Color(0xFFAAAAAA);
      const colorB = Color(0xFFBBBBBB);
      var buildCount = 0;
      var currentColor = colorA;
      late StateSetter externalSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              externalSetState = setState;
              return StreamChatTheme(
                data: StreamChatThemeData(
                  messageListViewTheme: StreamMessageListViewThemeData(
                    backgroundColor: currentColor,
                  ),
                ),
                child: Builder(
                  builder: (context) {
                    buildCount += 1;
                    StreamChatTheme.of(context); // register dependency
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(buildCount, 1);

      externalSetState(() => currentColor = colorB);
      await tester.pump();

      expect(buildCount, 2);
    });
  });

  group('StreamChatTheme as InheritedTheme', () {
    testWidgets(
      'wrap() preserves data so InheritedTheme.captureAll can carry it into a '
      'detached subtree',
      (tester) async {
        const backgroundColor = Color(0xFFDEADBE);
        late StreamChatThemeData captured;

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChatTheme(
              data: StreamChatThemeData(
                messageListViewTheme: const StreamMessageListViewThemeData(
                  backgroundColor: backgroundColor,
                ),
              ),
              child: Builder(
                builder: (outerContext) {
                  // Simulates what showDialog / showModalBottomSheet do
                  // internally — capture ambient inherited themes and re-apply
                  // them in a subtree mounted under the root Navigator overlay.
                  final captured0 = InheritedTheme.captureAll(
                    outerContext,
                    Builder(
                      builder: (innerContext) {
                        captured = StreamChatTheme.of(innerContext);
                        return const SizedBox();
                      },
                    ),
                  );
                  return Overlay(
                    initialEntries: [OverlayEntry(builder: (_) => captured0)],
                  );
                },
              ),
            ),
          ),
        );

        expect(captured.messageListViewTheme.backgroundColor, backgroundColor);
      },
    );
  });
}
