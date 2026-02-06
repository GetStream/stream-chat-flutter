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
    final nullProtected = {...this}..removeWhere((key, value) => key == null || value == null);
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

/// Extension on [Completer] to safely complete with value or error.
extension CompleterX<T> on Completer<T> {
  /// Safely completes the completer with the provided value.
  /// Returns early if the completer is already completed.
  void safeComplete([T? value]) {
    if (isCompleted) return;
    complete(value);
  }

  /// Safely completes the completer with the provided error.
  /// Returns early if the completer is already completed.
  void safeCompleteError(Object error, [StackTrace? stackTrace]) {
    if (isCompleted) return;
    completeError(error, stackTrace);
  }
}

/// Extension providing merge functionality for any iterable.
extension IterableMergeExtension<T extends Object?> on Iterable<T> {
  /// Merges this iterable with another iterable of the **same type**.
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
    return mergeFrom(
      other,
      key: key,
      value: (item) => item,
      update: update,
    );
  }

  /// Merges this iterable with another iterable of **a different type**.
  ///
  /// This method generalizes [merge] to support merging items of type [V]
  /// (for example, DTOs or partial updates) into an existing collection of
  /// items of type [T].
  ///
  /// The [value] function converts each [V] element into a corresponding [T]
  /// instance (or returns `null` to skip the item).
  ///
  /// The [key] extractor identifies how to match existing and new elements.
  /// When a matching key already exists, the [update] function determines how
  /// to combine the original and new values. If no match exists, the new
  /// element is added.
  ///
  /// Items that appear only in one iterable are preserved as-is.
  ///
  /// Example (merging DTOs into models):
  /// ```dart
  /// final users = [User(id: '1', name: 'John'), User(id: '2', name: 'Alice')];
  ///
  /// final dtos = [
  ///   UserDTO(id: '1', name: 'John Doe'),
  ///   UserDTO(id: '3', name: 'Bob'),
  /// ];
  ///
  /// final merged = users.mergeFrom(
  ///   dtos,
  ///   key: (user) => user.id,
  ///   value: (dto) => dto.toUser(),
  ///   update: (original, updated) => original.copyWith(name: updated.name),
  /// );
  ///
  /// // Result:
  /// // [
  /// //   User(id: '1', name: 'John Doe'),
  /// //   User(id: '2', name: 'Alice'),
  /// //   User(id: '3', name: 'Bob'),
  /// // ]
  /// ```
  ///
  /// Example (skipping null conversions):
  /// ```dart
  /// final list = [Item(id: 1, name: 'A')];
  /// final updates = [ItemUpdate(id: 1, name: null)];
  ///
  /// final merged = list.mergeFrom(
  ///   updates,
  ///   key: (item) => item.id,
  ///   value: (update) => update.toItemOrNull(),
  ///   update: (original, updated) => updated,
  /// );
  ///
  /// // The null return from `toItemOrNull()` causes the item to be skipped.
  /// ```
  Iterable<T> mergeFrom<K, V>(
    Iterable<V>? other, {
    required K Function(T item) key,
    required T? Function(V item) value,
    required T Function(T original, T updated) update,
  }) {
    if (other == null) return this;

    final itemMap = {for (final item in this) key(item): item};

    for (final otherItem in other) {
      final item = value.call(otherItem);
      if (item == null) continue;

      itemMap.update(
        key(item),
        (original) => update(original, item),
        ifAbsent: () => item,
      );
    }

    return itemMap.values;
  }
}

/// Extension on [Object] providing safe casting functionality.
extension SafeCastExtension on Object? {
  /// Safely casts the object to a specific type.
  ///
  /// Returns null if the object is null or cannot be cast to the type.
  T? safeCast<T>() {
    if (this is T) return this as T;
    return null;
  }
}
