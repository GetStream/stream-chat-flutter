import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../../stream_chat_flutter.dart';

/// Signature for building a widget from the users currently typing.
typedef TypingUsersWidgetBuilder = Widget Function(BuildContext context, List<User> users);

/// Builds a widget from the users typing in a channel or thread.
///
/// The [builder] runs with the users typing in [channel], or in the thread of
/// [parentId], whenever those users change. Nobody typing gives an empty list.
///
/// ```dart
/// StreamTypingUsersBuilder(
///   builder: (context, users) {
///     if (users.isEmpty) return const SizedBox.shrink();
///     return Text(context.translations.userTypingText(users));
///   },
/// )
/// ```
class StreamTypingUsersBuilder extends StatelessWidget {
  /// Creates a builder for the users typing in [channel] or a thread of it.
  const StreamTypingUsersBuilder({
    super.key,
    this.channel,
    this.parentId,
    required this.builder,
  });

  /// The channel to watch.
  ///
  /// If null, uses the closest [StreamChannel].
  final Channel? channel;

  /// The parent message id of the thread to watch.
  ///
  /// If null, watches the channel itself.
  final String? parentId;

  /// Builds the widget from the users currently typing.
  final TypingUsersWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final effectiveChannel = channel ?? StreamChannel.of(context).channel;
    final channelState = effectiveChannel.state;
    assert(channelState != null, 'Channel ${effectiveChannel.cid} is not initialized.');

    if (channelState == null) return builder(context, const []);

    return BetterStreamBuilder<Map<User, Event>>(
      stream: channelState.typingEventsStream,
      initialData: channelState.typingEvents,
      comparator: _hasSameTypingUsers,
      builder: (context, typingEvents) => builder(context, _typingUsersIn(typingEvents)),
    );
  }

  bool _hasSameTypingUsers(Map<User, Event>? previous, Map<User, Event>? current) {
    final previousIds = _typingUsersIn(previous).map((user) => user.id);
    final currentIds = _typingUsersIn(current).map((user) => user.id);
    return const IterableEquality<String>().equals(previousIds, currentIds);
  }

  List<User> _typingUsersIn(Map<User, Event>? typingEvents) {
    if (typingEvents == null || typingEvents.isEmpty) return [];

    return [
      for (final MapEntry(key: user, value: event) in typingEvents.entries)
        if (event.parentId == parentId) user,
    ];
  }
}
