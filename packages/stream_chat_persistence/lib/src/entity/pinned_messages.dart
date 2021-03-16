import 'package:moor/moor.dart';

import 'package:stream_chat_persistence/src/entity/messages.dart';

/// Represents a [PinnedMessages] table in [MoorChatDatabase].
@DataClassName('PinnedMessageEntity')
class PinnedMessages extends Messages {}
