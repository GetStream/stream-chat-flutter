import 'package:freezed_annotation/freezed_annotation.dart';

part 'mark_read_response.freezed.dart';

/// The result of marking channels or a thread as read, returned by
/// [StreamChatClient.markChannelRead], [StreamChatClient.markThreadRead] and
/// [StreamChatClient.markAllRead], and the calls built on them, such as
/// [Channel.markRead].
@freezed
class MarkReadResponse with _$MarkReadResponse {
  /// Creates a new [MarkReadResponse].
  const MarkReadResponse({
    required this.duration,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;
}
