// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/entity/messages.dart';

/// Represents a [PinnedMessages] table in [DriftChatDatabase].
@DataClassName('PinnedMessageEntity')
class PinnedMessages extends Messages {}
