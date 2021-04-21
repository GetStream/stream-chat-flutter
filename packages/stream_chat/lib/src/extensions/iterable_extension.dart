/// Useful extension functions for [Iterable]
extension IterableX<T> on Iterable<T?> {
  /// Removes all the null values
  /// and converts `Iterable<T?>` into `Iterable<T>`
  Iterable<T> get withNullifyer => [
        for (final item in this)
          if (item != null) item
      ];
}
