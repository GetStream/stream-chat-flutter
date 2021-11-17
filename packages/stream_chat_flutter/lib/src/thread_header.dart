import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/thread_header.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/thread_header_paint.png)
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
/// Make sure to have a [StreamChannel] ancestor in order to provide the
/// information about the channel.
/// Every part of the widget uses a [StreamBuilder] to render the channel
/// information as soon as it updates.
///
/// By default the widget shows a backButton that calls [Navigator.pop].
/// You can disable this button using the [showBackButton] property of just
/// override the behaviour
/// with [onBackPressed].
///
/// The widget components render the ui based on the first ancestor of type
/// [StreamChatTheme] and on its [ChannelTheme.channelHeaderTheme] property.
/// Modify it to change the widget appearance.
class ThreadHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Instantiate a new ThreadHeader
  const ThreadHeader({
    Key? key,
    required this.parent,
    this.showBackButton = true,
    this.onBackPressed,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.onTitleTap,
    this.showTypingIndicator = true,
    this.backgroundColor,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  /// True if this header shows the leading back button
  final bool showBackButton;

  /// Callback to call when pressing the back button.
  /// By default it calls [Navigator.pop]
  final VoidCallback? onBackPressed;

  /// Callback to call when the title is tapped.
  final VoidCallback? onTitleTap;

  /// The message parent of this thread
  final Message parent;

  /// Title widget
  final Widget? title;

  /// Subtitle widget
  final Widget? subtitle;

  /// Leading widget
  final Widget? leading;

  /// AppBar actions
  final List<Widget>? actions;

  /// If true the typing indicator will be rendered
  /// if a user is typing in this thread
  final bool showTypingIndicator;

  /// The background color of this [ThreadHeader].
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final channelHeaderTheme = ChannelHeaderTheme.of(context);

    final defaultSubtitle = subtitle ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${context.translations.withText} ',
              style: channelHeaderTheme.subtitleStyle,
            ),
            Flexible(
              child: ChannelName(
                textStyle: channelHeaderTheme.subtitleStyle,
              ),
            ),
          ],
        );

    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarTextStyle: theme.textTheme.bodyText2,
      titleTextStyle: theme.textTheme.headline6,
      systemOverlayStyle: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      elevation: 1,
      leading: leading ??
          (showBackButton
              ? StreamBackButton(
                  cid: StreamChannel.of(context).channel.cid,
                  onPressed: onBackPressed,
                  showUnreads: true,
                )
              : const SizedBox()),
      backgroundColor: backgroundColor ?? channelHeaderTheme.color,
      centerTitle: true,
      actions: actions,
      title: InkWell(
        onTap: onTitleTap,
        child: SizedBox(
          height: preferredSize.height,
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title ??
                  Text(
                    context.translations.threadReplyLabel,
                    style: channelHeaderTheme.titleStyle,
                  ),
              const SizedBox(height: 2),
              if (showTypingIndicator)
                Align(
                  child: TypingIndicator(
                    channel: StreamChannel.of(context).channel,
                    style: channelHeaderTheme.subtitleStyle,
                    parentId: parent.id,
                    alternativeWidget: defaultSubtitle,
                  ),
                )
              else
                defaultSubtitle,
            ],
          ),
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
