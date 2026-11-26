import 'package:stream_chat/stream_chat.dart';
import '../db/drift_chat_database.dart';

/// Useful mapping functions for [ConnectionEventEntity]
extension ConnectionEventX on ConnectionEventEntity {
  /// The current user the row stores, or null when it stores none.
  OwnUser? toOwnUser() => switch (ownUser) {
    final json? => OwnUser.fromJson(json),
    null => null,
  };
}
