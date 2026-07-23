// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  group('MessageInput URL enrichment', () {
    final originalRecordPlatform = RecordPlatform.instance;
    setUp(() => RecordPlatform.instance = FakeRecordPlatform());
    tearDown(() => RecordPlatform.instance = originalRecordPlatform);

    late MockClient client;
    late MockClientState clientState;
    late MockChannel channel;
    late MockChannelState channelState;

    setUp(() {
      registerFallbackValue(Message());

      client = MockClient();
      clientState = MockClientState();
      channel = MockChannel(
        ownCapabilities: const [
          ChannelCapability.sendMessage,
          ChannelCapability.sendLinks,
        ],
      );
      channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.currentUserStream).thenAnswer(
        (_) => Stream.value(OwnUser(id: 'user-id')),
      );

      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(channel.getRemainingCooldown).thenReturn(0);
      when(() => channelState.isUpToDate).thenReturn(true);

      when(() => client.enrichUrl(any())).thenAnswer(
        (invocation) async => OGAttachmentResponse()
          ..ogScrapeUrl = invocation.positionalArguments.first as String,
      );
    });

    Future<Object?> enrichUrlFrom(WidgetTester tester, String text) async {
      // Enrichment runs behind a real-clock debounce, so drive the flow with
      // real timers via runAsync.
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              connectivityStream: Stream.value([ConnectivityResult.mobile]),
              child: StreamChannel(
                channel: channel,
                child: const Scaffold(body: StreamMessageInput()),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), text);
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
      });

      return verify(() => client.enrichUrl(captureAny())).captured.single;
    }

    // The scheme (and host) are normalized to lowercase before enriching so a
    // backend that only handles lowercase schemes receives a consistent url.
    // Case-sensitive path and query parts must be preserved as-is.
    final cases = <String, (String, String)>{
      'uppercase HTTPS scheme': ('HTTPS://example.com', 'https://example.com'),
      'uppercase HTTP scheme': ('HTTP://example.com', 'http://example.com'),
      'mixed-case scheme': ('HtTpS://example.com', 'https://example.com'),
      'mixed-case host': ('HTTPS://Example.COM', 'https://example.com'),
      'preserves case-sensitive path and query': (
        'HTTPS://example.com/Path?Q=AbC',
        'https://example.com/Path?Q=AbC',
      ),
      'uppercase scheme with www and path': (
        'HTTPS://www.example.com/foo',
        'https://www.example.com/foo',
      ),
      'url embedded in surrounding text': (
        'look at HTTPS://example.com now',
        'https://example.com',
      ),
      'lowercase https scheme unchanged': (
        'https://example.com',
        'https://example.com',
      ),
    };

    for (final entry in cases.entries) {
      final (input, expected) = entry.value;
      testWidgets('enriches ${entry.key}', (tester) async {
        expect(await enrichUrlFrom(tester, input), expected);
      });
    }
  });
}
