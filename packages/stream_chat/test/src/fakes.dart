import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';

class FakeTokenManager extends Fake implements TokenManager {
  final token = Token.development('test-user-id');

  @override
  bool get isStatic => true;

  @override
  String? get userId => token.userId;

  @override
  Future<Token> loadToken({bool refresh = false}) async => token;

  @override
  Future<Token> setTokenOrProvider(
    String userId, {
    Token? token,
    TokenProvider? provider,
  }) async =>
      this.token;

  @override
  void reset() {}
}
