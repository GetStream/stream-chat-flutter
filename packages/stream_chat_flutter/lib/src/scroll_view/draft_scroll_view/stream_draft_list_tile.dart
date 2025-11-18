import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamDraftListTile}
/// A widget that displays a draft in a list.
///
/// This widget is used in the [StreamDraftListView] to display a draft.
///
/// The widget displays the channel name, the draft message preview, and the
/// timestamp.
/// {@endtemplate}
class StreamDraftListTile extends StatelessWidget {
  /// {@macro streamDraftListTile}
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
    final theme = StreamDraftListTileTheme.of(context);

    return Material(
      color: theme.backgroundColor,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: theme.padding,
          child: Column(
            spacing: 6,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (draft.channel case final channel?)
                DraftTitle(
                  channelName: channel.formatName(currentUser: currentUser),
                ),
              DraftMessageContent(
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

/// {@template draftTitle}
/// A widget that displays the channel name.
/// {@endtemplate}
class DraftTitle extends StatelessWidget {
  /// {@macro draftTitle}
  const DraftTitle({
    super.key,
    this.channelName,
  });

  /// The channel name to display.
  final String? channelName;

  @override
  Widget build(BuildContext context) {
    final theme = StreamDraftListTileTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          size: 16,
          Icons.edit_note_rounded,
          color: theme.draftChannelNameStyle?.color,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            channelName ?? context.translations.noTitleText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.draftChannelNameStyle,
          ),
        ),
      ],
    );
  }
}

/// {@template draftMessageContent}
/// A widget that displays the draft message content.
/// {@endtemplate}
class DraftMessageContent extends StatelessWidget {
  /// {@macro draftMessageContent}
  const DraftMessageContent({
    super.key,
    required this.draft,
    this.currentUser,
  });

  /// The draft to display.
  final Draft draft;

  /// The current user.
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    final theme = StreamDraftListTileTheme.of(context);

    return Row(
      children: [
        Expanded(
          child: StreamDraftMessagePreviewText(
            draftMessage: draft.message,
            textStyle: theme.draftMessageStyle,
          ),
        ),
        StreamTimestamp(
          date: draft.createdAt.toLocal(),
          style: theme.draftTimestampStyle,
          formatter: theme.draftTimestampFormatter,
        ),
      ],
    );
  }
}
