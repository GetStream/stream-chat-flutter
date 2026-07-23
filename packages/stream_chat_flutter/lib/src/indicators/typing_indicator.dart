import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamTypingIndicator}
/// Shows the list of user who are actively typing.
/// {@endtemplate}
class StreamTypingIndicator extends StatelessWidget {
  /// {@macro streamTypingIndicator}
  const StreamTypingIndicator({
    super.key,
    this.channel,
    this.alternativeWidget,
    this.style,
    this.padding = EdgeInsets.zero,
    this.parentId,
  });

  /// Style of the text widget
  final TextStyle? style;

  /// List of typing users
  final Channel? channel;

  /// The widget to build when no typing is happening
  final Widget? alternativeWidget;

  /// The padding of this widget
  final EdgeInsets padding;

  /// Id of the parent message in case of a thread
  final String? parentId;

  // Compares the typing users by id so the indicator only rebuilds when the
  // set of typing users changes. The stream maps to a new list on every typing
  // event (and on the stale-typing cleanup), so identity equality would rebuild
  // even when the same users are still typing. Order-sensitive because only the
  // first user is shown by name.
  bool _typingUsersEquals(List<User>? previous, List<User>? current) {
    final previousIds = previous?.map((it) => it.id) ?? const <String>[];
    final currentIds = current?.map((it) => it.id) ?? const <String>[];
    return const IterableEquality<String>().equals(previousIds, currentIds);
  }

  // Keeps only the users typing in the same context as this indicator: the
  // thread identified by [parentId], or the main channel when it's null.
  List<User> _typingUsers(Map<User, Event> typingEvents) {
    return typingEvents.entries.where((element) => element.value.parentId == parentId).map((e) => e.key).toList();
  }

  @override
  Widget build(BuildContext context) {
    final channelState = channel?.state ?? StreamChannel.of(context).channel.state!;

    final altWidget = alternativeWidget ?? const Empty();

    return BetterStreamBuilder<List<User>>(
      initialData: _typingUsers(channelState.typingEvents),
      stream: channelState.typingEventsStream.map(_typingUsers),
      comparator: _typingUsersEquals,
      builder: (context, users) => AnimatedSwitcher(
        layoutBuilder: (currentChild, previousChildren) => Stack(
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        ),
        duration: const Duration(milliseconds: 300),
        child: users.isNotEmpty
            ? Padding(
                padding: padding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Flexible(
                      child: Text(
                        context.translations.userTypingText(users),
                        maxLines: 1,
                        style: style,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Lottie.asset(
                        'lib/assets/animations/typing_dots.json',
                        package: 'stream_chat_flutter',
                        height: 5,
                      ),
                    ),
                  ],
                ),
              )
            : altWidget,
      ),
    );
  }
}
