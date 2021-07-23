import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/location.dart';
import 'package:test/test.dart';

void main() {
  test('should return the all default set params', () {
    const options = StreamHttpClientOptions();
    expect(options.location, isNull);
    expect(options.baseUrl, 'https://chat-us-east-1.stream-io-api.com');
    expect(options.connectTimeout, const Duration(seconds: 6));
    expect(options.receiveTimeout, const Duration(seconds: 6));
    expect(options.queryParams, const {});
    expect(options.headers, const {});
  });

  test('should override all the default set params', () {
    const options = StreamHttpClientOptions(
      baseUrl: 'base-url',
      connectTimeout: Duration(seconds: 3),
      receiveTimeout: Duration(seconds: 3),
      headers: {
        'test': 'test',
      },
      queryParams: {
        '123': '123',
      },
    );
    expect(options.location, isNull);
    expect(options.baseUrl, 'base-url');
    expect(options.connectTimeout, const Duration(seconds: 3));
    expect(options.receiveTimeout, const Duration(seconds: 3));
    expect(options.headers, {'test': 'test'});
    expect(options.queryParams, {'123': '123'});
  });

  group('should create baseUrl according to provided location', () {
    test('us-east', () {
      const options = StreamHttpClientOptions(location: Location.usEast);
      expect(options.location, isNotNull);
      expect(options.baseUrl, 'https://chat-proxy-us-east.stream-io-api.com');
    });
    test('eu-west', () {
      const options = StreamHttpClientOptions(location: Location.euWest);
      expect(options.location, isNotNull);
      expect(options.baseUrl, 'https://chat-proxy-dublin.stream-io-api.com');
    });
    test('mumbai', () {
      const options = StreamHttpClientOptions(location: Location.mumbai);
      expect(options.location, isNotNull);
      expect(options.baseUrl, 'https://chat-proxy-mumbai.stream-io-api.com');
    });
    test('sydney', () {
      const options = StreamHttpClientOptions(location: Location.sydney);
      expect(options.location, isNotNull);
      expect(options.baseUrl, 'https://chat-proxy-sydney.stream-io-api.com');
    });
    test('singapore', () {
      const options = StreamHttpClientOptions(location: Location.singapore);
      expect(options.location, isNotNull);
      expect(options.baseUrl, 'https://chat-proxy-singapore.stream-io-api.com');
    });
  });
}
