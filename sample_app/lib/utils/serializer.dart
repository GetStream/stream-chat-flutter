// TODO: Use from core once we migrate
/// Helper class for serialization to and from JSON with configurable extra data handling
mixin Serializer {
  /// Default key for storing extra/unknown fields
  static const defaultExtraDataKey = 'custom';

  /// Moves unknown JSON keys to a configurable extra data field
  ///
  /// Takes a JSON map and a set of known top-level fields.
  /// Known fields remain at the root level, unknown fields are moved
  /// to the specified extra data field.
  ///
  /// [extraDataKey] defaults to 'custom' but can be customized
  static Map<String, Object?> moveToExtraData(
    Map<String, Object?> json,
    Iterable<String> knownFields, {
    String extraDataKey = defaultExtraDataKey,
  }) {
    if (json.isEmpty) return <String, Object?>{};

    final result = <String, Object?>{};
    final extraData = <String, Object?>{};

    for (final MapEntry(:key, :value) in json.entries) {
      if (knownFields.contains(key) || key == extraDataKey) {
        result[key] = value;
      } else {
        extraData[key] = value;
      }
    }

    if (extraData.isNotEmpty) {
      result[extraDataKey] = extraData;
    }

    return result;
  }

  /// Moves fields from the extra data field back to the root level
  ///
  /// Takes a JSON map with an optional extra data field and flattens
  /// the extra data back to the root level.
  ///
  /// [extraDataKey] should match the key used in [moveToExtraData]
  static Map<String, Object?> moveFromExtraData(
    Map<String, Object?> json, {
    String extraDataKey = defaultExtraDataKey,
  }) {
    if (json.isEmpty) return <String, Object?>{};

    final result = <String, Object?>{...json};
    final extraData = result.remove(extraDataKey);

    if (extraData is Map<String, Object?>) {
      result.addAll(extraData);
    }

    return result;
  }
}
