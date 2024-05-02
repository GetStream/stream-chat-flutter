import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  group('ErrorAlertSheet tests', () {
    const methodChannel =
        MethodChannel('dev.fluttercommunity.plus/connectivity_status');
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel,
              (MethodCall methodCall) async {
        if (methodCall.method == 'listen') {
          try {
            await TestDefaultBinaryMessengerBinding
                .instance.defaultBinaryMessenger
                .handlePlatformMessage(
              methodChannel.name,
              methodChannel.codec.encodeSuccessEnvelope('wifi'),
              (_) {},
            );
          } catch (e) {
            print(e);
          }
        }
        return null;
      });
    });

    testWidgets('appears on error', (tester) async {
      void failFunction() => throw Exception('Something went wrong');

      await tester.pumpWidget(
        MaterialAppWrapper(
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
                    onPressed: () {
                      try {
                        failFunction();
                      } catch (e) {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => ErrorAlertSheet(
                            errorDescription: e.toString(),
                          ),
                        );
                      }
                    },
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
      expect(find.byType(ErrorAlertSheet), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testGoldens(
      'golden test for ErrorAlertSheet',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialAppWrapper(
            builder: (context, child) => StreamChat(
              client: MockClient(),
              child: child,
            ),
            home: const Scaffold(
              body: Center(
                child: ErrorAlertSheet(
                  errorDescription: 'Something went wrong.',
                ),
              ),
            ),
          ),
        );

        await screenMatchesGolden(tester, 'error_alert_sheet_0');
      },
    );

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, null);
    });
  });
}
