/// A wrapper class for values that implements [Comparable].
///
/// This class is used to compare values of different types in a way that
/// allows for consistent ordering.
///
/// This is useful when sorting or comparing values in a consistent manner.
///
/// For example, when sorting a list of objects with different types of fields,
/// using this class will ensure that all values are compared correctly
/// regardless of their type.
class ComparableField<T> implements Comparable<ComparableField<T>> {
  const ComparableField._(this.value);

  /// Creates a new [ComparableField] instance from a [value].
  static ComparableField<T>? fromValue<T>(T? value) {
    if (value == null) return null;
    return ComparableField._(value);
  }

  /// The value to be compared.
  final T value;

  @override
  int compareTo(ComparableField<T> other) {
    return switch ((value, other.value)) {
      (final num a, final num b) => a.compareTo(b),
      (final String a, final String b) => a.compareTo(b),
      (final DateTime a, final DateTime b) => a.compareTo(b),
      (final bool a, final bool b) when a == b => 0,
      (final bool a, final bool b) => a && !b ? 1 : -1, // true > false
      _ => 0, // All comparisons were equal or incomparable types
    };
  }
}

/// A interface that provides a way to access comparable fields by string keys.
///
/// Classes that implement this class can be used in sorting operations
/// where the sort key is determined at runtime.
abstract interface class ComparableFieldProvider {
  /// Gets a comparable field value for the given [sortKey].
  ///
  /// Returns a [ComparableField] or null if no comparable field with the given
  /// sort key exists.
  ComparableField? getComparableField(String sortKey);
}
