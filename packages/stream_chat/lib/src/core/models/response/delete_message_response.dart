import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';

part 'delete_message_response.freezed.dart';

/// The result of deleting a message.
///
/// See also:
///
///  * [StreamChatClient.deleteMessage] and
///    [StreamChatClient.deleteMessageForMe], which return it.
///  * [Channel.deleteMessage] and [Channel.deleteMessageForMe], which return it
///    too.
@freezed
class DeleteMessageResponse with _$DeleteMessageResponse {
  /// Creates a new [DeleteMessageResponse].
  const DeleteMessageResponse({
    required this.duration,
    required this.message,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The message the delete applied to.
  ///
  /// A message deleted only for the current user comes back as the other
  /// members still see it. One that [Channel] only removed locally, because
  /// it was never sent, comes back marked deleted.
  @override
  final Message message;
}
