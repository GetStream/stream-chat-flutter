import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_channel.dart';

/// Widget to show the current list of typing users
class TypingIndicator extends StatelessWidget {
  /// Instantiate a new TypingIndicator
  const TypingIndicator({
    Key key,
    this.channel,
    this.alternativeWidget,
    this.style,
    this.alignment = Alignment.centerLeft,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  /// Style of the text widget
  final TextStyle style;

  /// List of typing users
  final Channel channel;

  /// Widget built when no typings is happening
  final Widget alternativeWidget;

  /// The padding of this widget
  final EdgeInsets padding;

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final channelState =
        channel?.state ?? StreamChannel.of(context).channel.state;
    return StreamBuilder<List<User>>(
      initialData: channelState.typingEvents,
      stream: channelState.typingEventsStream,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: snapshot.data?.isNotEmpty == true
              ? Padding(
                  padding: padding,
                  child: Align(
                    key: Key('typings'),
                    alignment: alignment,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'animations/typing_dots.json',
                          package: 'stream_chat_flutter',
                          height: 4,
                        ),
                        Text(
                          '  ${snapshot.data[0].name}${snapshot.data.length == 1 ? '' : ' and ${snapshot.data.length - 1} more'} ${snapshot.data.length == 1 ? 'is' : 'are'} typing',
                          maxLines: 1,
                          style: style,
                        ),
                      ],
                    ),
                  ),
                )
              : Align(
                  key: Key('alternative'),
                  alignment: alignment,
                  child: Container(
                    child: alternativeWidget ?? Offstage(),
                  ),
                ),
        );
      },
    );
  }
}
