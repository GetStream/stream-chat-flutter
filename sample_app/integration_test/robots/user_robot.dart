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

  Future<UserRobot> openChannel({int index = 0}) => then((it) => it.openChannel(index: index));

  Future<UserRobot> sendMessage(String text) => then((it) => it.sendMessage(text));

  Future<UserRobot> addReaction(ReactionType type, {int messageIndex = 0}) =>
      then((it) => it.addReaction(type, messageIndex: messageIndex));

  Future<UserRobot> deleteReaction(ReactionType type, {int messageIndex = 0}) =>
      then((it) => it.deleteReaction(type, messageIndex: messageIndex));
}
