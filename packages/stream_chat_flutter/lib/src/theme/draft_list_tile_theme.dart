import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';

/// {@template streamDraftListTileTheme}
/// Overrides the default style of [StreamDraftListTile] descendants.
///
/// See also:
///
///  * [StreamDraftListTileThemeData], which is used to configure this
///    theme.
/// {@endtemplate}
class StreamDraftListTileTheme extends InheritedTheme {
  /// Creates a [StreamDraftListTileTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamDraftListTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamDraftListTileThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamDraftListTileTheme] widget, then
  /// [StreamChatThemeData.draftListTileTheme] is used.
  static StreamDraftListTileThemeData of(BuildContext context) {
    final draftListTileTheme = context.dependOnInheritedWidgetOfExactType<StreamDraftListTileTheme>();
    return draftListTileTheme?.data ?? StreamChatTheme.of(context).draftListTileTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamDraftListTileTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamDraftListTileTheme oldWidget) => data != oldWidget.data;
}

/// {@template streamDraftListTileThemeData}
/// A style that overrides the default appearance of
/// [StreamDraftListTile] widgets when used with
/// [StreamDraftListTileTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.draftListTileTheme].
/// {@endtemplate}
class StreamDraftListTileThemeData with Diagnosticable {
  /// {@macro streamDraftListTileThemeData}
  const StreamDraftListTileThemeData({
    this.padding,
    this.backgroundColor,
    this.draftChannelNameStyle,
    this.draftMessageStyle,
    this.draftTimestampStyle,
    this.draftTimestampFormatter,
  });

  /// The padding around the [StreamDraftListTile] widget.
  final EdgeInsetsGeometry? padding;

  /// The background color of the [StreamDraftListTile] widget.
  final Color? backgroundColor;

  /// The style of the channel name in the [StreamDraftListTile] widget.
  final TextStyle? draftChannelNameStyle;

  /// The style of the draft message in the [StreamDraftListTile] widget.
  final TextStyle? draftMessageStyle;

  /// The style of the draft timestamp in the [StreamDraftListTile] widget.
  final TextStyle? draftTimestampStyle;

  /// Formatter for the draft timestamp.
  ///
  /// If null, uses the default date formatting.
  ///
  /// Example:
  /// ```dart
  /// StreamDraftListTileThemeData(
  ///   draftTimestampStyle: TextStyle(...),
  ///   draftTimestampFormatter: (context, date) {
  ///     return Jiffy.parseFromDateTime(date).fromNow(); // "2 hours ago"
  ///   },
  /// )
  /// ```
  final DateFormatter? draftTimestampFormatter;

  /// A copy of [StreamDraftListTileThemeData] with specified attributes
  /// overridden.
  StreamDraftListTileThemeData copyWith({
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    TextStyle? draftChannelNameStyle,
    TextStyle? draftMessageStyle,
    TextStyle? draftTimestampStyle,
    DateFormatter? draftTimestampFormatter,
    Color? draftIconColor,
  }) => StreamDraftListTileThemeData(
    padding: padding ?? this.padding,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    draftChannelNameStyle: draftChannelNameStyle ?? this.draftChannelNameStyle,
    draftMessageStyle: draftMessageStyle ?? this.draftMessageStyle,
    draftTimestampStyle: draftTimestampStyle ?? this.draftTimestampStyle,
    draftTimestampFormatter: draftTimestampFormatter ?? this.draftTimestampFormatter,
  );

  /// Merges this [StreamDraftListTileThemeData] with the [other].
  StreamDraftListTileThemeData merge(
    StreamDraftListTileThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      padding: other.padding,
      backgroundColor: other.backgroundColor,
      draftChannelNameStyle: other.draftChannelNameStyle,
      draftMessageStyle: other.draftMessageStyle,
      draftTimestampStyle: other.draftTimestampStyle,
      draftTimestampFormatter: other.draftTimestampFormatter,
    );
  }

  /// Linearly interpolate between two [StreamDraftListTileThemeData].
  StreamDraftListTileThemeData lerp(
    StreamDraftListTileThemeData? a,
    StreamDraftListTileThemeData? b,
    double t,
  ) => StreamDraftListTileThemeData(
    padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
    backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
    draftChannelNameStyle: TextStyle.lerp(
      a?.draftChannelNameStyle,
      b?.draftChannelNameStyle,
      t,
    ),
    draftMessageStyle: TextStyle.lerp(
      a?.draftMessageStyle,
      b?.draftMessageStyle,
      t,
    ),
    draftTimestampStyle: TextStyle.lerp(
      a?.draftTimestampStyle,
      b?.draftTimestampStyle,
      t,
    ),
    draftTimestampFormatter: t < 0.5 ? a?.draftTimestampFormatter : b?.draftTimestampFormatter,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamDraftListTileThemeData &&
          other.padding == padding &&
          other.backgroundColor == backgroundColor &&
          other.draftChannelNameStyle == draftChannelNameStyle &&
          other.draftMessageStyle == draftMessageStyle &&
          other.draftTimestampStyle == draftTimestampStyle &&
          other.draftTimestampFormatter == draftTimestampFormatter;

  @override
  int get hashCode =>
      padding.hashCode ^
      backgroundColor.hashCode ^
      draftChannelNameStyle.hashCode ^
      draftMessageStyle.hashCode ^
      draftTimestampStyle.hashCode ^
      draftTimestampFormatter.hashCode;
}
