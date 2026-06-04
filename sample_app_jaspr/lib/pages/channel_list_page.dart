import 'package:jaspr/dom.dart' hide Filter;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:sample_app_jaspr/pages/message_view.dart';
import 'package:stream_chat_jaspr/stream_chat_jaspr.dart';
import 'package:universal_web/web.dart' as web;

const _pageStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.row,
  height: Unit.percent(100),
  fontFamily: StreamTypography.fontFamily,
);

// ---- Left panel ----

const _leftPanelStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  width: Unit.pixels(320),
  backgroundColor: StreamColors.white,
  raw: {
    'border-right': '1px solid #EBEEF1',
    'flex-shrink': '0',
  },
);

const _leftHeaderStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  padding: Padding.symmetric(
    horizontal: Unit.pixels(StreamSpacing.md),
    vertical: Unit.pixels(14),
  ),
  raw: {
    'border-bottom': '1px solid #EBEEF1',
    'flex-shrink': '0',
    'gap': '${StreamSpacing.xs}px',
  },
);

const _leftHeaderTitleStyles = Styles(
  flex: Flex(grow: 1),
  fontWeight: FontWeight.w700,
  fontSize: Unit.pixels(18),
  color: StreamColors.textPrimary,
);

const _signOutStyles = Styles(
  padding: Padding.symmetric(
    horizontal: Unit.pixels(10),
    vertical: Unit.pixels(5),
  ),
  radius: BorderRadius.circular(Unit.pixels(StreamRadii.md)),
  border: Border.all(color: StreamColors.borderDefault, width: Unit.pixels(1)),
  backgroundColor: StreamColors.white,
  color: StreamColors.textSecondary,
  cursor: Cursor.pointer,
  fontSize: Unit.pixels(StreamTypography.sizeXxs + 2),
  fontWeight: FontWeight.w500,
);

const _listContainerStyles = Styles(
  flex: Flex(grow: 1),
  overflow: Overflow.hidden,
);

// ---- Right panel ----

const _rightPanelStyles = Styles(
  flex: Flex(grow: 1),
  overflow: Overflow.hidden,
  raw: {'background': '#F9FAFB'},
);

const _emptyStateStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  justifyContent: JustifyContent.center,
  alignItems: AlignItems.center,
  height: Unit.percent(100),
  color: StreamColors.textTertiary,
  fontSize: Unit.pixels(StreamTypography.sizeBase),
);

/// Master/detail page: channel list on the left, message view on the right.
class ChannelListPage extends StatefulComponent {
  /// Creates a [ChannelListPage].
  const ChannelListPage({super.key});

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  StreamChannelListController? _controller;
  Channel? _selectedChannel;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    final client = StreamChatProvider.clientOf(context);
    final currentUser = client.state.currentUser;
    if (currentUser == null) return;

    _controller = StreamChannelListController(
      client: client,
      filter: Filter.and([
        Filter.in_('members', [currentUser.id]),
      ]),
    );
  }

  Future<void> _signOut() async {
    web.window.localStorage.removeItem('stream_chat_token');
    _controller?.dispose();
    _controller = null;
    _selectedChannel = null;
    await StreamChatProvider.clientOf(context).disconnectUser();
    Router.of(context).replace('/');
  }

  void _onChannelTap(Channel channel) {
    setState(() => _selectedChannel = channel);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    if (_controller == null) {
      return const div(styles: _pageStyles, [
        Component.text('No user connected.'),
      ]);
    }

    return div(styles: _pageStyles, [
      // ---- Left panel: channel list ----
      div(styles: _leftPanelStyles, [
        div(styles: _leftHeaderStyles, [
          const div(styles: _leftHeaderTitleStyles, [Component.text('Chats')]),
          button(
            onClick: _signOut,
            styles: _signOutStyles,
            const [Component.text('Sign out')],
          ),
        ]),
        div(styles: _listContainerStyles, [
          StreamChannelListView(
            controller: _controller!,
            onChannelTap: _onChannelTap,
            itemBuilder: (context, channel) => StreamChannelListTile(
              key: ValueKey(channel.cid),
              channel: channel,
              selected: channel.cid == _selectedChannel?.cid,
              onTap: () => _onChannelTap(channel),
            ),
          ),
        ]),
      ]),

      // ---- Right panel: message view ----
      div(styles: _rightPanelStyles, [
        if (_selectedChannel == null)
          const div(styles: _emptyStateStyles, [
            Component.text('Select a conversation to start messaging'),
          ])
        else
          MessageView(
            key: ValueKey(_selectedChannel!.cid),
            channel: _selectedChannel!,
          ),
      ]),
    ]);
  }
}
