import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:jose/jose.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/utils.dart';

///
typedef GuestTokenProvider = Future<String> Function(User user);

///
enum AuthType {
  ///
  jwt,

  ///
  anonymous,
}

///
extension AuthTypeX on AuthType {
  ///
  String get raw => {
        AuthType.jwt: 'jwt',
        AuthType.anonymous: 'anonymous',
      }[this]!;
}

/// Token designed to store the JWT and the user it is related to.
class Token extends Equatable {
  const Token._({
    required this.rawValue,
    required this.userId,
    required this.authType,
  });

  /// The token that can be used when user is unknown.
  /// Is used by `anonymous` token provider.
  factory Token.anonymous({String? userId}) => Token._(
        rawValue: '',
        userId: userId ?? randomId(),
        authType: AuthType.anonymous,
      );

  /// Creates a [Token] instance from the provided [rawValue] if it's valid.
  factory Token.fromRawValue(String rawValue) {
    final jwtBody = JsonWebToken.unverified(rawValue);
    final userId = jwtBody.claims.getTyped<String>('user_id');
    assert(
      userId != null,
      'Invalid `token`, It should contain `user_id`',
    );
    return Token._(rawValue: rawValue, userId: userId!, authType: AuthType.jwt);
  }

  /// The token which can be used during the development.
  /// Is used by `development(userId:)` token provider.
  factory Token.development(String userId) {
    const devSignature = 'devtoken';
    const header = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';
    final payload = json.encode({'user_id': userId});
    final payloadBytes = utf8.encode(payload);
    final payloadB64 = base64.encode(payloadBytes);
    final jwt = '$header.$payloadB64.$devSignature';
    return Token._(rawValue: jwt, userId: userId, authType: AuthType.jwt);
  }

  /// The token which designed to be used for guest users.
  static Future<Token> guest(User user, GuestTokenProvider provider) async {
    final rawToken = await provider(user);
    return Token.fromRawValue(rawToken);
  }

  ///
  final AuthType authType;

  ///
  final String rawValue;

  ///
  final String userId;

  @override
  List<Object?> get props => [authType, rawValue, userId];
}
