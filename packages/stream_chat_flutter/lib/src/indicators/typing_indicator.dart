import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  @override
  Widget build(BuildContext context) {
    final channelState =
        channel?.state ?? StreamChannel.of(context).channel.state!;

    final altWidget = alternativeWidget ?? const Offstage();

    return BetterStreamBuilder<Iterable<User>>(
      initialData: channelState.typingEvents.keys,
      stream: channelState.typingEventsStream.map((typingEvents) => typingEvents
          .entries
          .where((element) => element.value.parentId == parentId)
          .map((e) => e.key)),
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
                  children: [
                    Lottie.asset(
                      'animations/typing_dots.json',
                      package: 'stream_chat_flutter',
                      height: 4,
                    ),
                    Text(
                      context.translations.userTypingText(users),
                      maxLines: 1,
                      style: style,
                    ),
                  ],
                ),
              )
            : altWidget,
      ),
    );
  }
}
