import 'package:stream_chat/src/core/models/attachment.dart';

/// {@template giphy_info_type}
/// The different types of quality for a Giphy attachment.
/// {@endtemplate}
enum GiphyInfoType {
  /// Original quality giphy, the largest size to load.
  original('original'),

  /// Lower quality with a fixed height, adjusts width according to the
  /// Giphy aspect ratio. Lower size than [original].
  fixedHeight('fixed_height'),

  /// Still image of the [fixedHeight] giphy.
  fixedHeightStill('fixed_height_still'),

  /// Lower quality with a fixed height with width adjusted according to the
  /// aspect ratio and played at a lower frame rate. Significantly lower size,
  /// but visually less appealing.
  fixedHeightDownsampled('fixed_height_downsampled')
  ;

  /// {@macro giphy_info_type}
  const GiphyInfoType(this.value);

  /// The value of the [GiphyInfoType].
  final String value;
}

/// {@template giphy_info}
/// A class that contains extra information about a Giphy attachment.
/// {@endtemplate}
class GiphyInfo {
  /// {@macro giphy_info}
  const GiphyInfo({
    required this.url,
    required this.width,
    required this.height,
  });

  /// The url for the Giphy image.
  final String url;

  /// The width of the Giphy image.
  final double width;

  /// The height of the Giphy image.
  final double height;

  @override
  String toString() => 'GiphyInfo{url: $url, width: $width, height: $height}';
}

/// GiphyInfo extension on [Attachment] class.
extension GiphyInfoX on Attachment {
  /// Returns the [GiphyInfo] for the given [type].
  GiphyInfo? giphyInfo(GiphyInfoType type) {
    final giphy = extraData['giphy'] as Map<String, Object?>?;
    if (giphy == null) return null;

    final info = giphy[type.value] as Map<String, Object?>?;
    if (info == null) return null;

    return GiphyInfo(
      url: info['url']! as String,
      width: double.parse(info['width']! as String),
      height: double.parse(info['height']! as String),
    );
  }
}
