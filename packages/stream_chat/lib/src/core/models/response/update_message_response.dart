import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';

part 'update_message_response.freezed.dart';

/// The result of updating a message.
///
/// See also:
///
///  * [StreamChatClient.updateMessage] and [Channel.updateMessage], which
///    return it.
@freezed
class UpdateMessageResponse with _$UpdateMessageResponse {
  /// Creates a new [UpdateMessageResponse].
  const UpdateMessageResponse({
    required this.duration,
    required this.message,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The updated message.
  @override
  final Message message;
}
