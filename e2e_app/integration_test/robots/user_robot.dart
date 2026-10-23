import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide AttachmentType;

import '../mock_server/data_types.dart';
import '../pages/channel_list_page.dart';
import '../pages/message_list_page.dart';
import '../support/predefined_users.dart';
import '../support/widget_test_extensions.dart';
import 'participant_robot.dart';

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

  /// Signs out from the drawer behind the current user's avatar on the channel
  /// list.
  Future<UserRobot> logout() async {
    await _openDrawer();
    await tester.tapText('Sign out');
    return this;
  }

  Future<UserRobot> _openDrawer() async {
    final avatar = find.descendant(of: find.byType(StreamChannelListHeader), matching: find.byType(StreamUserAvatar));
    await tester.tapFinder(avatar);
    return this;
  }

  /// Opens the reminders screen from the bottom navigation.
  Future<UserRobot> openReminders() async {
    await tester.tapFinder(find.descendant(of: find.byType(StreamBottomNavBar), matching: find.text('Reminders')));
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

  /// The text currently in the composer.
  String get composerText =>
      tester.widget<StreamMessageComposerInputField>(find.byType(MessageListPage.composer.inputField)).controller.text;

  Future<UserRobot> tapOnSendButton() async {
    await tester.tapByKey(MessageListPage.composer.sendButton);
    return this;
  }

  /// Dismisses the link preview the composer built for the typed URL.
  Future<UserRobot> tapOnLinkPreviewCancelButton() async {
    await tester.tapFinder(MessageListPage.composer.linkPreviewRemoveButton);
    return this;
  }

  /// Stages [count] attachments of [type] in the composer, ready to be sent.
  ///
  /// The native suites pick files through the OS photo / document pickers,
  /// which run out of process and so are out of reach of an in-process test.
  /// Staging the file on the composer's own controller is the closest seam: the
  /// composer still shows it, and sending still goes through the real send
  /// button and the SDK's upload to the mock server.
  Future<UserRobot> attachFile(AttachmentType type, {int count = 1}) async {
    final leading = find.byType(DefaultStreamMessageComposerLeading);
    await tester.waitUntilVisible(leading);
    final controller = tester.widget<DefaultStreamMessageComposerLeading>(leading).props.controller;
    for (var i = 1; i <= count; i++) {
      final (name, bytes) = switch (type) {
        AttachmentType.image => ('image$i.png', _png),
        AttachmentType.video => ('video$i.mp4', _mp4),
        AttachmentType.file => ('file$i.pdf', _pdf),
      };
      controller.addAttachment(
        Attachment(
          type: type.attachment,
          file: AttachmentFile(size: bytes.length, bytes: bytes, name: name),
        ),
      );
    }
    await tester.settle();
    return this;
  }

  /// Taps the image at [index] (0 being the first one) of the newest message
  /// with media, opening the full-screen gallery.
  Future<UserRobot> openImageInGallery({int index = 0}) async {
    final images = find.descendant(
      of: MessageListPage.list.gallery,
      matching: find.byType(StreamMessageAttachment),
    );
    await tester.waitUntilVisible(images.at(index));
    await tester.tap(images.at(index));
    await tester.settle();
    await tester.waitUntilVisible(MessageListPage.list.mediaGalleryPreview);
    return this;
  }

  /// Swipes the full-screen gallery to its next image.
  Future<UserRobot> swipeToNextImageInGallery() async {
    final gallery = MessageListPage.list.mediaGalleryPreview;
    await tester.fling(find.descendant(of: gallery, matching: find.byType(PageView)), const Offset(-300, 0), 1000);
    await tester.settle();
    return this;
  }

  /// Runs the giphy command, then sends the Giphy it previews unless [send] is
  /// false. [useComposerCommand] picks the command from the suggestions
  /// instead of typing it out.
  Future<UserRobot> uploadGiphy({bool useComposerCommand = false, bool send = true}) async {
    // Any text yields a Giphy from the mock server.
    const query = 'G';
    if (useComposerCommand) {
      await openComposerCommands();
      await selectCommand('giphy');
      await typeText(query);
      await tapOnSendButton();
    } else {
      await sendMessage('/giphy $query');
    }
    await tester.waitUntilVisible(MessageListPage.list.ephemeralMessage);
    if (send) await tapOnSendGiphyButton();
    return this;
  }

  Future<UserRobot> tapOnSendGiphyButton() => _tapGiphyButton('Send');

  Future<UserRobot> tapOnShuffleGiphyButton() => _tapGiphyButton('Shuffle');

  Future<UserRobot> tapOnCancelGiphyButton() => _tapGiphyButton('Cancel');

  Future<UserRobot> _tapGiphyButton(String label) async {
    await tester.tapFinder(MessageListPage.list.giphyButton(label));
    return this;
  }

  /// Opens the message actions of the message at [messageIndex] and returns
  /// whether [action] is among them, then closes the actions again.
  Future<bool> hasMessageAction(Finder action, {int messageIndex = 0}) async {
    final message = find.byType(MessageListPage.messageItem).at(messageIndex);
    await tester.longPressUntilVisible(message, find.byKey(MessageListPage.list.actionsModalMessageKey));
    final available = action.evaluate().isNotEmpty;
    await tester.tapAt(const Offset(20, 80));
    await tester.waitUntilNotVisible(find.byKey(MessageListPage.list.actionsModalMessageKey));
    return available;
  }

  Future<UserRobot> copyMessage({int messageIndex = 0}) =>
      _selectMessageAction(MessageListPage.actions.copy, messageIndex: messageIndex);

  /// Searches messages from the channel list's search field.
  Future<UserRobot> search(String query) async {
    await tester.waitUntilVisible(ChannelListPage.searchField);
    await tester.enterText(ChannelListPage.searchField, query);
    await tester.settle();
    return this;
  }

  Future<UserRobot> tapOnSearchResult({int index = 0}) async {
    await tester.tapFinder(ChannelListPage.searchResults.at(index));
    return this;
  }

  Future<UserRobot> markMessageAsUnread(String text) =>
      _selectMessageAction(MessageListPage.actions.markUnread, text: text);

  Future<UserRobot> tapOnJumpToUnreadButton() async {
    await tester.tapFinder(MessageListPage.list.jumpToUnreadButtonParts.first);
    return this;
  }

  Future<UserRobot> dismissUnreadIndicator() async {
    await tester.tapFinder(MessageListPage.list.jumpToUnreadButtonParts.last);
    return this;
  }

  /// Scrolls the message list up until the message [text] is rendered.
  Future<UserRobot> scrollMessageListUpUntilVisible(String text) async {
    final message = MessageListPage.list.messageWithText(text);
    await tester.scrollUpUntil(() => message.evaluate().isNotEmpty, description: 'the message "$text"');
    return this;
  }

  /// Scrolls the message list down until the message [text] is rendered.
  Future<UserRobot> scrollMessageListDownUntilVisible(String text) async {
    final message = MessageListPage.list.messageWithText(text);
    await tester.scrollDownUntil(() => message.evaluate().isNotEmpty, description: 'the message "$text"');
    return this;
  }

  Future<UserRobot> pinMessage({int messageIndex = 0}) =>
      _selectMessageAction(MessageListPage.actions.pin, messageIndex: messageIndex);

  Future<UserRobot> unpinMessage({int messageIndex = 0}) =>
      _selectMessageAction(MessageListPage.actions.unpin, messageIndex: messageIndex);

  /// Picks 'Reply' from the message's actions without sending anything.
  Future<UserRobot> selectReplyFromContextMenu({int messageIndex = 0}) =>
      _selectMessageAction(MessageListPage.actions.reply, messageIndex: messageIndex);

  Future<UserRobot> flagMessage(String text) => _selectMessageAction(MessageListPage.actions.flag, text: text);

  Future<UserRobot> confirmFlagMessage() async {
    await tester.tapFinder(MessageListPage.actions.flagConfirm);
    return this;
  }

  Future<UserRobot> muteMessageAuthor(String text) =>
      _selectMessageAction(MessageListPage.actions.muteUser, text: text);

  Future<UserRobot> unmuteMessageAuthor(String text) =>
      _selectMessageAction(MessageListPage.actions.unmuteUser, text: text);

  Future<UserRobot> blockMessageAuthor(String text) =>
      _selectMessageAction(MessageListPage.actions.blockUser, text: text);

  Future<UserRobot> unblockMessageAuthor(String text) =>
      _selectMessageAction(MessageListPage.actions.unblockUser, text: text);

  /// Opens the actions of the message [text], checks whether each of [options]
  /// is offered, then closes the actions again.
  Future<List<bool>> messageActionsOffered(String text, List<Finder> options) async {
    final message = await _resolveMessage(messageIndex: 0, text: text);
    final modal = find.byKey(MessageListPage.list.actionsModalMessageKey);
    await tester.longPressUntilVisible(message, modal);
    final offered = [for (final option in options) option.evaluate().isNotEmpty];
    await closeMessageActions();
    return offered;
  }

  /// Dismisses the open message actions by tapping outside of them.
  Future<UserRobot> closeMessageActions() async {
    final modal = find.byKey(MessageListPage.list.actionsModalMessageKey);
    await tester.tapAt(const Offset(10, 120));
    await tester.waitUntilNotVisible(modal);
    return this;
  }

  Future<UserRobot> _selectMessageAction(Finder action, {int messageIndex = 0, String? text}) async {
    final message = await _resolveMessage(messageIndex: messageIndex, text: text);
    await tester.longPressUntilVisible(message, action);
    await tester.tapFinder(action);
    return this;
  }

  /// Opens the channel detail sheet by long-pressing the channel row.
  Future<UserRobot> openChannelMenu({int index = 0}) async {
    final tile = find.byType(ChannelListPage.channelTile).at(index);
    await tester.longPressUntilVisible(tile, ChannelListPage.channelAction('View Info'));
    return this;
  }

  Future<UserRobot> tapOnChannelAction(String label) async {
    await tester.tapFinder(ChannelListPage.channelAction(label));
    return this;
  }

  Future<UserRobot> tapOnViewChannelInfo() => tapOnChannelAction('View Info');

  Future<UserRobot> tapOnLeaveGroup() => tapOnChannelAction('Leave Group');

  Future<UserRobot> tapOnDeleteGroup() => tapOnChannelAction('Delete Group');

  /// Confirms the leave / delete dialog the app shows.
  Future<UserRobot> confirmChannelAction() async {
    final confirm = ChannelListPage.dialogButton('Leave').evaluate().isNotEmpty ? 'Leave' : 'Delete';
    await tester.tapFinder(ChannelListPage.dialogButton(confirm));
    return this;
  }

  /// Swipes the channel row at [index] to reveal its swipe actions.
  Future<UserRobot> swipeChannel({int index = 0}) async {
    final tile = find.byType(ChannelListPage.channelTile).at(index);
    await tester.waitUntilVisible(tile);
    await tester.drag(tile, Offset(-tester.getSize(tile).width * 0.5, 0));
    await tester.settle();
    await tester.waitUntilVisible(ChannelListPage.swipeAction(0));
    return this;
  }

  Future<UserRobot> tapOnMoreSwipeAction() => _tapSwipeAction(0);

  Future<UserRobot> tapOnMuteSwipeAction() => _tapSwipeAction(1);

  // A plain tap: scrolling the action into view first (as `tapFinder` does)
  // closes the open slidable before the tap lands.
  Future<UserRobot> _tapSwipeAction(int index) async {
    final action = ChannelListPage.swipeAction(index);
    await tester.waitUntilVisible(action);
    await tester.tap(action);
    await tester.settle();
    return this;
  }

  /// The mute swipe action toggles, so unmuting taps the same slot.
  Future<UserRobot> tapOnUnmuteSwipeAction() => tapOnMuteSwipeAction();

  /// Opens the channel whose row is titled [name].
  Future<UserRobot> openChannelNamed(String name) async {
    final tile = ChannelListPage.channelNamed(name);
    await tester.waitUntilVisible(tile);
    await tester.tap(tile.first);
    await tester.pumpAndSettle();
    return this;
  }

  Future<UserRobot> tapOnPinnedMessagesOption() async {
    await tester.tapFinder(ChannelInfoPage.pinnedMessagesOption);
    return this;
  }

  /// Creates a poll asking [question] with [options] through the attachment
  /// picker, and sends it.
  Future<UserRobot> createPoll(String question, List<String> options, {bool multipleAnswers = false}) async {
    await tester.tapFinder(MessageListPage.composer.attachmentsButton);
    await tester.tapFinder(AttachmentPickerPage.pollTab);
    await tester.waitUntilVisible(AttachmentPickerPage.pollCreatorTitle);

    await tester.enterText(AttachmentPickerPage.questionField.first, question);
    await tester.settle();
    for (final (index, option) in options.indexed) {
      final field = AttachmentPickerPage.optionFields.at(index);
      // The creator starts with one option field; each further one is added
      // from its "Add an option" row.
      if (index > 0) await _addPollOptionField(field);
      await tester.waitUntilVisible(field);
      await tester.enterText(field, option);
      await tester.settle();
    }
    if (multipleAnswers) await tester.tapFinder(AttachmentPickerPage.multipleAnswersSwitch);

    await tester.tapFinder(AttachmentPickerPage.savePollButton);
    await tester.waitUntilNotVisible(AttachmentPickerPage.pollCreatorTitle);
    await tester.waitUntilVisible(MessageListPage.list.poll);
    return this;
  }

  // The first tap on "Add an option" can be spent on moving focus off the
  // field just filled in, so it is retried until the new field shows up.
  Future<void> _addPollOptionField(Finder field) async {
    for (var attempt = 0; attempt < 5 && field.evaluateSafely().isEmpty; attempt++) {
      await tester.tap(AttachmentPickerPage.addOptionButton.last);
      await tester.settle();
    }
  }

  /// Taps the poll [option], which votes for it, or removes the vote when it
  /// was already cast.
  Future<UserRobot> castPollVote(String option) async {
    await tester.tapFinder(MessageListPage.list.pollOption(option));
    return this;
  }

  Future<UserRobot> removePollVote(String option) => castPollVote(option);

  Future<UserRobot> openPollResults() async {
    await tester.tapFinder(find.descendant(of: MessageListPage.list.poll, matching: find.text('View Results')));
    await tester.waitUntilVisible(find.text('Poll Results'));
    return this;
  }

  /// Ends the poll, confirming the dialog that asks for it.
  Future<UserRobot> endPoll() async {
    await tester.tapFinder(find.descendant(of: MessageListPage.list.poll, matching: find.text('End Poll')));
    await tester.tapFinder(find.text('End'));
    return this;
  }

  /// Opens the thread list from the bottom navigation.
  Future<UserRobot> openThreadList() async {
    await tester.tapText('Threads');
    return this;
  }

  /// Opens the thread at [index] of the thread list.
  Future<UserRobot> openThreadFromThreadList({int index = 0}) async {
    await tester.tapFinder(find.byType(StreamThreadListTile).at(index));
    await tester.waitUntilVisible(MessageListPage.threadHeader);
    return this;
  }

  /// Opens the command suggestions by typing `/`.
  Future<UserRobot> openComposerCommands() => typeText('/');

  /// Picks the command [name] from the open command suggestions.
  Future<UserRobot> selectCommand(String name) async {
    await tester.tapFinder(MessageListPage.composer.commandSuggestion(name));
    return this;
  }

  /// Mentions the participant through the mentions overlay, and sends the
  /// message unless [send] is false.
  Future<UserRobot> mentionParticipant({bool send = true}) async {
    await typeText('@');
    await tester.tapFinder(
      find.descendant(of: MessageListPage.composer.mentionsOverlay, matching: find.text(ParticipantRobot.name)),
    );
    if (send) await tester.tapByKey(MessageListPage.composer.sendButton);
    return this;
  }

  /// Taps an empty spot in the message list (just under the header).
  Future<UserRobot> tapOnMessageList() async {
    final list = find.byType(MessageListPage.list.view);
    await tester.waitUntilVisible(list);
    await tester.tapAt(tester.getTopLeft(list) + const Offset(20, 20));
    await tester.settle();
    return this;
  }

  /// Taps the floating scroll-to-bottom button.
  Future<UserRobot> tapOnScrollToBottomButton() async {
    await tester.tapFinder(MessageListPage.list.scrollToBottomButton);
    return this;
  }

  Future<UserRobot> editMessage(String newText, {int messageIndex = 0}) async {
    final message = find.byType(MessageListPage.messageItem).at(messageIndex);
    await tester.longPressUntilVisible(message, MessageListPage.actions.edit);
    await tester.tapFinder(MessageListPage.actions.edit);
    await tester.enterTextInField(MessageListPage.composer.inputField, newText);
    await tester.tapByKey(MessageListPage.composer.sendButton);
    return this;
  }

  /// Deletes the message, or hard-deletes it when [hard] is set — through the
  /// e2e app's own action, as the SDK offers a hard delete only for a message
  /// that failed to send.
  Future<UserRobot> deleteMessage({int messageIndex = 0, String? text, bool hard = false}) async {
    final message = await _resolveMessage(messageIndex: messageIndex, text: text);
    if (hard) {
      await tester.longPressUntilVisible(message, MessageListPage.actions.hardDelete);
      await tester.tapFinder(MessageListPage.actions.hardDelete);
      return this;
    }
    await tester.longPressUntilVisible(message, MessageListPage.actions.delete);
    await tester.tapFinder(MessageListPage.actions.delete);
    await tester.tapFinder(MessageListPage.actions.deleteConfirm);
    return this;
  }

  /// Copies the id of the message [text], for [openMessageByIdFromChannelList].
  Future<UserRobot> copyMessageId(String text) => _selectMessageAction(MessageListPage.actions.copyId, text: text);

  /// Opens the message whose id [copyMessageId] copied, through the channel
  /// actions sheet's debug action.
  Future<UserRobot> openMessageByIdFromChannelList({int index = 0}) async {
    await openChannelMenu(index: index);
    await tester.tapFinder(ChannelListPage.channelAction('Open Message by ID'));
    return this;
  }

  /// Picks what the channel list's search field searches.
  Future<UserRobot> selectSearchScope(String label) async {
    await tester.tapFinder(ChannelListPage.searchScope(label));
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

  /// Taps "View" on the "Replied to a thread" annotation of the newest message
  /// that was also sent to the channel, which opens it in its thread.
  Future<UserRobot> tapOnThreadReplyAnnotation() async {
    await tester.tapFinder(find.text('View'));
    await tester.waitUntilVisible(MessageListPage.threadHeader);
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

  /// Nudges the message list up by one drag. To *arrive* somewhere, scroll
  /// until it is visible instead — a fixed number of drags is viewport-
  /// dependent.
  Future<UserRobot> scrollMessageListUp() async {
    await tester.scrollMessageList(300);
    return this;
  }

  /// Scrolls a thread up to its top, paging in older replies as needed.
  ///
  /// Stops once both the separator and the parent row above it are built, so
  /// the parent and any duplicate copy of it among the replies are both built.
  /// The separator alone is not enough: the list can build it a whole row
  /// before it builds the parent.
  Future<UserRobot> scrollToTopOfThread() async {
    await tester.scrollUpUntil(
      () =>
          MessageListPage.list.threadSeparator.evaluate().isNotEmpty &&
          MessageListPage.list.threadParent.evaluate().isNotEmpty,
      description: 'the top of the thread',
    );
    return this;
  }

  Future<UserRobot> scrollMessageListDown() async {
    await tester.scrollMessageList(-300);
    return this;
  }

  /// Taps the [link] inside a message's text, rather than the middle of the
  /// whole text, which may not be part of the link.
  Future<UserRobot> tapOnLinkText(String link) async {
    await tester.waitUntilVisible(find.textContaining(link));
    await tester.tapOnText(find.textRange.ofSubstring(link));
    await tester.settle();
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

  /// Toggles the reaction [type] through the full emoji sheet behind the
  /// reaction picker's "+".
  Future<UserRobot> toggleReactionUsingExtendedPicker(ReactionType type, {int messageIndex = 0}) async {
    final add = find.byKey(MessageListPage.reactions.addReactionButton);
    final message = find.byType(MessageListPage.messageItem).at(messageIndex);
    await tester.longPressUntilVisible(message, add);
    await tester.tapFinder(add);
    await tester.tapFinder(MessageListPage.reactions.extendedPickerReaction(type));
    return this;
  }

  /// Taps the reaction [type] shown on a message, opening the sheet of who
  /// reacted.
  Future<UserRobot> tapOnMessageReactions(ReactionType type) async {
    await tester.tapFinder(find.text(type.emoji));
    await tester.waitUntilVisible(MessageListPage.reactions.authorsSheet);
    return this;
  }

  /// Switches the reaction authors sheet to the authors of [type].
  Future<UserRobot> selectReactionInAuthors(ReactionType type) async {
    await tester.tapFinder(
      find.descendant(of: MessageListPage.reactions.authorsSheet, matching: find.textContaining(type.emoji)),
    );
    return this;
  }

  Future<UserRobot> closeReactionAuthors() async {
    await tester.tapAt(const Offset(10, 120));
    await tester.waitUntilNotVisible(MessageListPage.reactions.authorsSheet);
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

  Future<UserRobot> logout() => then((it) => it.logout());

  Future<UserRobot> openReminders() => then((it) => it.openReminders());

  Future<UserRobot> openChannel({int index = 0}) => then((it) => it.openChannel(index: index));

  Future<UserRobot> sendMessage(String text) => then((it) => it.sendMessage(text));

  Future<UserRobot> typeText(String text) => then((it) => it.typeText(text));

  Future<UserRobot> clearComposer() => then((it) => it.clearComposer());

  Future<UserRobot> tapOnSendButton() => then((it) => it.tapOnSendButton());

  Future<UserRobot> tapOnLinkPreviewCancelButton() => then((it) => it.tapOnLinkPreviewCancelButton());

  Future<UserRobot> attachFile(AttachmentType type, {int count = 1}) => then((it) => it.attachFile(type, count: count));

  Future<UserRobot> openImageInGallery({int index = 0}) => then((it) => it.openImageInGallery(index: index));

  Future<UserRobot> swipeToNextImageInGallery() => then((it) => it.swipeToNextImageInGallery());

  Future<UserRobot> uploadGiphy({bool useComposerCommand = false, bool send = true}) =>
      then((it) => it.uploadGiphy(useComposerCommand: useComposerCommand, send: send));

  Future<UserRobot> tapOnSendGiphyButton() => then((it) => it.tapOnSendGiphyButton());

  Future<UserRobot> tapOnShuffleGiphyButton() => then((it) => it.tapOnShuffleGiphyButton());

  Future<UserRobot> tapOnCancelGiphyButton() => then((it) => it.tapOnCancelGiphyButton());

  Future<UserRobot> copyMessage({int messageIndex = 0}) => then((it) => it.copyMessage(messageIndex: messageIndex));

  Future<UserRobot> search(String query) => then((it) => it.search(query));

  Future<UserRobot> tapOnSearchResult({int index = 0}) => then((it) => it.tapOnSearchResult(index: index));

  Future<UserRobot> markMessageAsUnread(String text) => then((it) => it.markMessageAsUnread(text));

  Future<UserRobot> tapOnJumpToUnreadButton() => then((it) => it.tapOnJumpToUnreadButton());

  Future<UserRobot> dismissUnreadIndicator() => then((it) => it.dismissUnreadIndicator());

  Future<UserRobot> scrollMessageListUpUntilVisible(String text) =>
      then((it) => it.scrollMessageListUpUntilVisible(text));

  Future<UserRobot> scrollMessageListDownUntilVisible(String text) =>
      then((it) => it.scrollMessageListDownUntilVisible(text));

  Future<UserRobot> pinMessage({int messageIndex = 0}) => then((it) => it.pinMessage(messageIndex: messageIndex));

  Future<UserRobot> unpinMessage({int messageIndex = 0}) => then((it) => it.unpinMessage(messageIndex: messageIndex));

  Future<UserRobot> selectReplyFromContextMenu({int messageIndex = 0}) =>
      then((it) => it.selectReplyFromContextMenu(messageIndex: messageIndex));

  Future<UserRobot> openChannelMenu({int index = 0}) => then((it) => it.openChannelMenu(index: index));

  Future<UserRobot> tapOnChannelAction(String label) => then((it) => it.tapOnChannelAction(label));

  Future<UserRobot> tapOnViewChannelInfo() => then((it) => it.tapOnViewChannelInfo());

  Future<UserRobot> tapOnLeaveGroup() => then((it) => it.tapOnLeaveGroup());

  Future<UserRobot> tapOnDeleteGroup() => then((it) => it.tapOnDeleteGroup());

  Future<UserRobot> confirmChannelAction() => then((it) => it.confirmChannelAction());

  Future<UserRobot> swipeChannel({int index = 0}) => then((it) => it.swipeChannel(index: index));

  Future<UserRobot> tapOnMoreSwipeAction() => then((it) => it.tapOnMoreSwipeAction());

  Future<UserRobot> tapOnMuteSwipeAction() => then((it) => it.tapOnMuteSwipeAction());

  Future<UserRobot> tapOnUnmuteSwipeAction() => then((it) => it.tapOnUnmuteSwipeAction());

  Future<UserRobot> openChannelNamed(String name) => then((it) => it.openChannelNamed(name));

  Future<UserRobot> flagMessage(String text) => then((it) => it.flagMessage(text));

  Future<UserRobot> confirmFlagMessage() => then((it) => it.confirmFlagMessage());

  Future<UserRobot> muteMessageAuthor(String text) => then((it) => it.muteMessageAuthor(text));

  Future<UserRobot> unmuteMessageAuthor(String text) => then((it) => it.unmuteMessageAuthor(text));

  Future<UserRobot> blockMessageAuthor(String text) => then((it) => it.blockMessageAuthor(text));

  Future<UserRobot> unblockMessageAuthor(String text) => then((it) => it.unblockMessageAuthor(text));

  Future<UserRobot> closeMessageActions() => then((it) => it.closeMessageActions());

  Future<UserRobot> tapOnPinnedMessagesOption() => then((it) => it.tapOnPinnedMessagesOption());

  Future<UserRobot> createPoll(String question, List<String> options, {bool multipleAnswers = false}) =>
      then((it) => it.createPoll(question, options, multipleAnswers: multipleAnswers));

  Future<UserRobot> castPollVote(String option) => then((it) => it.castPollVote(option));

  Future<UserRobot> removePollVote(String option) => then((it) => it.removePollVote(option));

  Future<UserRobot> openPollResults() => then((it) => it.openPollResults());

  Future<UserRobot> endPoll() => then((it) => it.endPoll());

  Future<UserRobot> openThreadList() => then((it) => it.openThreadList());

  Future<UserRobot> openThreadFromThreadList({int index = 0}) =>
      then((it) => it.openThreadFromThreadList(index: index));

  Future<UserRobot> openComposerCommands() => then((it) => it.openComposerCommands());

  Future<UserRobot> selectCommand(String name) => then((it) => it.selectCommand(name));

  Future<UserRobot> mentionParticipant({bool send = true}) => then((it) => it.mentionParticipant(send: send));

  Future<UserRobot> tapOnMessageList() => then((it) => it.tapOnMessageList());

  Future<UserRobot> tapOnScrollToBottomButton() => then((it) => it.tapOnScrollToBottomButton());

  Future<UserRobot> editMessage(String newText, {int messageIndex = 0}) =>
      then((it) => it.editMessage(newText, messageIndex: messageIndex));

  Future<UserRobot> deleteMessage({int messageIndex = 0, String? text, bool hard = false}) =>
      then((it) => it.deleteMessage(messageIndex: messageIndex, text: text, hard: hard));

  Future<UserRobot> copyMessageId(String text) => then((it) => it.copyMessageId(text));

  Future<UserRobot> openMessageByIdFromChannelList({int index = 0}) =>
      then((it) => it.openMessageByIdFromChannelList(index: index));

  Future<UserRobot> selectSearchScope(String label) => then((it) => it.selectSearchScope(label));

  Future<UserRobot> quoteMessage(String text, {int messageIndex = 0, String? quotedText}) =>
      then((it) => it.quoteMessage(text, messageIndex: messageIndex, quotedText: quotedText));

  Future<UserRobot> swipeMessage({int messageIndex = 0, String? text}) =>
      then((it) => it.swipeMessage(messageIndex: messageIndex, text: text));

  Future<UserRobot> tapQuotedMessage() => then((it) => it.tapQuotedMessage());

  Future<UserRobot> tapOnThreadReplyAnnotation() => then((it) => it.tapOnThreadReplyAnnotation());

  Future<UserRobot> waitForMessageListToLoad() => then((it) => it.waitForMessageListToLoad());

  Future<UserRobot> openThread({int messageIndex = 0, String? parentText}) =>
      then((it) => it.openThread(messageIndex: messageIndex, parentText: parentText));

  Future<UserRobot> openThreadFromReplies() => then((it) => it.openThreadFromReplies());

  Future<UserRobot> sendMessageInThread(String text, {bool alsoSendInChannel = false}) =>
      then((it) => it.sendMessageInThread(text, alsoSendInChannel: alsoSendInChannel));

  Future<UserRobot> tapBackButton() => then((it) => it.tapBackButton());

  Future<UserRobot> moveToChannelListFromThread() => then((it) => it.moveToChannelListFromThread());

  Future<UserRobot> scrollMessageListUp() => then((it) => it.scrollMessageListUp());

  Future<UserRobot> scrollMessageListDown() => then((it) => it.scrollMessageListDown());

  Future<UserRobot> scrollToTopOfThread() => then((it) => it.scrollToTopOfThread());

  Future<UserRobot> tapLinkPreview() => then((it) => it.tapLinkPreview());

  Future<UserRobot> tapOnLinkText(String link) => then((it) => it.tapOnLinkText(link));

  Future<UserRobot> addReaction(ReactionType type, {int messageIndex = 0}) =>
      then((it) => it.addReaction(type, messageIndex: messageIndex));

  Future<UserRobot> toggleReactionUsingExtendedPicker(ReactionType type, {int messageIndex = 0}) =>
      then((it) => it.toggleReactionUsingExtendedPicker(type, messageIndex: messageIndex));

  Future<UserRobot> tapOnMessageReactions(ReactionType type) => then((it) => it.tapOnMessageReactions(type));

  Future<UserRobot> selectReactionInAuthors(ReactionType type) => then((it) => it.selectReactionInAuthors(type));

  Future<UserRobot> closeReactionAuthors() => then((it) => it.closeReactionAuthors());

  Future<UserRobot> deleteReaction(ReactionType type, {int messageIndex = 0}) =>
      then((it) => it.deleteReaction(type, messageIndex: messageIndex));
}

// The smallest valid payload of each type, enough for the SDK to upload and
// for the mock server to answer with a URL of its own.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);
final _pdf = Uint8List.fromList(utf8.encode('%PDF-1.4\n1 0 obj<<>>endobj\ntrailer<<>>\n%%EOF\n'));
final _mp4 = Uint8List.fromList([0, 0, 0, 24, ...utf8.encode('ftypmp42'), 0, 0, 0, 0, ...utf8.encode('mp42isom')]);
