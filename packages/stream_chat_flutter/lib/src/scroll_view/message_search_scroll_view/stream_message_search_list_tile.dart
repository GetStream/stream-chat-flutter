import 'package:flutter/material.dart';
import '../../../stream_chat_flutter.dart';

/// A widget that displays a message search item.
///
/// This widget is intended to be used as a
/// Tile in [StreamMessageSearchListView].
///
/// It displays the message's text, channel, sender, and timestamp.
///
/// See also:
/// * [StreamMessageSearchListView]
/// * [StreamUserAvatar]
class StreamMessageSearchListTile extends StatelessWidget {
  /// Creates a new instance of [StreamMessageSearchListTile].
  const StreamMessageSearchListTile({
    super.key,
    required this.result,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.visualDensity = VisualDensity.compact,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
  });

  /// The search result to display.
  final SearchMessageResult result;

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list tile.
  final Widget? title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// A widget to display at the end of tile.
  final Widget? trailing;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  final GestureLongPressCallback? onLongPress;

  /// {@template flutter.material.ListTile.tileColor}
  /// Defines the background color of `ListTile`.
  ///
  /// When the value is null,
  /// the `tileColor` is set to [ListTileTheme.tileColor]
  /// if it's not null and to [Colors.transparent] if it's null.
  /// {@endtemplate}
  final Color? tileColor;

  /// Defines how compact the list tile's layout will be.
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
  ///    widgets within a [Theme].
  final VisualDensity visualDensity;

  /// The tile's internal padding.
  ///
  /// Insets a [ListTile]'s contents: its [leading], [title], [subtitle],
  /// and [trailing] widgets.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 16.0)` is used.
  final EdgeInsetsGeometry contentPadding;

  /// Creates a copy of this tile but with the given fields replaced with
  /// the new values.
  StreamMessageSearchListTile copyWith({
    Key? key,
    SearchMessageResult? result,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    Color? tileColor,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? contentPadding,
  }) => StreamMessageSearchListTile(
    key: key ?? this.key,
    result: result ?? this.result,
    leading: leading ?? this.leading,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    trailing: trailing ?? this.trailing,
    onTap: onTap ?? this.onTap,
    onLongPress: onLongPress ?? this.onLongPress,
    tileColor: tileColor ?? this.tileColor,
    visualDensity: visualDensity ?? this.visualDensity,
    contentPadding: contentPadding ?? this.contentPadding,
  );

  @override
  Widget build(BuildContext context) {
    final message = result.message;
    final user = message.user!;

    final leading = this.leading ?? StreamUserAvatar(size: .lg, user: user);

    final title =
        this.title ??
        MessageSearchListTileTitle(
          result: result,
          textStyle: context.streamTextTheme.metadataEmphasis.copyWith(overflow: TextOverflow.ellipsis),
        );

    final subtitle =
        this.subtitle ??
        Row(
          children: [
            Expanded(
              child: StreamMessagePreviewText(
                message: message,
                textStyle: context.streamTextTheme.metadataDefault.copyWith(
                  color: context.streamColorScheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            MessageSearchTileMessageDate(
              message: message,
              textStyle: context.streamTextTheme.metadataDefault.copyWith(
                color: context.streamColorScheme.textSecondary,
              ),
            ),
          ],
        );

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      visualDensity: visualDensity,
      contentPadding: contentPadding,
      tileColor: tileColor,
      leading: leading,
      trailing: trailing,
      title: title,
      subtitle: subtitle,
    );
  }
}

/// A widget that displays the title of a [StreamMessageSearchListTile].
class MessageSearchListTileTitle extends StatelessWidget {
  /// Creates a new [MessageSearchListTileTitle] instance.
  const MessageSearchListTileTitle({
    super.key,
    required this.result,
    this.textStyle,
  });

  /// The search result to display the title of.
  final SearchMessageResult result;

  /// The style to use for the title.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final user = result.message.user!;
    final channel = result.channel;
    final channelName = channel?.custom['name'];

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: user.id == StreamChat.of(context).currentUser?.id ? context.translations.youText : user.nameOrId,
          ),
          if (channelName != null) ...[
            TextSpan(
              text: ' ${context.translations.inText} ',
              style: textStyle?.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
            TextSpan(
              text: channelName as String,
            ),
          ],
        ],
      ),
      style: textStyle,
    );
  }
}

/// A widget which shows formatted created date of the passed [message].
class MessageSearchTileMessageDate extends StatelessWidget {
  /// Creates a new instance of [MessageSearchTileMessageDate].
  const MessageSearchTileMessageDate({
    super.key,
    required this.message,
    this.textStyle,
    this.formatter,
  });

  /// The searched message response.
  final Message message;

  /// The text style to use for the date.
  final TextStyle? textStyle;

  /// An optional formatter to format the date.
  final DateFormatter? formatter;

  @override
  Widget build(BuildContext context) {
    final createdAt = message.createdAt;
    return StreamTimestamp(
      date: createdAt.toLocal(),
      style: textStyle,
      formatter: formatter,
    );
  }
}
