import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/event_type.dart';

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
  return switch (event.type) {
    EventType.pollVoteCasted ||
    EventType.pollVoteChanged when event.pollVote?.isAnswer == true =>
      event.copyWith(type: EventType.pollAnswerCasted),
    _ => null,
  };
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
  return switch (event.type) {
    EventType.pollVoteRemoved when event.pollVote?.isAnswer == true =>
      event.copyWith(type: EventType.pollAnswerRemoved),
    _ => null,
  };
}
