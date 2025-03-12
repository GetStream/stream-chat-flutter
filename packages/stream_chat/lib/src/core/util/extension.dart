import 'dart:async';

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
    final mimeType = lookupMimeType(this);
    if (mimeType == null) return null;
    return MediaType.parse(mimeType);
  }
}

/// Extension on [StreamController] to safely add events and errors.
extension StreamControllerX<T> on StreamController<T> {
  /// Safely adds the event to the controller,
  /// Returns early if the controller is closed.
  void safeAdd(T event) {
    if (isClosed) return;
    add(event);
  }

  /// Safely adds the error to the controller,
  /// Returns early if the controller is closed.
  void safeAddError(Object error, [StackTrace? stackTrace]) {
    if (isClosed) return;
    addError(error, stackTrace);
  }
}
