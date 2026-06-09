import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'message_list_view_theme.g.theme.dart';

/// Applies a message-list-view theme to descendant [StreamMessageListView]
/// widgets.
///
/// Wrap a subtree with [StreamMessageListViewTheme] to override the styling of
/// the message list background and highlight colour. Access the merged theme
/// using [StreamMessageListViewTheme.of].
///
/// {@tool snippet}
///
/// Override message-list-view styling for a specific section:
///
/// ```dart
/// StreamMessageListViewTheme(
///   data: StreamMessageListViewThemeData(
///     backgroundColor: Colors.grey.shade100,
///     messageHighlightColor: Colors.yellow.withOpacity(0.3),
///   ),
///   child: StreamMessageListView(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMessageListViewThemeData], which describes the theme data.
///  * [StreamMessageListView], the widget affected by this theme.
class StreamMessageListViewTheme extends InheritedTheme {
  /// Creates a message-list-view theme that controls descendant widgets.
  const StreamMessageListViewTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The message-list-view theme data for descendant widgets.
  final StreamMessageListViewThemeData data;

  /// Returns the [StreamMessageListViewThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamMessageListViewTheme] ancestor take
  /// precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides — for example, overriding only
  /// [StreamMessageListViewThemeData.backgroundColor] while inheriting other
  /// properties from the global theme.
  static StreamMessageListViewThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamMessageListViewTheme>();
    return StreamChatTheme.of(context).messageListViewTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamMessageListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamMessageListViewTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamMessageListView] widgets.
///
/// All fields are nullable. When a field is null, the consuming widget falls
/// back to a default derived from the ambient [StreamChatThemeData].
///
/// {@tool snippet}
///
/// Customize message-list-view appearance globally:
///
/// ```dart
/// StreamChatThemeData(
///   messageListViewTheme: StreamMessageListViewThemeData(
///     backgroundColor: Colors.grey.shade100,
///     messageHighlightColor: Colors.yellow.withOpacity(0.3),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMessageListView], the widget that uses this theme data.
///  * [StreamMessageListViewTheme], for overriding theme in a widget subtree.
@themeGen
@immutable
class StreamMessageListViewThemeData with _$StreamMessageListViewThemeData {
  /// Creates message-list-view theme data with optional style overrides.
  const StreamMessageListViewThemeData({
    this.backgroundColor,
    this.backgroundImage,
    this.messageHighlightColor,
  });

  /// The background color of the [StreamMessageListView].
  ///
  /// If null, the list view uses the ambient scaffold background color.
  final Color? backgroundColor;

  /// A background image rendered behind the message list.
  ///
  /// If null, no background image is shown.
  final DecorationImage? backgroundImage;

  /// The highlight color used when jumping to and highlighting a message.
  ///
  /// If null, falls back to the color scheme's `backgroundHighlight` color.
  final Color? messageHighlightColor;

  /// Linearly interpolate between two [StreamMessageListViewThemeData] objects.
  static StreamMessageListViewThemeData? lerp(
    StreamMessageListViewThemeData? a,
    StreamMessageListViewThemeData? b,
    double t,
  ) => _$StreamMessageListViewThemeData.lerp(a, b, t);
}
