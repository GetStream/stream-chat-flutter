import 'package:jaspr/dom.dart' hide Filter;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:stream_chat_jaspr/stream_chat_jaspr.dart';

const _pageStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  height: Unit.percent(100),
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
  },
);

const _headerTitleStyles = Styles(
  flex: Flex(grow: 1),
  fontWeight: FontWeight.w700,
  fontSize: Unit.pixels(18),
  color: Color('#1a1a1a'),
);

const _signOutStyles = Styles(
  padding: Padding.symmetric(
    horizontal: Unit.pixels(12),
    vertical: Unit.pixels(6),
  ),
  radius: BorderRadius.circular(Unit.pixels(6)),
  border: Border.all(color: Color('#d1d5db'), width: Unit.pixels(1)),
  backgroundColor: Colors.white,
  color: Color('#374151'),
  cursor: Cursor.pointer,
  fontSize: Unit.pixels(13),
  fontWeight: FontWeight.w500,
);

const _listContainerStyles = Styles(
  flex: Flex(grow: 1),
  overflow: Overflow.hidden,
  backgroundColor: Colors.white,
);

class ChannelListPage extends StatefulComponent {
  const ChannelListPage({super.key});

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  StreamChannelListController? _controller;

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
    await StreamChatProvider.clientOf(context).disconnectUser();
    Router.of(context).replace('/');
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final client = StreamChatProvider.clientOf(context);
    final currentUser = client.state.currentUser;
    final userName = currentUser?.name ?? 'User';

    if (_controller == null) {
      return const div(styles: _pageStyles, [
        Component.text('No user connected.'),
      ]);
    }

    return div(styles: _pageStyles, [
      div(styles: _headerStyles, [
        div(styles: _headerTitleStyles, [
          Component.text('Channels \u2014 $userName'),
        ]),
        button(
          onClick: _signOut,
          styles: _signOutStyles,
          const [Component.text('Sign out')],
        ),
      ]),
      div(styles: _listContainerStyles, [
        StreamChannelListView(controller: _controller!),
      ]),
    ]);
  }
}
