extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

/// List extension
extension ListX<T> on List<T> {
  /// Insert any item<T> inBetween the list items
  List<T> insertBetween(T item) => expand((e) sync* {
    yield item;
    yield e;
  }).skip(1).toList(growable: false);
}
