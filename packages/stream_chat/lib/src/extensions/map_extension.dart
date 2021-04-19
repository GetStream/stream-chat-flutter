/// Useful extension functions for [Map]
extension MapX<K, V> on Map<K, V> {
  /// Returns a new map with null keys or values removed
  Map<K, V> get nullProtected =>
      Map.from(this)..removeWhere((key, value) => key == null || value == null);
}
