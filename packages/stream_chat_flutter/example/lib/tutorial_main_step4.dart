// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_example/tutorial_channel_list_page.dart';
import 'package:stream_chat_flutter_example/tutorial_client.dart';

/// Step 4 of the
/// [Flutter Chat tutorial](https://getstream.io/chat/sdk/flutter/tutorial/) -
/// a working app on the default theme.
///
/// Run with: `flutter run -t lib/tutorial_main_step4.dart`
///
/// Two screens are all you write: the channel list, and the client setup that
/// puts [StreamChat] above the app. The conversation itself is
/// [StreamChannelPage], which the list navigates to.
///
/// `tutorial_main_step5.dart` and `tutorial_main_step6.dart` differ from this file only in
/// `MyApp` - that is the whole surface theming and component overrides touch.
Future<void> main() async {
  final client = await connectTutorialUser();

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.client});

  /// The client created in `main`. Holds the connection and the local cache.
  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// `StreamChat` must be an ancestor of every Stream widget. Putting it in
      /// `builder` keeps it above whatever `home` renders.
      builder: (context, child) => StreamChat(client: client, child: child),
      home: const ChannelListPage(),
    );
  }
}
