import 'package:jaspr/dom.dart' hide Filter;
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat_jaspr/stream_chat_jaspr.dart';

const _viewStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  height: Unit.percent(100),
  overflow: Overflow.hidden,
  fontFamily: StreamTypography.fontFamily,
);

const _headerStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  padding: Padding.symmetric(
    horizontal: Unit.pixels(StreamSpacing.md),
    vertical: Unit.pixels(StreamSpacing.sm),
  ),
  backgroundColor: StreamColors.white,
  raw: {
    'border-bottom': '1px solid #EBEEF1',
    'flex-shrink': '0',
    'gap': '${StreamSpacing.sm}px',
  },
);

const _headerInfoStyles = Styles(
  flex: Flex(grow: 1),
  minWidth: Unit.zero,
);

const _headerNameStyles = Styles(
  fontWeight: FontWeight.w600,
  fontSize: Unit.pixels(StreamTypography.sizeHeader),
  color: StreamColors.textPrimary,
  raw: {
    'white-space': 'nowrap',
    'overflow': 'hidden',
    'text-overflow': 'ellipsis',
  },
);

const _headerStatusStyles = Styles(
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  color: StreamColors.textSecondary,
);

const _messagesAreaStyles = Styles(
  flex: Flex(grow: 1),
  overflow: Overflow.hidden,
);

/// The right-hand panel of the master/detail layout.
///
/// Shows the message history for [channel] and a composer to send messages.
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
    final imageUrl = channel.resolveImageUrl(currentUser);
    final isOnline = channel.resolveIsOnline(currentUser);

    return div(styles: _viewStyles, [
      // Header.
      div(styles: _headerStyles, [
        StreamJasprAvatar(
          initials: initials,
          imageUrl: imageUrl,
          isOnline: isOnline,
          size: 40,
        ),
        div(styles: _headerInfoStyles, [
          div(styles: _headerNameStyles, [Component.text(channelName)]),
          if (isOnline) const div(styles: _headerStatusStyles, [Component.text('Online')]),
        ]),
      ]),

      // Message list.
      div(styles: _messagesAreaStyles, [
        StreamMessageListView(
          controller: _controller,
          channel: channel,
        ),
      ]),

      // Composer.
      StreamMessageComposer(channel: channel),
    ]);
  }
}
