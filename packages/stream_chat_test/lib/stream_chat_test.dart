/// BDD-style test helpers and utilities for Stream Chat SDK testing.
///
/// Re-exports `package:test` and `package:mocktail` so a test file only needs
/// two imports: `package:stream_chat/stream_chat.dart` and this library.
library;

// Re-export test framework and mocking library.
export 'package:mocktail/mocktail.dart';
// NOTE(re-evaluate): re-exported so tests can name `Token` / `TokenProvider`
// without importing `package:stream_chat/src/...` themselves. Re-evaluate once
// stream_chat exposes these from its public barrel or a testing entrypoint.
export 'package:stream_chat/src/core/http/token.dart' show Token;
export 'package:stream_chat/src/core/http/token_manager.dart' show TokenProvider;
export 'package:test/test.dart';

// Helpers
export 'src/helpers/api_mocker_mixin.dart';
export 'src/helpers/matchers.dart';
export 'src/helpers/mocks.dart';
export 'src/helpers/test_data.dart';

// Testers
export 'src/testers/base_tester.dart';
export 'src/testers/channel_tester.dart';
export 'src/testers/chat_client_tester.dart';
export 'src/testers/websocket_tester.dart';
