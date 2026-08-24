// ignore_for_file: public_member_api_docs
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

/// Credentials and client setup shared by the tutorial entry points.
///
/// This mirrors the top of `lib/main.dart` in Step 4 of the
/// [Flutter Chat tutorial](https://getstream.io/chat/sdk/flutter/tutorial/).
/// The three `main_step*.dart` entry points differ only in `MyApp`, so the
/// setup lives here rather than being repeated in each of them.

/// Credentials from Step 3 of the tutorial.
/// - API key: `getstream env --target flutter` writes it to `dart_defines.json`,
///   passed in with `--dart-define-from-file` and read here. Falls back to the demo key.
/// - User + token: set [userId] to the user you minted a token for and paste that
///   token below - both must match, or the connection is rejected. Or keep the
///   demo pair below as-is.
const _envApiKey = String.fromEnvironment('STREAM_API_KEY');

const apiKey = _envApiKey == '' ? 'b67pax5b2wdq' : _envApiKey;
const userId = 'tutorial-flutter';
const userName = 'Tutorial Flutter';
const userToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c';

/// Builds the client, turns on offline storage, and connects the user.
Future<StreamChatClient> connectTutorialUser() async {
  /// Offline support: channels and messages are cached on device, so the app
  /// opens with content even without a connection. Attach the persistence
  /// client *before* `connectUser` - attaching it afterwards does nothing for
  /// the current session.
  final client = StreamChatClient(apiKey, logLevel: Level.INFO)
    ..chatPersistenceClient = StreamChatPersistenceClient(
      logLevel: Level.INFO,
      connectionMode: ConnectionMode.regular,
    );

  /// Development token from `getstream token`. In production, fetch the
  /// token from your backend after login - never hardcode secrets.
  await client.connectUser(
    User(id: userId, name: userName),
    userToken,
  );

  return client;
}
