import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mock_server/data_types.dart';
import '../pages/message_list_page.dart';
import '../support/widget_test_extensions.dart';
import 'backend_robot.dart';
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

  /// Asserts a quoted reply is (or is not) on screen, and — when [quote] is
  /// given — that its quoted bubble previews [quote].
  ///
  /// [text] identifies the reply by its own text. Leave it null for a reply that
  /// has none (an attachment-only quote, which the mock server sends with no
  /// body): the assertion then applies to whichever quoted bubble is on screen.
  ///
  /// [isDisplayed] `false` is how the native suites check that tapping a quote
  /// jumped the list away from the reply.
  Future<UserRobot> assertQuotedMessage({
    String? text,
    String? quote,
    bool isDisplayed = true,
  }) async {
    final reply = switch (text) {
      final text? => MessageListPage.list.messageWithText(text),
      _ => MessageListPage.list.quotedMessage.first,
    };

    if (!isDisplayed) {
      await tester.waitUntilNotVisible(reply);
      return this;
    }

    await tester.waitUntilVisible(reply);
    if (quote == null) return this;

    // Scoping to the reply only makes sense when it was located by its own text;
    // otherwise `reply` already *is* the bubble.
    final bubbleText = switch (text) {
      != null => find.descendant(of: reply, matching: MessageListPage.list.quotedMessageText),
      _ => MessageListPage.list.quotedMessageText.first,
    };
    await tester.expectRenderedText(bubbleText, quote);
    return this;
  }

  /// Asserts the message [text] is actually on screen.
  ///
  /// `hitTestable()` is what makes this a *visibility* check: a plain finder
  /// matches a row that is merely built, so it can report a row the list has
  /// already scrolled past — which makes "the row is gone" a poor stand-in for
  /// "the list scrolled away from it".
  Future<UserRobot> assertMessageOnScreen(String text, {bool isDisplayed = true}) async {
    final message = MessageListPage.list.messageWithText(text).hitTestable();
    if (isDisplayed) {
      await tester.waitUntilVisible(message);
    } else {
      await tester.waitUntilNotVisible(message);
    }
    return this;
  }

  /// Asserts the backend's "unknown command" error message is shown.
  Future<UserRobot> assertInvalidCommandMessage(String command) async {
    await tester.waitUntilVisible(MessageListPage.list.moderatedMessage);
    await tester.waitUntilVisible(find.textContaining("command $command doesn't exist"));
    return this;
  }

  Future<UserRobot> assertGiphy({required bool isDisplayed}) async {
    final giphy = MessageListPage.list.giphy;
    if (isDisplayed) {
      await tester.waitUntilVisible(giphy);
    } else {
      await tester.waitUntilNotVisible(giphy);
    }
    return this;
  }

  /// Asserts the thread-reply count, either on the parent's footer in the
  /// channel or on the separator inside the thread.
  ///
  /// The two are worded differently by the SDK: the in-thread separator uses
  /// `threadSeparatorText` (so one reply reads "1 reply"), while the channel
  /// footer hardcodes `'$replyCount replies'` — which makes a single reply read
  /// "1 replies". Asserted as rendered, so the channel branch below encodes a
  /// bug on purpose: fixing FLU-669 makes "1 replies" become "1 reply", and this
  /// assert has to change with it.
  Future<UserRobot> assertThreadReplyLabel({
    required int replies,
    bool inThread = false,
  }) async {
    final label = switch (inThread) {
      true => replies == 1 ? '1 reply' : '$replies replies',
      false => '$replies replies',
    };

    final scope = switch (inThread) {
      true => find.text(label),
      false => find.descendant(of: MessageListPage.list.threadReplies, matching: find.text(label)),
    };
    await tester.waitUntilVisible(scope);
    return this;
  }

  Future<UserRobot> assertThreadReplyLabelAvatars({required int count}) async {
    await tester.waitUntilVisible(MessageListPage.list.threadReplies);
    expect(MessageListPage.list.threadRepliesAvatars, findsNWidgets(count));
    return this;
  }

  /// Asserts how many rows currently render the message [text].
  Future<UserRobot> assertMessages({required String text, required int count}) async {
    final messages = MessageListPage.list.messageWithText(text);

    final end = DateTime.now().add(const Duration(seconds: 30));
    while (messages.evaluate().length != count && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(messages, findsNWidgets(count));
    return this;
  }

  /// Asserts the message list holds exactly [count] rows.
  ///
  /// A system message occupies a row of its own ([StreamSystemMessage]) rather
  /// than a [MessageListPage.messageItem], so both are counted — mirroring the
  /// native cell count. The list is lazy, so this is only meaningful for counts
  /// small enough to fit on screen.
  Future<UserRobot> assertMessageCount(int count) async {
    int rowCount() =>
        find.byType(MessageListPage.messageItem).evaluate().length +
        MessageListPage.list.systemMessage.evaluate().length;

    final end = DateTime.now().add(const Duration(seconds: 30));
    while (rowCount() != count && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(rowCount(), count);
    return this;
  }

  /// Asserts whether the floating scroll-to-bottom button is shown.
  ///
  /// When it is not, its unread-count badge cannot be either — the SDK only
  /// wraps the button once the count is above zero — which is what the native
  /// `assertScrollToBottomButtonUnreadCount(0)` checks.
  Future<UserRobot> assertScrollToBottomButton({
    required bool isDisplayed,
    int? unreadCount,
  }) async {
    final button = MessageListPage.list.scrollToBottomButton;
    final badge = MessageListPage.list.scrollToBottomUnreadBadge;

    if (isDisplayed) {
      await tester.waitUntilVisible(button);
    } else {
      await tester.waitUntilNotVisible(button);
      await tester.waitUntilNotVisible(badge);
    }

    // The SDK only wraps the button in a badge once the count is above zero, so
    // an expected count of 0 is asserted as the badge being absent.
    switch (unreadCount) {
      case null:
        break;
      case 0:
        await tester.waitUntilNotVisible(badge);
      case final count:
        await tester.expectRenderedText(find.descendant(of: badge, matching: find.byType(Text)), '$count');
    }
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

  /// Asserts the message at [messageIndex] is marked as failed to be sent.
  /// Mirrors the native `assertMessageFailedToBeSent`.
  Future<UserRobot> assertMessageFailedToBeSent({int messageIndex = 0}) async {
    await _waitOnMessage(MessageListPage.list.errorBadge, messageIndex: messageIndex);
    return this;
  }

  /// Asserts the delivery status shown on the message at [messageIndex].
  Future<UserRobot> assertMessageDeliveryStatus(
    MessageDeliveryStatus status, {
    int messageIndex = 0,
  }) async {
    await _waitOnMessage(MessageListPage.list.sendingStatus(status), messageIndex: messageIndex);
    return this;
  }

  /// Waits for [finder] to appear inside the message at [messageIndex] (index 0
  /// being the newest message), so a status on an older message can't satisfy
  /// the assertion.
  Future<void> _waitOnMessage(Finder finder, {required int messageIndex}) {
    final message = find.byType(MessageListPage.messageItem).at(messageIndex);
    return tester.waitUntilVisible(find.descendant(of: message, matching: finder));
  }

  /// Scrolls up through the history until all [messagesCount] messages are
  /// loaded and the oldest one is on screen.
  ///
  /// Both ends come from the channel's own state instead of the message text:
  /// what the mock server seeds as text depends on how the channel was generated
  /// (see `messagesText` on [BackendRobot.generateChannels]), message identity
  /// does not.
  Future<UserRobot> assertMessageListPagination({required int messagesCount}) async {
    await tester.waitUntilVisible(find.byType(MessageListPage.list.view));

    // Pages in whatever the channel query didn't return. The mock server hands
    // over the whole history up front, so today this holds without scrolling.
    await tester.scrollUpUntil(
      () => _loadedMessages.length >= messagesCount,
      description: 'all $messagesCount messages to load',
    );
    expect(_loadedMessages, hasLength(messagesCount));

    final oldest = MessageListPage.list.message(_loadedMessages.first.id);
    // Guards against a vacuous pass: the oldest message has to be out of view
    // (i.e. actually reached by scrolling), and it would be on screen already if
    // the loaded history were ordered newest-first.
    expect(oldest, findsNothing);
    await tester.scrollUpUntil(
      () => oldest.evaluate().isNotEmpty,
      description: 'the oldest message to be reached',
    );
    return this;
  }

  /// The slice of the channel's history the message list has loaded so far,
  /// oldest first.
  List<Message> get _loadedMessages {
    final context = tester.element(find.byType(MessageListPage.list.view));
    return StreamChannel.of(context).channel.state?.messages ?? const [];
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

  Future<UserRobot> assertQuotedMessage({String? text, String? quote, bool isDisplayed = true}) =>
      then((it) => it.assertQuotedMessage(text: text, quote: quote, isDisplayed: isDisplayed));

  Future<UserRobot> assertInvalidCommandMessage(String command) =>
      then((it) => it.assertInvalidCommandMessage(command));

  Future<UserRobot> assertGiphy({required bool isDisplayed}) => then((it) => it.assertGiphy(isDisplayed: isDisplayed));

  Future<UserRobot> assertThreadReplyLabel({required int replies, bool inThread = false}) =>
      then((it) => it.assertThreadReplyLabel(replies: replies, inThread: inThread));

  Future<UserRobot> assertThreadReplyLabelAvatars({required int count}) =>
      then((it) => it.assertThreadReplyLabelAvatars(count: count));

  Future<UserRobot> assertMessages({required String text, required int count}) =>
      then((it) => it.assertMessages(text: text, count: count));

  Future<UserRobot> assertMessageCount(int count) => then((it) => it.assertMessageCount(count));

  Future<UserRobot> assertScrollToBottomButton({required bool isDisplayed, int? unreadCount}) =>
      then((it) => it.assertScrollToBottomButton(isDisplayed: isDisplayed, unreadCount: unreadCount));

  Future<UserRobot> assertTypingIndicator({required bool isDisplayed}) =>
      then((it) => it.assertTypingIndicator(isDisplayed: isDisplayed));

  Future<UserRobot> assertMentionsOverlay({required bool isDisplayed}) =>
      then((it) => it.assertMentionsOverlay(isDisplayed: isDisplayed));

  Future<UserRobot> assertLinkPreview() => then((it) => it.assertLinkPreview());

  Future<UserRobot> assertMessageFailedToBeSent({int messageIndex = 0}) =>
      then((it) => it.assertMessageFailedToBeSent(messageIndex: messageIndex));

  Future<UserRobot> assertMessageDeliveryStatus(
    MessageDeliveryStatus status, {
    int messageIndex = 0,
  }) => then((it) => it.assertMessageDeliveryStatus(status, messageIndex: messageIndex));

  Future<UserRobot> assertReaction({
    required ReactionType type,
    required bool isDisplayed,
  }) => then((it) => it.assertReaction(type: type, isDisplayed: isDisplayed));
}
