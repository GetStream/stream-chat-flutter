// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/entity/pinned_messages.dart';
import 'package:stream_chat_persistence/src/entity/reactions.dart';

/// Represents a [PinnedMessageReactions] table in [MoorChatDatabase].
@DataClassName('PinnedMessageReactionEntity')
class PinnedMessageReactions extends Reactions {
  /// The messageId to which the reaction belongs
  @override
  TextColumn get messageId =>
      text().references(PinnedMessages, #id, onDelete: KeyAction.cascade)();
}
