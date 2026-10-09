import 'dart:convert' show JsonEncoder, jsonDecode;
import 'dart:io' show File, exit, stderr;

/// Applies the renames in a `renamed-models.json` file to an OpenAPI spec.
///
/// The backend spec generator does this natively via its `-renamed-models`
/// flag, but specs published by the protocol repo are generated without it,
/// so the renames have to be applied to the spec before generating a client.
///
/// Usage: dart tools/rename_openapi_models.dart <spec.json> <renames.json> <out.json>
void main(List<String> args) {
  if (args.length != 3) {
    stderr.writeln(
      'Usage: dart tools/rename_openapi_models.dart <spec.json> <renames.json> <out.json>',
    );
    exit(64);
  }

  final [specPath, renamesPath, outputPath] = args;

  final spec = jsonDecode(File(specPath).readAsStringSync()) as Map<String, dynamic>;
  final renames = (jsonDecode(File(renamesPath).readAsStringSync()) as Map<String, dynamic>).cast<String, String>();

  final components = spec['components'] as Map<String, dynamic>?;
  final schemas = components?['schemas'] as Map<String, dynamic>?;
  if (schemas == null) {
    stderr.writeln('No components.schemas found in $specPath');
    exit(1);
  }

  final applied = <String, String>{};
  for (final MapEntry(key: from, value: to) in renames.entries) {
    if (!schemas.containsKey(from)) continue;
    if (schemas.containsKey(to)) {
      stderr.writeln('Cannot rename $from to $to: $to already exists in the spec');
      exit(1);
    }

    schemas[to] = schemas.remove(from);
    applied[from] = to;
  }

  final refs = renameRefs(spec, applied);

  File(outputPath).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(spec));

  for (final MapEntry(key: from, value: to) in applied.entries) {
    print('• Renamed $from -> $to');
  }
  print('• Rewrote $refs \$ref(s)');
}

/// Rewrites every `$ref` in [node] pointing at a renamed schema, returning the
/// number of references rewritten.
int renameRefs(Object? node, Map<String, String> renames) {
  var count = 0;
  switch (node) {
    case final Map<String, dynamic> map:
      for (final key in map.keys.toList()) {
        final value = map[key];
        if (key == r'$ref' && value is String) {
          const prefix = '#/components/schemas/';
          if (!value.startsWith(prefix)) continue;

          final target = renames[value.substring(prefix.length)];
          if (target == null) continue;

          map[key] = '$prefix$target';
          count++;
        } else {
          count += renameRefs(value, renames);
        }
      }
    case final List<dynamic> list:
      for (final item in list) {
        count += renameRefs(item, renames);
      }
  }
  return count;
}
