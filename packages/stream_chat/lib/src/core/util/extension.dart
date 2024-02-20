import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// Useful extension functions for [Iterable]
extension IterableX<T> on Iterable<T?> {
  /// Removes all the null values
  /// and converts `Iterable<T?>` into `Iterable<T>`
  Iterable<T> get withNullifyer => whereType();
}

/// Useful extension functions for [Map]
extension MapX<K, V> on Map<K?, V?> {
  /// Returns a new map with null keys or values removed
  Map<K, V> get nullProtected {
    final nullProtected = {...this}
      ..removeWhere((key, value) => key == null || value == null);
    return nullProtected.cast();
  }
}

/// Useful extension functions for [String]
extension StringX on String {
  /// returns the media type from the passed file name.
  MediaType? get mediaType {
    if (toLowerCase().endsWith('heic')) {
      return MediaType.parse('image/heic');
    } else {
      final mimeType = lookupMimeType(this);
      if (mimeType == null) return null;
      return MediaType.parse(mimeType);
    }
  }
}
