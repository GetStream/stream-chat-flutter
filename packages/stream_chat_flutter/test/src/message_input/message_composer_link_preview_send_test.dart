import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../fakes.dart';
import '../mocks.dart';

void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  const url = 'https://example.com';

  testWidgets('sends without scraping links once the user dismissed the preview', (tester) async {
    final (:client, :channel) = _channel();
    when(() => client.enrichUrl(any())).thenAnswer((_) async => OGAttachmentResponse()..ogScrapeUrl = url);
    await _pumpComposer(tester, client: client, channel: channel);

    await _typeText(tester, 'look $url');
    tester.widget<core.StreamMessageComposerLinkPreviewAttachment>(_linkPreview).props.onRemovePressed!();
    await tester.pumpAndSettle();
    await _typeText(tester, 'look $url now');
    expect(_linkPreview, findsNothing);
    await _send(tester);

    verify(() => channel.sendMessage(any(), skipEnrichUrl: true)).called(1);
  });

  testWidgets('lets the server scrape links the composer could not preview', (tester) async {
    final (:client, :channel) = _channel();
    when(() => client.enrichUrl(any())).thenAnswer((_) async => throw Exception('no og data'));
    await _pumpComposer(tester, client: client, channel: channel);

    await _typeText(tester, 'look $url');
    expect(_linkPreview, findsNothing);
    await _send(tester);

    verify(() => channel.sendMessage(any(), skipEnrichUrl: false)).called(1);
  });

  testWidgets('previews a new link after the dismissed one is removed', (tester) async {
    final (:client, :channel) = _channel();
    when(() => client.enrichUrl(any())).thenAnswer(
      (invocation) async => OGAttachmentResponse()..ogScrapeUrl = invocation.positionalArguments.first as String,
    );
    await _pumpComposer(tester, client: client, channel: channel);

    await _typeText(tester, 'look $url');
    tester.widget<core.StreamMessageComposerLinkPreviewAttachment>(_linkPreview).props.onRemovePressed!();
    await tester.pumpAndSettle();
    await _typeText(tester, 'look');
    await _typeText(tester, 'look https://other.example.com');

    expect(_linkPreview, findsOneWidget);
  });
}

final _linkPreview = find.byType(core.StreamMessageComposerLinkPreviewAttachment);

Future<void> _typeText(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  // Link previews update behind a 350ms debounce; advance past it.
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

Future<void> _send(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('send_key')));
  await tester.pumpAndSettle();
}

({MockClient client, MockChannel channel}) _channel() {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(
    ownCapabilities: const [ChannelCapability.sendMessage, ChannelCapability.sendLinks],
  );
  final channelState = MockChannelState();

  registerFallbackValue(Message());
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channelState.members).thenReturn([]);
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.messages).thenReturn([]);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.draft).thenReturn(null);
  when(() => channelState.draftStream).thenAnswer((_) => Stream.value(null));
  when(
    () => channel.sendMessage(any(), skipEnrichUrl: any(named: 'skipEnrichUrl')),
  ).thenAnswer((_) async => SendMessageResponse());

  return (client: client, channel: channel);
}

Future<void> _pumpComposer(
  WidgetTester tester, {
  required MockClient client,
  required MockChannel channel,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          channel: channel,
          child: Scaffold(body: StreamMessageComposer(enableVoiceRecording: false)),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
