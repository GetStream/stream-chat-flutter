import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Widget to show the current list of typing users
class TypingIndicator extends StatefulWidget {
  /// Instantiate a new TypingIndicator
  const TypingIndicator({
    Key? key,
    this.channel,
    this.alternativeWidget,
    this.style,
    this.alignment = Alignment.centerLeft,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  /// Style of the text widget
  final TextStyle? style;

  /// List of typing users
  final Channel? channel;

  /// Widget built when no typings is happening
  final Widget? alternativeWidget;

  /// The padding of this widget
  final EdgeInsets padding;

  /// Alignment of the typing indicator
  final Alignment alignment;

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> {
  @override
  Widget build(BuildContext context) {
    final channelState =
        widget.channel?.state ?? StreamChannel.of(context).channel.state!;

    final altWidget = Align(
      key: const Key('alternative'),
      alignment: widget.alignment,
      child: Container(
        child: widget.alternativeWidget ?? const Offstage(),
      ),
    );
    return BetterStreamBuilder<List<User>>(
      initialData: channelState.typingEvents,
      stream: channelState.typingEventsStream,
      builder: (context, snapshot) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: snapshot.isNotEmpty == true
            ? Padding(
                key: const Key('main'),
                padding: widget.padding,
                child: Align(
                  key: const Key('typings'),
                  alignment: widget.alignment,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'animations/typing_dots.json',
                        package: 'stream_chat_flutter',
                        height: 4,
                      ),
                      Text(
                        // ignore: lines_longer_than_80_chars
                        '  ${snapshot[0].name}${snapshot.length == 1 ? '' : ' and ${snapshot.length - 1} more'} ${snapshot.length == 1 ? 'is' : 'are'} typing',
                        maxLines: 1,
                        style: widget.style,
                      ),
                    ],
                  ),
                ),
              )
            : altWidget,
      ),
    );
  }
}
