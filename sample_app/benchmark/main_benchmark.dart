// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

import 'benchmark_page.dart';

// Run with:
//   flutter run --profile -t benchmark/main_benchmark.dart
//
// Credentials shared with sample_app — same API key + sahil user/token.
const _apiKey = 'kv7mcsxr24p8';
const _userId = 'sahil';
const _userToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FoaWwifQ.WnIUoB5gR2kcAsFhiDvkiD6zdHXZ-VSU2aQWWkhsvfo';

const _benchmarkChannelType = 'messaging';
const _benchmarkChannelId = 'perf-test-5k';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamChatClient(_apiKey, logLevel: Level.OFF);
  await client.connectUser(User(id: _userId), _userToken);

  runApp(_BenchmarkApp(client: client));
}

class _BenchmarkApp extends StatelessWidget {
  const _BenchmarkApp({required this.client});

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      supportedLocales: const [Locale('en')],
      localizationsDelegates: GlobalStreamChatLocalizations.delegates,
      builder: (context, widget) => StreamChat(
        client: client,
        child: widget,
      ),
      home: const _BenchmarkLauncher(),
    );
  }
}

class _BenchmarkLauncher extends StatefulWidget {
  const _BenchmarkLauncher();

  @override
  State<_BenchmarkLauncher> createState() => _BenchmarkLauncherState();
}

class _BenchmarkLauncherState extends State<_BenchmarkLauncher> {
  late final Future<Channel> _channelFuture = _watchBenchmarkChannel();

  Future<Channel> _watchBenchmarkChannel() async {
    final client = StreamChat.of(context).client;
    final channel = client.channel(
      _benchmarkChannelType,
      id: _benchmarkChannelId,
      extraData: const {'name': 'Perf benchmark'},
    );
    await channel.watch(
      messagesPagination: const PaginationParams(limit: 25),
    );
    return channel;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Channel>(
      future: _channelFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Failed to open channel:\n${snapshot.error}'),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return BenchmarkPage(channel: snapshot.data!);
      },
    );
  }
}
