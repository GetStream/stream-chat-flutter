// coverage:ignore-file
import 'package:drift/drift.dart';
import 'messages.dart';

/// Represents a [PinnedMessages] table in [DriftChatDatabase].
@DataClassName('PinnedMessageEntity')
class PinnedMessages extends Messages {}
