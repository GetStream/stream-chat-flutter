// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  group('MessageComposer URL enrichment', () {
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

      when(() => client.enrichUrl(any())).thenAnswer(
        (invocation) async => Result.success(_ogResponse(invocation.positionalArguments.first as String)),
      );
    });

    Future<void> pumpComposer(
      WidgetTester tester, {
      StreamMessageComposerController? controller,
      ErrorListener? onError,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            connectivityStream: Stream.value([ConnectivityResult.mobile]),
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamMessageComposer(messageComposerController: controller, onError: onError),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> typeAndWaitForEnrichment(WidgetTester tester, String text) async {
      await tester.enterText(find.byType(TextField), text);
      // Enrichment runs behind a 350ms debounce; advance past it.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    }

    Future<Object?> enrichUrlFrom(WidgetTester tester, String text) async {
      await pumpComposer(tester);
      await typeAndWaitForEnrichment(tester, text);

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

    testWidgets('a scraped url becomes the link preview', (tester) async {
      final controller = StreamMessageComposerController();
      addTearDown(controller.dispose);
      await pumpComposer(tester, controller: controller);

      await typeAndWaitForEnrichment(tester, 'https://example.com');

      expect(controller.ogAttachment?.ogScrapeUrl, 'https://example.com');
    });

    testWidgets('a failed scrape clears the link preview and reports the error', (tester) async {
      const error = StreamApiException(code: StreamErrorCode.inputError, message: 'unreachable', statusCode: 400);
      when(() => client.enrichUrl('https://unreachable.example')).thenAnswer((_) async => const Result.failure(error));
      final controller = StreamMessageComposerController();
      addTearDown(controller.dispose);
      final errors = <Object>[];
      await pumpComposer(tester, controller: controller, onError: (error, _) => errors.add(error));
      await typeAndWaitForEnrichment(tester, 'https://example.com');

      await typeAndWaitForEnrichment(tester, 'https://unreachable.example');

      expect(controller.ogAttachment, isNull);
      expect(errors, [error]);
    });

    testWidgets('a scrape without a scraped url shows no link preview', (tester) async {
      when(() => client.enrichUrl(any())).thenAnswer(
        (_) async => const Result.success(OGAttachmentResponse(duration: '0.01ms', title: 'Example Domain')),
      );
      final controller = StreamMessageComposerController();
      addTearDown(controller.dispose);
      await pumpComposer(tester, controller: controller);

      await typeAndWaitForEnrichment(tester, 'https://example.com');
      await typeAndWaitForEnrichment(tester, 'https://example.com ');

      expect(controller.attachments, isEmpty);
    });

    testWidgets('a url scraped earlier is previewed again without a second request', (tester) async {
      final controller = StreamMessageComposerController();
      addTearDown(controller.dispose);
      await pumpComposer(tester, controller: controller);

      await typeAndWaitForEnrichment(tester, 'https://example.com');
      await typeAndWaitForEnrichment(tester, 'no link here');
      await typeAndWaitForEnrichment(tester, 'https://example.com');

      expect(controller.ogAttachment?.ogScrapeUrl, 'https://example.com');
      verify(() => client.enrichUrl('https://example.com')).called(1);
    });
  });
}

OGAttachmentResponse _ogResponse(String url) {
  return OGAttachmentResponse(duration: '0.01ms', ogScrapeUrl: url, titleLink: url);
}
