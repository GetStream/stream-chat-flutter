import 'dart:ui' show hashValues;

import 'package:flutter/foundation.dart';

class IndexedKey extends LocalKey {
  /// Creates an indexed key that delegates its [operator==] to the given key.
  ///
  /// It contains an index used in [ScrollablePositionedList].
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
  int get hashCode => hashValues(runtimeType, key);

  @override
  String toString() {
    return '(IndexedKey) index: $index, key: $key';
  }
}
