import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'stream_channel_list_item_theme.g.theme.dart';

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
    this.muteIconPosition,
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

  /// The position of the mute icon.
  ///
  /// Falls back to [MuteIconPosition.title].
  final MuteIconPosition? muteIconPosition;

  /// Linearly interpolate between two [StreamChannelListItemThemeData] objects.
  static StreamChannelListItemThemeData? lerp(
    StreamChannelListItemThemeData? a,
    StreamChannelListItemThemeData? b,
    double t,
  ) => _$StreamChannelListItemThemeData.lerp(a, b, t);
}

/// The position of the mute icon.
/// By default the mute icon will be shown directly next to the title.
/// When choosing for subtitle, the mute icon will be shown at the end of the list item.
enum MuteIconPosition {
  /// Top row of the list item, next to the title.
  title,

  /// Bottom row, at the end of the list item.
  subtitle,
}
