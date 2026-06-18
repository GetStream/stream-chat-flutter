import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/chat.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'poll_option_style.g.theme.dart';

/// Visual styling properties for poll option rows.
///
/// Defines the appearance of individual poll options including text styles,
/// checkbox, progress bar, and voter avatar stack.
///
/// Shared by [StreamPollInteractorThemeData] and
/// [StreamPollOptionsSheetThemeData] so that option rows can be styled
/// consistently (or overridden independently) wherever they are rendered.
///
/// See also:
///
///  * [StreamPollInteractorThemeData], which wraps this style for the inline
///    poll interactor.
///  * [StreamPollOptionsSheetThemeData], which wraps this style for the
///    full-screen options dialog.
@themeGen
@immutable
class StreamPollOptionStyle with _$StreamPollOptionStyle {
  /// Creates poll option style properties.
  const StreamPollOptionStyle({
    this.textStyle,
    this.votesTextStyle,
    this.votesAvatarSize,
    this.checkboxStyle,
    this.progressBarStyle,
  });

  /// The text style for the option label.
  ///
  /// If null, defaults to [StreamTextTheme.captionDefault].
  final TextStyle? textStyle;

  /// The text style for the vote count displayed alongside each option.
  ///
  /// If null, defaults to [StreamTextTheme.metadataDefault].
  final TextStyle? votesTextStyle;

  /// The size of the voter avatar stack shown alongside each option.
  ///
  /// Only visible when the poll has public voting visibility.
  /// If null, defaults to [StreamAvatarStackSize.xs].
  final StreamAvatarStackSize? votesAvatarSize;

  /// The visual styling for the option selection checkbox.
  ///
  /// If null, defaults to a circular checkbox with [StreamCheckboxSize.md].
  final StreamCheckboxStyle? checkboxStyle;

  /// The visual styling for the vote distribution progress bar.
  ///
  /// If null, defaults to a progress bar with accent neutral fill.
  final StreamProgressBarStyle? progressBarStyle;

  /// Linearly interpolate between two [StreamPollOptionStyle] objects.
  static StreamPollOptionStyle? lerp(
    StreamPollOptionStyle? a,
    StreamPollOptionStyle? b,
    double t,
  ) => _$StreamPollOptionStyle.lerp(a, b, t);
}
