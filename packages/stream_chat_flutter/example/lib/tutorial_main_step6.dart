// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_example/tutorial_channel_list_page.dart';
import 'package:stream_chat_flutter_example/tutorial_client.dart';
import 'package:stream_chat_flutter_example/tutorial_rounded_avatar.dart';

/// Step 6 of the
/// [Flutter Chat tutorial](https://getstream.io/chat/sdk/flutter/tutorial/) -
/// the themed app, with one widget swapped out.
///
/// Run with: `flutter run -t lib/tutorial_main_step6.dart`
///
/// Theming changes tokens (colors, fonts, shapes). To change an actual
/// *widget*, register a component builder and override only the slot you want -
/// every other widget keeps its default. Here [RoundedAvatar] replaces the
/// circular avatar with a rounded square.
///
/// `avatar` is one of the shared slots you pass directly. Chat-specific ones -
/// `messageItem`, `channelListItem`, `messageComposer` - go through
/// `extensions: streamChatComponentBuilders(...)` instead.
///
/// Component builders resolve through the factory, so they reach inside
/// [StreamChannelPage] too even though it owns its own header, list, and
/// composer. Only `MyApp` changes from `tutorial_main_step5.dart`.
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
    /// One brand color per brightness. Stream derives its whole semantic
    /// palette from the swatch, so this single value restyles bubbles,
    /// sending indicators, unread badges, and the composer cursor.
    final brand = StreamColorSwatch.fromColor(Colors.green);
    final brandDark = StreamColorSwatch.fromColor(
      Colors.green,
      brightness: Brightness.dark,
    );

    /// Per-widget override, merged on top of the derived palette. Reusing
    /// `brand.shade100` is what keeps the tiles and the message bubbles in
    /// the same green family.
    final customTheme = StreamChatThemeData(
      channelListItemTheme: StreamChannelListItemThemeData(
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: WidgetStateProperty.all(brand.shade100),
      ),
    );

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: [
          StreamTheme(
            brightness: Brightness.light,
            colorScheme: StreamColorScheme.light(brand: brand),
          ),
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: [
          StreamTheme(
            brightness: Brightness.dark,
            colorScheme: StreamColorScheme.dark(brand: brandDark),
          ),
        ],
      ),
      builder: (context, child) => StreamChat(
        client: client,
        themeData: customTheme,
        componentBuilders: StreamComponentBuilders(
          avatar: (context, props) => RoundedAvatar(props: props),
        ),
        child: child,
      ),
      home: const ChannelListPage(),
    );
  }
}
