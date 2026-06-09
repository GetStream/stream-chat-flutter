// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// First step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// There are three important things to notice that are common to all Flutter
/// application using StreamChat:
///
/// 1. The Dart API [StreamChatClient] is initialized with your API Key
/// 2. The current user is set by calling [StreamChatClient.connectUser]
/// 3. The client is then passed to the top-level [StreamChat] widget
///    [StreamChat] is an inherited widget and must be the parent of all
///    Chat related widgets.
///
/// Please note that while Flutter can be used to build both mobile and web
/// applications, in this tutorial we focus on mobile. Make sure when running
/// the app that you use a mobile device.
///
/// Let's have a look at what we've built:
///
/// - We set up the Chat [StreamChatClient] with the API key
///
/// - We set the current user for Chat with [StreamChatClient.connectUser]
/// and a pre-generated user token
///
/// - We make [StreamChat] the root Widget of our application
///
/// - We create a single [ChannelPage] widget under [StreamChat] with three
/// widgets: [StreamChannelHeader], [StreamMessageListView]
/// and [StreamMessageComposer]
///
/// If you now run the simulator you will see a single channel UI.
Future<void> main() async {
  final client = StreamChatClient(
    's2dxdhpxd94g',
    logLevel: Level.INFO,
  );

  await client.connectUser(
    User(id: 'super-band-9'),
    '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A''',
  );

  final channel = client.channel('messaging', id: 'flutterdevs');

  await channel.watch();

  runApp(
    MyApp(
      client: client,
      channel: channel,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.client,
    required this.channel,
  });

  /// Instance of [StreamChatClient] we created earlier. This contains
  /// information about our application and connection state.
  final StreamChatClient client;

  /// The channel we'd like to observe and participate in.
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        return StreamChat(
          client: client,
          child: widget,
        );
      },
      home: StreamChannel(
        channel: channel,
        child: const ChannelPage(),
      ),
    );
  }
}

/// Displays the list of messages inside the channel.
class ChannelPage extends StatelessWidget {
  const ChannelPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: <Widget>[
          const Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageComposer(),
        ],
      ),
    );
  }
}
