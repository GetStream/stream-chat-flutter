import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:sample_app_jaspr/utils/app_config.dart';
import 'package:stream_chat_jaspr/stream_chat_jaspr.dart';
import 'package:universal_web/web.dart' as web;

const _avatarColors = [
  Color('#005FFF'),
  Color('#00B2FF'),
  Color('#00DDB5'),
  Color('#A95EDB'),
  Color('#FF5733'),
  Color('#FF8C00'),
  Color('#FF3B7A'),
];

const _pageStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.column,
  alignItems: AlignItems.center,
  height: Unit.percent(100),
  backgroundColor: Color('#f9fafb'),
  fontFamily: FontFamily.list([
    FontFamily('Inter'),
    FontFamilies.sansSerif,
  ]),
);

const _headerStyles = Styles(
  padding: Padding.only(top: Unit.pixels(48), bottom: Unit.pixels(24)),
  display: Display.flex,
  flexDirection: FlexDirection.column,
  alignItems: AlignItems.center,
  raw: {'gap': '8px'},
);

const _titleStyles = Styles(
  fontSize: Unit.pixels(22),
  fontWeight: FontWeight.w700,
  color: Color('#1a1a1a'),
);

const _subtitleStyles = Styles(
  fontSize: Unit.pixels(14),
  color: Color('#72767e'),
);

const _listStyles = Styles(
  width: Unit.percent(100),
  maxWidth: Unit.pixels(480),
  flex: Flex(grow: 1),
  overflow: Overflow.auto,
);

const _tileStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  padding: Padding.symmetric(
    horizontal: Unit.pixels(20),
    vertical: Unit.pixels(14),
  ),
  cursor: Cursor.pointer,
  raw: {
    'transition': 'background-color 0.15s ease',
    'border-bottom': '1px solid #e5e7eb',
  },
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

const _nameStyles = Styles(
  fontWeight: FontWeight.w600,
  fontSize: Unit.pixels(15),
  color: Color('#1a1a1a'),
);

const _accountLabelStyles = Styles(
  fontSize: Unit.pixels(13),
  color: Color('#72767e'),
  raw: {'margin-top': '2px'},
);

const _infoStyles = Styles(
  flex: Flex(grow: 1),
  padding: Padding.only(left: Unit.pixels(12)),
);

const _arrowStyles = Styles(
  fontSize: Unit.pixels(18),
  color: Color('#005FFF'),
  raw: {'flex-shrink': '0'},
);

const _overlayStyles = Styles(
  position: Position.fixed(
    top: Unit.zero,
    left: Unit.zero,
    right: Unit.zero,
    bottom: Unit.zero,
  ),
  display: Display.flex,
  alignItems: AlignItems.center,
  justifyContent: JustifyContent.center,
  raw: {'z-index': '100', 'background-color': 'rgba(0,0,0,0.4)'},
);

const _overlayBoxStyles = Styles(
  backgroundColor: Colors.white,
  radius: BorderRadius.circular(Unit.pixels(12)),
  padding: Padding.all(Unit.pixels(32)),
  display: Display.flex,
  flexDirection: FlexDirection.column,
  alignItems: AlignItems.center,
  raw: {'gap': '12px'},
);

class ChooseUserPage extends StatefulComponent {
  const ChooseUserPage({required this.client, super.key});

  final StreamChatClient client;

  @override
  State<ChooseUserPage> createState() => _ChooseUserPageState();
}

class _ChooseUserPageState extends State<ChooseUserPage> {
  bool _connecting = false;

  String _initials(User user) {
    final name = user.name;
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Future<void> _selectUser(String token, User user) async {
    if (_connecting) return;
    setState(() => _connecting = true);

    try {
      await component.client.connectUser(user, token);
      web.window.localStorage.setItem('stream_chat_token', token);
      Router.of(context).push('/channels');
    } catch (_) {
      setState(() => _connecting = false);
    }
  }

  @override
  Component build(BuildContext context) {
    final users = defaultUsers;

    final tiles = users.entries.map((entry) {
      final token = entry.key;
      final user = entry.value;
      final initials = _initials(user);
      final colorIndex = user.name.hashCode.abs() % _avatarColors.length;

      return div(
        styles: _tileStyles,
        events: {'click': (_) => _selectUser(token, user)},
        [
          div(
            styles: _avatarStyles.combine(
              Styles(backgroundColor: _avatarColors[colorIndex]),
            ),
            [Component.text(initials)],
          ),
          div(styles: _infoStyles, [
            div(styles: _nameStyles, [Component.text(user.name)]),
            const div(
              styles: _accountLabelStyles,
              [Component.text('Stream test account')],
            ),
          ]),
          const div(styles: _arrowStyles, [Component.text('\u203A')]),
        ],
      );
    }).toList();

    return div(styles: _pageStyles, [
      const div(styles: _headerStyles, [
        div(styles: _titleStyles, [
          Component.text('Welcome to Stream Chat'),
        ]),
        div(styles: _subtitleStyles, [
          Component.text('Select a user to try the Jaspr SDK:'),
        ]),
      ]),
      div(styles: _listStyles, tiles),
      if (_connecting)
        const div(styles: _overlayStyles, [
          div(styles: _overlayBoxStyles, [
            Component.text('Connecting...'),
          ]),
        ]),
    ]);
  }
}
