import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:test/test.dart';

void main() {
  test('should return the all default set params', () {
    const options = StreamHttpClientOptions();
    expect(options.baseUrl, 'https://chat.stream-io-api.com');
    expect(options.connectTimeout, const Duration(seconds: 6));
    expect(options.receiveTimeout, const Duration(seconds: 6));
    expect(options.queryParameters, const {});
    expect(options.headers, const {});
  });

  test('should override all the default set params', () {
    const options = StreamHttpClientOptions(
      baseUrl: 'base-url',
      connectTimeout: Duration(seconds: 3),
      receiveTimeout: Duration(seconds: 3),
      headers: {'test': 'test'},
      queryParameters: {'123': '123'},
    );
    expect(options.baseUrl, 'base-url');
    expect(options.connectTimeout, const Duration(seconds: 3));
    expect(options.receiveTimeout, const Duration(seconds: 3));
    expect(options.headers, {'test': 'test'});
    expect(options.queryParameters, {'123': '123'});
  });
}
