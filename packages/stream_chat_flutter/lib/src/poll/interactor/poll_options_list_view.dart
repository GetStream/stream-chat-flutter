import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/avatars/user_avatar.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/theme/poll_interactor_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template pollOptionsListView}
/// A widget that displays the list of poll options.
///
/// Used in [StreamPollInteractor] to display the poll options to interact with.
/// {@endtemplate}
class PollOptionsListView extends StatelessWidget {
  /// {@macro pollOptionsListView}
  const PollOptionsListView({
    super.key,
    required this.poll,
    this.visibleOptionCount,
    this.showProgressBar = false,
    this.onCastVote,
    this.onRemoveVote,
  });

  /// The poll to display the options for.
  final Poll poll;

  /// The number of visible options in the poll.
  ///
  /// If null, all options will be visible.
  final int? visibleOptionCount;

  /// Whether to show the voting progress bar.
  ///
  /// Note: This is only used when the poll is public.
  final bool showProgressBar;

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

    return ListView.separated(
      shrinkWrap: true,
      itemCount: options.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final option = options.elementAt(index);
        return PollOptionItem(
          key: ValueKey(option.id),
          poll: poll,
          option: option,
          showProgressBar: showProgressBar,
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
/// {@endtemplate}
class PollOptionItem extends StatelessWidget {
  /// {@macro pollOptionItem}
  const PollOptionItem({
    super.key,
    required this.poll,
    required this.option,
    this.showProgressBar = true,
    this.onChanged,
  });

  /// The poll the option belongs to.
  final Poll poll;

  /// The poll option the user can interact with.
  final PollOption option;

  /// Whether to show the progress bar.
  ///
  /// Note: This is only used when the poll is public.
  final bool showProgressBar;

  /// Callback invoked when the user interacts with the option.
  ///
  /// The [bool] parameter is the new value of the option.
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollInteractorTheme.of(context);

    final pollClosed = poll.isClosed;
    final isOptionSelected = poll.hasCurrentUserVotedFor(option);

    final control = ExcludeFocus(
      child: Checkbox(
        value: isOptionSelected,
        onChanged: pollClosed ? null : onChanged,
        checkColor: theme.pollOptionCheckboxCheckColor,
        shape: theme.pollOptionCheckboxShape,
        side: theme.pollOptionCheckboxBorderSide,
        activeColor: theme.pollOptionCheckboxActiveColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(
          vertical: VisualDensity.minimumDensity,
          horizontal: VisualDensity.minimumDensity,
        ),
      ),
    );

    return InkWell(
      onTap: pollClosed ? null : () => onChanged?.call(!isOptionSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          spacing: 4,
          children: <Widget>[
            if (pollClosed case false) control,
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    spacing: 4,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          option.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.pollOptionTextStyle,
                        ),
                      ),
                      // Show voters only if the poll is public.
                      if (poll.votingVisibility == VotingVisibility.public)
                        OptionVoters(
                          // We only show the latest 3 voters.
                          voters: [
                            ...?poll.latestVotesByOption[option.id],
                          ].map((it) => it.user).whereType<User>().take(3),
                        ),
                      Text(
                        poll.voteCountFor(option).toString(),
                        style: theme.pollOptionVoteCountTextStyle,
                      ),
                    ],
                  ),
                  if (showProgressBar)
                    OptionVotesProgressBar(
                      value: poll.voteRatioFor(option),
                      borderRadius:
                          theme.pollOptionVotesProgressBarBorderRadius ??
                              BorderRadius.circular(4),
                      trackColor: theme.pollOptionVotesProgressBarTrackColor,
                      valueColor: switch (poll.isOptionWinner(option)) {
                        true => theme.pollOptionVotesProgressBarWinnerColor,
                        false => theme.pollOptionVotesProgressBarValueColor,
                      },
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// {@template optionVoters}
/// A widget that displays the voters of an option.
///
/// Used in [PollOptionItem] to display the voters of a poll option.
/// {@endtemplate}
class OptionVoters extends StatelessWidget {
  /// {@macro optionVoters}
  const OptionVoters({
    super.key,
    this.radius = 10,
    this.overlap = 0.5,
    required this.voters,
  }) : assert(
          overlap >= 0 && overlap <= 1,
          'Overlap must be between 0 and 1',
        );

  /// The radius of the avatars.
  final double radius;

  /// The overlap between the avatars.
  ///
  /// The default value is 1/2 i.e. 50%.
  final double overlap;

  /// The list of voters to display.
  final Iterable<User> voters;

  @override
  Widget build(BuildContext context) {
    if (voters.isEmpty) return const Empty();

    final theme = StreamChatTheme.of(context);

    final diameter = radius * 2;
    final width = diameter + (voters.length * diameter * overlap);

    var overlapPadding = 0.0;

    return SizedBox.fromSize(
      size: Size(width, diameter),
      child: Stack(
        children: [
          ...voters.map(
            (user) {
              overlapPadding += diameter * overlap;
              return Positioned(
                right: overlapPadding - (diameter * overlap),
                bottom: 0,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorTheme.barsBg,
                  ),
                  padding: const EdgeInsets.all(1),
                  child: StreamUserAvatar(
                    user: user,
                    constraints: BoxConstraints.tight(Size.fromRadius(radius)),
                    showOnlineStatus: false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// {@template optionVotesProgressBar}
/// A widget that displays the progress of the votes for an option.
///
/// Used in [PollOptionItem] to display the progress of the votes for a
/// particular option.
/// {@endtemplate}
class OptionVotesProgressBar extends StatelessWidget {
  /// {@macro optionVotesProgressBar}
  const OptionVotesProgressBar({
    super.key,
    required this.value,
    this.minHeight = 4,
    this.trackColor,
    this.valueColor,
    this.borderRadius = BorderRadius.zero,
  });

  /// The value of the progress bar.
  final double value;

  /// The minimum height of the progress bar.
  final double minHeight;

  /// The color of the track.
  final Color? trackColor;

  /// The color of the value.
  final Color? valueColor;

  /// The border radius of the progress bar.
  ///
  /// Defaults to [BorderRadius.zero].
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: borderRadius);
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: minHeight,
      ),
      decoration: ShapeDecoration(
        shape: shape,
        color: trackColor,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.constrain(Size.zero);

          final textDirection = Directionality.of(context);
          final alignment = switch (textDirection) {
            TextDirection.ltr => Alignment.centerLeft,
            TextDirection.rtl => Alignment.centerRight,
          };

          return Align(
            alignment: alignment,
            child: AnimatedContainer(
              height: size.height,
              width: size.width * value,
              duration: Durations.medium2,
              decoration: ShapeDecoration(
                shape: shape,
                color: valueColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
