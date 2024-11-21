import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/poll_interactor_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template pollHeader}
/// A widget used as the header of a poll.
///
/// Used in [StreamPollInteractor] to display the poll question and voting mode.
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          poll.name,
          style: theme.pollTitleStyle,
        ),
        Text(
          context.translations.pollVotingModeLabel(poll.votingMode),
          style: theme.pollSubtitleStyle,
        ),
      ],
    );
  }
}
