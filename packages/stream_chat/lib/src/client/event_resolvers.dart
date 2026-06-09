import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/event_type.dart';

/// Resolves message new events into more specific `pollCreated` events
/// for easier downstream state handling.
///
/// Applies when:
/// - `event.type` is `messageNew` or `notification.message_new, and
/// - `event.poll` is not null
///
/// Returns a modified event with type `pollCreated`,
/// or `null` if not applicable.
Event? pollCreatedResolver(Event event) {
  final validTypes = {EventType.messageNew, EventType.notificationMessageNew};
  if (!validTypes.contains(event.type)) return null;

  final poll = event.poll;
  if (poll == null) return null;

  // If the event is a message new or notification message new and
  // it contains a poll, we can resolve it to a poll created event.
  return event.copyWith(type: EventType.pollCreated);
}

/// Resolves casted or changed poll vote events into more specific
/// `pollAnswerCasted` events for easier downstream state handling.
///
/// Applies when:
/// - `event.type` is `pollVoteCasted` or `pollVoteChanged`, and
/// - `event.pollVote?.isAnswer == true`
///
/// Returns a modified event with type `pollAnswerCasted`,
/// or `null` if not applicable.
Event? pollAnswerCastedResolver(Event event) {
  final validTypes = {EventType.pollVoteCasted, EventType.pollVoteChanged};
  if (!validTypes.contains(event.type)) return null;

  final pollVote = event.pollVote;
  if (pollVote?.isAnswer != true) return null;

  // If the event is a poll vote casted or changed and it's an answer
  // we can resolve it to a poll answer casted event.
  return event.copyWith(type: EventType.pollAnswerCasted);
}

/// Resolves removed poll vote events into more specific
/// `pollAnswerRemoved` events for easier downstream state handling.
///
/// Applies when:
/// - `event.type` is `pollVoteRemoved`, and
/// - `event.pollVote?.isAnswer == true`
///
/// Returns a modified event with type `pollAnswerRemoved`,
/// or `null` if not applicable.
Event? pollAnswerRemovedResolver(Event event) {
  if (event.type != EventType.pollVoteRemoved) return null;

  final pollVote = event.pollVote;
  if (pollVote?.isAnswer != true) return null;

  // If the event is a poll vote removed and it's an answer
  // we can resolve it to a poll answer removed event.
  return event.copyWith(type: EventType.pollAnswerRemoved);
}

/// Resolves message new events into more specific `locationShared` events
/// for easier downstream state handling.
///
/// Applies when:
/// - `event.type` is `messageNew` or `notification.message_new, and
/// - `event.message.sharedLocation` is not null
///
/// Returns a modified event with type `locationShared`,
/// or `null` if not applicable.
Event? locationSharedResolver(Event event) {
  final validTypes = {EventType.messageNew, EventType.notificationMessageNew};
  if (!validTypes.contains(event.type)) return null;

  final sharedLocation = event.message?.sharedLocation;
  if (sharedLocation == null) return null;

  // If the event is a message new or notification message new and it
  // contains a shared location, we can resolve it to a location shared event.
  return event.copyWith(type: EventType.locationShared);
}

/// Resolves message updated events into more specific `locationUpdated`
/// events for easier downstream state handling.
///
/// Applies when:
/// - `event.type` is `messageUpdated`, and
/// - `event.message.sharedLocation` is not null and not expired
///
/// Returns a modified event with type `locationUpdated`,
/// or `null` if not applicable.
Event? locationUpdatedResolver(Event event) {
  if (event.type != EventType.messageUpdated) return null;

  final sharedLocation = event.message?.sharedLocation;
  if (sharedLocation == null) return null;

  if (sharedLocation.isLive && sharedLocation.isExpired) return null;

  // If the location is static or still active, we can resolve it
  // to a location updated event.
  return event.copyWith(type: EventType.locationUpdated);
}

/// Resolves message updated events into more specific `locationExpired`
/// events for easier downstream state handling.
///
/// Applies when:
/// - `event.type` is `messageUpdated`, and
/// - `event.message.sharedLocation` is not null and expired
///
/// Returns a modified event with type `locationExpired`,
/// or `null` if not applicable.
Event? locationExpiredResolver(Event event) {
  if (event.type != EventType.messageUpdated) return null;

  final sharedLocation = event.message?.sharedLocation;
  if (sharedLocation == null) return null;

  if (sharedLocation.isStatic || sharedLocation.isActive) return null;

  // If the location is live and expired, we can resolve it to a
  // location expired event.
  return event.copyWith(type: EventType.locationExpired);
}
