import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';

part 'get_many_messages_response.freezed.dart';

/// The result of fetching messages of a channel by their ids.
///
/// See also:
///
///  * [StreamChatClient.getManyMessages] and [Channel.getManyMessages], which
///    return it.
@freezed
class GetManyMessagesResponse with _$GetManyMessagesResponse {
  /// Creates a new [GetManyMessagesResponse].
  const GetManyMessagesResponse({
    required this.duration,
    required this.messages,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The messages that were found, in the order their ids were given.
  ///
  /// A message that does not exist or cannot be shown is left out.
  @override
  final List<Message> messages;
}
