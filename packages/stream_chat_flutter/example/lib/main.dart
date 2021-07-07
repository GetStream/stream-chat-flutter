import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

// import 'package:stream_chat_persistence/stream_chat_persistence.dart';

// final chatPersistentClient = StreamChatPersistenceClient(
//   logLevel: Level.INFO,
// );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Create a new instance of [StreamChatClient] passing the apikey obtained from your
  /// project dashboard.
  final client = StreamChatClient(
    's2dxdhpxd94g',
    logLevel: Level.INFO,
  );

  /// Set the current user and connect the websocket. In a production scenario, this should be done using
  /// a backend to generate a user token using our server SDK.
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
  await client.connectUser(
    User(id: 'super-band-9'),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A',
  );

  final channel = client.channel('messaging', id: 'godevs');

  await channel.watch();

  runApp(MyApp(client, channel));
}

Locale get _defaultLocale {
  // Flutter 1.26 (2.0.1) returns `Locale?`, 1.27 `Locale`
  final Locale? locale = WidgetsBinding.instance?.window.locale;
  return locale ?? const Locale('en', 'US');
}

/// Example application using Stream Chat Flutter widgets.
/// Stream Chat Flutter is a set of Flutter widgets which provide full chat functionalities
/// for building Flutter applications using Stream.
/// If you'd prefer using minimal wrapper widgets for your app, please see our other
/// package, `stream_chat_flutter_core`.
class MyApp extends StatelessWidget {
  /// Instance of Stream Client.
  /// Stream's [StreamChatClient] can be used to connect to our servers and set the default
  /// user for the application. Performing these actions trigger a websocket connection
  /// allowing for real-time updates.
  final StreamChatClient client;

  /// Instance of the Channel
  final Channel channel;

  /// Example using Stream's Flutter package.
  /// If you'd prefer using minimal wrapper widgets for your app, please see our other
  /// package, `stream_chat_flutter_core`.
  MyApp(this.client, this.channel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      locale: Locale('de'),
      supportedLocales: [Locale('en'), Locale('it')],
      localizationsDelegates: GlobalStreamChatLocalizations(
          localeConfig: LocaleConfig(
        supportedLanguages: ['it'],
        customPath: 'lib/i18n',
      )).delegates,
      builder: (context, widget) {
        return StreamChat(
          client: client,
          child: widget,
        );
      },
      home: StreamChannel(
        channel: channel,
        child: ChannelPage(),
      ),
    );
  }
}

/// A list of messages sent in the current channel.
///
/// This is implemented using [MessageListView], a widget that provides query functionalities
/// fetching the messages from the api and showing them in a listView
class ChannelPage extends StatelessWidget {
  /// Creates the page that shows the list of messages
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}
