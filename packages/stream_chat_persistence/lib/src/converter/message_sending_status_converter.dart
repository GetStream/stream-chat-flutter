import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';

/// Maps a [MessageSendingStatus] into a [int] understood
/// by the sqlite backend.
class MessageSendingStatusConverter
    extends TypeConverter<MessageSendingStatus, int> {
  @override
  MessageSendingStatus mapToDart(int fromDb) {
    switch (fromDb) {
      case 0:
        return MessageSendingStatus.sending;
      case 1:
        return MessageSendingStatus.sent;
      case 2:
        return MessageSendingStatus.failed;
      case 3:
        return MessageSendingStatus.updating;
      case 4:
        return MessageSendingStatus.failed_update;
      case 5:
        return MessageSendingStatus.deleting;
      case 6:
        return MessageSendingStatus.failed_delete;
      default:
        return null;
    }
  }

  @override
  int mapToSql(MessageSendingStatus value) {
    switch (value) {
      case MessageSendingStatus.sending:
        return 0;
      case MessageSendingStatus.sent:
        return 1;
      case MessageSendingStatus.failed:
        return 2;
      case MessageSendingStatus.updating:
        return 3;
      case MessageSendingStatus.failed_update:
        return 4;
      case MessageSendingStatus.deleting:
        return 5;
      case MessageSendingStatus.failed_delete:
        return 6;
      default:
        return null;
    }
  }
}
