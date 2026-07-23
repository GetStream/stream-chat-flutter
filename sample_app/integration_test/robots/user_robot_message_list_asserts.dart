import 'package:flutter_test/flutter_test.dart';

import '../mock_server/data_types.dart';
import '../pages/message_list_page.dart';
import '../support/widget_test_extensions.dart';
import 'user_robot.dart';

extension UserRobotMessageListAsserts on UserRobot {
  Future<UserRobot> assertMessage(String text, {bool isDisplayed = true}) async {
    final message = find.text(text);
    if (isDisplayed) {
      await tester.waitUntilVisible(message);
    } else {
      await tester.waitUntilNotVisible(message);
    }
    return this;
  }

  /// Asserts a message whose rendered text merely *contains* [text]. Useful for
  /// multi-line messages: the markdown renderer collapses single newlines, so
  /// the literal `'a\nb'` never matches — but each token still appears.
  Future<UserRobot> assertMessageContains(String text) async {
    await tester.waitUntilVisible(find.textContaining(text));
    return this;
  }

  /// A thread reply is rendered as a regular message inside the thread view.
  Future<UserRobot> assertThreadReply(String text) => assertMessage(text);

  Future<UserRobot> assertEditedMessage(String text) async {
    await assertMessage(text);
    await tester.waitUntilVisible(MessageListPage.list.editedLabel);
    return this;
  }

  Future<UserRobot> assertDeletedMessage({bool isDisplayed = true}) async {
    final deleted = MessageListPage.list.deletedMessage;
    if (isDisplayed) {
      await tester.waitUntilVisible(deleted);
    } else {
      await tester.waitUntilNotVisible(deleted);
    }
    return this;
  }

  /// A hard-deleted message vanishes entirely: neither its text nor the
  /// soft-delete placeholder remains.
  Future<UserRobot> assertHardDeletedMessage(String text) async {
    await assertMessage(text, isDisplayed: false);
    await assertDeletedMessage(isDisplayed: false);
    return this;
  }

  Future<UserRobot> assertTypingIndicator({required bool isDisplayed}) async {
    final indicator = MessageListPage.list.typingIndicator;
    if (isDisplayed) {
      await tester.waitUntilVisible(indicator);
    } else {
      await tester.waitUntilNotVisible(indicator);
    }
    return this;
  }

  Future<UserRobot> assertMentionsOverlay({required bool isDisplayed}) async {
    final overlay = MessageListPage.composer.mentionsOverlay;
    if (isDisplayed) {
      await tester.waitUntilVisible(overlay);
    } else {
      await tester.waitUntilNotVisible(overlay);
    }
    return this;
  }

  Future<UserRobot> assertLinkPreview() async {
    await tester.waitUntilVisible(MessageListPage.list.linkPreview);
    return this;
  }

  /// Scrolls up through the paged history until the oldest message loads. The
  /// mock server seeds message text as the 1-based index, so the oldest message
  /// is `'1'` (the newest is `'$messagesCount'`).
  Future<UserRobot> assertMessageListPagination({required int messagesCount}) async {
    await tester.waitUntilVisible(find.text('$messagesCount'));
    await tester.scrollUpUntilVisible(find.text('1'));
    return this;
  }

  /// Edits the first message to [newText] and asserts its cell grew (or shrank)
  /// accordingly.
  Future<UserRobot> assertMessageSizeChangesAfterEditing(
    String newText, {
    required bool increased,
  }) async {
    final message = find.byType(MessageListPage.messageItem);
    final before = tester.getSize(message.first).height;

    await editMessage(newText);
    await assertMessage(newText);

    final after = tester.getSize(message.first).height;
    if (increased) {
      expect(after, greaterThan(before));
    } else {
      expect(after, lessThan(before));
    }
    return this;
  }

  /// Asserts the composer grows with multi-line input but stops growing once it
  /// reaches its height cap.
  Future<UserRobot> assertComposerGrowsWithinLimit() async {
    final field = find.byType(MessageListPage.composer.inputField);

    final emptyHeight = tester.getSize(field).height;
    await typeText('1\n2\n3');
    expect(tester.getSize(field).height, greaterThan(emptyHeight));

    await typeText('1\n2\n3\n4\n5\n6\n7\n8\n9\n10');
    final cappedHeight = tester.getSize(field).height;
    await typeText('1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12');
    expect(tester.getSize(field).height, cappedHeight);

    await clearComposer();
    return this;
  }

  Future<UserRobot> assertReaction({
    required ReactionType type,
    required bool isDisplayed,
  }) async {
    // Reaction display chips carry no keys, so they're located by emoji glyph.
    final reaction = find.text(type.emoji);
    if (isDisplayed) {
      await tester.waitUntilVisible(reaction);
    } else {
      await tester.waitUntilNotVisible(reaction);
    }
    return this;
  }
}

/// Chainable counterparts to [UserRobotMessageListAsserts], so an assertion can
/// follow a fluent action chain (`userRobot.addReaction(x).assertReaction(...)`).
extension UserRobotMessageListAssertsChain on Future<UserRobot> {
  Future<UserRobot> assertMessage(String text, {bool isDisplayed = true}) =>
      then((it) => it.assertMessage(text, isDisplayed: isDisplayed));

  Future<UserRobot> assertMessageContains(String text) => then((it) => it.assertMessageContains(text));

  Future<UserRobot> assertThreadReply(String text) => then((it) => it.assertThreadReply(text));

  Future<UserRobot> assertEditedMessage(String text) => then((it) => it.assertEditedMessage(text));

  Future<UserRobot> assertDeletedMessage({bool isDisplayed = true}) =>
      then((it) => it.assertDeletedMessage(isDisplayed: isDisplayed));

  Future<UserRobot> assertHardDeletedMessage(String text) => then((it) => it.assertHardDeletedMessage(text));

  Future<UserRobot> assertTypingIndicator({required bool isDisplayed}) =>
      then((it) => it.assertTypingIndicator(isDisplayed: isDisplayed));

  Future<UserRobot> assertMentionsOverlay({required bool isDisplayed}) =>
      then((it) => it.assertMentionsOverlay(isDisplayed: isDisplayed));

  Future<UserRobot> assertLinkPreview() => then((it) => it.assertLinkPreview());

  Future<UserRobot> assertReaction({
    required ReactionType type,
    required bool isDisplayed,
  }) => then((it) => it.assertReaction(type: type, isDisplayed: isDisplayed));
}
