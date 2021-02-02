import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'back_button.dart';
import 'channel_name.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/thread_header.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/thread_header_paint.png)
///
/// It shows the current thread information.
///
/// ```dart
/// class ThreadPage extends StatelessWidget {
///   final Message parent;
///
///   ThreadPage({
///     Key key,
///     this.parent,
///   }) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: ThreadHeader(
///         parent: parent,
///       ),
///       body: Column(
///         children: <Widget>[
///           Expanded(
///             child: MessageListView(
///               parentMessage: parent,
///             ),
///           ),
///           MessageInput(
///             parentMessage: parent,
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// Usually you would use this widget as an [AppBar] inside a [Scaffold].
/// However you can also use it as a normal widget.
///
/// Make sure to have a [StreamChannel] ancestor in order to provide the information about the channel.
/// Every part of the widget uses a [StreamBuilder] to render the channel information as soon as it updates.
///
/// By default the widget shows a backButton that calls [Navigator.pop].
/// You can disable this button using the [showBackButton] property of just override the behaviour
/// with [onBackPressed].
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme] and on its [ChannelTheme.channelHeaderTheme] property.
/// Modify it to change the widget appearance.
class ThreadHeader extends StatelessWidget implements PreferredSizeWidget {
  /// True if this header shows the leading back button
  final bool showBackButton;

  /// Callback to call when pressing the back button.
  /// By default it calls [Navigator.pop]
  final VoidCallback onBackPressed;

  /// The message parent of this thread
  final Message parent;

  /// Instantiate a new ThreadHeader
  ThreadHeader({
    Key key,
    @required this.parent,
    this.showBackButton = true,
    this.onBackPressed,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Theme.of(context).brightness,
      elevation: 1,
      leading: showBackButton
          ? StreamBackButton(
              cid: StreamChannel.of(context).channel.cid,
              onPressed: onBackPressed,
              showUnreads: true,
            )
          : SizedBox(),
      backgroundColor:
          StreamChatTheme.of(context).channelTheme.channelHeaderTheme.color,
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Thread Reply',
            style: StreamChatTheme.of(context)
                .channelTheme
                .channelHeaderTheme
                .title,
          ),
          SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'with ',
                style: StreamChatTheme.of(context)
                    .channelTheme
                    .channelHeaderTheme
                    .lastMessageAt,
              ),
              Flexible(
                child: ChannelName(
                  textStyle: StreamChatTheme.of(context)
                      .channelTheme
                      .channelHeaderTheme
                      .lastMessageAt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  final Size preferredSize;
}
