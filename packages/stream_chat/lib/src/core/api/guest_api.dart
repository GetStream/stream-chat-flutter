import '../http/stream_http_client.dart';
import '../models/user.dart';
import 'responses.dart';

/// Defines the api dedicated to guest users operations
class GuestApi {
  /// Initialize a new guest api
  GuestApi(this._client);

  final StreamHttpClient _client;

  /// Returns the information about guest user
  Future<ConnectGuestUserResponse> getGuestUser(User user) async {
    final response = await _client.post(
      '/guest',
      data: {'user': user},
    );
    return ConnectGuestUserResponse.fromJson(response.data);
  }
}
