import 'package:stream_chat/src/core/http/token.dart';

/// A function which can be used to request a Stream Chat API token from your
/// own backend server. Function requires a single [userId].
typedef TokenProvider = Future<String> Function(String userId);

///
class TokenManager {
  ///
  TokenManager({
    String? userId,
    Token? token,
    TokenProvider? tokenProvider,
  })  : _userId = userId,
        _token = token,
        _provider = tokenProvider;

  String? _type;
  Token? _token;

  TokenProvider? _provider;

  String? _userId;

  /// User id to which this TokenManager is configured to
  String? get userId => _userId;

  ///
  bool get isStatic => _type == 'static';

  ///
  Future<Token> setTokenOrProvider(
    String userId, {
    Token? token,
    TokenProvider? provider,
  }) async {
    assert(() {
      if (token == null && provider == null) {
        throw AssertionError('Provide at-least token or provider');
      }
      if (token != null && provider != null) {
        throw AssertionError("Can't set both token and provider");
      }
      return true;
    }(), '');

    _userId = userId;

    if (token != null) {
      _type = 'static';
      _token = token;
    }
    if (provider != null) {
      _type = 'provider';
      _provider = provider;
    }

    return loadToken();
  }

  ///
  Future<Token> loadToken({bool refresh = false}) async {
    assert(
      _userId != null && _type != null,
      'Please call `setTokenOrProvider` before calling `loadToken`',
    );
    if (refresh || _token == null) {
      final rawValue = await _provider!(_userId!);
      _token = Token.fromRawValue(rawValue);
    }
    return _token!;
  }

  ///
  void reset() {
    _userId = null;
    _token = null;
    _provider = null;
  }
}
