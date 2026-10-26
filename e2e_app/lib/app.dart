import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

import 'auth/auth_controller.dart';
import 'pages/choose_user_page.dart';
import 'pages/home_page.dart';
import 'widgets/e2e_message_actions.dart';

/// Root widget of the e2e app.
///
/// [StreamChat] stays mounted whenever [AuthController.client] exists, so the
/// screens that read `StreamChat.of(context)` keep their ancestor across a
/// logout and the next login.
class E2eApp extends StatelessWidget {
  const E2eApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Chat E2E',
      theme: ThemeData(extensions: [StreamTheme(brightness: Brightness.light)]),
      localizationsDelegates: const [
        GlobalStreamChatLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      builder: (context, child) => ListenableBuilder(
        listenable: authController,
        builder: (context, child) {
          final wrapped = StreamSnackbarScope(child: child ?? const SizedBox.shrink());
          final client = authController.client;
          if (client == null) return StreamChatTheme(data: StreamChatThemeData(), child: wrapped);

          return StreamChat(
            client: client,
            connectivityStream: authController.debugConnectivityStream,
            configData: StreamChatConfigurationData(
              messageListViewConfiguration: const StreamMessageListViewConfiguration(
                highlightInitialMessage: true,
                swipeToReply: true,
              ),
            ),
            componentBuilders: StreamComponentBuilders(
              extensions: streamChatComponentBuilders(messageItem: e2eMessageItemBuilder),
            ),
            child: wrapped,
          );
        },
        child: child,
      ),
      home: ListenableBuilder(
        listenable: authController,
        builder: (context, _) => switch (authController.value) {
          Authenticated() => const HomePage(),
          Authenticating() => const Scaffold(body: Center(child: CircularProgressIndicator())),
          Unauthenticated() => const ChooseUserPage(),
        },
      ),
    );
  }
}
