import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/poll_card_style.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_style.dart';
import 'package:stream_chat_flutter/src/theme/poll_question_style.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/chat.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'poll_options_sheet_theme.g.theme.dart';

/// Applies a poll options sheet theme to descendant [StreamPollOptionsSheet]
/// widgets.
///
/// Wrap a subtree with [StreamPollOptionsSheetTheme] to override the
/// options sheet styling. Access the merged theme using
/// [StreamPollOptionsSheetTheme.of].
///
/// {@tool snippet}
///
/// Override options sheet styling for a specific route:
///
/// ```dart
/// StreamPollOptionsSheetTheme(
///   data: StreamPollOptionsSheetThemeData(
///     questionStyle: StreamPollQuestionStyle(
///       textStyle: TextStyle(fontWeight: FontWeight.w700),
///     ),
///     optionsCardStyle: StreamPollCardStyle(
///       backgroundColor: Colors.white,
///     ),
///   ),
///   child: StreamPollOptionsSheet(poll: poll),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollOptionsSheetThemeData], which describes the options sheet
///    theme.
///  * [StreamPollOptionsSheet], the widget affected by this theme.
class StreamPollOptionsSheetTheme extends InheritedTheme {
  /// Creates a poll options sheet theme that controls descendant widgets.
  const StreamPollOptionsSheetTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The poll options sheet theme data for descendant widgets.
  final StreamPollOptionsSheetThemeData data;

  /// Returns the [StreamPollOptionsSheetThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamPollOptionsSheetTheme] ancestor
  /// take precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides — for example, overriding only
  /// [StreamPollOptionsSheetThemeData.backgroundColor] while inheriting
  /// other properties from the global theme.
  static StreamPollOptionsSheetThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamPollOptionsSheetTheme>();
    return StreamChatTheme.of(context).pollOptionsSheetTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamPollOptionsSheetTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollOptionsSheetTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamPollOptionsSheet] widgets.
///
/// Covers the sheet surface, the "Question" card, and the options card.
///
/// {@tool snippet}
///
/// Customize the options sheet appearance globally:
///
/// ```dart
/// StreamChatThemeData(
///   pollOptionsSheetTheme: StreamPollOptionsSheetThemeData(
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
///  * [StreamPollOptionsSheet], the widget that uses this theme data.
///  * [StreamPollOptionsSheetTheme], for overriding theme in a widget
///    subtree.
///  * [StreamPollQuestionStyle], the nested style describing the question
///    card surface (chrome + header + body text).
///  * [StreamPollCardStyle], the nested style describing the options card
///    chrome.
///  * [StreamPollOptionStyle], the nested style describing each option row.
@themeGen
@immutable
class StreamPollOptionsSheetThemeData with _$StreamPollOptionsSheetThemeData {
  /// Creates poll options sheet theme data with optional style overrides.
  const StreamPollOptionsSheetThemeData({
    this.backgroundColor,
    this.contentPadding,
    this.sectionSpacing,
    this.sheetHeaderStyle,
    this.questionStyle,
    this.optionsCardStyle,
    this.optionsItemSpacing,
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

  /// The padding around the sheet's scrollable content.
  ///
  /// If null, defaults to `EdgeInsets.all(StreamSpacing.md)`.
  final EdgeInsetsGeometry? contentPadding;

  /// The vertical gap between the question card and the options card.
  ///
  /// If null, defaults to `StreamSpacing.xxl`.
  final double? sectionSpacing;

  /// The visual styling for the question card surface (chrome + header
  /// label + question body text).
  ///
  /// When null, the sheet falls back to its token-backed defaults.
  final StreamPollQuestionStyle? questionStyle;

  /// The visual styling for the options card surface that wraps the poll
  /// options list.
  ///
  /// Controls the card background color, corner radius, and inner padding.
  final StreamPollCardStyle? optionsCardStyle;

  /// The vertical spacing between individual poll option rows inside the
  /// options card.
  ///
  /// Forwarded to [PollOptionsListView.spacing]. If null, the list view
  /// falls back to its own token-backed default.
  final double? optionsItemSpacing;

  /// The visual styling applied to each poll option row rendered inside the
  /// sheet.
  ///
  /// When non-null, the sheet scopes this value onto the descendant
  /// [StreamPollInteractorTheme] so that [PollOptionItem] picks it up
  /// without the options list needing to know about the sheet theme.
  ///
  /// When null, option rows inherit styling from the surrounding
  /// [StreamPollInteractorTheme] (or its token-backed defaults).
  final StreamPollOptionStyle? optionStyle;

  /// Linearly interpolate between two [StreamPollOptionsSheetThemeData]
  /// objects.
  static StreamPollOptionsSheetThemeData? lerp(
    StreamPollOptionsSheetThemeData? a,
    StreamPollOptionsSheetThemeData? b,
    double t,
  ) => _$StreamPollOptionsSheetThemeData.lerp(a, b, t);
}
