import 'package:jaspr/dom.dart' hide Filter;
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat_jaspr/stream_chat_jaspr.dart';

const _viewStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  height: Unit.percent(100),
  overflow: Overflow.hidden,
  fontFamily: FontFamily.list([
    FontFamily('Inter'),
    FontFamilies.sansSerif,
  ]),
);

const _headerStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  padding: Padding.symmetric(
    horizontal: Unit.pixels(16),
    vertical: Unit.pixels(12),
  ),
  backgroundColor: Colors.white,
  raw: {
    'border-bottom': '1px solid #e5e7eb',
    'flex-shrink': '0',
    'gap': '12px',
  },
);

const _headerInfoStyles = Styles(
  flex: Flex(grow: 1),
  minWidth: Unit.zero,
);

const _headerNameStyles = Styles(
  fontWeight: FontWeight.w600,
  fontSize: Unit.pixels(16),
  color: Color('#1a1a1a'),
  raw: {
    'white-space': 'nowrap',
    'overflow': 'hidden',
    'text-overflow': 'ellipsis',
  },
);

const _onlineRowStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  raw: {'gap': '5px', 'margin-top': '1px'},
);

const _onlineDotStyles = Styles(
  width: Unit.pixels(8),
  height: Unit.pixels(8),
  radius: BorderRadius.circular(Unit.pixels(4)),
  backgroundColor: Color('#00DDB5'),
  raw: {'flex-shrink': '0'},
);

const _onlineLabelStyles = Styles(
  fontSize: Unit.pixels(12),
  color: Color('#72767e'),
);

const _messagesAreaStyles = Styles(
  flex: Flex(grow: 1),
  overflow: Overflow.hidden,
);

/// The right-hand panel of the master/detail layout.
///
/// Shows the message history for [channel] and a text input to send messages.
class MessageView extends StatefulComponent {
  /// Creates a [MessageView] for the given [channel].
  const MessageView({
    required this.channel,
    super.key,
  });

  /// The channel to display.
  final Channel channel;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late final StreamMessageListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamMessageListController(channel: component.channel);
    _controller.doInitialLoad();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final channel = component.channel;
    final currentUser = StreamChatProvider.clientOf(context).state.currentUser!;
    final channelName = channel.resolveChannelName(currentUser);
    final initials = channel.resolveInitials(currentUser);

    // Determine if this is a 1:1 DM so we can show online status.
    final members = channel.state?.members ?? [];
    final otherMembers =
        members.where((m) => m.userId != currentUser.id).toList();
    final isOnline = otherMembers.length == 1 &&
        (otherMembers.first.user?.online ?? false);

    return div(styles: _viewStyles, [
      // Header.
      div(styles: _headerStyles, [
        StreamJasprAvatar(
          initials: initials,
          size: 40,
          colorSeed: channel.cid ?? initials,
        ),
        div(styles: _headerInfoStyles, [
          div(styles: _headerNameStyles, [Component.text(channelName)]),
          if (isOnline)
            div(styles: _onlineRowStyles, [
              div(styles: _onlineDotStyles, []),
              div(styles: _onlineLabelStyles, [Component.text('Online')]),
            ]),
        ]),
      ]),

      // Message list.
      div(styles: _messagesAreaStyles, [
        StreamMessageListView(
          controller: _controller,
          channel: channel,
        ),
      ]),

      // Input.
      StreamMessageInput(channel: channel),
    ]);
  }
}
