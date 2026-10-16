// How the composer's suggestions and no-permission message lay out under
// side safe-area insets.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

const _padding = EdgeInsets.only(left: 47, right: 84, bottom: 34);

void main() {
  testWidgets('StreamMessageComposer runs command suggestions under the side insets', (tester) async {
    await _pumpComposer(tester, channel: _channelWithCommands());
    await tester.enterText(find.byType(EditableText), '/');
    await tester.pumpAndSettle();

    final suggestions = tester.getRect(find.byType(Card));
    expect(suggestions.left, 0);
    expect(suggestions.right, moreOrLessEquals(_screenWidth(tester)));
  });

  testWidgets('StreamMessageComposer keeps command suggestions clear of the side insets', (tester) async {
    await _pumpComposer(tester, channel: _channelWithCommands());
    await tester.enterText(find.byType(EditableText), '/');
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(StreamMessageComposer));
    final header = tester.getRect(find.text(context.translations.instantCommandsLabel));
    expect(header.left, greaterThanOrEqualTo(_padding.left));
    expect(header.right, lessThanOrEqualTo(_screenWidth(tester) - _padding.right));
  });

  testWidgets('StreamMessageComposer runs custom trigger suggestions under the side insets', (tester) async {
    const suggestionsKey = Key('custom-suggestions');
    final trigger = StreamAutocompleteTrigger(
      trigger: '#',
      optionsViewBuilder: (_, _, _) => const SizedBox(key: suggestionsKey, width: double.infinity, height: 48),
    );

    await _pumpComposer(tester, channel: MockChannel(), customAutocompleteTriggers: [trigger]);
    await tester.enterText(find.byType(EditableText), '#');
    await tester.pumpAndSettle();

    final suggestions = tester.getRect(find.byKey(suggestionsKey));
    expect(suggestions.left, 0);
    expect(suggestions.right, moreOrLessEquals(_screenWidth(tester)));
  });

  testWidgets('StreamMessageComposer keeps the no-permission message clear of the insets', (tester) async {
    await _pumpComposer(tester, channel: MockChannel(ownCapabilities: const []));

    final context = tester.element(find.byType(StreamMessageComposer));
    final message = tester.getRect(find.text(context.translations.sendMessagePermissionError));
    final screenHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(message.left, greaterThanOrEqualTo(_padding.left));
    expect(message.right, lessThanOrEqualTo(_screenWidth(tester) - _padding.right));
    expect(message.bottom, lessThanOrEqualTo(screenHeight - _padding.bottom));
  });
}

// A channel whose config offers a single command.
MockChannel _channelWithCommands() {
  final channel = MockChannel();
  when(() => channel.config).thenReturn(
    ChannelConfig(
      commands: [Command(name: 'giphy', description: 'Post a random gif', args: '[text]')],
    ),
  );
  return channel;
}

double _screenWidth(WidgetTester tester) => tester.view.physicalSize.width / tester.view.devicePixelRatio;

// Pumps a [StreamMessageComposer] for [channel] at the bottom of a screen with
// [_padding] as its safe-area insets.
Future<void> _pumpComposer(
  WidgetTester tester, {
  required MockChannel channel,
  List<StreamAutocompleteTrigger> customAutocompleteTriggers = const [],
}) async {
  final originalRecordPlatform = RecordPlatform.instance;
  RecordPlatform.instance = FakeRecordPlatform();
  addTearDown(() => RecordPlatform.instance = originalRecordPlatform);

  final client = MockClient();
  final clientState = MockClientState();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channel.lastMessageAt).thenReturn(null);
  when(() => channel.extraData).thenReturn({'name': 'test'});
  when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': 'test'}));
  when(() => channelState.members).thenReturn([]);
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.messages).thenReturn([]);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.draft).thenReturn(null);

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(padding: _padding),
          child: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: StreamMessageComposer(customAutocompleteTriggers: customAutocompleteTriggers),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
