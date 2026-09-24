/// Helpers for moving custom fields in and out of the `extra_data` key of a
/// JSON map.
class Serializer {
  /// A copy of [json] with every key not in [topLevelFields] moved into
  /// `extra_data`.
  ///
  /// The `extra_data` entry is always present, even when every key is known.
  ///
  /// ```dart
  /// Serializer.moveToExtraDataFromRoot(
  ///   {
  ///     'id': '1',
  ///     'color': 'red',
  ///   },
  ///   ['id'],
  /// );
  ///
  /// // {
  /// //   'id': '1',
  /// //   'extra_data': {
  /// //     'color': 'red',
  /// //   },
  /// // }
  /// ```
  static Map<String, dynamic> moveToExtraDataFromRoot(
    Map<String, dynamic> json,
    List<String> topLevelFields,
  ) {
    final knownFields =
        _knownFieldsCache[topLevelFields] ??= topLevelFields.toSet();

    final root = <String, dynamic>{};
    final extraData = <String, dynamic>{};
    for (final MapEntry(:key, :value) in json.entries) {
      if (knownFields.contains(key)) {
        root[key] = value;
      } else {
        extraData[key] = value;
      }
    }

    root['extra_data'] = extraData;
    return root;
  }

  /// A copy of [json] with the entries of `extra_data` moved to the root.
  ///
  /// An entry in `extra_data` replaces a root entry with the same key.
  ///
  /// ```dart
  /// Serializer.moveFromExtraDataToRoot({
  ///   'id': '1',
  ///   'extra_data': {
  ///     'color': 'red',
  ///   },
  /// });
  ///
  /// // {
  /// //   'id': '1',
  /// //   'color': 'red',
  /// // }
  /// ```
  static Map<String, dynamic> moveFromExtraDataToRoot(
    Map<String, dynamic> json,
  ) {
    final extraData = json['extra_data'];
    return {...json, if (extraData != null) ...extraData}..remove('extra_data');
  }

  // Each list of top level fields as a set, built once, so key lookups stay
  // fast.
  static final _knownFieldsCache = Expando<Set<String>>();
}
