import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/avatar/stream_user_avatar_stack.dart';
import 'package:stream_chat_flutter/src/theme/poll_interactor_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template pollOptionsListView}
/// A widget that displays the list of poll options.
///
/// Used in [StreamPollInteractor] to display the poll options to interact with.
///
/// See also:
///
///  * [PollOptionItem], the widget used to render each individual option.
///  * [StreamPollInteractorThemeData.optionStyle], for customizing option
///    appearance.
///  * [StreamPollInteractor], the parent widget that uses this list.
/// {@endtemplate}
class PollOptionsListView extends StatelessWidget {
  /// {@macro pollOptionsListView}
  const PollOptionsListView({
    super.key,
    required this.poll,
    this.padding,
    this.spacing,
    this.optionStyle,
    this.visibleOptionCount,
    this.onSeeMoreOptions,
    this.onCastVote,
    this.onRemoveVote,
  });

  /// The poll to display the options for.
  final Poll poll;

  /// Padding applied around the list of options.
  ///
  /// If null, defaults to `EdgeInsets.symmetric(horizontal: context.streamSpacing.xs)`.
  final EdgeInsetsGeometry? padding;

  /// The vertical spacing between poll options.
  ///
  /// If null, defaults to `context.streamSpacing.xxxs`.
  final double? spacing;

  /// The style used to render each [PollOptionItem].
  ///
  /// If null, defaults to [StreamPollInteractorThemeData.optionStyle].
  final StreamPollOptionStyle? optionStyle;

  /// The number of visible options in the poll.
  ///
  /// If null, all options will be visible.
  final int? visibleOptionCount;

  /// Callback invoked when the user wants to see more options.
  ///
  /// This is only available if the poll has more options than the
  /// [visibleOptionCount].
  final VoidCallback? onSeeMoreOptions;

  /// Callback invoked when the user wants to cast a vote.
  ///
  /// The [PollOption] parameter is the option the user wants to vote for.
  final ValueChanged<PollOption>? onCastVote;

  /// Callback invoked when the user wants to remove a vote.
  ///
  /// The [PollVote] parameter is the vote the user wants to remove.
  final ValueChanged<PollVote>? onRemoveVote;

  void _handleVoteRemoval(PollOption option) {
    final vote = poll.currentUserVoteFor(option);
    if (vote == null) return;

    return onRemoveVote?.call(vote);
  }

  void _handleVoteAction(
    PollOption option, {
    required bool checked,
  }) {
    if (checked) return onCastVote?.call(option);
    return _handleVoteRemoval(option);
  }

  @override
  Widget build(BuildContext context) {
    final options = switch (visibleOptionCount) {
      final count? => poll.options.take(count),
      _ => poll.options,
    };

    final streamSpacing = context.streamSpacing;
    final translations = context.translations;

    final effectiveSpacing = spacing ?? streamSpacing.xxxs;
    final effectivePadding = padding ?? .symmetric(horizontal: streamSpacing.xs);

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        ListView.separated(
          shrinkWrap: true,
          itemCount: options.length,
          padding: effectivePadding,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => SizedBox(height: effectiveSpacing),
          itemBuilder: (context, index) {
            final option = options.elementAt(index);
            return PollOptionItem(
              key: ValueKey(option.id),
              poll: poll,
              option: option,
              style: optionStyle,
              onChanged: (checked) {
                if (checked == null) return;

                // Handle voting based on the voting mode.
                poll.votingMode.when(
                  disabled: () {}, // Do nothing
                  all: () => _handleVoteAction(option, checked: checked),
                  // Note: We don't need to remove the other votes in the unique
                  // voting mode as the backend handles it.
                  unique: () => _handleVoteAction(option, checked: checked),
                  limited: (count) => _handleVoteAction(
                    option,
                    checked: checked && poll.ownVotes.length < count,
                  ),
                );
              },
            );
          },
        ),
        if (visibleOptionCount case final count? when count < poll.options.length)
          StreamButton(
            size: .small,
            style: .secondary,
            type: .ghost,
            onPressed: onSeeMoreOptions,
            themeStyle: .from(tapTargetSize: .shrinkWrap),
            child: Text(translations.seeAllOptionsLabel(count: poll.options.length)),
          ),
      ],
    );
  }
}

/// {@template pollOptionItem}
/// A widget that displays a poll option.
///
/// Used in [PollOptionsListView] to display the poll options to interact with.
///
/// This widget is used to display the poll option and the number of votes it
/// has received. Also shows the voters if the poll is public.
///
/// See also:
///
///  * [StreamPollOptionStyle], for customizing option appearance.
///  * [PollOptionsListView], which uses this widget for each option.
/// {@endtemplate}
class PollOptionItem extends StatelessWidget {
  /// {@macro pollOptionItem}
  const PollOptionItem({
    super.key,
    required this.poll,
    required this.option,
    this.style,
    this.onChanged,
  });

  /// The poll the option belongs to.
  final Poll poll;

  /// The poll option the user can interact with.
  final PollOption option;

  /// The style used to render this item.
  ///
  /// If null, defaults to [StreamPollInteractorThemeData.optionStyle].
  final StreamPollOptionStyle? style;

  /// Callback invoked when the user interacts with the option.
  ///
  /// The [bool] parameter is the new value of the option.
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = style ?? StreamPollInteractorTheme.of(context).optionStyle;
    final defaults = _StreamPollOptionDefaults(context);

    final radius = context.streamRadius;
    final spacing = context.streamSpacing;

    final effectiveTextStyle = theme?.textStyle ?? defaults.textStyle;
    final effectiveVotesTextStyle = theme?.votesTextStyle ?? defaults.votesTextStyle;
    final effectiveCheckboxStyle = theme?.checkboxStyle ?? defaults.checkboxStyle;
    final effectiveVotesAvatarSize = theme?.votesAvatarSize ?? defaults.votesAvatarSize;
    final effectiveProgressBarStyle = theme?.progressBarStyle ?? defaults.progressBarStyle;

    final pollClosed = poll.isClosed;
    final isOptionSelected = poll.hasCurrentUserVotedFor(option);

    final control = ExcludeFocus(
      child: StreamCheckboxTheme(
        data: .new(style: effectiveCheckboxStyle),
        child: StreamCheckbox.circular(
          size: .md,
          value: isOptionSelected,
          onChanged: pollClosed ? null : onChanged,
        ),
      ),
    );

    return InkWell(
      borderRadius: .all(radius.md),
      onTap: pollClosed ? null : () => onChanged?.call(!isOptionSelected),
      child: Padding(
        padding: .all(spacing.xs),
        child: Row(
          spacing: spacing.sm,
          children: <Widget>[
            if (pollClosed case false) control,
            Expanded(
              child: Column(
                spacing: spacing.xxs,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    spacing: spacing.xs,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          option.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: effectiveTextStyle,
                        ),
                      ),
                      Row(
                        mainAxisSize: .min,
                        spacing: spacing.xxs,
                        children: [
                          // Show voters only if the poll is public.
                          if (poll.votingVisibility == VotingVisibility.public)
                            StreamUserAvatarStack(
                              size: effectiveVotesAvatarSize,
                              // We only show the latest 3 voters.
                              users: [
                                ...?poll.latestVotesByOption[option.id],
                              ].map((it) => it.user).whereType<User>().take(3),
                            ),
                          Text(
                            poll.voteCountFor(option).toString(),
                            style: effectiveVotesTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  StreamProgressBarTheme(
                    data: .new(style: effectiveProgressBarStyle),
                    child: _AnimatedPollOptionProgressBar(
                      value: poll.voteRatioFor(option),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A progress bar that animates only when [value] changes between widget
// updates, not every time the widget's State is recreated.
//
// This avoids the progress bar visually "refilling" from 0 each time a poll
// option is re-mounted (e.g. when the poll message scrolls back into view in
// the message list).
class _AnimatedPollOptionProgressBar extends StatefulWidget {
  const _AnimatedPollOptionProgressBar({required this.value});

  final double value;

  @override
  State<_AnimatedPollOptionProgressBar> createState() => _AnimatedPollOptionProgressBarState();
}

class _AnimatedPollOptionProgressBarState extends State<_AnimatedPollOptionProgressBar> {
  // Tracks the value the bar is currently displaying so we can animate from
  // it to a new target value when [widget.value] changes.
  late double _previousValue = widget.value;

  @override
  void didUpdateWidget(covariant _AnimatedPollOptionProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _previousValue = oldWidget.value;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeOutCubic,
      duration: Durations.medium2,
      tween: Tween(begin: _previousValue, end: widget.value),
      builder: (_, value, _) => StreamProgressBar(value: value),
    );
  }
}

// Default values for [StreamPollOptionStyle] backed by stream design tokens.
class _StreamPollOptionDefaults extends StreamPollOptionStyle {
  _StreamPollOptionDefaults(this._context);

  final BuildContext _context;

  late final _alignment = StreamMessageLayout.messageAlignmentOf(_context);
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;
  late final StreamTextTheme _textTheme = _context.streamTextTheme;

  Color get _textColor => switch (_alignment) {
    .start => _colorScheme.textPrimary,
    .end => _colorScheme.brand.shade900,
  };

  @override
  StreamAvatarStackSize get votesAvatarSize => StreamAvatarStackSize.xs;

  @override
  TextStyle get textStyle => _textTheme.captionDefault.copyWith(color: _textColor);

  @override
  TextStyle get votesTextStyle => _textTheme.metadataDefault.copyWith(color: _textColor);

  @override
  StreamCheckboxStyle get checkboxStyle => StreamCheckboxStyle.from(
    side: switch (_alignment) {
      .start => BorderSide(color: _colorScheme.borderStrong),
      .end => BorderSide(color: _colorScheme.brand.shade300),
    },
  );

  @override
  StreamProgressBarStyle get progressBarStyle => StreamProgressBarStyle(
    trackColor: switch (_alignment) {
      .start => _colorScheme.backgroundSurfaceStrong,
      .end => _colorScheme.brand.shade200,
    },
    fillColor: switch (_alignment) {
      .start => _colorScheme.accentNeutral,
      .end => _colorScheme.accentPrimary,
    },
  );
}
