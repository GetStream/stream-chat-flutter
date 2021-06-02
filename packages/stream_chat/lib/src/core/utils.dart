import 'dart:convert';
import 'dart:math' as math;

// This alphabet uses `A-Za-z0-9_-` symbols. The genetic algorithm helped
// optimize the gzip compression for this alphabet.
const _alphabet =
    'ModuleSymbhasOwnPr0123456789ABCDEFGHNRVfgctiUvzKqYTJkLxpZXIjQW';

/// Generates a random String id
/// Adopted from: https://github.com/ai/nanoid/blob/main/non-secure/index.js
String randomId({int size = 21}) {
  var id = '';
  for (var i = 0; i < size; i++) {
    id += _alphabet[(math.Random().nextInt(32) * 64) | 0];
  }
  return id;
}

/// Creates a hash string from the passed [objects]
String generateHash(List<Object?> objects) {
  final payload = json.encode(objects);
  final payloadBytes = utf8.encode(payload);
  final payloadB64 = base64.encode(payloadBytes);
  return payloadB64;
}
