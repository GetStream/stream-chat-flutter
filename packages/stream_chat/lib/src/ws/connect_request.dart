import 'package:stream_core/stream_core.dart'
    show AuthType, SystemEnvironmentManager, UserToken, WebSocketOptions, WsRequest;

import '../core/models/own_user.dart';
import 'connect_user_details.dart';

/// Builds the request that opens a Stream Chat WebSocket connection.
///
/// Describes the endpoint to connect to, producing the [WebSocketOptions] a single connection
/// attempt is made with, and the [ConnectAuthRequest] that authenticates it once the socket is open.
class ConnectRequest {
  /// Creates a [ConnectRequest] against [endpoint].
  const ConnectRequest({
    required this.apiKey,
    required this.endpoint,
    required this.environment,
  });

  /// Creates a [ConnectRequest] against the connect endpoint of an API at [baseUrl].
  ConnectRequest.forApi(
    String baseUrl, {
    required this.apiKey,
    required this.environment,
  }) : endpoint = endpointFor(baseUrl);

  /// The key identifying the app the connection belongs to.
  final String apiKey;

  /// The address the connection is opened against.
  final String endpoint;

  /// Describes this SDK to the API.
  ///
  /// Read for each attempt, so a connection reflects how the app describes itself at the time it
  /// is opened.
  final SystemEnvironmentManager environment;

  /// The connect endpoint for an API at [baseUrl].
  ///
  /// Uses the same host as the API, over `wss` for an encrypted address and `ws` for a plain one.
  /// Throws a [FormatException] when [baseUrl] is neither.
  static String endpointFor(String baseUrl) {
    final api = Uri.parse(baseUrl);

    final scheme = switch (api.scheme) {
      'https' || 'wss' => 'wss',
      'http' || 'ws' => 'ws',
      _ => throw FormatException('Not an API address', baseUrl),
    };

    return Uri(
      scheme: scheme,
      host: api.host,
      port: api.hasPort ? api.port : null,
      pathSegments: ['api', 'v2', 'connect'],
    ).toString();
  }

  /// The options that open a connection authenticated with a [token] of its [UserToken.authType].
  ///
  /// The options never carry the token itself; [authenticate] sends it once the socket is open.
  WebSocketOptions build({required UserToken token}) {
    return WebSocketOptions(
      url: endpoint,
      queryParameters: {
        'api_key': apiKey,
        'stream-auth-type': token.authType.headerValue,
        'X-Stream-Client': environment.userAgent,
      },
    );
  }

  /// The first message of a connection opened for [user], authenticating it with [token].
  ///
  /// Set [includeUserDetails] to send the user's full details rather than their id alone, which
  /// creates or updates the user. If [token] is anonymous, [user] and
  /// [includeUserDetails] are not used.
  ConnectAuthRequest authenticate({
    required OwnUser user,
    required UserToken token,
    bool includeUserDetails = false,
  }) {
    if (token.authType == AuthType.anonymous) {
      return ConnectAuthRequest(token: token.rawValue, userDetails: const {'id': _anonymousUserId});
    }

    final details = ConnectUserDetails.fromOwnUser(user);
    return ConnectAuthRequest(
      token: token.rawValue,
      userDetails: includeUserDetails ? details.toJson() : {'id': details.id},
    );
  }
}

// The id an anonymous connection presents in place of the anonymous user's own.
const _anonymousUserId = 'anon';

/// The first message sent over a connection, which authenticates it.
class ConnectAuthRequest extends WsRequest {
  /// Creates a [ConnectAuthRequest] presenting [token] for the user [userDetails] describes.
  const ConnectAuthRequest({required this.token, required this.userDetails});

  /// The token the connection is authenticated with, which may be empty for an
  /// anonymous one.
  final String token;

  /// The user the connection is opened for: their id, and their full details when they are to be
  /// created or updated.
  final Map<String, Object?> userDetails;

  @override
  // The token goes last, so a value in the user details that cannot be
  // serialized stops the encoding before the token is written.
  Map<String, Object?> toJson() => {
    'products': const ['chat'],
    'user_details': userDetails,
    'token': token,
  };

  @override
  List<Object?> get props => [token, userDetails];

  // Leaves the token out, so it never reaches a log through this request.
  @override
  String toString() => 'ConnectAuthRequest(userDetails: $userDetails)';
}
