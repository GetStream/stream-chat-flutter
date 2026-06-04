import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:sample_app_jaspr/pages/channel_list_page.dart';
import 'package:sample_app_jaspr/pages/choose_user_page.dart';
import 'package:sample_app_jaspr/utils/app_config.dart';
import 'package:stream_chat_jaspr/stream_chat_jaspr.dart';
import 'package:universal_web/web.dart' as web;

const _kTokenKey = 'stream_chat_token';

const _loadingStyles = Styles(
  display: Display.flex,
  alignItems: AlignItems.center,
  justifyContent: JustifyContent.center,
  height: Unit.percent(100),
  fontSize: Unit.pixels(14),
  color: Color('#72767e'),
);

class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamChatClient _client;
  bool _ready = false;
  bool _autoConnected = false;

  @override
  void initState() {
    super.initState();
    _client = StreamChatClient(kDefaultStreamApiKey);
    _tryRestoreSession();
  }

  Future<void> _tryRestoreSession() async {
    final token = web.window.localStorage.getItem(_kTokenKey);
    if (token != null && defaultUsers.containsKey(token)) {
      try {
        await _client.connectUser(defaultUsers[token]!, token);
        _autoConnected = true;
      } catch (_) {
        web.window.localStorage.removeItem(_kTokenKey);
      }
    }
    setState(() => _ready = true);
  }

  @override
  Component build(BuildContext context) {
    if (!_ready) {
      return const div(styles: _loadingStyles, [Component.text('Loading...')]);
    }

    return StreamChatProvider(
      client: _client,
      child: Router(
        routes: [
          Route(
            path: '/',
            builder: (context, state) {
              if (_autoConnected) {
                Future.microtask(() => Router.of(context).replace('/channels'));
                return const div([]);
              }
              return ChooseUserPage(client: _client);
            },
          ),
          Route(
            path: '/channels',
            builder: (context, state) => const ChannelListPage(),
          ),
        ],
      ),
    );
  }
}
