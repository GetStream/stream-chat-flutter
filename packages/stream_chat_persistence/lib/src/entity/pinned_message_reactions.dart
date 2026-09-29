// coverage:ignore-file
import 'package:drift/drift.dart';
import 'pinned_messages.dart';
import 'reactions.dart';

/// Represents a [PinnedMessageReactions] table in [DriftChatDatabase].
@DataClassName('PinnedMessageReactionEntity')
class PinnedMessageReactions extends Reactions {
  /// The messageId to which the reaction belongs
  @override
  TextColumn get messageId => text().nullable().references(PinnedMessages, #id, onDelete: KeyAction.cascade)();
}
