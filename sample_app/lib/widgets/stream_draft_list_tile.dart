import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sample_app/widgets/stream_draft_list_tile_theme.dart';
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
                _DraftTitle(
                  channelName: channel.formatName(currentUser: currentUser),
                  theme: theme,
                ),
              _DraftMessageContent(
                draft: draft,
                currentUser: currentUser,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftTitle extends StatelessWidget {
  const _DraftTitle({
    this.channelName,
    required this.theme,
  });

  final String? channelName;
  final StreamDraftListTileThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.edit_note_rounded,
          size: 16,
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

class _DraftMessageContent extends StatelessWidget {
  const _DraftMessageContent({
    required this.draft,
    this.currentUser,
    required this.theme,
  });

  final Draft draft;
  final User? currentUser;
  final StreamDraftListTileThemeData theme;

  @override
  Widget build(BuildContext context) {
    final date = draft.createdAt.toLocal();
    final formatter = theme.draftTimestampFormatter;
    final timestamp = formatter != null ? formatter(context, date) : _formatDate(date);

    return Row(
      children: [
        Expanded(
          child: StreamDraftMessagePreviewText(
            draftMessage: draft.message,
            textStyle: theme.draftMessageStyle,
          ),
        ),
        Text(
          timestamp,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.draftTimestampStyle,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final jiffy = Jiffy.parseFromDateTime(date);
    final now = DateTime.now();
    if (now.difference(date).inDays == 0 && now.day == date.day) {
      return jiffy.jm;
    }
    if (now.difference(date).inDays < 7) return jiffy.EEEE;
    return jiffy.yMd;
  }
}
