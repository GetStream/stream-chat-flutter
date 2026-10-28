import 'package:e2e_app/pages/reminders_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide AttachmentType;

import '../mock_server/data_types.dart';
import '../pages/channel_list_page.dart';
import '../pages/message_list_page.dart';
import '../support/widget_test_extensions.dart';
import 'backend_robot.dart';
import 'participant_robot.dart';
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

  /// Asserts [count] attachments of [type] are staged in the composer.
  Future<UserRobot> assertAttachmentsInComposer(AttachmentType type, {int count = 1}) async {
    final staged = MessageListPage.composer.stagedAttachments(type.attachment);
    await tester.waitUntilVisible(staged);
    expect(staged, findsNWidgets(count));
    return this;
  }

  /// Asserts the newest media message shows [count] images: one renders as a
  /// single image, several as a gallery grid of that many tiles.
  Future<UserRobot> assertImage({required bool isDisplayed, int count = 1}) async {
    final images = count == 1
        ? MessageListPage.list.image
        : find.descendant(of: MessageListPage.list.gallery, matching: find.byType(StreamMessageAttachment));
    if (!isDisplayed) return _assertVisibility(images, isDisplayed: false);

    await tester.waitUntilVisible(images);
    expect(images, findsNWidgets(count));
    return this;
  }

  Future<UserRobot> assertVideo({required bool isDisplayed}) =>
      _assertVisibility(MessageListPage.list.video, isDisplayed: isDisplayed);

  Future<UserRobot> assertFile({required bool isDisplayed, int count = 1}) async {
    final files = MessageListPage.list.file;
    if (!isDisplayed) return _assertVisibility(files, isDisplayed: false);

    await tester.waitUntilVisible(files);
    expect(files, findsNWidgets(count));
    return this;
  }

  /// Asserts the full-screen gallery shows image [position] of [total].
  Future<UserRobot> assertGalleryPosition(int position, {required int total}) async {
    await tester.waitUntilVisible(
      find.descendant(of: MessageListPage.list.mediaGalleryPreview, matching: find.text('$position of $total')),
    );
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

  /// Asserts whether the Send / Shuffle / Cancel buttons of an ephemeral Giphy
  /// preview are shown.
  Future<UserRobot> assertGiphyButtons({required bool areDisplayed}) async {
    for (final label in const ['Send', 'Shuffle', 'Cancel']) {
      await _assertVisibility(MessageListPage.list.giphyButton(label), isDisplayed: areDisplayed);
    }
    return this;
  }

  /// Asserts the "only visible to you" note an ephemeral message carries.
  Future<UserRobot> assertOnlyVisibleToYou() async {
    await tester.waitUntilVisible(
      find.descendant(of: MessageListPage.list.ephemeralMessage, matching: find.textContaining('Only visible to you')),
    );
    return this;
  }

  /// Asserts the ephemeral message shows no delivery status.
  Future<UserRobot> assertEphemeralMessageDeliveryStatusHidden() async {
    final ephemeral = MessageListPage.list.ephemeralMessage;
    await tester.waitUntilVisible(ephemeral);
    // The row may build an indicator; what matters is that it shows no status.
    for (final status in MessageDeliveryStatus.values.where((it) => it != MessageDeliveryStatus.nil)) {
      expect(find.descendant(of: ephemeral, matching: MessageListPage.list.sendingStatus(status)), findsNothing);
    }
    return this;
  }

  Future<UserRobot> assertMessagePinnedLabel({String pinnedBy = 'You', bool isDisplayed = true}) =>
      _assertVisibility(MessageListPage.list.pinnedLabel(pinnedBy: pinnedBy), isDisplayed: isDisplayed);

  Future<UserRobot> assertPinnedMessagesScreen() async {
    await tester.waitUntilVisible(ChannelInfoPage.pinnedMessagesTitle);
    return this;
  }

  Future<UserRobot> assertMessageInPinnedMessages(String text) async {
    await tester.waitUntilVisible(
      find.descendant(of: ChannelInfoPage.pinnedMessages, matching: find.textContaining(text)),
    );
    return this;
  }

  Future<UserRobot> assertPinnedMessagesAreEmpty() async {
    await tester.waitUntilVisible(ChannelInfoPage.pinnedMessagesEmpty);
    expect(ChannelInfoPage.pinnedMessages, findsNothing);
    return this;
  }

  /// Asserts the slow-mode cooldown is (or is not) running in the composer.
  Future<UserRobot> assertCooldown({required bool isDisplayed}) =>
      _assertVisibility(MessageListPage.composer.slowModePlaceholder, isDisplayed: isDisplayed);

  /// Asserts the composer is locked by slow mode: there is no send button,
  /// only the countdown.
  Future<UserRobot> assertComposerIsDisabledInSlowMode() async {
    await assertCooldown(isDisplayed: true);
    expect(find.byKey(MessageListPage.composer.sendButton), findsNothing);
    return this;
  }

  Future<UserRobot> assertFlagMessageDialog({required bool isDisplayed}) =>
      _assertVisibility(MessageListPage.actions.flagDialog, isDisplayed: isDisplayed);

  /// Asserts the actions of the message [text] offer to unmute its author when
  /// [isAuthorMuted], and to mute them otherwise.
  Future<UserRobot> assertMuteMessageAuthorOption(String text, {required bool isAuthorMuted}) async {
    const actions = MessageListPage.actions;
    final offered = await messageActionsOffered(text, [actions.muteUser, actions.unmuteUser]);
    expect(offered, [!isAuthorMuted, isAuthorMuted], reason: '[Mute User, Unmute User] offered');
    return this;
  }

  Future<UserRobot> assertBlockMessageAuthorOption(String text, {required bool isAuthorBlocked}) async {
    const actions = MessageListPage.actions;
    final offered = await messageActionsOffered(text, [actions.blockUser, actions.unblockUser]);
    expect(offered, [!isAuthorBlocked, isAuthorBlocked], reason: '[Block User, Unblock User] offered');
    return this;
  }

  Future<UserRobot> assertPollMessage(String question) async {
    await tester.waitUntilVisible(find.descendant(of: MessageListPage.list.poll, matching: find.text(question)));
    return this;
  }

  /// Asserts the poll option [text] is shown and, when [isChecked] is given,
  /// whether the user's vote is on it.
  Future<UserRobot> assertPollOption(String text, {bool? isChecked}) async {
    final option = MessageListPage.list.pollOption(text);
    await tester.waitUntilVisible(option);
    if (isChecked == null) return this;

    bool checked() =>
        (tester.widget(find.descendant(of: option, matching: _checkbox).first) as dynamic).props.value == true;
    final end = DateTime.now().add(const Duration(seconds: 10));
    while (checked() != isChecked && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(checked(), isChecked, reason: 'poll option "$text" checked');
    return this;
  }

  static final _checkbox = find.byWidgetPredicate((it) => it.runtimeType.toString() == 'StreamCheckbox');

  Future<UserRobot> assertPollOptionVoteCount(String text, {required int count}) async {
    await tester.waitUntilVisible(
      find.descendant(of: MessageListPage.list.pollOption(text), matching: find.text('$count')),
    );
    return this;
  }

  Future<UserRobot> assertPollResults({required String voterName}) async {
    await tester.waitUntilVisible(find.text(voterName));
    return this;
  }

  /// A closed poll replaces its voting-mode subtitle with "Vote ended".
  Future<UserRobot> assertPollClosed() async {
    await tester.waitUntilVisible(find.descendant(of: MessageListPage.list.poll, matching: find.text('Vote ended')));
    return this;
  }

  Future<UserRobot> assertThreadListIsEmpty() async {
    await tester.waitUntilVisible(find.text('Reply to a message to start a thread'));
    expect(find.byType(StreamThreadListTile), findsNothing);
    return this;
  }

  Future<UserRobot> assertThreadInThreadList(String parentText, {required int replies}) async {
    final tile = find.byType(StreamThreadListTile);
    await tester.waitUntilVisible(find.descendant(of: tile, matching: find.textContaining(parentText)));
    await tester.waitUntilVisible(
      find.descendant(of: tile, matching: find.text(replies == 1 ? '1 reply' : '$replies replies')),
    );
    return this;
  }

  /// Asserts the unread separator is shown, reading [unreadCount] when given.
  Future<UserRobot> assertUnreadSeparator({int? unreadCount, bool isDisplayed = true}) async {
    final separator = MessageListPage.list.unreadSeparator;
    if (!isDisplayed) return _assertVisibility(separator, isDisplayed: false);

    await tester.waitUntilVisible(separator);
    if (unreadCount != null) {
      final label = unreadCount == 1 ? '1 unread message' : '$unreadCount unread messages';
      await tester.waitUntilVisible(find.descendant(of: separator, matching: find.text(label)));
    }
    return this;
  }

  /// Asserts the jump-to-unread pill is shown, reading [unreadCount] when given.
  Future<UserRobot> assertJumpToUnreadButton({int? unreadCount, bool isDisplayed = true}) async {
    final button = MessageListPage.list.jumpToUnreadButton;
    final parts = MessageListPage.list.jumpToUnreadButtonParts;
    if (!isDisplayed) return _assertVisibility(parts, isDisplayed: false);

    await tester.waitUntilVisible(parts);
    if (unreadCount != null) {
      await tester.waitUntilVisible(find.descendant(of: button, matching: find.text('$unreadCount unread')));
    }
    return this;
  }

  Future<UserRobot> assertMessageInSearchResults(String text) async {
    await tester.waitUntilVisible(
      find.descendant(of: ChannelListPage.searchResults, matching: find.textContaining(text)),
    );
    return this;
  }

  Future<UserRobot> assertMessageCopied(String text) async {
    final end = DateTime.now().add(const Duration(seconds: 5));
    String? copied;
    while (DateTime.now().isBefore(end)) {
      copied = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
      if (copied == text) break;
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(copied, text);
    return this;
  }

  /// Asserts the newest message named [text] is attributed to [authorName].
  Future<UserRobot> assertMessageAuthor(String text, {required String authorName}) async {
    final message = MessageListPage.list.messageWithText(text);
    await tester.waitUntilVisible(message);
    expect(tester.widget<StreamMessageItem>(message.first).props.message.user?.name, authorName);
    return this;
  }

  Future<UserRobot> assertRemindersScreen() async {
    await tester.waitUntilVisible(find.byType(RemindersTab));
    return this;
  }

  Future<UserRobot> assertRemindersAreEmpty() async {
    await tester.waitUntilVisible(find.text('No reminders yet'));
    expect(find.byType(MessageReminderListTile), findsNothing);
    return this;
  }

  /// Asserts the reminders screen lists the message [text], saved for later
  /// (no due date) when [savedForLater], or due at a set time otherwise.
  Future<UserRobot> assertReminder(String text, {bool savedForLater = false}) async {
    final tile = find.ancestor(of: find.text(text), matching: find.byType(MessageReminderListTile));
    await tester.waitUntilVisible(tile);
    final status = savedForLater ? find.byType(SavedForLaterIndicator) : find.byType(TimedReminderIndicator);
    await tester.waitUntilVisible(find.descendant(of: tile, matching: status));
    return this;
  }

  /// Asserts a message shows the reminder annotation: "Saved for later" for a
  /// reminder without a due date, "Reminder set" for one with.
  Future<UserRobot> assertMessageReminder({required bool remindAtIsSet}) async {
    await tester.waitUntilVisible(find.text(remindAtIsSet ? 'Reminder set' : 'Saved for later'));
    return this;
  }

  /// Asserts the reaction authors sheet does (or does not) list [name].
  Future<UserRobot> assertReactionAuthor(String name, {bool isDisplayed = true}) => _assertVisibility(
    find.descendant(of: MessageListPage.reactions.authorsSheet, matching: find.text(name)),
    isDisplayed: isDisplayed,
  );

  /// Asserts the authors sheet lists the user's own reaction. The sheet names
  /// every author, the user included, and marks the own row with
  /// `tapToRemoveReactionLabel` — the counterpart of the native "You".
  Future<UserRobot> assertOwnReactionInAuthors() async {
    await tester.waitUntilVisible(
      find.descendant(of: MessageListPage.reactions.authorsSheet, matching: find.text('Tap to remove')),
    );
    return this;
  }

  /// Asserts the thread-reply count, either on the parent's footer in the
  /// channel or on the separator inside the thread.
  ///
  /// The two go through different translations — the footer uses
  /// `threadReplyCountText`, the separator `threadSeparatorText` — but both read
  /// the same in English, so [inThread] only picks which one to look at.
  Future<UserRobot> assertThreadReplyLabel({
    required int replies,
    bool inThread = false,
  }) async {
    final label = replies == 1 ? '1 reply' : '$replies replies';

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
  /// `buildMessage` returns a row of its own — never a [MessageListPage.messageItem] —
  /// for system, ephemeral and error messages, so all four types are counted here,
  /// mirroring the native cell count. The list is lazy, so this is only meaningful
  /// for counts small enough to fit on screen.
  Future<UserRobot> assertMessageCount(int count) async {
    int rowCount() =>
        find.byType(MessageListPage.messageItem).evaluate().length +
        MessageListPage.list.systemMessage.evaluate().length +
        MessageListPage.list.ephemeralMessage.evaluate().length +
        MessageListPage.list.moderatedMessage.evaluate().length;

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

  Future<UserRobot> assertComposerText(String expected) async {
    final end = DateTime.now().add(const Duration(seconds: 10));
    while (composerText != expected && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(composerText, expected);
    return this;
  }

  /// A mention picked from the overlay is completed with a trailing space.
  Future<UserRobot> assertMentionWasApplied() => assertComposerText('@${ParticipantRobot.name} ');

  Future<UserRobot> assertComposerAttachmentsButton({required bool isDisplayed}) =>
      _assertVisibility(MessageListPage.composer.attachmentsButton, isDisplayed: isDisplayed);

  Future<UserRobot> assertComposerCommands({required bool isDisplayed}) =>
      _assertVisibility(MessageListPage.composer.commandsOverlay, isDisplayed: isDisplayed);

  /// Asserts how many message timestamps are rendered, i.e. how many message
  /// groups the visible messages form.
  Future<UserRobot> assertMessageTimestamps(int count) async {
    final timestamps = MessageListPage.list.timestamps;
    final end = DateTime.now().add(const Duration(seconds: 10));
    while (timestamps.evaluate().length != count && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(timestamps, findsNWidgets(count));
    return this;
  }

  /// Asserts the annotation a thread reply sent also to the channel carries,
  /// in the channel or inside the thread.
  Future<UserRobot> assertAlsoInTheChannelLabel({required bool inThread}) async {
    await tester.waitUntilVisible(MessageListPage.list.showInChannelAnnotation(inThread: inThread));
    return this;
  }

  Future<UserRobot> _assertVisibility(Finder finder, {required bool isDisplayed}) async {
    if (isDisplayed) {
      await tester.waitUntilVisible(finder);
    } else {
      await tester.waitUntilNotVisible(finder);
    }
    return this;
  }

  Future<UserRobot> assertLinkPreview() async {
    await tester.waitUntilVisible(MessageListPage.list.linkPreview);
    return this;
  }

  /// Asserts the message list does (or does not) show a link preview card.
  ///
  /// Wait for the message itself first: asserting absence right away passes
  /// before the message even arrives.
  Future<UserRobot> assertLinkPreviewInMessageList({required bool isDisplayed}) =>
      _assertVisibility(MessageListPage.list.linkPreview, isDisplayed: isDisplayed);

  Future<UserRobot> assertLinkPreviewInComposer({required bool isDisplayed}) =>
      _assertVisibility(MessageListPage.composer.linkPreview, isDisplayed: isDisplayed);

  /// Asserts the message [text] is rendered and its link is tappable, i.e. the
  /// markdown renderer turned the URL into a link span.
  Future<UserRobot> assertMessageWithLink(String text, {required String link}) async {
    final message = MessageListPage.list.messageWithText(text);
    await tester.waitUntilVisible(message);
    final linkSpans = find.descendant(
      of: message,
      matching: find.byWidgetPredicate((widget) {
        if (widget is! RichText) return false;
        var found = false;
        widget.text.visitChildren((span) {
          if (span is TextSpan && span.recognizer != null && (span.text?.contains(link) ?? false)) found = true;
          return !found;
        });
        return found;
      }, description: 'tappable link "$link"'),
    );
    await tester.waitUntilVisible(linkSpans);
    return this;
  }

  /// Asserts the message at [messageIndex] is marked as failed to be sent, or
  /// with [isDisplayed] false, that it isn't.
  /// Mirrors the native `assertMessageFailedToBeSent`.
  Future<UserRobot> assertMessageFailedToBeSent({int messageIndex = 0, bool isDisplayed = true}) async {
    if (isDisplayed) {
      await _waitOnMessage(MessageListPage.list.errorBadge, messageIndex: messageIndex);
    } else {
      final message = find.byType(MessageListPage.messageItem).at(messageIndex);
      await tester.waitUntilNotVisible(find.descendant(of: message, matching: MessageListPage.list.errorBadge));
    }
    return this;
  }

  /// Asserts the delivery status shown on the message at [messageIndex].
  ///
  /// With [count], asserts instead how many messages in the list show
  /// [status] — the SDK only shows it on the last message of a group.
  ///
  /// [MessageDeliveryStatus.nil] is the absence of any status on the message:
  /// the indicator either renders nothing or is not built at all (a deleted or
  /// an ephemeral message has none).
  Future<UserRobot> assertMessageDeliveryStatus(
    MessageDeliveryStatus status, {
    int messageIndex = 0,
    int? count,
  }) async {
    if (count != null) {
      final statuses = MessageListPage.list.sendingStatus(status);
      final end = DateTime.now().add(const Duration(seconds: 30));
      while (statuses.evaluate().length != count && DateTime.now().isBefore(end)) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(statuses, findsNWidgets(count));
      return this;
    }

    if (status == MessageDeliveryStatus.nil) {
      final message = find.byType(MessageListPage.messageItem).at(messageIndex);
      await tester.waitUntilVisible(message);
      // A failed message's indicator renders nothing (the error badge marks it),
      // so `failed` is not a status shown here.
      const shown = [
        MessageDeliveryStatus.read,
        MessageDeliveryStatus.delivered,
        MessageDeliveryStatus.pending,
        MessageDeliveryStatus.sent,
      ];
      for (final shown in shown) {
        await tester.waitUntilNotVisible(
          find.descendant(of: message, matching: MessageListPage.list.sendingStatus(shown)),
        );
      }
      return this;
    }

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

  /// The slice of the history the message list has loaded so far, oldest
  /// first: the channel's messages, or inside a thread the parent followed by
  /// its replies.
  List<Message> get _loadedMessages {
    final view = find.byType(MessageListPage.list.view);
    final state = StreamChannel.of(tester.element(view)).channel.state;
    final parent = tester.widget<StreamMessageListView>(view).parentMessage;
    if (parent == null) return state?.messages ?? const [];
    return [parent, ...?state?.threads[parent.id]];
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

  Future<UserRobot> assertMessageOnScreen(String text, {bool isDisplayed = true}) =>
      then((it) => it.assertMessageOnScreen(text, isDisplayed: isDisplayed));

  Future<UserRobot> assertInvalidCommandMessage(String command) =>
      then((it) => it.assertInvalidCommandMessage(command));

  Future<UserRobot> assertGiphy({required bool isDisplayed}) => then((it) => it.assertGiphy(isDisplayed: isDisplayed));

  Future<UserRobot> assertGiphyButtons({required bool areDisplayed}) =>
      then((it) => it.assertGiphyButtons(areDisplayed: areDisplayed));

  Future<UserRobot> assertOnlyVisibleToYou() => then((it) => it.assertOnlyVisibleToYou());

  Future<UserRobot> assertMessageInSearchResults(String text) => then((it) => it.assertMessageInSearchResults(text));

  Future<UserRobot> assertMessageAuthor(String text, {required String authorName}) =>
      then((it) => it.assertMessageAuthor(text, authorName: authorName));

  Future<UserRobot> assertRemindersScreen() => then((it) => it.assertRemindersScreen());

  Future<UserRobot> assertRemindersAreEmpty() => then((it) => it.assertRemindersAreEmpty());

  Future<UserRobot> assertReminder(String text, {bool savedForLater = false}) =>
      then((it) => it.assertReminder(text, savedForLater: savedForLater));

  Future<UserRobot> assertMessageReminder({required bool remindAtIsSet}) =>
      then((it) => it.assertMessageReminder(remindAtIsSet: remindAtIsSet));

  Future<UserRobot> assertReactionAuthor(String name, {bool isDisplayed = true}) =>
      then((it) => it.assertReactionAuthor(name, isDisplayed: isDisplayed));

  Future<UserRobot> assertOwnReactionInAuthors() => then((it) => it.assertOwnReactionInAuthors());

  Future<UserRobot> assertMessageCopied(String text) => then((it) => it.assertMessageCopied(text));

  Future<UserRobot> assertUnreadSeparator({int? unreadCount, bool isDisplayed = true}) =>
      then((it) => it.assertUnreadSeparator(unreadCount: unreadCount, isDisplayed: isDisplayed));

  Future<UserRobot> assertJumpToUnreadButton({int? unreadCount, bool isDisplayed = true}) =>
      then((it) => it.assertJumpToUnreadButton(unreadCount: unreadCount, isDisplayed: isDisplayed));

  Future<UserRobot> assertPollMessage(String question) => then((it) => it.assertPollMessage(question));

  Future<UserRobot> assertPollOption(String text, {bool? isChecked}) =>
      then((it) => it.assertPollOption(text, isChecked: isChecked));

  Future<UserRobot> assertPollOptionVoteCount(String text, {required int count}) =>
      then((it) => it.assertPollOptionVoteCount(text, count: count));

  Future<UserRobot> assertPollResults({required String voterName}) =>
      then((it) => it.assertPollResults(voterName: voterName));

  Future<UserRobot> assertPollClosed() => then((it) => it.assertPollClosed());

  Future<UserRobot> assertThreadListIsEmpty() => then((it) => it.assertThreadListIsEmpty());

  Future<UserRobot> assertThreadInThreadList(String parentText, {required int replies}) =>
      then((it) => it.assertThreadInThreadList(parentText, replies: replies));

  Future<UserRobot> assertFlagMessageDialog({required bool isDisplayed}) =>
      then((it) => it.assertFlagMessageDialog(isDisplayed: isDisplayed));

  Future<UserRobot> assertMuteMessageAuthorOption(String text, {required bool isAuthorMuted}) =>
      then((it) => it.assertMuteMessageAuthorOption(text, isAuthorMuted: isAuthorMuted));

  Future<UserRobot> assertBlockMessageAuthorOption(String text, {required bool isAuthorBlocked}) =>
      then((it) => it.assertBlockMessageAuthorOption(text, isAuthorBlocked: isAuthorBlocked));

  Future<UserRobot> assertMessagePinnedLabel({String pinnedBy = 'You', bool isDisplayed = true}) =>
      then((it) => it.assertMessagePinnedLabel(pinnedBy: pinnedBy, isDisplayed: isDisplayed));

  Future<UserRobot> assertPinnedMessagesScreen() => then((it) => it.assertPinnedMessagesScreen());

  Future<UserRobot> assertMessageInPinnedMessages(String text) => then((it) => it.assertMessageInPinnedMessages(text));

  Future<UserRobot> assertPinnedMessagesAreEmpty() => then((it) => it.assertPinnedMessagesAreEmpty());

  Future<UserRobot> assertCooldown({required bool isDisplayed}) =>
      then((it) => it.assertCooldown(isDisplayed: isDisplayed));

  Future<UserRobot> assertComposerIsDisabledInSlowMode() => then((it) => it.assertComposerIsDisabledInSlowMode());

  Future<UserRobot> assertEphemeralMessageDeliveryStatusHidden() =>
      then((it) => it.assertEphemeralMessageDeliveryStatusHidden());

  Future<UserRobot> assertAttachmentsInComposer(AttachmentType type, {int count = 1}) =>
      then((it) => it.assertAttachmentsInComposer(type, count: count));

  Future<UserRobot> assertImage({required bool isDisplayed, int count = 1}) =>
      then((it) => it.assertImage(isDisplayed: isDisplayed, count: count));

  Future<UserRobot> assertVideo({required bool isDisplayed}) => then((it) => it.assertVideo(isDisplayed: isDisplayed));

  Future<UserRobot> assertFile({required bool isDisplayed, int count = 1}) =>
      then((it) => it.assertFile(isDisplayed: isDisplayed, count: count));

  Future<UserRobot> assertGalleryPosition(int position, {required int total}) =>
      then((it) => it.assertGalleryPosition(position, total: total));

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

  Future<UserRobot> assertLinkPreviewInMessageList({required bool isDisplayed}) =>
      then((it) => it.assertLinkPreviewInMessageList(isDisplayed: isDisplayed));

  Future<UserRobot> assertLinkPreviewInComposer({required bool isDisplayed}) =>
      then((it) => it.assertLinkPreviewInComposer(isDisplayed: isDisplayed));

  Future<UserRobot> assertMessageWithLink(String text, {required String link}) =>
      then((it) => it.assertMessageWithLink(text, link: link));

  Future<UserRobot> assertComposerText(String expected) => then((it) => it.assertComposerText(expected));

  Future<UserRobot> assertMentionWasApplied() => then((it) => it.assertMentionWasApplied());

  Future<UserRobot> assertComposerAttachmentsButton({required bool isDisplayed}) =>
      then((it) => it.assertComposerAttachmentsButton(isDisplayed: isDisplayed));

  Future<UserRobot> assertComposerCommands({required bool isDisplayed}) =>
      then((it) => it.assertComposerCommands(isDisplayed: isDisplayed));

  Future<UserRobot> assertMessageTimestamps(int count) => then((it) => it.assertMessageTimestamps(count));

  Future<UserRobot> assertAlsoInTheChannelLabel({required bool inThread}) =>
      then((it) => it.assertAlsoInTheChannelLabel(inThread: inThread));

  Future<UserRobot> assertMessageFailedToBeSent({int messageIndex = 0, bool isDisplayed = true}) =>
      then((it) => it.assertMessageFailedToBeSent(messageIndex: messageIndex, isDisplayed: isDisplayed));

  Future<UserRobot> assertMessageDeliveryStatus(
    MessageDeliveryStatus status, {
    int messageIndex = 0,
    int? count,
  }) => then((it) => it.assertMessageDeliveryStatus(status, messageIndex: messageIndex, count: count));

  Future<UserRobot> assertReaction({
    required ReactionType type,
    required bool isDisplayed,
  }) => then((it) => it.assertReaction(type: type, isDisplayed: isDisplayed));
}
