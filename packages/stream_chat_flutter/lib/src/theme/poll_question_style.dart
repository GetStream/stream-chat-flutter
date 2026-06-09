import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/poll_card_style.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'poll_question_style.g.theme.dart';

/// Visual styling for the "Question" card surface used by poll dialogs.
///
/// Bundles the card chrome (via [StreamPollCardStyle]) with the text styles
/// applied to the small "Question" header label and the question body text.
///
/// Shared by [StreamPollOptionsSheetThemeData] and
/// [StreamPollResultsSheetThemeData], which both render a visually identical
/// question card at the top of their scaffold.
///
/// See also:
///
///  * [StreamPollOptionsSheetThemeData], which embeds this style.
///  * [StreamPollResultsSheetThemeData], which embeds this style.
///  * [StreamPollCardStyle], the chrome primitive reused inside [cardStyle].
@themeGen
@immutable
class StreamPollQuestionStyle with _$StreamPollQuestionStyle {
  /// Creates poll question style properties.
  const StreamPollQuestionStyle({
    this.cardStyle,
    this.headerTextStyle,
    this.textStyle,
  });

  /// Chrome (background color, corner radius, padding) of the question card.
  ///
  /// If null, defaults are resolved by the consuming dialog theme (typically
  /// a token-backed [StreamPollCardStyle] wrapped around the question
  /// header + body text).
  final StreamPollCardStyle? cardStyle;

  /// The text style for the small "Question" header label rendered above
  /// the question body text.
  ///
  /// If null, defaults to [StreamTextTheme.headingXs] with
  /// [StreamColorScheme.textTertiary].
  final TextStyle? headerTextStyle;

  /// The text style for the poll question body text.
  ///
  /// If null, defaults to [StreamTextTheme.headingMd] with
  /// [StreamColorScheme.textPrimary].
  final TextStyle? textStyle;

  /// Linearly interpolate between two [StreamPollQuestionStyle] objects.
  static StreamPollQuestionStyle? lerp(
    StreamPollQuestionStyle? a,
    StreamPollQuestionStyle? b,
    double t,
  ) => _$StreamPollQuestionStyle.lerp(a, b, t);
}
