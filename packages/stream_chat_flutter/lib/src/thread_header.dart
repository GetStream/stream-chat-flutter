import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro thread_header}
@Deprecated("Use 'StreamThreadHeader' instead")
typedef ThreadHeader = StreamThreadHeader;

/// {@template thread_header}
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
/// {@endtemplate}
class StreamThreadHeader extends StatelessWidget
    implements PreferredSizeWidget {
  /// Instantiate a new ThreadHeader
  const StreamThreadHeader({
    Key? key,
    required this.parent,
    this.showBackButton = true,
    this.onBackPressed,
    this.title,
    this.subtitle,
    this.centerTitle,
    this.leading,
    this.actions,
    this.onTitleTap,
    this.showTypingIndicator = true,
    this.backgroundColor,
    this.elevation = 1,
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

  /// Whether the title should be centered
  final bool? centerTitle;

  /// Leading widget
  final Widget? leading;

  /// AppBar actions
  final List<Widget>? actions;

  /// If true the typing indicator will be rendered
  /// if a user is typing in this thread
  final bool showTypingIndicator;

  /// The background color of this [StreamThreadHeader].
  final Color? backgroundColor;

  /// The elevation for this [StreamThreadHeader].
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final effectiveCenterTitle = getEffectiveCenterTitle(
      Theme.of(context),
      actions: actions,
      centerTitle: centerTitle,
    );

    final channelHeaderTheme = StreamChannelHeaderTheme.of(context);

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
              child: StreamChannelName(
                channel: StreamChannel.of(context).channel,
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
      elevation: elevation,
      leading: leading ??
          (showBackButton
              ? StreamBackButton(
                  cid: StreamChannel.of(context).channel.cid,
                  onPressed: onBackPressed,
                  showUnreads: true,
                )
              : const SizedBox()),
      backgroundColor: backgroundColor ?? channelHeaderTheme.color,
      centerTitle: centerTitle,
      actions: actions,
      title: InkWell(
        onTap: onTitleTap,
        child: SizedBox(
          height: preferredSize.height,
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: effectiveCenterTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.stretch,
            children: [
              title ??
                  Text(
                    context.translations.threadReplyLabel,
                    style: channelHeaderTheme.titleStyle,
                  ),
              const SizedBox(height: 2),
              if (showTypingIndicator)
                Align(
                  child: StreamTypingIndicator(
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
