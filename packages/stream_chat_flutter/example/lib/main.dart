import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

/// A chat-persisted StreamChatClient
final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.INFO,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Create a new instance of [StreamChatClient] passing the apikey obtained
  /// from your project dashboard.
  final client = StreamChatClient(
    'kv7mcsxr24p8',
    logLevel: Level.INFO,
  )..chatPersistenceClient = chatPersistentClient;

  /// Set the current user and connect the websocket. In a production
  /// scenario, this should be done using a backend to generate a user token
  /// using our server SDK.
  ///
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
  await client.connectUser(
    User(id: 'salvatore'),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FsdmF0b3JlIn0.pgiJz7sIc7iP29BHKFwe3nLm5-OaR_1l2P-SlgiC9a8',
  );

  final channel = client.channel('messaging', id: 'godevs2', extraData: {
    'members': ['salvatore'],
  });

  await channel.watch();

  await channel.enableSlowMode(cooldownInterval: 20);
  print('Channel cooldown set to ${channel.cooldown}');

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
/// This is implemented using [MessageListView], a widget that provides query
/// functionalities fetching the messages from the api and showing them in a
/// listView.
class ChannelPage extends StatelessWidget {
  /// Creates the page that shows the list of messages
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const ChannelHeader(),
        body: Column(
          children: const <Widget>[
            Expanded(
              child: MessageListView(),
            ),
            MessageInput(),
          ],
        ),
      );
}
