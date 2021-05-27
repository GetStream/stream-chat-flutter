import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/user.dart';

///
class GuestApi {
  ///
  GuestApi(this._client);

  final StreamHttpClient _client;

  ///
  Future<ConnectGuestUserResponse> getGuestUser(User user) async {
    final response = await _client.post(
      '/guest',
      data: {'user': user},
    );
    return ConnectGuestUserResponse.fromJson(response.data);
  }
}
