import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  group('EditMessageSheet tests', () {
    testWidgets('appears on tap', (tester) async {
      final channel = MockChannel();
      when(channel.getRemainingCooldown).thenReturn(0);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: MockClient(),
            connectivityStream: Stream.value([ConnectivityResult.wifi]),
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
                        channel: channel,
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

    goldenTest(
      'golden test for EditMessageSheet',
      fileName: 'edit_message_sheet_0',
      constraints: const BoxConstraints.tightFor(width: 300, height: 300),
      builder: () {
        final channel = MockChannel();
        when(channel.getRemainingCooldown).thenReturn(0);

        return MaterialAppWrapper(
          builder: (context, child) => StreamChat(
            client: MockClient(),
            connectivityStream: Stream.value([ConnectivityResult.wifi]),
            child: child,
          ),
          home: Scaffold(
            bottomSheet: EditMessageSheet(
              channel: channel,
              message: Message(id: 'msg123', text: 'Hello World!'),
            ),
          ),
        );
      },
    );
  });
}
