import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';

part 'update_message_partial_response.freezed.dart';

/// The result of updating some of a message's fields.
///
/// See also:
///
///  * [StreamChatClient.updateMessagePartial], [StreamChatClient.pinMessage]
///    and [StreamChatClient.unpinMessage], which return it.
///  * [Channel.updateMessagePartial], [Channel.pinMessage] and
///    [Channel.unpinMessage], which return it too.
@freezed
class UpdateMessagePartialResponse with _$UpdateMessagePartialResponse {
  /// Creates a new [UpdateMessagePartialResponse].
  const UpdateMessagePartialResponse({
    required this.duration,
    this.message,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The updated message.
  @override
  final Message? message;
}
