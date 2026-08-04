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

  Future<UserRobot> deleteMessage({int messageIndex = 0}) async {
    final message = find.byType(MessageListPage.messageItem).at(messageIndex);
    await tester.longPressUntilVisible(message, MessageListPage.actions.delete);
    await tester.tapFinder(MessageListPage.actions.delete);
    await tester.tapFinder(MessageListPage.actions.deleteConfirm);
    return this;
  }

  Future<UserRobot> openThread({int messageIndex = 0}) async {
    final message = find.byType(MessageListPage.messageItem).at(messageIndex);
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

  Future<UserRobot> scrollMessageListUp() async {
    await tester.scrollMessageList(300);
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

  Future<UserRobot> deleteMessage({int messageIndex = 0}) => then((it) => it.deleteMessage(messageIndex: messageIndex));

  Future<UserRobot> openThread({int messageIndex = 0}) => then((it) => it.openThread(messageIndex: messageIndex));

  Future<UserRobot> openThreadFromReplies() => then((it) => it.openThreadFromReplies());

  Future<UserRobot> sendMessageInThread(String text, {bool alsoSendInChannel = false}) =>
      then((it) => it.sendMessageInThread(text, alsoSendInChannel: alsoSendInChannel));

  Future<UserRobot> tapBackButton() => then((it) => it.tapBackButton());

  Future<UserRobot> moveToChannelListFromThread() => then((it) => it.moveToChannelListFromThread());

  Future<UserRobot> scrollMessageListUp() => then((it) => it.scrollMessageListUp());

  Future<UserRobot> scrollMessageListDown() => then((it) => it.scrollMessageListDown());

  Future<UserRobot> tapLinkPreview() => then((it) => it.tapLinkPreview());

  Future<UserRobot> addReaction(ReactionType type, {int messageIndex = 0}) =>
      then((it) => it.addReaction(type, messageIndex: messageIndex));

  Future<UserRobot> deleteReaction(ReactionType type, {int messageIndex = 0}) =>
      then((it) => it.deleteReaction(type, messageIndex: messageIndex));
}
