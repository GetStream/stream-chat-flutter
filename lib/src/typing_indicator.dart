import 'package:flutter/material.dart';
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
  }) : super(key: key);

  /// Style of the text widget
  final TextStyle style;

  /// List of typing users
  final Channel channel;

  /// Widget built when no typings is happening
  final Widget alternativeWidget;

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
              ? Align(
                  key: Key('typings'),
                  alignment: alignment,
                  child: Text(
                    '${snapshot.data.map((u) => u.name).join(',')} ${snapshot.data.length == 1 ? 'is' : 'are'} typing...',
                    maxLines: 1,
                    style: style,
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
