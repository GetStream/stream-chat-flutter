import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/components/stream_jaspr_avatar.dart';
import 'package:stream_chat_jaspr/src/stream_chat_provider.dart';
import 'package:stream_chat_jaspr/src/theme/stream_chat_jaspr_tokens.dart';
import 'package:stream_chat_jaspr/src/utils/extensions.dart';

const _tileStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  padding: Padding.symmetric(
    horizontal: Unit.pixels(StreamSpacing.md),
    vertical: Unit.pixels(StreamSpacing.sm),
  ),
  cursor: Cursor.pointer,
  position: Position.relative(),
  raw: {
    'transition': 'background-color 0.15s ease',
    'border-bottom': '1px solid #EBEEF1',
    'gap': '${StreamSpacing.sm}px',
  },
);

const _infoStyles = Styles(
  flex: Flex(grow: 1),
  minWidth: Unit.zero,
  raw: {'gap': '${StreamSpacing.xxxs}px', 'display': 'flex', 'flex-direction': 'column'},
);

const _titleRowStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  raw: {'gap': '${StreamSpacing.xs}px'},
);

const _nameStyles = Styles(
  flex: Flex(grow: 1),
  fontWeight: FontWeight.w600,
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  color: StreamColors.textPrimary,
  minWidth: Unit.zero,
  raw: {
    'white-space': 'nowrap',
    'overflow': 'hidden',
    'text-overflow': 'ellipsis',
  },
);

const _timeStyles = Styles(
  fontSize: Unit.pixels(StreamTypography.sizeXxs),
  color: StreamColors.textTertiary,
  raw: {'white-space': 'nowrap', 'flex-shrink': '0'},
);

const _previewRowStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  raw: {'gap': '${StreamSpacing.xxs}px'},
);

const _prefixStyles = Styles(
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  fontWeight: FontWeight.w600,
  color: StreamColors.textTertiary,
  raw: {'flex-shrink': '0', 'white-space': 'nowrap'},
);

const _previewTextStyles = Styles(
  flex: Flex(grow: 1),
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  color: StreamColors.textSecondary,
  minWidth: Unit.zero,
  raw: {
    'white-space': 'nowrap',
    'overflow': 'hidden',
    'text-overflow': 'ellipsis',
  },
);

const _badgeStyles = Styles(
  minWidth: Unit.pixels(20),
  height: Unit.pixels(20),
  radius: BorderRadius.circular(Unit.pixels(StreamRadii.pill)),
  backgroundColor: StreamColors.primary,
  color: StreamColors.white,
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  fontWeight: FontWeight.w700,
  display: Display.flex,
  alignItems: AlignItems.center,
  justifyContent: JustifyContent.center,
  border: Border.all(color: StreamColors.white, width: Unit.pixels(2)),
  padding: Padding.symmetric(horizontal: Unit.pixels(StreamSpacing.xxs)),
);

const _selectionOverlayStyles = Styles(
  radius: BorderRadius.circular(Unit.pixels(StreamRadii.lg)),
  backgroundColor: StreamColors.selectionOverlay,
  position: Position.absolute(
    top: Unit.pixels(StreamSpacing.xxs),
    right: Unit.pixels(StreamSpacing.xxs),
    bottom: Unit.pixels(StreamSpacing.xxs),
    left: Unit.pixels(StreamSpacing.xxs),
  ),
  raw: {'pointer-events': 'none'},
);

/// A component that renders a single channel tile in a channel list.
///
/// Displays the channel avatar, name, last message preview (with sender
/// prefix and attachment-type indicators), relative timestamp, and an
/// unread-count badge.
///
/// Subscribes to [Channel.state] streams so the tile updates in real-time.
/// Pass [selected] to show the design-system selection overlay.
class StreamChannelListTile extends StatefulComponent {
  /// Creates a [StreamChannelListTile].
  const StreamChannelListTile({
    required this.channel,
    this.onTap,
    this.selected = false,
    super.key,
  });

  /// The channel to display.
  final Channel channel;

  /// Called when the tile is clicked.
  final void Function()? onTap;

  /// Whether this tile is currently selected.
  ///
  /// Shows a rounded semi-transparent overlay when true.
  final bool selected;

  @override
  State<StreamChannelListTile> createState() => _StreamChannelListTileState();
}

class _StreamChannelListTileState extends State<StreamChannelListTile> {
  StreamSubscription<ChannelState>? _stateSubscription;
  StreamSubscription<String?>? _nameSubscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  void _subscribe() {
    final channelState = component.channel.state;
    if (channelState == null) return;

    _stateSubscription = channelState.channelStateStream.listen((_) {
      setState(() {});
    });
    _nameSubscription = component.channel.nameStream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _nameSubscription?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final channel = component.channel;
    final currentUser = StreamChatProvider.clientOf(context).state.currentUser!;
    final channelState = channel.state;

    final channelName = channel.resolveChannelName(currentUser);
    final initials = channel.resolveInitials(currentUser);
    final imageUrl = channel.resolveImageUrl(currentUser);
    final isOnline = channel.resolveIsOnline(currentUser);
    final (:prefix, :preview) = channel.resolveLastMessagePreview(currentUser);
    final unreadCount = channelState?.unreadCount ?? 0;
    final lastMessageAt = channel.lastMessageAt;

    return div(
      styles: _tileStyles,
      events: {
        if (component.onTap != null) 'click': (_) => component.onTap!(),
      },
      [
        // Selection overlay (behind content via pointer-events:none).
        if (component.selected) const div(styles: _selectionOverlayStyles, []),

        // Avatar.
        StreamJasprAvatar(
          initials: initials,
          imageUrl: imageUrl,
          isOnline: isOnline,
          size: 40,
        ),

        // Info column: title row + preview row.
        div(styles: _infoStyles, [
          // Title row: channel name + timestamp (top-right).
          div(styles: _titleRowStyles, [
            div(styles: _nameStyles, [Component.text(channelName)]),
            if (lastMessageAt != null)
              div(
                styles: _timeStyles,
                [Component.text(lastMessageAt.toRelativeString())],
              ),
          ]),

          // Preview row: optional sender prefix + message text + unread badge.
          div(styles: _previewRowStyles, [
            if (prefix.isNotEmpty) div(styles: _prefixStyles, [Component.text(prefix)]),
            div(styles: _previewTextStyles, [Component.text(preview)]),
            if (unreadCount > 0)
              div(
                styles: _badgeStyles,
                [Component.text('$unreadCount')],
              ),
          ]),
        ]),
      ],
    );
  }
}
