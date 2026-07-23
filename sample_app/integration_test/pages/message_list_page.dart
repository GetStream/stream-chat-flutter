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
}

final class _Reactions {
  const _Reactions();

  /// Key of a reaction in the reaction picker (message actions modal).
  /// The SDK keys each picker button by its reaction type string.
  Key pickerReaction(ReactionType type) => ValueKey(type.reaction);
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

  /// The confirm button in the delete-confirmation dialog.
  Finder get deleteConfirm => find.text('Delete');
}

final class _MessageList {
  const _MessageList();

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

  /// A rendered URL preview card on a message.
  Finder get linkPreview => find.byType(StreamLinkPreviewAttachment);
}
