import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_votes_style.dart';
import 'package:stream_chat_flutter/src/theme/poll_question_style.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/chat.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'poll_results_sheet_theme.g.theme.dart';

/// Applies a poll results sheet theme to descendant [StreamPollResultsSheet]
/// widgets.
///
/// Wrap a subtree with [StreamPollResultsSheetTheme] to override the
/// results sheet styling. Access the merged theme using
/// [StreamPollResultsSheetTheme.of].
///
/// {@tool snippet}
///
/// Override results sheet styling for a specific route:
///
/// ```dart
/// StreamPollResultsSheetTheme(
///   data: StreamPollResultsSheetThemeData(
///     questionStyle: StreamPollQuestionStyle(
///       textStyle: TextStyle(fontWeight: FontWeight.w700),
///     ),
///     optionStyle: StreamPollOptionVotesStyle(
///       cardStyle: StreamPollCardStyle(
///         backgroundColor: Colors.white,
///       ),
///     ),
///   ),
///   child: StreamPollResultsSheet(poll: poll),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollResultsSheetThemeData], which describes the results sheet
///    theme.
///  * [StreamPollResultsSheet], the widget affected by this theme.
class StreamPollResultsSheetTheme extends InheritedTheme {
  /// Creates a poll results sheet theme that controls descendant widgets.
  const StreamPollResultsSheetTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The poll results sheet theme data for descendant widgets.
  final StreamPollResultsSheetThemeData data;

  /// Returns the [StreamPollResultsSheetThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamPollResultsSheetTheme] ancestor
  /// take precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides — for example, overriding only
  /// [StreamPollResultsSheetThemeData.backgroundColor] while inheriting
  /// other properties from the global theme.
  static StreamPollResultsSheetThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamPollResultsSheetTheme>();
    return StreamChatTheme.of(context).pollResultsSheetTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamPollResultsSheetTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollResultsSheetTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamPollResultsSheet] widgets.
///
/// Covers the sheet surface, the "Question" card at the top, and each
/// per-option card that lists the latest votes.
///
/// {@tool snippet}
///
/// Customize the results sheet appearance globally:
///
/// ```dart
/// StreamChatThemeData(
///   pollResultsSheetTheme: StreamPollResultsSheetThemeData(
///     questionStyle: StreamPollQuestionStyle(
///       headerTextStyle: TextStyle(fontWeight: FontWeight.w700),
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollResultsSheet], the widget that uses this theme data.
///  * [StreamPollResultsSheetTheme], for overriding theme in a widget
///    subtree.
///  * [StreamPollQuestionStyle], the nested style describing the question
///    card surface (chrome + header + body text).
///  * [StreamPollOptionVotesStyle], the nested style describing each
///    per-option result card.
@themeGen
@immutable
class StreamPollResultsSheetThemeData with _$StreamPollResultsSheetThemeData {
  /// Creates poll results sheet theme data with optional style overrides.
  const StreamPollResultsSheetThemeData({
    this.backgroundColor,
    this.contentPadding,
    this.sectionSpacing,
    this.sheetHeaderStyle,
    this.questionStyle,
    this.optionsItemSpacing,
    this.optionStyle,
    this.totalVoteCountTextStyle,
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

  /// The padding around the sheet's scrollable content.
  ///
  /// If null, defaults to `EdgeInsets.all(StreamSpacing.md)`.
  final EdgeInsetsGeometry? contentPadding;

  /// The vertical gap between the question card and the per-option results
  /// cards.
  ///
  /// If null, defaults to `StreamSpacing.xxl`.
  final double? sectionSpacing;

  /// The visual styling for the question card surface (chrome + header
  /// label + question body text).
  ///
  /// When null, the sheet falls back to its token-backed defaults.
  final StreamPollQuestionStyle? questionStyle;

  /// The vertical spacing between consecutive per-option results cards.
  ///
  /// If null, defaults to `StreamSpacing.md`.
  final double? optionsItemSpacing;

  /// The visual styling for each per-option results card.
  ///
  /// Controls the card chrome, the "Option N" header label, the option body
  /// text, the vote count label, the winner trophy icon, the footer divider,
  /// and the footer action button (e.g. "View all").
  final StreamPollOptionVotesStyle? optionStyle;

  /// The text style for the total vote count footer shown beneath the
  /// per-option results (e.g. `"14 votes total"`).
  ///
  /// If null, defaults to [StreamTextTheme.bodyDefault] with
  /// [StreamColorScheme.textPrimary].
  final TextStyle? totalVoteCountTextStyle;

  /// Linearly interpolate between two [StreamPollResultsSheetThemeData]
  /// objects.
  static StreamPollResultsSheetThemeData? lerp(
    StreamPollResultsSheetThemeData? a,
    StreamPollResultsSheetThemeData? b,
    double t,
  ) => _$StreamPollResultsSheetThemeData.lerp(a, b, t);
}
