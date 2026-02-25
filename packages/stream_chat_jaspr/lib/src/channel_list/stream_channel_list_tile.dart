import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/stream_chat_provider.dart';
import 'package:stream_chat_jaspr/src/utils/extensions.dart';

const _avatarColors = [
  Color('#005FFF'),
  Color('#00B2FF'),
  Color('#00DDB5'),
  Color('#A95EDB'),
  Color('#FF5733'),
  Color('#FF8C00'),
  Color('#FF3B7A'),
];

const _tileStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  padding: Padding.symmetric(
    horizontal: Unit.pixels(16),
    vertical: Unit.pixels(12),
  ),
  cursor: Cursor.pointer,
  raw: {'transition': 'background-color 0.15s ease'},
);

const _avatarStyles = Styles(
  width: Unit.pixels(40),
  height: Unit.pixels(40),
  radius: BorderRadius.circular(Unit.pixels(20)),
  display: Display.flex,
  alignItems: AlignItems.center,
  justifyContent: JustifyContent.center,
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: Unit.pixels(16),
  raw: {'flex-shrink': '0'},
);

const _infoStyles = Styles(
  flex: Flex(grow: 1),
  minWidth: Unit.zero,
  padding: Padding.symmetric(horizontal: Unit.pixels(12)),
);

const _nameStyles = Styles(
  fontWeight: FontWeight.w600,
  fontSize: Unit.pixels(15),
  color: Color('#1a1a1a'),
  raw: {
    'white-space': 'nowrap',
    'overflow': 'hidden',
    'text-overflow': 'ellipsis',
  },
);

const _previewStyles = Styles(
  fontSize: Unit.pixels(13),
  raw: {
    'margin-top': '2px',
    'white-space': 'nowrap',
    'overflow': 'hidden',
    'text-overflow': 'ellipsis',
  },
);

const _metaStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  alignItems: AlignItems.end,
  raw: {'flex-shrink': '0', 'gap': '4px'},
);

const _timeStyles = Styles(
  fontSize: Unit.pixels(12),
  color: Color('#72767e'),
  raw: {'white-space': 'nowrap'},
);

const _unreadBadgeStyles = Styles(
  minWidth: Unit.pixels(20),
  height: Unit.pixels(20),
  radius: BorderRadius.circular(Unit.pixels(10)),
  backgroundColor: Color('#005FFF'),
  color: Colors.white,
  fontSize: Unit.pixels(11),
  fontWeight: FontWeight.w600,
  display: Display.flex,
  alignItems: AlignItems.center,
  justifyContent: JustifyContent.center,
  padding: Padding.symmetric(horizontal: Unit.pixels(6)),
);

/// A component that renders a single channel tile in a channel list.
///
/// Displays the channel avatar, name, last message preview, relative
/// timestamp, and unread message count badge.
///
/// Subscribes to [Channel.state] streams so the tile updates in real-time.
class StreamChannelListTile extends StatefulComponent {
  /// Creates a [StreamChannelListTile].
  const StreamChannelListTile({
    required this.channel,
    this.onTap,
    super.key,
  });

  /// The channel to display.
  final Channel channel;

  /// Called when the tile is clicked.
  final void Function()? onTap;

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
    final lastMessageText = channel.resolveLastMessageText();
    final initials = channel.resolveInitials(currentUser);
    final unreadCount = channelState?.unreadCount ?? 0;
    final lastMessageAt = channel.lastMessageAt;

    final colorIndex = channelName.hashCode.abs() % _avatarColors.length;
    final avatarColor = _avatarColors[colorIndex];

    final previewColor = unreadCount > 0
        ? const Color('#1a1a1a')
        : const Color('#72767e');

    return div(
      styles: _tileStyles,
      events: {
        if (component.onTap != null) 'click': (_) => component.onTap!(),
      },
      [
        div(
          styles: _avatarStyles.combine(
            Styles(backgroundColor: avatarColor),
          ),
          [Component.text(initials)],
        ),
        div(styles: _infoStyles, [
          div(styles: _nameStyles, [Component.text(channelName)]),
          div(
            styles: _previewStyles.combine(Styles(color: previewColor)),
            [Component.text(lastMessageText)],
          ),
        ]),
        div(styles: _metaStyles, [
          if (lastMessageAt != null)
            div(
              styles: _timeStyles,
              [Component.text(lastMessageAt.toRelativeString())],
            ),
          if (unreadCount > 0)
            div(
              styles: _unreadBadgeStyles,
              [Component.text('$unreadCount')],
            ),
        ]),
      ],
    );
  }
}
