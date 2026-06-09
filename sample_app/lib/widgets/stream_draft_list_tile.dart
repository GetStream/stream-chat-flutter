import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that displays a draft in a list.
///
/// The widget displays the channel name, the draft message preview, and the
/// timestamp.
class StreamDraftListTile extends StatelessWidget {
  /// Creates a new [StreamDraftListTile].
  const StreamDraftListTile({
    super.key,
    required this.draft,
    this.currentUser,
    this.onTap,
    this.onLongPress,
  });

  /// The draft to display.
  final Draft draft;

  /// The current user.
  final User? currentUser;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.streamColorScheme.backgroundElevation1,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            spacing: 6,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (draft.channel case final channel?)
                _DraftTitle(
                  channelName: channel.formatName(currentUser: currentUser),
                ),
              _DraftMessageContent(
                draft: draft,
                currentUser: currentUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftTitle extends StatelessWidget {
  const _DraftTitle({this.channelName});

  final String? channelName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final style = context.streamTextTheme.bodyEmphasis.copyWith(
      color: colorScheme.textPrimary,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.edit_note_rounded, size: 16, color: style.color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            channelName ?? context.translations.noTitleText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

class _DraftMessageContent extends StatelessWidget {
  const _DraftMessageContent({
    required this.draft,
    this.currentUser,
  });

  final Draft draft;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final subtleStyle = context.streamTextTheme.captionDefault.copyWith(
      color: colorScheme.textSecondary,
    );

    return Row(
      children: [
        Expanded(
          child: StreamDraftMessagePreviewText(
            draftMessage: draft.message,
            textStyle: subtleStyle,
          ),
        ),
        StreamTimestamp(
          date: draft.createdAt.toLocal(),
          style: subtleStyle,
        ),
      ],
    );
  }
}
