/// Useful extension functions for [Map]
extension MapX on Map {
  /// Returns a new map with null keys or values removed
  Map<String, dynamic> get nullProtected {
    return {...this}..removeWhere((key, value) => key == null || value == null);
  }
}
