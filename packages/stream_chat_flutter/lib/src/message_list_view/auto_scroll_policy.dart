import 'package:stream_chat/stream_chat.dart';

/// How [StreamMessageListView] reacts when a new message arrives.
///
/// Returned by a [StreamAutoScrollResolver] and consumed by the list to decide
/// whether and how to move to the newest message.
enum StreamAutoScrollBehavior {
  /// Keeps the current scroll position untouched.
  none,

  /// Moves to the newest message instantly, without animation.
  jump,

  /// Animates to the newest message.
  animate,
}

/// The information available when resolving a [StreamAutoScrollBehavior] for a
/// newly arrived message.
///
/// Passed to a [StreamAutoScrollResolver]. Not intended to be constructed
/// directly.
class StreamAutoScrollDetails {
  /// Creates a set of details describing a newly arrived message.
  const StreamAutoScrollDetails({
    required this.message,
    required this.currentUser,
    required this.isAtBottom,
  });

  /// The message that just arrived.
  final Message message;

  /// The currently connected user, or `null` when no user is connected.
  final OwnUser? currentUser;

  /// Whether the message list is currently scrolled to the bottom.
  final bool isAtBottom;

  /// Whether [message] was sent by [currentUser].
  bool get isOwnMessage => message.user?.id == currentUser?.id;
}

/// Signature for resolving the [StreamAutoScrollBehavior] for a newly arrived
/// message in a [StreamMessageListView].
typedef StreamAutoScrollResolver = StreamAutoScrollBehavior Function(StreamAutoScrollDetails details);

/// Controls whether and how [StreamMessageListView] scrolls to the newest
/// message when a new message arrives.
///
/// Assign one of the provided policies to
/// [StreamMessageListViewConfiguration.autoScrollPolicy], or supply a fully
/// custom one via [StreamAutoScrollPolicy.custom]:
///
/// ```dart
/// StreamMessageListView(
///   config: StreamMessageListViewConfiguration(
///     autoScrollPolicy: StreamAutoScrollPolicy.disabled,
///   ),
/// )
/// ```
///
/// See also:
///
///  * [StreamAutoScrollBehavior], which enumerates the possible reactions.
///  * [StreamAutoScrollDetails], which describes the message being reacted to.
abstract class StreamAutoScrollPolicy {
  const StreamAutoScrollPolicy._();

  /// Resolves the behavior using the provided `resolve` function.
  ///
  /// Consider hoisting the function to a field or top-level function rather
  /// than allocating a new closure on each build, so that equal configurations
  /// compare as equal.
  const factory StreamAutoScrollPolicy.custom(StreamAutoScrollResolver resolve) = _CustomAutoScrollPolicy;

  /// Never scrolls automatically, leaving scrolling under the caller's control
  /// (e.g. through [StreamMessageListView.scrollController]).
  static const StreamAutoScrollPolicy disabled = _DisabledAutoScrollPolicy();

  /// Scrolls to the newest message only while the newest message is visible at
  /// the bottom, regardless of who sent it.
  static const StreamAutoScrollPolicy whenAtBottom = _WhenAtBottomAutoScrollPolicy();

  /// Scrolls to the newest message when the current user sends a message, or
  /// when a message from another user arrives while the newest message is
  /// visible at the bottom.
  ///
  /// This is the default policy.
  static const StreamAutoScrollPolicy whenOwnMessageOrAtBottom = _WhenOwnMessageOrAtBottomAutoScrollPolicy();

  /// Resolves the [StreamAutoScrollBehavior] to apply for the given `details`.
  StreamAutoScrollBehavior resolve(StreamAutoScrollDetails details);
}

// Scrolls for the current user's own messages, and for others' only while the
// newest message is visible at the bottom.
class _WhenOwnMessageOrAtBottomAutoScrollPolicy extends StreamAutoScrollPolicy {
  const _WhenOwnMessageOrAtBottomAutoScrollPolicy() : super._();

  @override
  StreamAutoScrollBehavior resolve(StreamAutoScrollDetails details) {
    if (details.isOwnMessage || details.isAtBottom) {
      return StreamAutoScrollBehavior.animate;
    }

    return StreamAutoScrollBehavior.none;
  }
}

// Scrolls only while the newest message is visible at the bottom, regardless
// of who sent the message.
class _WhenAtBottomAutoScrollPolicy extends StreamAutoScrollPolicy {
  const _WhenAtBottomAutoScrollPolicy() : super._();

  @override
  StreamAutoScrollBehavior resolve(StreamAutoScrollDetails details) {
    if (details.isAtBottom) return StreamAutoScrollBehavior.animate;
    return StreamAutoScrollBehavior.none;
  }
}

// Never scrolls automatically; the caller drives scrolling.
class _DisabledAutoScrollPolicy extends StreamAutoScrollPolicy {
  const _DisabledAutoScrollPolicy() : super._();

  @override
  StreamAutoScrollBehavior resolve(StreamAutoScrollDetails details) => StreamAutoScrollBehavior.none;
}

// Delegates the decision to a caller-provided resolver.
class _CustomAutoScrollPolicy extends StreamAutoScrollPolicy {
  const _CustomAutoScrollPolicy(this._resolve) : super._();

  final StreamAutoScrollResolver _resolve;

  @override
  StreamAutoScrollBehavior resolve(StreamAutoScrollDetails details) => _resolve(details);
}
