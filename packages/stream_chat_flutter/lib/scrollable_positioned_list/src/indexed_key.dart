import 'package:flutter/foundation.dart';

/// {@template indexed_key}
/// Creates an indexed key that delegates its [operator==] to the given key.
///
/// It contains an index used in [ScrollablePositionedList].
/// {@endtemplate}
class IndexedKey extends LocalKey {
  /// {@macro indexed_key}
  const IndexedKey(this.key, this.index);

  /// The key to which this this delegates its [operator==].
  final Key? key;

  /// Index used to show position in a list.
  final int index;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is IndexedKey && other.key == key;
  }

  @override
  int get hashCode => Object.hash(runtimeType, key);

  @override
  String toString() => '(IndexedKey) index: $index, key: $key';
}
