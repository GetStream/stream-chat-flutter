import 'package:jaspr/dom.dart' hide Filter;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:sample_app_jaspr/pages/message_view.dart';
import 'package:stream_chat_jaspr/stream_chat_jaspr.dart';

const _pageStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.row,
  height: Unit.percent(100),
  fontFamily: FontFamily.list([
    FontFamily('Inter'),
    FontFamilies.sansSerif,
  ]),
);

// ---- Left panel ----

const _leftPanelStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  width: Unit.pixels(320),
  backgroundColor: Colors.white,
  raw: {
    'border-right': '1px solid #e5e7eb',
    'flex-shrink': '0',
  },
);

const _leftHeaderStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  padding: Padding.symmetric(
    horizontal: Unit.pixels(16),
    vertical: Unit.pixels(14),
  ),
  raw: {
    'border-bottom': '1px solid #e5e7eb',
    'flex-shrink': '0',
    'gap': '8px',
  },
);

const _leftHeaderTitleStyles = Styles(
  flex: Flex(grow: 1),
  fontWeight: FontWeight.w700,
  fontSize: Unit.pixels(18),
  color: Color('#1a1a1a'),
);

const _signOutStyles = Styles(
  padding: Padding.symmetric(
    horizontal: Unit.pixels(10),
    vertical: Unit.pixels(5),
  ),
  radius: BorderRadius.circular(Unit.pixels(6)),
  border: Border.all(color: Color('#d1d5db'), width: Unit.pixels(1)),
  backgroundColor: Colors.white,
  color: Color('#374151'),
  cursor: Cursor.pointer,
  fontSize: Unit.pixels(12),
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
  backgroundColor: Color('#f9fafb'),
);

const _emptyStateStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  justifyContent: JustifyContent.center,
  alignItems: AlignItems.center,
  height: Unit.percent(100),
  color: Color('#72767e'),
  fontSize: Unit.pixels(15),
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
          div(styles: _leftHeaderTitleStyles, [Component.text('Chats')]),
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
            itemBuilder: (context, channel) => _ChannelTileWithSelection(
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
          div(styles: _emptyStateStyles, [
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

/// Wraps [StreamChannelListTile] with a selection highlight.
class _ChannelTileWithSelection extends StatelessComponent {
  const _ChannelTileWithSelection({
    required this.channel,
    required this.selected,
    required this.onTap,
  });

  final Channel channel;
  final bool selected;
  final void Function() onTap;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        backgroundColor: selected ? const Color('#EEF2FF') : Colors.transparent,
      ),
      [
        StreamChannelListTile(
          key: ValueKey(channel.cid),
          channel: channel,
          onTap: onTap,
        ),
      ],
    );
  }
}
