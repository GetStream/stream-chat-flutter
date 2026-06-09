import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'stream_channel_list_item_theme.g.theme.dart';

/// Predefined attribute positions for [StreamChannelListTile].
///
/// Each position controls where the channel attribute icons are rendered
/// within the tile.
///
/// See also:
///
///  * [StreamChannelListTile], which uses these position variants.
///  * [StreamChannelListItemThemeData.attributePosition], for setting a
///    global default position.
enum AttributePosition {
  /// Inline with the channel name in the title row.
  inlineTitle,

  /// At the trailing end of the subtitle row.
  trailingBottom,
}

/// Applies a channel list item theme to descendant
/// [StreamChannelListItem] widgets.
///
/// Wrap a subtree with [StreamChannelListItemTheme] to override styling.
/// Access the merged theme using [BuildContext.streamChannelListItemTheme].
///
/// {@tool snippet}
///
/// Override channel list item colors for a specific section:
///
/// ```dart
/// StreamChannelListItemTheme(
///   data: StreamChannelListItemThemeData(
///     backgroundColor: Colors.grey.shade50,
///   ),
///   child: StreamChannelListItem(
///     avatar: StreamAvatar(...),
///     title: 'General',
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamChannelListItemThemeData], which describes the theme.
///  * [StreamChannelListItem], the widget affected by this theme.
class StreamChannelListItemTheme extends InheritedTheme {
  /// Creates a channel list item theme that controls descendant widgets.
  const StreamChannelListItemTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The channel list item theme data for descendant widgets.
  final StreamChannelListItemThemeData data;

  /// Returns the [StreamChannelListItemThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamChannelListItemTheme] ancestor
  /// take precedence over global values from [StreamTheme.of].
  static StreamChannelListItemThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamChannelListItemTheme>();
    return StreamChatTheme.of(context).channelListItemTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamChannelListItemTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamChannelListItemTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamChannelListItem] widgets.
///
/// {@tool snippet}
///
/// Customize channel list item appearance globally:
///
/// ```dart
/// StreamTheme(
///   channelListItemTheme: StreamChannelListItemThemeData(
///     backgroundColor: Colors.white,
///     borderColor: Colors.grey.shade200,
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamChannelListItem], the widget that uses this theme data.
///  * [StreamChannelListItemTheme], for overriding theme in a widget subtree.
@themeGen
@immutable
class StreamChannelListItemThemeData with _$StreamChannelListItemThemeData {
  /// Creates a channel list item theme with optional style overrides.
  const StreamChannelListItemThemeData({
    this.titleStyle,
    this.subtitleStyle,
    this.timestampStyle,
    this.backgroundColor,
    this.borderColor,
    this.attributePosition,
  });

  /// The text style for the channel title.
  ///
  /// Falls back to [StreamTextTheme.headingSm] with [StreamColorScheme.textPrimary].
  final TextStyle? titleStyle;

  /// The text style for the message preview subtitle.
  ///
  /// Falls back to [StreamTextTheme.captionDefault] with [StreamColorScheme.textSecondary].
  final TextStyle? subtitleStyle;

  /// The text style for the timestamp.
  ///
  /// Falls back to [StreamTextTheme.captionDefault] with [StreamColorScheme.textTertiary].
  final TextStyle? timestampStyle;

  /// Defines the default background color of the tile.
  ///
  /// This color is resolved from [WidgetState]s.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// The bottom border color of the list item.
  ///
  /// Falls back to [StreamColorScheme.borderSubtle].
  final Color? borderColor;

  /// Position of channel attribute icons.
  ///
  /// Defaults to [AttributePosition.inlineTitle].
  final AttributePosition? attributePosition;

  /// Linearly interpolate between two [StreamChannelListItemThemeData] objects.
  static StreamChannelListItemThemeData? lerp(
    StreamChannelListItemThemeData? a,
    StreamChannelListItemThemeData? b,
    double t,
  ) => _$StreamChannelListItemThemeData.lerp(a, b, t);
}
