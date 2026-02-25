import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:sample_app_jaspr/pages/channel_list_page.dart';
import 'package:sample_app_jaspr/pages/choose_user_page.dart';
import 'package:sample_app_jaspr/utils/app_config.dart';
import 'package:stream_chat_jaspr/stream_chat_jaspr.dart';

class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamChatClient _client;

  @override
  void initState() {
    super.initState();
    _client = StreamChatClient(kDefaultStreamApiKey);
  }

  @override
  Component build(BuildContext context) {
    return StreamChatProvider(
      client: _client,
      child: Router(
        routes: [
          Route(
            path: '/',
            builder: (context, state) => ChooseUserPage(client: _client),
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
