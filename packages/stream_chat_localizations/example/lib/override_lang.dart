import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

class _CustomStreamChatLocalizationsDelegate
    extends LocalizationsDelegate<StreamChatLocalizations> {
  const _CustomStreamChatLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<StreamChatLocalizations> load(Locale locale) =>
      SynchronousFuture(CustomStreamChatLocalizationsEn());

  @override
  bool shouldReload(_CustomStreamChatLocalizationsDelegate old) => false;
}

/// Customized translations for English ('en')
class CustomStreamChatLocalizationsEn extends StreamChatLocalizationsEn {
  /// A [LocalizationsDelegate] for [StreamChatLocalizationsEn].
  static const delegate = _CustomStreamChatLocalizationsDelegate();

  @override
  String get launchUrlError => 'My custom error';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Create a new instance of [StreamChatClient] passing the apikey obtained
  /// from your project dashboard.
  final client = StreamChatClient(
    's2dxdhpxd94g',
    logLevel: Level.INFO,
  );

  /// Set the current user and connect the websocket. In a production
  /// scenario, this should be done using a backend to generate a user token
  /// using our server SDK.
  ///
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
  await client.connectUser(
    User(id: 'super-band-9'),
    '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A''',
  );

  final channel = client.channel('messaging', id: 'godevs');

  await channel.watch();

  runApp(
    MyApp(
      client: client,
      channel: channel,
    ),
  );
}

/// Example application using Stream Chat Flutter widgets.
///
/// Stream Chat Flutter is a set of Flutter widgets which provide full chat
/// functionalities for building Flutter applications using Stream. If you'd
/// prefer using minimal wrapper widgets for your app, please see our other
/// package, `stream_chat_flutter_core`.
class MyApp extends StatelessWidget {
  /// Example using Stream's Flutter package.
  ///
  /// If you'd prefer using minimal wrapper widgets for your app, please see
  /// our other package, `stream_chat_flutter_core`.
  const MyApp({
    Key? key,
    required this.client,
    required this.channel,
  }) : super(key: key);

  /// Instance of Stream Client.
  ///
  /// Stream's [StreamChatClient] can be used to connect to our servers and
  /// set the default user for the application. Performing these actions
  /// trigger a websocket connection allowing for real-time updates.
  final StreamChatClient client;

  /// Instance of the Channel
  final Channel channel;

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        // Add all the supported locales
        supportedLocales: const [
          Locale('en'),
          Locale('hi'),
          Locale('fr'),
          Locale('it'),
          Locale('es'),
          Locale('ja'),
          Locale('ko'),
          Locale('pt'),
        ],
        // Add overridden "CustomStreamChatLocalizationsEn.delegate" along with
        // "GlobalStreamChatLocalizations.delegates"
        localizationsDelegates: const [
          CustomStreamChatLocalizationsEn.delegate,
          ...GlobalStreamChatLocalizations.delegates,
        ],
        builder: (context, widget) => StreamChat(
          client: client,
          child: widget,
        ),
        home: StreamChannel(
          channel: channel,
          child: const ChannelPage(),
        ),
      );
}

/// A list of messages sent in the current channel.
///
/// This is implemented using [StreamMessageListView],
/// a widget that provides query
/// functionalities fetching the messages from the api and showing them in a
/// listView.
class ChannelPage extends StatelessWidget {
  /// Creates the page that shows the list of messages
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const StreamChannelHeader(),
        body: Column(
          children: const <Widget>[
            Expanded(
              child: StreamMessageListView(),
            ),
            StreamMessageInput(),
          ],
        ),
      );
}
