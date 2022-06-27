import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that displays a user.
///
/// This widget is intended to be used as a Tile in [StreamUserListView]
///
/// It shows the user's avatar, name and last message.
///
/// See also:
/// * [StreamUserListView]
/// * [StreamUserAvatar]
class StreamUserListTile extends StatelessWidget {
  /// Creates a new instance of [StreamUserListTile].
  const StreamUserListTile({
    super.key,
    required this.user,
    this.leading,
    this.title,
    this.subtitle,
    this.selected = false,
    this.selectedWidget,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.visualDensity = VisualDensity.compact,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
  });

  /// The user to display.
  final User user;

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list tile.
  final Widget? title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// A widget to display at the end of tile.
  final Widget? selectedWidget;

  /// If this tile is also [enabled] then icons and text are rendered with the
  /// same color.
  ///
  /// By default the selected color is the theme's primary color. The selected
  /// color can be overridden with a [ListTileTheme].
  ///
  /// {@tool dartpad}
  /// Here is an example of using a [StatefulWidget] to keep track of the
  /// selected index, and using that to set the `selected` property on the
  /// corresponding [ListTile].
  ///
  /// ** See code in examples/api/lib/material/list_tile/list_tile.selected.0.dart **
  /// {@end-tool}
  final bool selected;

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
  StreamUserListTile copyWith({
    Key? key,
    User? user,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? selectedWidget,
    bool? selected,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    Color? tileColor,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? contentPadding,
  }) =>
      StreamUserListTile(
        key: key ?? this.key,
        user: user ?? this.user,
        leading: leading ?? this.leading,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        selectedWidget: selectedWidget ?? this.selectedWidget,
        selected: selected ?? this.selected,
        onTap: onTap ?? this.onTap,
        onLongPress: onLongPress ?? this.onLongPress,
        tileColor: tileColor ?? this.tileColor,
        visualDensity: visualDensity ?? this.visualDensity,
        contentPadding: contentPadding ?? this.contentPadding,
      );

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);

    final leading = this.leading ??
        StreamUserAvatar(
          user: user,
          constraints: const BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        );

    final title = this.title ??
        Text(
          user.name,
          style: chatThemeData.textTheme.bodyBold,
        );

    final subtitle = this.subtitle ??
        UserLastActive(
          user: user,
        );

    final selectedWidget = this.selectedWidget ??
        StreamSvgIcon.checkSend(
          color: chatThemeData.colorTheme.accentPrimary,
        );

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: leading,
      trailing: selected ? selectedWidget : null,
      title: title,
      subtitle: subtitle,
    );
  }
}

/// A widget that displays a user's last active time.
class UserLastActive extends StatelessWidget {
  /// Creates a new instance of the [UserLastActive] widget.
  const UserLastActive({
    super.key,
    required this.user,
  });

  /// The user whose last active time is displayed.
  final User user;

  @override
  Widget build(BuildContext context) {
    final chatTheme = StreamChatTheme.of(context);
    return Text(
      user.online
          ? context.translations.userOnlineText
          : '${context.translations.userLastOnlineText} '
              '${Jiffy(user.lastActive).fromNow()}',
      style: chatTheme.textTheme.footnote.copyWith(
        color: chatTheme.colorTheme.textHighEmphasis.withOpacity(0.5),
      ),
    );
  }
}
