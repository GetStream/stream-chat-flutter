import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('EditMessageSheet tests', () {
    const methodChannel =
        MethodChannel('dev.fluttercommunity.plus/connectivity_status');
    setUp(() {
      methodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'listen') {
          try {
            await ServicesBinding.instance.defaultBinaryMessenger
                .handlePlatformMessage(
              methodChannel.name,
              methodChannel.codec.encodeSuccessEnvelope('wifi'),
              (_) {},
            );
          } catch (e) {
            print(e);
          }
        }
      });
    });

    testWidgets('appears on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: MockClient(),
            child: child,
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    child: const Text('Show Modal'),
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => EditMessageSheet(
                        channel: MockChannel(),
                        message: Message(id: 'msg123', text: 'Hello World!'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(EditMessageSheet), findsOneWidget);
      expect(find.text('Edit Message'), findsOneWidget);
      expect(find.byType(StreamMessageInput), findsOneWidget);
    });

    testGoldens(
      'golden test for EditMessageSheet',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamChat(
              client: MockClient(),
              child: child,
            ),
            home: Scaffold(
                body: Center(
              child: EditMessageSheet(
                channel: MockChannel(),
                message: Message(id: 'msg123', text: 'Hello World!'),
              ),
            )),
          ),
        );

        await screenMatchesGolden(tester, 'edit_message_sheet_0');
      },
    );

    tearDown(() {
      methodChannel.setMockMethodCallHandler(null);
    });
  });
}
