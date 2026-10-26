import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mock_server/data_types.dart';

abstract final class MessageListPage {
  static const composer = _Composer();
  static const reactions = _Reactions();
  static const actions = _MessageActions();
  static const list = _MessageList();

  /// The widget that renders a single message row. Long-pressing it opens the
  /// message actions modal (which hosts the reaction picker and actions).
  static Type get messageItem => StreamMessageItem;

  /// The AppBar back button (channel and thread headers both default to it).
  static Finder get backButton => find.byType(StreamBackButton);

  /// The thread view header — present once the user is inside a thread.
  static Finder get threadHeader => find.byType(StreamThreadHeader);
}

final class _Composer {
  const _Composer();

  Type get inputField => StreamMessageComposerInputField;

  /// Same key drives the send button and the edit-confirm (checkmark) button.
  Key get sendButton => const ValueKey('send_key');

  /// Mention suggestions overlay shown while typing `@`.
  Finder get mentionsOverlay => find.byType(StreamMentionAutocompleteOptions);

  /// Command suggestions overlay shown while typing `/`.
  Finder get commandsOverlay => find.byType(StreamCommandAutocompleteOptions);

  /// The suggestion for the command [name] (e.g. `giphy`) in [commandsOverlay].
  /// The overlay titles each command by its sentence-cased name.
  Finder commandSuggestion(String name) => find.descendant(
    of: commandsOverlay,
    matching: find.text('${name[0].toUpperCase()}${name.substring(1)}'),
  );

  /// The countdown the send button turns into while slow mode is active.
  /// `_SlowModeCountdownButton` is private, so it is located by the
  /// placeholder the input shows alongside it (`slowModeOnLabel`).
  Finder get slowModePlaceholder => find.textContaining('Slow mode, wait');

  /// The link preview the composer shows above the input while the typed text
  /// holds an enrichable URL. The core widget is not exported by the SDK, hence
  /// matching on the runtime type.
  Finder get linkPreview =>
      find.byWidgetPredicate((it) => it.runtimeType.toString() == 'StreamMessageComposerLinkPreviewAttachment');

  /// The remove ("x") control on [linkPreview], which drops the preview so the
  /// message is sent without one.
  Finder get linkPreviewRemoveButton => find.descendant(
    of: linkPreview,
    matching: find.byWidgetPredicate((it) => it.runtimeType.toString() == 'StreamRemoveControl'),
  );

  /// The attachments staged in the composer, waiting to be sent, whose type is
  /// [type].
  Finder stagedAttachments(String type) => find.byWidgetPredicate(
    (it) => it is DefaultMessageComposerAttachment && it.props.attachment.type == type,
    description: 'staged $type attachment',
  );

  /// The attachments ("+") button at the composer's leading edge. The default
  /// leading drops the button altogether while a command is selected.
  Finder get attachmentsButton => find.descendant(
    of: find.byType(DefaultStreamMessageComposerLeading),
    matching: find.byType(StreamButton),
  );

  /// The "also send in channel" checkbox, which the composer only shows while
  /// inside a thread. `DmCheckboxListTile` is not exported, so it is located by
  /// its label (`alsoSendAsDirectMessageLabel`).
  Finder get alsoSendInChannelCheckbox => find.text('Also send in Channel');
}

/// The attachment picker and the poll creator it leads to.
abstract final class AttachmentPickerPage {
  static Finder get pollTab => find.byTooltip('Create a new poll');

  static Finder get pollCreatorTitle => find.text('Create Poll');

  /// The question field: the first editable field of the poll creator.
  static Finder get questionField => find.descendant(
    of: find.byWidgetPredicate((it) => it.runtimeType.toString() == 'PollQuestionTextField'),
    matching: find.byType(EditableText),
  );

  /// The option fields of the poll creator, in order. A new empty one is
  /// appended as soon as the last one is filled in.
  static Finder get optionFields => find.descendant(
    of: find.byWidgetPredicate((it) => it.runtimeType.toString() == 'PollOptionListItem'),
    matching: find.byType(EditableText),
  );

  static Finder get addOptionButton => find.text('Add an option');

  static Finder get multipleAnswersSwitch => find.descendant(
    of: find.ancestor(
      of: find.text('Multiple answers'),
      matching: find.byWidgetPredicate((it) => it.runtimeType.toString() == 'PollConfigOption'),
    ),
    matching: find.byWidgetPredicate((it) => it.runtimeType.toString() == 'StreamSwitch'),
  );

  static Finder get savePollButton => find.byTooltip('Save poll');
}

final class _Reactions {
  const _Reactions();

  /// Key of a reaction in the reaction picker (message actions modal).
  /// The SDK keys each picker button by its reaction type string.
  Key pickerReaction(ReactionType type) => ValueKey(type.reaction);

  /// The "+" at the end of the reaction picker, opening the full emoji sheet.
  Key get addReactionButton => const ValueKey('add_reaction');

  /// The emoji [type] in the full emoji sheet. The sheet is not exported,
  /// hence matching on the runtime type.
  Finder extendedPickerReaction(ReactionType type) => find.descendant(
    of: find.byWidgetPredicate((it) => it.runtimeType.toString() == 'StreamEmojiPickerSheet'),
    matching: find.text(type.emoji),
  );

  /// The sheet listing who reacted to a message, opened by tapping its
  /// reactions.
  Finder get authorsSheet => find.byType(ReactionDetailSheet);
}

/// Rows inside the message actions modal (opened by long-pressing a message).
///
/// The rows are `StreamContextMenuAction<MessageAction>` widgets, which
/// `find.byType` cannot match (it compares the fully-generic runtime type), so
/// each action is located by its label text — the exact default-English strings
/// the SDK renders (`translations.dart`), mirroring how the native robots read
/// the localized labels.
final class _MessageActions {
  const _MessageActions();

  Finder get edit => find.text('Edit Message');
  Finder get delete => find.text('Delete Message');
  Finder get threadReply => find.text('Thread Reply');

  Finder get flag => find.text('Flag Message');
  Finder get muteUser => find.text('Mute User');
  Finder get unmuteUser => find.text('Unmute User');
  Finder get blockUser => find.text('Block User');
  Finder get unblockUser => find.text('Unblock User');

  /// The question the flag confirmation dialog asks (`flagMessageQuestion`).
  Finder get flagDialog => find.textContaining('send a copy of this message to a moderator');

  /// The confirm button of the flag dialog (`flagLabel`).
  Finder get flagConfirm => find.text('Flag');

  Finder get markUnread => find.text('Mark Unread');
  Finder get copy => find.text('Copy Message');

  /// The e2e app's own actions (see its `e2eMessageItemBuilder`).
  Finder get hardDelete => find.text('Hard Delete Message');
  Finder get copyId => find.text('Copy Message ID');

  Finder get pin => find.text('Pin to Conversation');
  Finder get unpin => find.text('Unpin from Conversation');

  /// Starts a quoted reply (`replyLabel`). Distinct from [threadReply].
  Finder get reply => find.text('Reply');

  /// The confirm button in the delete-confirmation dialog.
  Finder get deleteConfirm => find.text('Delete');
}

final class _MessageList {
  const _MessageList();

  /// The message list itself. Also the entry point to the channel driving it:
  /// `StreamChannel.of()` on its context resolves the channel whose state holds
  /// however much of the history has been paged in.
  Type get view => StreamMessageListView;

  /// The row rendering the message with [id]. Matches on message identity, so
  /// it locates a message regardless of what it says.
  Finder message(String id) => find.byWidgetPredicate(
    (widget) => widget is StreamMessageItem && widget.props.message.id == id,
    description: 'message row for $id',
  );

  /// The key the message actions modal gives its own copy of the message it
  /// was opened for.
  Key get actionsModalMessageKey => const Key('MessageItem');

  /// The row rendering the message whose text is exactly [text].
  ///
  /// The open actions modal renders its own copy of the message under
  /// [actionsModalMessageKey]; excluding that one row keeps this finder
  /// unambiguous while the modal is up. Rows in the list carry a key of their
  /// own (a `ValueKey` of the message id), so they cannot be told apart from
  /// the modal's copy by the mere absence of a key.
  Finder messageWithText(String text) => find.byWidgetPredicate(
    (widget) =>
        widget is StreamMessageItem && widget.key != actionsModalMessageKey && widget.props.message.text == text,
    description: 'message row with text "$text"',
  );

  /// The quoted-message bubble a reply carries above its own text.
  Finder get quotedMessage => find.byType(StreamQuotedMessage);

  /// The quote's text preview. Rendered by the same [StreamMessagePreviewText]
  /// as the channel list, but with no channel in scope — so it carries no
  /// "You:" / sender prefix, and a deleted quote reads "Message deleted".
  Finder get quotedMessageText => find.descendant(
    of: quotedMessage,
    matching: find.descendant(of: find.byType(StreamMessagePreviewText), matching: find.byType(Text)),
  );

  /// A system message row (e.g. the "channel truncated" notice). System
  /// messages get their own row widget rather than a [StreamMessageItem].
  Finder get systemMessage => find.byType(StreamSystemMessage);

  /// The row an error message gets — what the backend returns for an unknown
  /// slash command. Error messages bypass [StreamMessageItem] entirely.
  Finder get moderatedMessage => find.byType(StreamModeratedMessage);

  /// The row an ephemeral message gets, e.g. a Giphy preview awaiting a
  /// send/shuffle/cancel. Like the system and error rows, it is not a
  /// [StreamMessageItem].
  Finder get ephemeralMessage => find.byType(StreamEphemeralMessage);

  /// A single rendered image. Several images in one message render as a
  /// [gallery] instead.
  Finder get image => find.byType(StreamImageAttachment);

  /// Several images (or videos) of one message, rendered as a grid.
  Finder get gallery => find.byType(StreamGalleryAttachment);

  Finder get video => find.byType(StreamVideoAttachment);

  Finder get file => find.byType(StreamFileAttachment);

  /// The full-screen media viewer opened by tapping an image.
  Finder get mediaGalleryPreview => find.byType(StreamMediaGalleryPreview);

  /// A button ('Send', 'Shuffle' or 'Cancel') on the ephemeral Giphy preview.
  Finder giphyButton(String label) => find.descendant(of: ephemeralMessage, matching: find.text(label));

  Finder get poll => find.byType(StreamPollAttachment);

  /// The row of the poll option [text] in the poll on the message list.
  /// `PollOptionItem` is not exported, hence matching on the runtime type.
  Finder pollOption(String text) => find.byWidgetPredicate(
    (it) => it.runtimeType.toString() == 'PollOptionItem' && ((it as dynamic).option as PollOption).text == text,
    description: 'poll option "$text"',
  );

  /// A rendered Giphy attachment.
  Finder get giphy => find.byType(StreamGiphyAttachment);

  /// Thread-participant avatars shown next to the "N replies" footer.
  Finder get threadRepliesAvatars => find.descendant(
    of: threadReplies,
    matching: find.byType(StreamUserAvatar),
  );

  /// The floating "scroll to bottom" button.
  ///
  /// It has no key or dedicated type — it is a floating [StreamButton] the view
  /// swaps for an `Empty()` whenever it should be hidden, so its presence in the
  /// tree *is* the "button is shown" signal.
  Finder get scrollToBottomButton => find.descendant(
    of: find.byType(view),
    matching: find.byWidgetPredicate(
      (widget) => widget is StreamButton && widget.props.isFloating == true,
      description: 'floating scroll-to-bottom button',
    ),
  );

  /// The unread-count badge wrapped around [scrollToBottomButton]. The SDK only
  /// builds it while the count is greater than zero.
  Finder get scrollToBottomUnreadBadge => find.descendant(
    of: find.byType(view),
    matching: find.byType(StreamBadgeNotification),
  );

  /// The "… is typing" text of [StreamTypingIndicator]. The indicator widget is
  /// always mounted (it renders an empty child when nobody types), so presence
  /// is detected by its text, not by the widget type.
  Finder get typingIndicator => find.textContaining('is typing');

  /// The placeholder shown in place of a soft-deleted message
  /// (`messageDeletedLabel`). The `StreamMessageDeleted` widget is not exported,
  /// so it is located by its label.
  Finder get deletedMessage => find.text('Message deleted');

  /// The "Edited" footnote under an edited message (`editedMessageLabel`).
  Finder get editedLabel => find.text('Edited');

  /// The timestamps under the message rows. The SDK only builds a footer for the
  /// last message of a group, so the count is the number of message groups.
  Finder get timestamps => find.descendant(
    of: find.byType(StreamMessageItem),
    matching: find.byType(StreamTimestamp),
  );

  /// The annotation above a thread reply that was also sent to the channel:
  /// `repliedToThreadAnnotationLabel` on the in-channel copy,
  /// `alsoSentInChannelAnnotationLabel` inside the thread.
  Finder showInChannelAnnotation({required bool inThread}) =>
      find.text(inThread ? 'Also sent in channel' : 'Replied to a thread');

  /// The "Pinned by …" annotation above a pinned message.
  Finder pinnedLabel({String? pinnedBy}) =>
      pinnedBy == null ? find.textContaining('Pinned by') : find.text('Pinned by $pinnedBy');

  /// The separator above the first unread message.
  Finder get unreadSeparator => find.byType(UnreadMessagesSeparator);

  /// The floating "N unread" pill that jumps to the first unread message.
  Finder get jumpToUnreadButton => find.byType(UnreadIndicatorButton);

  /// The jump area ("N unread" label) and the dismiss ("x") button of
  /// [jumpToUnreadButton], in that order.
  Finder get jumpToUnreadButtonParts => find.descendant(of: jumpToUnreadButton, matching: find.byType(StreamButton));

  /// A rendered URL preview card on a message.
  Finder get linkPreview => find.byType(StreamLinkPreviewAttachment);

  /// The "N replies" footer under a message that has thread replies. It only
  /// renders on messages whose `replyCount > 0` (i.e. thread parents), and
  /// tapping it opens the thread.
  Finder get threadReplies => find.byType(StreamMessageReplies);

  /// The banner between a thread's parent message and its replies. It is the
  /// second-to-last row, so it only renders at the top of the thread.
  /// `ThreadSeparator` is not exported, hence matching on the runtime type.
  Finder get threadSeparator => find.byWidgetPredicate((it) => it.runtimeType.toString() == 'ThreadSeparator');

  /// The row the thread view renders its parent message in, on top of the
  /// replies. Reply rows are keyed by their message id; the parent row is the
  /// one thread-root row without a key, which tells it apart from a duplicate
  /// copy of the parent among the replies.
  Finder get threadParent => find.byWidgetPredicate(
    (widget) => widget is StreamMessageItem && widget.key == null && widget.props.message.parentId == null,
    description: 'thread parent row',
  );

  /// The badge the SDK overlays on a message that failed to send (or bounced).
  /// `StreamMessageItem` only builds it while the message is in a failed state,
  /// so its presence *is* the failure indicator.
  Finder get errorBadge => find.byType(StreamErrorBadge);

  /// The delivery-status icon on one of the current user's own messages.
  ///
  /// The glyph itself comes from the theme's icon set, so the status is matched
  /// against what the SDK handed [StreamSendingIndicator] rather than against
  /// the rendered icon.
  Finder sendingStatus(MessageDeliveryStatus status) {
    bool hasStatus(StreamSendingIndicator it) {
      final state = it.message.state;
      // The indicator picks its branch by priority — read, then delivered, then
      // the message's own state — and `isCompleted` does not revert once the
      // message is later delivered or read. So every state-based case has to
      // rule those two flags out, or a read message would match `sent` too.
      final unacknowledged = !it.isMessageRead && !it.isMessageDelivered;
      switch (status) {
        case MessageDeliveryStatus.read:
          return it.isMessageRead;
        case MessageDeliveryStatus.delivered:
          return !it.isMessageRead && it.isMessageDelivered;
        case MessageDeliveryStatus.pending:
          return unacknowledged && state.isOutgoing;
        case MessageDeliveryStatus.sent:
          return unacknowledged && state.isCompleted;
        case MessageDeliveryStatus.failed:
          return state.isFailed;
        case MessageDeliveryStatus.nil:
          // No branch of the indicator applies, so it renders nothing. A failed
          // message also lands here — [errorBadge] is what marks that one.
          return unacknowledged && !state.isCompleted && !state.isOutgoing;
      }
    }

    return find.byWidgetPredicate(
      (widget) => widget is StreamSendingIndicator && hasStatus(widget),
      description: 'sending indicator with status ${status.name}',
    );
  }
}
