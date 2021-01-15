import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import 'channel_list_page.dart';
import 'stream_chat.dart';

void main() async {
  final client = Client(
    "qk4nn7rpcn75",
    logLevel: Level.INFO,
  );

  await client.setUser(
    User(id: "wild-breeze-7"),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo',
  );

  runApp(StreamChat(
    child: MyApp(),
    client: client,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stream Chat Example',
      home: ChatLoader(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff1f1f3),
        primaryColor: Color(0xfff1f1f3),
        accentColor: Color(0xff006bff),
        iconTheme: IconThemeData(
          color: Color(0xff006bff),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Color(0xff006bff),
        ),
        backgroundColor: Color(0xfff1f1f3),
        canvasColor: Color(0xfff1f1f3),
      ),
    );
  }

  @override
  void dispose() {
    StreamChat.of(context).dispose();
    super.dispose();
  }
}

class ChatLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    return StreamBuilder<User>(
      stream: streamChat.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return ChannelListPage(
            filter: {
              'members': {
                '\$in': [StreamChat.of(context).user.id],
              }
            },
            sort: [SortOption("last_message_at")],
            pagination: PaginationParams(
              limit: 20,
            ),
          );
        }
      },
    );
  }
}
