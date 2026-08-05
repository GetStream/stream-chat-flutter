import 'package:flutter_test/flutter_test.dart';

import '../mock_server/data_types.dart';
import '../pages/channel_list_page.dart';
import '../pages/message_list_page.dart';
import '../support/predefined_users.dart';
import '../support/widget_test_extensions.dart';

class UserRobot {
  UserRobot(this.tester);

  final WidgetTester tester;

  Future<UserRobot> login([
    UserCredentials user = PredefinedUsers.currentUser,
  ]) async {
    await tester.scrollToText(user.name);
    await tester.tapText(user.name);
    return this;
  }

  /// Waits for the channel list to render its rows.
  Future<UserRobot> waitForChannelListToLoad() async {
    await tester.waitUntilVisible(find.byType(ChannelListPage.channelTile));
    return this;
  }

  Future<UserRobot> openChannel({int index = 0}) async {
    final tile = find.byType(ChannelListPage.channelTile).at(index);
    await tester.waitUntilVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();
    return this;
  }

  Future<UserRobot> sendMessage(String text) async {
    await tester.enterTextInField(MessageListPage.composer.inputField, text);
    await tester.tapByKey(MessageListPage.composer.sendButton);
    return this;
  }

  /// Types [text] into the composer without sending it.
  Future<UserRobot> typeText(String text) async {
    await tester.enterTextInField(MessageListPage.composer.inputField, text);
    return this;
  }

  /// Clears whatever is currently in the composer.
  Future<UserRobot> clearComposer() => typeText('');

  Future<UserRobot> editMessage(String newText, {int messageIndex = 0}) async {
    final message = find.byType(MessageListPage.messageItem).at(messageIndex);
    await tester.longPressUntilVisible(message, MessageListPage.actions.edit);
    await tester.tapFinder(MessageListPage.actions.edit);
    await tester.enterTextInField(MessageListPage.composer.inputField, newText);
    await tester.tapByKey(MessageListPage.composer.sendButton);
    return this;
  }

  Future<UserRobot> deleteMessage({int messageIndex = 0, String? text}) async {
    final message = await _resolveMessage(messageIndex: messageIndex, text: text);
    await tester.longPressUntilVisible(message, MessageListPage.actions.delete);
    await tester.tapFinder(MessageListPage.actions.delete);
    await tester.tapFinder(MessageListPage.actions.deleteConfirm);
    return this;
  }

  /// Quotes a message and sends [text] as the reply.
  Future<UserRobot> quoteMessage(
    String text, {
    int messageIndex = 0,
    String? quotedText,
  }) async {
    final message = await _resolveMessage(messageIndex: messageIndex, text: quotedText);
    await tester.longPressUntilVisible(message, MessageListPage.actions.reply);
    await tester.tapFinder(MessageListPage.actions.reply);
    return sendMessage(text);
  }

  /// Swipes a message, which the SDK treats as starting a quoted reply.
  Future<UserRobot> swipeMessage({int messageIndex = 0, String? text}) async {
    await tester.swipeToReply(await _resolveMessage(messageIndex: messageIndex, text: text));
    return this;
  }

  /// Taps a reply's quoted bubble, which jumps the list to the original message.
  Future<UserRobot> tapQuotedMessage() async {
    await tester.tapFinder(MessageListPage.list.quotedMessage);
    return this;
  }

  /// The message row to act on: the one whose text is [text] when given,
  /// otherwise the one at [messageIndex] (0 being the newest).
  ///
  /// Naming a message also scrolls up to it, so an older message that has not
  /// been reached yet can still be acted on.
  Future<Finder> _resolveMessage({required int messageIndex, String? text}) async {
    if (text == null) return find.byType(MessageListPage.messageItem).at(messageIndex);

    final message = MessageListPage.list.messageWithText(text);
    await tester.scrollUpUntil(
      () => message.evaluate().isNotEmpty,
      description: 'the message with text "$text"',
    );
    // A thread renders its root message on top of the paged-in history, so the
    // same text can resolve to more than one row; acting on the first is enough.
    return message.first;
  }

  /// Opens the thread of a message.
  ///
  /// [parentText] must be given whenever the channel already holds thread
  /// replies: the mock server's replies are rendered in the channel list too, so
  /// the newest row is a *reply*, and the SDK offers no 'Thread Reply' action on
  /// one (its `parentId` is set). Naming the parent also handles it being
  /// scrolled out of view, since it is the oldest message.
  Future<UserRobot> openThread({int messageIndex = 0, String? parentText}) async {
    final message = await _resolveMessage(messageIndex: messageIndex, text: parentText);
    await tester.longPressUntilVisible(message, MessageListPage.actions.threadReply);
    await tester.tapFinder(MessageListPage.actions.threadReply);
    await tester.waitUntilVisible(MessageListPage.threadHeader);
    return this;
  }

  /// Opens the thread from a parent message's "N replies" footer, mirroring the
  /// native robot's `threadReplyCountButton` route into a thread.
  ///
  /// [openThread]'s long-press route can't be used when a thread reply was also
  /// sent to the channel: that in-channel copy is the newest message and exposes
  /// no 'Thread Reply' action. The footer renders only on the parent, so it is
  /// unambiguous.
  Future<UserRobot> openThreadFromReplies() async {
    // The footer only renders on the parent, which is the channel's oldest
    // message — and the mock server's replies are rendered in the channel as
    // well, so it can start out scrolled past.
    await tester.scrollUpUntil(
      () => MessageListPage.list.threadReplies.evaluate().isNotEmpty,
      description: 'the thread replies footer',
    );
    await tester.tapFinder(MessageListPage.list.threadReplies);
    await tester.waitUntilVisible(MessageListPage.threadHeader);
    return this;
  }

  /// Sends [text] from inside a thread, optionally ticking the composer's
  /// "also send in channel" checkbox first so the reply is copied into the
  /// channel as well.
  Future<UserRobot> sendMessageInThread(
    String text, {
    bool alsoSendInChannel = false,
  }) async {
    if (alsoSendInChannel) {
      await tester.tapFinder(MessageListPage.composer.alsoSendInChannelCheckbox);
    }
    return sendMessage(text);
  }

  /// Navigates back (out of a thread, or out of the channel).
  Future<UserRobot> tapBackButton() async {
    await tester.tapFinder(MessageListPage.backButton);
    return this;
  }

  /// Leaves the thread and then the channel, landing back on the channel list.
  Future<UserRobot> moveToChannelListFromThread() async {
    await tapBackButton();
    await tester.waitUntilNotVisible(MessageListPage.threadHeader);
    return tapBackButton();
  }

  /// Waits for the message list to be interactive.
  Future<UserRobot> waitForMessageListToLoad() async {
    await tester.waitUntilVisible(find.byType(MessageListPage.composer.inputField));
    return this;
  }

  Future<UserRobot> scrollMessageListUp({int times = 1}) async {
    for (var i = 0; i < times; i++) {
      await tester.scrollMessageList(300);
    }
    return this;
  }

  Future<UserRobot> scrollMessageListDown() async {
    await tester.scrollMessageList(-300);
    return this;
  }

  Future<UserRobot> tapLinkPreview() async {
    await tester.tapFinder(MessageListPage.list.linkPreview);
    return this;
  }

  Future<UserRobot> addReaction(
    ReactionType type, {
    int messageIndex = 0,
  }) async {
    final reaction = MessageListPage.reactions.pickerReaction(type);
    final message = find.byType(MessageListPage.messageItem).at(messageIndex);
    await tester.longPressUntilVisible(message, find.byKey(reaction));
    await tester.tapByKey(reaction);
    return this;
  }

  /// Re-selecting an own reaction in the picker toggles it off, so deleting a
  /// reaction reuses the same flow as adding it.
  Future<UserRobot> deleteReaction(
    ReactionType type, {
    int messageIndex = 0,
  }) {
    return addReaction(type, messageIndex: messageIndex);
  }
}

/// Fluent chaining over async [UserRobot] actions so test steps read like the
/// native robots (`userRobot.login().openChannel()`) instead of a block of
/// sequential `await`s. Each method mirrors the instance method above.
extension UserRobotChain on Future<UserRobot> {
  Future<UserRobot> login([
    UserCredentials user = PredefinedUsers.currentUser,
  ]) => then((it) => it.login(user));

  Future<UserRobot> waitForChannelListToLoad() => then((it) => it.waitForChannelListToLoad());

  Future<UserRobot> openChannel({int index = 0}) => then((it) => it.openChannel(index: index));

  Future<UserRobot> sendMessage(String text) => then((it) => it.sendMessage(text));

  Future<UserRobot> typeText(String text) => then((it) => it.typeText(text));

  Future<UserRobot> clearComposer() => then((it) => it.clearComposer());

  Future<UserRobot> editMessage(String newText, {int messageIndex = 0}) =>
      then((it) => it.editMessage(newText, messageIndex: messageIndex));

  Future<UserRobot> deleteMessage({int messageIndex = 0, String? text}) =>
      then((it) => it.deleteMessage(messageIndex: messageIndex, text: text));

  Future<UserRobot> quoteMessage(String text, {int messageIndex = 0, String? quotedText}) =>
      then((it) => it.quoteMessage(text, messageIndex: messageIndex, quotedText: quotedText));

  Future<UserRobot> swipeMessage({int messageIndex = 0, String? text}) =>
      then((it) => it.swipeMessage(messageIndex: messageIndex, text: text));

  Future<UserRobot> tapQuotedMessage() => then((it) => it.tapQuotedMessage());

  Future<UserRobot> waitForMessageListToLoad() => then((it) => it.waitForMessageListToLoad());

  Future<UserRobot> openThread({int messageIndex = 0, String? parentText}) =>
      then((it) => it.openThread(messageIndex: messageIndex, parentText: parentText));

  Future<UserRobot> openThreadFromReplies() => then((it) => it.openThreadFromReplies());

  Future<UserRobot> sendMessageInThread(String text, {bool alsoSendInChannel = false}) =>
      then((it) => it.sendMessageInThread(text, alsoSendInChannel: alsoSendInChannel));

  Future<UserRobot> tapBackButton() => then((it) => it.tapBackButton());

  Future<UserRobot> moveToChannelListFromThread() => then((it) => it.moveToChannelListFromThread());

  Future<UserRobot> scrollMessageListUp({int times = 1}) => then((it) => it.scrollMessageListUp(times: times));

  Future<UserRobot> scrollMessageListDown() => then((it) => it.scrollMessageListDown());

  Future<UserRobot> tapLinkPreview() => then((it) => it.tapLinkPreview());

  Future<UserRobot> addReaction(ReactionType type, {int messageIndex = 0}) =>
      then((it) => it.addReaction(type, messageIndex: messageIndex));

  Future<UserRobot> deleteReaction(ReactionType type, {int messageIndex = 0}) =>
      then((it) => it.deleteReaction(type, messageIndex: messageIndex));
}
