import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Overrides the default style of [StreamDraftListTile] descendants.
class StreamDraftListTileTheme extends InheritedTheme {
  /// Creates a [StreamDraftListTileTheme].
  const StreamDraftListTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamDraftListTileThemeData data;

  /// Returns the closest [StreamDraftListTileThemeData] from the widget tree,
  /// falling back to a default built from the ambient [StreamChatTheme].
  static StreamDraftListTileThemeData of(BuildContext context) {
    final tileTheme = context.dependOnInheritedWidgetOfExactType<StreamDraftListTileTheme>();
    if (tileTheme != null) return tileTheme.data;

    final chatTheme = StreamChatTheme.of(context);
    final colorTheme = chatTheme.colorTheme;
    final textTheme = chatTheme.textTheme;

    return StreamDraftListTileThemeData(
      backgroundColor: colorTheme.barsBg,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      draftChannelNameStyle: textTheme.bodyBold.copyWith(
        color: colorTheme.textHighEmphasis,
      ),
      draftMessageStyle: textTheme.footnote.copyWith(
        color: colorTheme.textLowEmphasis,
      ),
      draftTimestampStyle: textTheme.footnote.copyWith(
        color: colorTheme.textLowEmphasis,
      ),
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamDraftListTileTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamDraftListTileTheme oldWidget) => data != oldWidget.data;
}

/// A style that overrides the default appearance of [StreamDraftListTile]
/// widgets when used with [StreamDraftListTileTheme].
class StreamDraftListTileThemeData with Diagnosticable {
  /// Creates a new [StreamDraftListTileThemeData].
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

  /// Formatter for the draft timestamp. Defaults to a Jiffy-based format.
  final String Function(BuildContext, DateTime)? draftTimestampFormatter;

  /// Returns a copy of this theme with the given fields replaced.
  StreamDraftListTileThemeData copyWith({
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    TextStyle? draftChannelNameStyle,
    TextStyle? draftMessageStyle,
    TextStyle? draftTimestampStyle,
    String Function(BuildContext, DateTime)? draftTimestampFormatter,
  }) => StreamDraftListTileThemeData(
    padding: padding ?? this.padding,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    draftChannelNameStyle: draftChannelNameStyle ?? this.draftChannelNameStyle,
    draftMessageStyle: draftMessageStyle ?? this.draftMessageStyle,
    draftTimestampStyle: draftTimestampStyle ?? this.draftTimestampStyle,
    draftTimestampFormatter: draftTimestampFormatter ?? this.draftTimestampFormatter,
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
