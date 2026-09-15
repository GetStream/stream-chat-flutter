import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

/// Returns sentinels that no hardcoded English label could produce, so the
/// assertions prove the row label was composed through
/// `translations.accessibility` rather than matching an inlined string.
class FakeAccessibilityTranslations extends DefaultAccessibilityTranslations {
  const FakeAccessibilityTranslations();

  @override
  String outgoingMessageLabel({required String body}) => 'OUT:$body';

  @override
  String incomingMessageLabel({required String senderName, required String body}) => 'IN:$senderName:$body';

  @override
  String outgoingDeletedMessageLabel({required String body}) => 'OUT-DEL:$body';

  @override
  String incomingDeletedMessageLabel({required String senderName, required String body}) => 'IN-DEL:$senderName:$body';

  @override
  String formatRecentDateTime(DateTime date) => 'AT-TIME';
}

/// Localizations resolving the labels under test to [FakeAccessibilityTranslations].
class FakeLocalizations implements StreamChatLocalizations {
  @override
  AccessibilityTranslations get accessibility => const FakeAccessibilityTranslations();

  @override
  String threadReplyCountText(int count) => count == 1 ? 'singular:$count' : 'plural:$count';

  // Strings the row composes verbatim; only the labels under test are faked.
  @override
  String get messageDeletedLabel => DefaultTranslations.instance.messageDeletedLabel;

  @override
  String get editedMessageLabel => 'EDITED';

  @override
  String photosAttachmentCountText(int count) => DefaultTranslations.instance.photosAttachmentCountText(count);

  @override
  String attachmentsUploadProgressText({required int completed, required int total}) => 'UP:$completed/$total';

  // Anything else throws instead of resolving to null, so an unstubbed lookup
  // fails the test loudly rather than rendering an empty label.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Loads [FakeLocalizations] for every locale.
class FakeLocalizationsDelegate extends LocalizationsDelegate<StreamChatLocalizations> {
  const FakeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<StreamChatLocalizations> load(Locale locale) async => FakeLocalizations();

  @override
  bool shouldReload(FakeLocalizationsDelegate old) => false;
}

/// A deterministic attachment renderer, so an attachment-only message lays out
/// without loading assets. Renders no semantics of its own, keeping the
/// assertions about the row label unambiguous.
class FixedSizeAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  const FixedSizeAttachmentBuilder();

  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) {
    return attachments.isNotEmpty;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    return const SizedBox(width: 200, height: 50);
  }
}

/// The signed-in reader.
///
/// A language is what makes a translated message resolve to the reader's own
/// language, in the bubble and in the announcement alike.
final currentUser = OwnUser(id: 'current-user', name: 'Luke Skywalker', language: 'en');

/// Somebody else in the channel, the author of an incoming message.
final otherUser = User(id: 'other-user', name: 'Han Solo');

/// Renders [message] as a single [StreamMessageItem] inside a mocked channel.
Widget buildMessageScene(
  Message message, {
  String? semanticsLabel,
  bool excludeFromSemantics = false,
  StreamChatConfigurationData? configData,
  OwnUser? reader,
  bool signedIn = true,
  StreamMessageAlignment alignment = StreamMessageAlignment.start,
  StreamMessageStackPosition stackPosition = StreamMessageStackPosition.single,
  // Set to true to render a channel that has not been watched yet, whose
  // read state is therefore unavailable.
  bool unwatchedChannel = false,
  // Set to false to resolve the shipped English strings instead of the
  // sentinels, pinning what a user actually hears.
  bool fakeTranslations = true,
  // When given, the row is rebuilt from this listenable rather than from
  // [message], leaving the widgets above it untouched — which is what a live
  // channel does to a row on a read receipt or a new message.
  ValueListenable<Message>? rebuildFrom,
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  final effectiveReader = switch (signedIn) {
    true => reader ?? currentUser,
    false => null,
  };
  when(() => clientState.currentUser).thenReturn(effectiveReader);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(effectiveReader));
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(unwatchedChannel ? null : channelState);
  when(() => channelState.readStream).thenAnswer((_) => Stream.value(const []));

  return MaterialApp(
    localizationsDelegates: switch (fakeTranslations) {
      true => const [FakeLocalizationsDelegate()],
      false => const <LocalizationsDelegate<Object>>[],
    },
    home: StreamChat(
      client: client,
      configData: configData,
      connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
      child: StreamChannel(
        channel: channel,
        showLoading: false,
        child: Scaffold(
          body: StreamMessageLayout(
            data: StreamMessageLayoutData(alignment: alignment, stackPosition: stackPosition),
            child: switch (rebuildFrom) {
              null => _messageItem(message, semanticsLabel, excludeFromSemantics),
              final listenable => ValueListenableBuilder(
                valueListenable: listenable,
                builder: (_, rebuilt, __) => _messageItem(rebuilt, semanticsLabel, excludeFromSemantics),
              ),
            },
          ),
        ),
      ),
    ),
  );
}

Widget _messageItem(Message message, String? semanticsLabel, bool excludeFromSemantics) {
  return StreamMessageItem(
    message: message,
    semanticsLabel: semanticsLabel,
    excludeFromSemantics: excludeFromSemantics,
    attachmentBuilders: const [FixedSizeAttachmentBuilder()],
  );
}

/// A message authored by [user], defaulting to an incoming text message.
Message testMessage({
  User? user,
  String? text = 'Are we still meeting tomorrow',
  int replyCount = 0,
  List<Attachment> attachments = const [],
  List<User> mentionedUsers = const [],
  MessageState state = MessageState.sent,
  DateTime? messageTextUpdatedAt,
  String type = MessageType.regular,
}) {
  return Message(
    id: 'test-message',
    type: type,
    text: text,
    createdAt: DateTime(2026, 8, 26, 15),
    user: user ?? otherUser,
    state: state,
    replyCount: replyCount,
    attachments: attachments,
    mentionedUsers: mentionedUsers,
    messageTextUpdatedAt: messageTextUpdatedAt,
  );
}

/// What a screen reader walking the row would read out, in order.
List<String> labelsOf(WidgetTester tester) {
  return tester.semantics.simulatedAccessibilityTraversal().map((it) => it.label).toList();
}
