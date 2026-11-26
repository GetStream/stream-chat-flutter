import 'package:freezed_annotation/freezed_annotation.dart';

import '../events/message_events.dart';

part 'mark_read_response.freezed.dart';

/// The result of marking channels or a thread as read.
///
/// See also:
///
///  * [StreamChatClient.markChannelRead], [StreamChatClient.markThreadRead]
///    and [StreamChatClient.markAllRead], which return it.
///  * [Channel.markRead] and [Channel.markThreadRead], which return it too.
@freezed
class MarkReadResponse with _$MarkReadResponse {
  /// Creates a new [MarkReadResponse].
  const MarkReadResponse({
    required this.duration,
    this.event,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The event announcing the read, or null when there is none, such as when
  /// [Channel.markRead] only updates the local unread count.
  @override
  final MessageReadEvent? event;
}
