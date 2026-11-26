import 'package:freezed_annotation/freezed_annotation.dart';

import '../events/chat_event.dart';

part 'event_response.freezed.dart';

/// The result of sending an event to a channel.
///
/// See also:
///
///  * [StreamChatClient.sendEvent] and [Channel.sendEvent], which return it.
@freezed
class EventResponse with _$EventResponse {
  /// Creates a new [EventResponse].
  const EventResponse({
    required this.duration,
    required this.event,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The event that was sent.
  ///
  /// An event with a custom type comes back as an [UnknownEvent].
  @override
  final ChatEvent event;
}
