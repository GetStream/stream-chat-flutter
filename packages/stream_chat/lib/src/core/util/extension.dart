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

/// Extension providing merge functionality for any iterable.
extension IterableMergeExtension<T extends Object?> on Iterable<T> {
  /// Merges this iterable with another iterable of the same type.
  ///
  /// This method allows merging two iterables by identifying items with the
  /// same key and using an update function to combine them. Items that exist
  /// only in one iterable will be included in the result.
  ///
  /// Example:
  /// ```dart
  /// final list1 = [User(id: '1', name: 'John'), User(id: '2', name: 'Alice')];
  /// final list2 = [User(id: '1', age: 30), User(id: '3', name: 'Bob')];
  ///
  /// final merged = list1.merge(
  ///   list2,
  ///   key: (user) => user.id,
  ///   update: (original, updated) => original.copyWith(age: updated.age),
  /// );
  ///
  /// // Result: [
  /// //  User(id: '1', name: 'John', age: 30),
  /// //  User(id: '2', name: 'Alice'),
  /// //  User(id: '3', name: 'Bob'),
  /// // ]
  /// ```
  Iterable<T> merge<K>(
    Iterable<T>? other, {
    required K Function(T item) key,
    required T Function(T original, T updated) update,
  }) {
    if (other == null) return this;

    final itemMap = {for (final item in this) key(item): item};

    for (final item in other) {
      itemMap.update(
        key(item),
        (original) => update(original, item),
        ifAbsent: () => item,
      );
    }

    return itemMap.values;
  }
}
