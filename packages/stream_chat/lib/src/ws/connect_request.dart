import 'dart:convert';

import 'package:stream_core/stream_core.dart' show SystemEnvironmentManager, UserToken, WebSocketOptions;

import '../core/models/own_user.dart';
import 'connect_user_details.dart';

/// Builds the request that opens a Stream Chat WebSocket connection.
///
/// Describes the endpoint to connect to and the credentials to present, producing the
/// [WebSocketOptions] a single connection attempt is made with.
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
      pathSegments: ['connect'],
    ).toString();
  }

  /// The options that open a connection for [user], presenting [token].
  ///
  /// Set [includeUserDetails] to send the user's full details rather than their id alone, which
  /// creates or updates them server-side.
  WebSocketOptions build({
    required OwnUser user,
    required UserToken token,
    bool includeUserDetails = false,
  }) {
    final details = ConnectUserDetails.fromOwnUser(user);

    return WebSocketOptions(
      url: endpoint,
      queryParameters: {
        'api_key': apiKey,
        'authorization': token.rawValue,
        'stream-auth-type': token.authType.name,
        'X-Stream-Client': jsonEncode(environment.userAgent),
        'json': jsonEncode({
          'user_id': details.id,
          'user_details': includeUserDetails ? details : {'id': details.id},
          'server_determines_connection_id': true,
        }),
      },
    );
  }
}
