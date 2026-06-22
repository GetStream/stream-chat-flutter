import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/poll_interactor_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template pollHeader}
/// A widget used as the header of a poll.
///
/// Used in [StreamPollInteractor] to display the poll question and voting mode.
///
/// See also:
///
///  * [StreamPollInteractorThemeData.titleTextStyle], for customizing the
///    question text.
///  * [StreamPollInteractorThemeData.subtitleTextStyle], for customizing the
///    voting mode text.
///  * [StreamPollInteractor], the parent widget that uses this header.
/// {@endtemplate}
class PollHeader extends StatelessWidget {
  /// {@macro pollHeader}
  const PollHeader({
    super.key,
    required this.poll,
  });

  /// The poll the header is for.
  final Poll poll;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollInteractorTheme.of(context);
    final defaults = _StreamPollHeaderDefaults(context);

    final spacing = context.streamSpacing;

    final effectiveTitleTextStyle = theme.titleTextStyle ?? defaults.titleTextStyle;
    final effectiveSubtitleTextStyle = theme.subtitleTextStyle ?? defaults.subtitleTextStyle;

    return Padding(
      padding: .all(spacing.md),
      child: Column(
        spacing: spacing.xxs,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(poll.name, style: effectiveTitleTextStyle),
          Text(context.translations.pollVotingModeLabel(poll.votingMode), style: effectiveSubtitleTextStyle),
        ],
      ),
    );
  }
}

// Default values for [StreamPollInteractorThemeData] backed by stream design tokens.
class _StreamPollHeaderDefaults extends StreamPollInteractorThemeData {
  _StreamPollHeaderDefaults(this._context);

  final BuildContext _context;

  late final _alignment = StreamMessageLayout.messageAlignmentOf(_context);
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;
  late final StreamTextTheme _textTheme = _context.streamTextTheme;

  Color get _textColor => switch (_alignment) {
    .start => _colorScheme.textPrimary,
    .end => _colorScheme.brand.shade900,
  };

  @override
  TextStyle get titleTextStyle => _textTheme.bodyEmphasis.copyWith(color: _textColor);

  @override
  TextStyle get subtitleTextStyle => _textTheme.captionDefault.copyWith(color: _textColor);
}
