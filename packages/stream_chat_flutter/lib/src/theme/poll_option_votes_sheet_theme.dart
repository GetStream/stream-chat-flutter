import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_votes_style.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/chat.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'poll_option_votes_sheet_theme.g.theme.dart';

/// Applies a poll option votes sheet theme to descendant
/// [StreamPollOptionVotesSheet] widgets.
///
/// Wrap a subtree with [StreamPollOptionVotesSheetTheme] to override the
/// votes sheet styling. Access the merged theme using
/// [StreamPollOptionVotesSheetTheme.of].
///
/// {@tool snippet}
///
/// Override votes sheet styling for a specific route:
///
/// ```dart
/// StreamPollOptionVotesSheetTheme(
///   data: StreamPollOptionVotesSheetThemeData(
///     optionStyle: StreamPollOptionVotesStyle(
///       cardStyle: StreamPollCardStyle(backgroundColor: Colors.white),
///     ),
///   ),
///   child: StreamPollOptionVotesSheet(
///     poll: poll,
///     option: option,
///     pollVotesCount: poll.voteCountsByOption[option.id],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollOptionVotesSheetThemeData], which describes the votes
///    sheet theme.
///  * [StreamPollOptionVotesSheet], the widget affected by this theme.
class StreamPollOptionVotesSheetTheme extends InheritedTheme {
  /// Creates a poll option votes sheet theme that controls descendant
  /// widgets.
  const StreamPollOptionVotesSheetTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The poll option votes sheet theme data for descendant widgets.
  final StreamPollOptionVotesSheetThemeData data;

  /// Returns the [StreamPollOptionVotesSheetThemeData] merged from local
  /// and global themes.
  ///
  /// Local values from the nearest [StreamPollOptionVotesSheetTheme]
  /// ancestor take precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides — for example, overriding only
  /// [StreamPollOptionVotesSheetThemeData.backgroundColor] while inheriting
  /// other properties from the global theme.
  static StreamPollOptionVotesSheetThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamPollOptionVotesSheetTheme>();
    return StreamChatTheme.of(context).pollOptionVotesSheetTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamPollOptionVotesSheetTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollOptionVotesSheetTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamPollOptionVotesSheet] widgets.
///
/// Covers the sheet surface and the per-option card that lists every vote
/// cast for the selected option.
///
/// The per-option card reuses [StreamPollOptionVotesStyle] so that the
/// votes sheet visually matches the option cards rendered inside
/// [StreamPollResultsSheet].
///
/// {@tool snippet}
///
/// Customize the votes sheet appearance globally:
///
/// ```dart
/// StreamChatThemeData(
///   pollOptionVotesSheetTheme: StreamPollOptionVotesSheetThemeData(
///     optionStyle: StreamPollOptionVotesStyle(
///       cardStyle: StreamPollCardStyle(backgroundColor: Colors.white),
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollOptionVotesSheet], the widget that uses this theme data.
///  * [StreamPollOptionVotesSheetTheme], for overriding theme in a widget
///    subtree.
///  * [StreamPollOptionVotesStyle], the nested style describing the
///    per-option card, reused from the results sheet.
@themeGen
@immutable
class StreamPollOptionVotesSheetThemeData with _$StreamPollOptionVotesSheetThemeData {
  /// Creates poll option votes sheet theme data with optional style
  /// overrides.
  const StreamPollOptionVotesSheetThemeData({
    this.backgroundColor,
    this.contentPadding,
    this.sheetHeaderStyle,
    this.optionStyle,
  });

  /// The background color of the sheet surface.
  ///
  /// If null, defaults to [StreamColorScheme.backgroundApp].
  final Color? backgroundColor;

  /// The visual styling for the [StreamSheetHeader] rendered at the top of
  /// the sheet.
  ///
  /// Scoped to the sheet's header via an inner [StreamSheetHeaderTheme] so
  /// overrides here do not leak into other sheet headers on the screen.
  /// When null, the header inherits the ambient [StreamSheetHeaderTheme].
  final StreamSheetHeaderStyle? sheetHeaderStyle;

  /// The padding around the sheet's content.
  ///
  /// If null, defaults to `EdgeInsets.all(StreamSpacing.md)`.
  final EdgeInsetsGeometry? contentPadding;

  /// The visual styling for the per-option card rendered as the sheet's
  /// body.
  ///
  /// Controls the card chrome (background, corner radius, inner padding),
  /// the "Option N" header label, the option body text, the vote count
  /// label, and — when the option is the winner — the trophy icon.
  ///
  /// When null, the sheet falls back to its token-backed defaults.
  final StreamPollOptionVotesStyle? optionStyle;

  /// Linearly interpolate between two
  /// [StreamPollOptionVotesSheetThemeData] objects.
  static StreamPollOptionVotesSheetThemeData? lerp(
    StreamPollOptionVotesSheetThemeData? a,
    StreamPollOptionVotesSheetThemeData? b,
    double t,
  ) => _$StreamPollOptionVotesSheetThemeData.lerp(a, b, t);
}
