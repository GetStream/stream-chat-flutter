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
    this.queryParams = const {},
    this.headers = const {},
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

  /// Common query parameters.
  ///
  /// List values use the default [ListFormat.multiCompatible].
  ///
  /// The value can be overridden per parameter by adding a [MultiParam]
  /// object wrapping the actual List value and the desired format.
  final Map<String, Object?> queryParams;

  /// Http request headers.
  /// The keys of initial headers will be converted to lowercase,
  /// for example 'Content-Type' will be converted to 'content-type'.
  ///
  /// The key of Header Map is case-insensitive
  /// eg: content-type and Content-Type are
  /// regard as the same key.
  final Map<String, Object?> headers;
}
