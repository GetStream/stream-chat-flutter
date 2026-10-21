import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  testWidgets('StreamMessageComposer reports a failed typing indicator through onError', (tester) async {
    const error = StreamClientException(message: 'boom');
    final client = MockClient();
    final clientState = MockClientState();
    final channel = MockChannel(
      ownCapabilities: const [ChannelCapability.sendMessage, ChannelCapability.typingEvents],
    );
    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
    final channelState = MockChannelState();
    when(() => channel.state).thenReturn(channelState);
    when(() => channel.client).thenReturn(client);
    when(channel.getRemainingCooldown).thenReturn(0);
    when(() => channel.keyStroke(any())).thenAnswer((_) async => const Result.failure(error));

    final errors = <Object>[];
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: StreamMessageComposer(onError: (error, _) => errors.add(error)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Hello');
    // Typing is reported behind a 350ms throttle; advance past it.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(errors, [error]);
  });
}
