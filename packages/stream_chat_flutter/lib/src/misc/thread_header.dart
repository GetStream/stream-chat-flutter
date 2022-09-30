import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamThreadHeader}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/thread_header.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/thread_header_paint.png)
///
/// Shows information about the current message thread.
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
/// A [StreamChannel] ancestor is required in order to provide the
/// information about the channel.
///
/// Every part of the widget uses a [StreamBuilder] to render the channel
/// information as soon as it updates.
///
/// By default the widget shows a backButton that calls [Navigator.pop].
/// You can disable this button using the [showBackButton] property.
/// Alternatively, you can override the behavior with [onBackPressed].
///
/// The UI is rendered based on the first ancestor of type [StreamChatTheme]
/// and the [ChannelTheme.channelHeaderTheme] property. Modify it to change
/// the widget's appearance.
/// {@endtemplate}
class StreamThreadHeader extends StatelessWidget
    implements PreferredSizeWidget {
  /// {@macro streamThreadHeader}
  const StreamThreadHeader({
    super.key,
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
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  /// Whether to show the leading back button.
  ///
  /// Defaults to `true`.
  final bool showBackButton;

  /// The action to perform when pressing the back button.
  ///
  /// By default it calls [Navigator.pop]
  final VoidCallback? onBackPressed;

  /// The action to perform when the title is tapped.
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

  /// {@macro flutter.material.appbar.actions}
  final List<Widget>? actions;

  /// Whether to show the typing indicator if users are currently typing.
  ///
  /// Defaults to `true`.
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
                  channelId: StreamChannel.of(context).channel.cid,
                  onPressed: onBackPressed,
                  showUnreadCount: true,
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
                StreamTypingIndicator(
                  channel: StreamChannel.of(context).channel,
                  style: channelHeaderTheme.subtitleStyle,
                  parentId: parent.id,
                  alternativeWidget: defaultSubtitle,
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
