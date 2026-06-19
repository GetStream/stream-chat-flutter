import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/poll_card_style.dart';
import 'package:stream_core_flutter/chat.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'poll_option_votes_style.g.theme.dart';

/// Visual styling for a per-option votes card.
///
/// Backs the per-option cards rendered by the `PollVotesByOption*` widget
/// family — used inside [StreamPollResultsSheet] (one card per option, with
/// a preview list of voters and an optional "View all" footer) and inside
/// [StreamPollOptionVotesSheet] (a single card listing every vote cast for
/// the selected option).
///
/// Bundles the card chrome (via [StreamPollCardStyle]) with the text styles
/// for the "Option N" header label, the option body text, and the vote count
/// label, the winner trophy icon, the footer divider color, and the
/// [StreamButtonThemeStyle] applied to the footer action button (e.g.
/// "View all") shown when the number of votes exceeds the configured visible
/// count.
///
/// See also:
///
///  * [StreamPollResultsSheetThemeData], which embeds this style as its
///    per-option card styling.
///  * [StreamPollOptionVotesSheetThemeData], which embeds this style so the
///    votes dialog card matches the results dialog cards visually.
///  * [StreamPollCardStyle], the chrome primitive reused inside [cardStyle].
@themeGen
@immutable
class StreamPollOptionVotesStyle with _$StreamPollOptionVotesStyle {
  /// Creates poll option votes style properties.
  const StreamPollOptionVotesStyle({
    this.cardStyle,
    this.numberTextStyle,
    this.textStyle,
    this.voteCountTextStyle,
    this.winnerIconColor,
    this.winnerIconSize,
    this.footerDividerColor,
    this.footerButtonStyle,
  });

  /// Chrome (background color, corner radius, padding) of the option card.
  ///
  /// If null, defaults are resolved by the consuming dialog theme.
  final StreamPollCardStyle? cardStyle;

  /// The text style for the small "Option N" header label rendered above
  /// the option body text.
  ///
  /// If null, defaults to [StreamTextTheme.headingXs] with
  /// [StreamColorScheme.textTertiary].
  final TextStyle? numberTextStyle;

  /// The text style for the poll option body text.
  ///
  /// If null, defaults to [StreamTextTheme.headingMd] with
  /// [StreamColorScheme.textPrimary].
  final TextStyle? textStyle;

  /// The text style for the per-option vote count label
  /// (e.g. `"12 votes"`) rendered on the trailing edge of the option row.
  ///
  /// If null, defaults to [StreamTextTheme.bodyEmphasis] with
  /// [StreamColorScheme.textPrimary].
  final TextStyle? voteCountTextStyle;

  /// The color applied to the trophy icon shown next to the winning
  /// option's vote count.
  ///
  /// If null, defaults to [StreamColorScheme.textSecondary].
  final Color? winnerIconColor;

  /// The size (in logical pixels) of the trophy icon shown next to the
  /// winning option's vote count.
  ///
  /// If null, defaults to `20`.
  final double? winnerIconSize;

  /// The color of the thin divider rendered between the option row and the
  /// "View all" footer action when the number of votes exceeds the visible
  /// count.
  ///
  /// If null, defaults to [StreamColorScheme.borderDefault].
  final Color? footerDividerColor;

  /// The button styling applied to the footer action (e.g. "View all")
  /// rendered beneath an option when the number of votes exceeds the visible
  /// count.
  ///
  /// Forwarded to [StreamButton.themeStyle]. When null, the button uses its
  /// secondary / ghost / small defaults from [StreamButton].
  final StreamButtonThemeStyle? footerButtonStyle;

  /// Linearly interpolate between two [StreamPollOptionVotesStyle] objects.
  static StreamPollOptionVotesStyle? lerp(
    StreamPollOptionVotesStyle? a,
    StreamPollOptionVotesStyle? b,
    double t,
  ) => _$StreamPollOptionVotesStyle.lerp(a, b, t);
}
