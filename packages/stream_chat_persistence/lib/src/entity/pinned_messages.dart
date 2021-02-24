import 'package:moor/moor.dart';

import 'messages.dart';

/// Represents a [PinnedMessages] table in [MoorChatDatabase].
@DataClassName('PinnedMessageEntity')
class PinnedMessages extends Messages {}
