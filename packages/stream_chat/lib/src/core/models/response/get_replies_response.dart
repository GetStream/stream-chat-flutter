import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';

part 'get_replies_response.freezed.dart';

/// One page of the replies in a thread.
///
/// See also:
///
///  * [StreamChatClient.getReplies] and [Channel.getReplies], which return it.
@freezed
class GetRepliesResponse with _$GetRepliesResponse {
  /// Creates a new [GetRepliesResponse].
  const GetRepliesResponse({
    required this.duration,
    required this.messages,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The replies on this page, oldest first.
  @override
  final List<Message> messages;
}
