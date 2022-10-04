import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
    required this.messageResponse,
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

  /// The message response to display.
  final GetMessageResponse messageResponse;

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
    GetMessageResponse? messageResponse,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    Color? tileColor,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? contentPadding,
  }) =>
      StreamMessageSearchListTile(
        key: key ?? this.key,
        messageResponse: messageResponse ?? this.messageResponse,
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
    final message = messageResponse.message;
    final user = message.user!;
    final channelPreviewTheme = StreamChannelPreviewTheme.of(context);

    final leading = this.leading ??
        StreamUserAvatar(
          user: user,
          constraints: const BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        );

    final title = this.title ??
        MessageSearchListTileTitle(
          messageResponse: messageResponse,
          textStyle: channelPreviewTheme.titleStyle,
        );

    final subtitle = this.subtitle ??
        Row(
          children: [
            Expanded(
              child: StreamMessagePreviewText(
                message: message,
                textStyle: channelPreviewTheme.subtitleStyle,
              ),
            ),
            const SizedBox(width: 16),
            MessageSearchTileMessageDate(
              message: message,
              textStyle: channelPreviewTheme.lastMessageAtStyle,
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
    required this.messageResponse,
    this.textStyle,
  });

  /// The message response for the tile.
  final GetMessageResponse messageResponse;

  /// The style to use for the title.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final user = messageResponse.message.user!;
    final channel = messageResponse.channel;
    final channelName = channel?.extraData['name'];

    return Row(
      children: [
        Text(
          user.id == StreamChat.of(context).currentUser?.id
              ? context.translations.youText
              : user.name,
          style: textStyle,
        ),
        if (channelName != null) ...[
          Text(
            ' ${context.translations.inText} ',
            style: textStyle?.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            channelName as String,
            style: textStyle,
          ),
        ],
      ],
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
  });

  /// The searched message response.
  final Message message;

  /// The text style to use for the date.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final createdAt = message.createdAt;
    String stringDate;
    final now = DateTime.now();
    if (now.year != createdAt.year ||
        now.month != createdAt.month ||
        now.day != createdAt.day) {
      stringDate = Jiffy(createdAt.toLocal()).yMd;
    } else {
      stringDate = Jiffy(createdAt.toLocal()).jm;
    }

    return Text(
      stringDate,
      style: textStyle,
    );
  }
}
