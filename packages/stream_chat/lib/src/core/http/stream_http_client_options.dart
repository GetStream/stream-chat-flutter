part of 'stream_http_client.dart';

const _defaultBaseURL = 'https://chat-us-east-1.stream-io-api.com';

/// Client options to modify [StreamHttpClient]
class StreamHttpClientOptions {
  /// Instantiates a new [StreamHttpClientOptions]
  const StreamHttpClientOptions({
    String? baseUrl,
    this.location,
    this.connectTimeout = const Duration(seconds: 6),
    this.receiveTimeout = const Duration(seconds: 6),
  }) : _baseUrl = baseUrl ?? _defaultBaseURL;

  final String _baseUrl;

  /// base url to use with client.
  String get baseUrl {
    if (location == null) return _baseUrl;
    const serviceName = 'chat';
    final locationName = location!.name;
    const baseDomainName = 'stream-io-api.com';
    return 'https://$serviceName-proxy-$locationName.$baseDomainName';
  }

  /// data center to use with client
  final Location? location;

  /// connect timeout, default to 6s
  final Duration connectTimeout;

  /// received timeout, default to 6s
  final Duration receiveTimeout;

  /// Get the current user agent
  String get userAgent => 'stream-chat-dart-client-'
      '${CurrentPlatform.name}-'
      '${PACKAGE_VERSION.split('+')[0]}';
}
