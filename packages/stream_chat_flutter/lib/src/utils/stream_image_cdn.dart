/// Resize mode for CDN image transformations.
///
/// See the [Stream Image Resizing docs](https://getstream.io/chat/docs/flutter-dart/file_uploads/?language=dart#image-resizing)
/// for more information.
enum ResizeMode {
  /// Resizes the image to fit within the given dimensions, preserving the
  /// aspect ratio. The image may be smaller than the requested size.
  clip('clip'),

  /// Resizes and crops the image to exactly fill the given dimensions.
  crop('crop'),

  /// Stretches the image to exactly fill the given dimensions,
  /// ignoring the aspect ratio.
  scale('scale'),

  /// Resizes the image to fill the given dimensions, preserving the
  /// aspect ratio. Parts of the image may be cropped.
  fill('fill');

  const ResizeMode(this.value);

  /// The raw string value used as a CDN query parameter.
  final String value;
}

/// Crop alignment for CDN image transformations.
///
/// This determines which part of the image is preserved when cropping.
enum CropMode {
  /// Crop from the center of the image.
  center('center'),

  /// Crop from the top of the image.
  top('top'),

  /// Crop from the bottom of the image.
  bottom('bottom'),

  /// Crop from the left of the image.
  left('left'),

  /// Crop from the right of the image.
  right('right');

  const CropMode(this.value);

  /// The raw string value used as a CDN query parameter.
  final String value;
}

/// Configuration for resizing an image via a CDN.
///
/// When passed to [StreamImageCDN.resolveUrl], the CDN will resize the image
/// to the given [width] and [height] using the specified [mode] and [crop].
class ImageResize {
  /// Creates a new [ImageResize] configuration.
  const ImageResize({
    required this.width,
    required this.height,
    this.mode = .clip,
    this.crop = .center,
  });

  /// The target width in logical pixels.
  final double width;

  /// The target height in logical pixels.
  final double height;

  /// The resize mode to use.
  ///
  /// Defaults to [ResizeMode.clip].
  final ResizeMode mode;

  /// The crop alignment when the resize mode requires cropping.
  ///
  /// Defaults to [CropMode.center].
  final CropMode crop;
}

/// Handles CDN URL resolution and cache key generation for Stream Chat images.
///
/// The default implementation supports Stream's own CDN
/// (`stream-io-cdn.com`).
///
/// To customize behavior for a custom CDN, extend this class and override
/// [resolveUrl] and/or [cacheKey]:
///
/// ```dart
/// class MyImageCDN extends StreamImageCDN {
///   @override
///   String cacheKey(String imageUrl) {
///     // Custom cache key logic for your CDN.
///     return Uri.parse(imageUrl).path;
///   }
/// }
/// ```
///
/// Then inject it via [StreamChatConfigurationData]:
///
/// ```dart
/// StreamChat(
///   client: client,
///   configData: StreamChatConfigurationData(
///     imageCDN: MyImageCDN(),
///   ),
///   child: ...,
/// )
/// ```
class StreamImageCDN {
  /// Creates a new [StreamImageCDN] instance.
  const StreamImageCDN();

  // Placeholder for an unset dimension; not a size the client chose.
  static const _wildcard = '*';

  // The host suffix for Stream's image CDN.
  static const _streamCDNHost = 'stream-io-cdn.com';

  // Whether [uri] is served from Stream's image CDN.
  //
  // Matched whole or as a dot-separated suffix, so a lookalike such as
  // `evilstream-io-cdn.com` is not mistaken for ours.
  static bool _isStreamCDN(Uri uri) {
    // A trailing dot is the absolute form of the same host.
    var host = uri.host;
    if (host.endsWith('.')) host = host.substring(0, host.length - 1);

    return host == _streamCDNHost || host.endsWith('.$_streamCDNHost');
  }

  // Parameters that identify a rendition, in cache-key order.
  //
  // These are the image-transformation parameters that affect which rendition
  // is returned; everything else is stripped from the cache key.
  static const _persistedParameters = ['crop', 'h', 'resize', 'w'];

  /// Resolves the [sourceUrl] by appending resize/transform parameters
  /// appropriate for the CDN.
  ///
  /// When [resize] is null, no resizing parameters are added and the
  /// [sourceUrl] is returned unchanged.
  ///
  /// For non-Stream CDN URLs, returns [sourceUrl] unchanged regardless
  /// of [resize]. A URL that already requests a specific size is also
  /// returned unchanged, so [resize] never replaces a size already on it.
  ///
  /// Override this to customize URL rewriting for a custom CDN.
  String resolveUrl(String sourceUrl, {ImageResize? resize}) {
    final uri = Uri.tryParse(sourceUrl);
    if (uri == null || !_isStreamCDN(uri)) return sourceUrl;
    if (resize == null || _isAlreadySized(uri)) return sourceUrl;

    final queryParameters = {
      ...uri.queryParameters,
      'w': resize.width == 0 ? _wildcard : resize.width.floor().toString(),
      'h': resize.height == 0 ? _wildcard : resize.height.floor().toString(),
      'resize': resize.mode.value,
      'ro': '0',
    };

    // Only meaningful with a crop resize, and it reaches the cache key, so a
    // crop left over from the source URL would split one rendition in two.
    if (resize.mode == ResizeMode.crop) {
      queryParameters['crop'] = resize.crop.value;
    } else {
      queryParameters.remove('crop');
    }

    return uri.replace(queryParameters: queryParameters).toString();
  }

  // Whether [uri] already asks the CDN for a specific size. A crop or a
  // resize mode alone does not select one.
  static bool _isAlreadySized(Uri uri) {
    final params = uri.queryParameters;
    return const ['w', 'h'].any((name) {
      final value = params[name];
      return value != null && value != _wildcard;
    });
  }

  /// Returns a stable cache key for [imageUrl], stripping volatile
  /// authentication parameters (e.g. CloudFront signed URL tokens)
  /// while preserving those that identify distinct image renditions.
  ///
  /// Only the parameters that identify a rendition (`crop`, `h`, `resize`,
  /// `w`) are kept, always in the same order, so one rendition yields one key
  /// however the source URL ordered them.
  ///
  /// For non-Stream CDN URLs, returns the full URL string unchanged.
  ///
  /// Override this to customize cache key generation for a custom CDN.
  String cacheKey(String imageUrl) {
    final uri = Uri.tryParse(imageUrl);
    if (uri == null || !_isStreamCDN(uri)) return imageUrl;

    final params = uri.queryParameters;
    final filteredParams = {
      for (final name in _persistedParameters)
        if (params[name] case final value?) name: value,
    };

    return uri.replace(queryParameters: filteredParams).toString();
  }
}
