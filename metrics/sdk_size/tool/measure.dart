// Measures how much each SDK variant adds to a release app, and the size of
// every publishable package's pub.dev archive.
//
// Usage, from the repository root:
//
//   dart run metrics/sdk_size/tool/measure.dart --platform android
//   dart run metrics/sdk_size/tool/measure.dart --platform ios --variant stream_chat
//   dart run metrics/sdk_size/tool/measure.dart --platform pub
//
// `pub` needs `melos bootstrap` first, so the packages resolve each other from
// their paths.
//
// Results land in build/sdk_size/results:
//
// - sizes-<platform>.json: KB each variant adds on top of `baseline`, or the
//   archive size of each package for `pub`.
// - breakdown-<platform>.json: bytes each variant adds per component, such as a
//   Dart package or a native library.
// - analysis/<platform>-<variant>.json: the raw `--analyze-size` output, which
//   opens in the DevTools App Size tool.
import 'dart:convert';
import 'dart:io';

const _baseline = 'baseline';
const _platforms = ['android', 'ios', 'pub'];

final _root = File.fromUri(Platform.script).parent.parent.parent.parent;
final _metricsDir = Directory('${_root.path}/metrics/sdk_size');
final _buildDir = Directory('${_root.path}/build/sdk_size');
final _resultsDir = Directory('${_buildDir.path}/results');

Future<void> main(List<String> args) async {
  final options = _parseArgs(args);
  final platform = options.platform;
  _resultsDir.createSync(recursive: true);

  if (platform == 'pub') {
    final sizes = await _measurePubArchives();
    _writeJson('sizes-pub.json', sizes);
    _printSizes('pub archive', sizes);
    return;
  }

  final variants = _variants(only: options.variants);
  final totals = <String, int>{};
  final components = <String, Map<String, int>>{};

  final template = await _createTemplate();
  for (final variant in variants) {
    stdout.writeln('\n▶ Building $variant for $platform');
    final app = await _createApp(template, variant);
    final analysis = await _build(app, platform);

    final copy = File('${_resultsDir.path}/analysis/$platform-$variant.json');
    copy.parent.createSync(recursive: true);
    analysis.copySync(copy.path);

    totals[variant] = _artifactSize(app, platform);
    final parts = _flatten(
      jsonDecode(analysis.readAsStringSync()) as Map<String, dynamic>,
    );
    if (!parts.keys.any((it) => it.startsWith('package:'))) {
      _fail('No Dart packages found in ${analysis.path}');
    }
    components[variant] = parts;
  }

  final sizes = <String, double>{};
  final breakdown = <String, Map<String, int>>{};
  final baselineTotal = totals[_baseline]!;
  final baselineComponents = components[_baseline]!;
  for (final variant in variants.where((it) => it != _baseline)) {
    sizes[variant] = _kb(totals[variant]! - baselineTotal);
    breakdown[variant] = _subtract(components[variant]!, baselineComponents);
  }

  _writeJson('sizes-$platform.json', sizes);
  _writeJson('breakdown-$platform.json', breakdown);
  _printSizes(platform, sizes);
  for (final MapEntry(key: variant, value: parts) in breakdown.entries) {
    _printBreakdown('$platform $variant', parts);
  }
  stdout.writeln(
    '\nOpen ${_resultsDir.path}/analysis/*.json in the DevTools App Size tool '
    '(`dart devtools`) to drill down further.',
  );
}

class _Options {
  _Options(this.platform, this.variants);

  final String platform;
  final List<String> variants;
}

_Options _parseArgs(List<String> args) {
  String? platform;
  final variants = <String>[];
  String value(int i) {
    if (i >= args.length) _fail('Missing a value for ${args[i - 1]}.');
    return args[i];
  }

  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--platform':
        platform = value(++i);
      case '--variant':
        variants.add(value(++i));
      default:
        _fail('Unknown argument: ${args[i]}');
    }
  }
  if (platform == null || !_platforms.contains(platform)) {
    _fail('Pass --platform with one of ${_platforms.join(', ')}.');
  }
  return _Options(platform, variants);
}

/// The variants under `variants/` passed with `--variant`, or all of them, with
/// `baseline` first since the others are measured against it.
List<String> _variants({required List<String> only}) {
  final all =
      Directory('${_metricsDir.path}/variants')
          .listSync()
          .whereType<Directory>()
          .map(_name)
          .where((it) => only.isEmpty || only.contains(it) || it == _baseline)
          .toList()
        ..sort();
  for (final name in only) {
    if (!all.contains(name)) _fail('Unknown variant: $name');
  }
  return [_baseline, ...all.where((it) => it != _baseline)];
}

/// A fresh `flutter create --empty` app.
Future<Directory> _createTemplate() async {
  final template = Directory('${_buildDir.path}/template');
  if (template.existsSync()) template.deleteSync(recursive: true);
  await _run('flutter', [
    'create',
    '--empty',
    '--platforms=android,ios',
    '--org=io.getstream',
    '--project-name=sdk_size_app',
    template.path,
  ]);
  return template;
}

Future<Directory> _createApp(Directory template, String variant) async {
  final app = Directory('${_buildDir.path}/apps/$variant');
  if (app.existsSync()) app.deleteSync(recursive: true);
  app.parent.createSync(recursive: true);
  await _run('cp', ['-R', template.path, app.path]);

  final variantDir = '${_metricsDir.path}/variants/$variant';
  final dependencies = File(
    '$variantDir/dependencies.yaml',
  ).readAsStringSync().trimRight();
  File('${app.path}/pubspec.yaml').writeAsStringSync('''
name: sdk_size_app
publish_to: none

environment:
  sdk: ${_sdkConstraint()}

dependencies:
  flutter:
    sdk: flutter
$dependencies

${_dependencyOverrides()}
flutter:
  uses-material-design: true
''');
  File('$variantDir/main.dart').copySync('${app.path}/lib/main.dart');
  return app;
}

/// The Dart SDK constraint the packages are published with.
String _sdkConstraint() {
  final pubspec = File('${_root.path}/packages/stream_chat/pubspec.yaml');
  final match = RegExp(
    r'^  sdk: (.+)$',
    multiLine: true,
  ).firstMatch(pubspec.readAsStringSync());
  if (match == null) _fail('No SDK constraint in ${pubspec.path}');
  return match.group(1)!.trim();
}

/// Path overrides for every repository package.
String _dependencyOverrides() {
  final block = ['dependency_overrides:'];
  for (final package in _packages()) {
    block
      ..add('  ${_name(package)}:')
      ..add('    path: ${package.path}');
  }
  return '${block.join('\n')}\n';
}

/// Every package under `packages/`.
List<Directory> _packages() {
  return Directory(
      '${_root.path}/packages',
    ).listSync().whereType<Directory>().where((dir) => File('${dir.path}/pubspec.yaml').existsSync()).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
}

String _name(FileSystemEntity entity) => entity.uri.pathSegments.where((s) => s.isNotEmpty).last;

/// Builds a release app with `--analyze-size` and returns the analysis file.
Future<File> _build(Directory app, String platform) async {
  await _run('flutter', ['pub', 'get'], workingDirectory: app.path);
  final output = await _run('flutter', [
    'build',
    if (platform == 'android') ...[
      'apk',
      '--target-platform=android-arm64',
      // Also drops plugins' native libraries for other ABIs.
      '--split-per-abi',
    ] else ...[
      'ios',
      '--no-codesign',
    ],
    '--release',
    '--analyze-size',
    '--code-size-directory=${app.path}/build/code-size',
  ], workingDirectory: app.path);

  // Flutter writes the summary under ~/.flutter-devtools and prints its path.
  final match = RegExp(
    r'analysis can be found at: (\S+\.json)',
  ).firstMatch(output);
  if (match == null) _fail('No size analysis reported for ${app.path}');
  return File(match.group(1)!);
}

/// The size a user installs: the APK on Android, the `Runner.app` bundle on
/// iOS.
int _artifactSize(Directory app, String platform) {
  if (platform == 'android') {
    return File(
      '${app.path}/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk',
    ).lengthSync();
  }
  return Directory(
    '${app.path}/build/ios/iphoneos/Runner.app',
  ).listSync(recursive: true, followLinks: false).whereType<File>().fold(0, (sum, file) => sum + file.lengthSync());
}

/// Flattens an `--analyze-size` tree into components: one per Dart package in
/// the AOT snapshot, one per native library or framework, and one per
/// remaining top-level entry such as `classes.dex` or `assets`.
Map<String, int> _flatten(Map<String, dynamic> root) {
  final result = <String, int>{};
  void add(String key, int value) => result[key] = (result[key] ?? 0) + value;

  void visit(Map<String, dynamic> node, String topLevel) {
    final name = node['n'] as String;
    final value = _value(node);
    final children = (node['children'] as List?)?.cast<Map<String, dynamic>>();

    if (name.contains('(Dart AOT)')) {
      for (final child in children ?? const <Map<String, dynamic>>[]) {
        add(_dartPackage(child['n'] as String), _value(child));
      }
      return;
    }
    if (_isNativeLibrary(name) && !_containsDartAot(node)) {
      add('native:$name', value);
      return;
    }
    if (children == null || children.isEmpty) {
      add(topLevel, value);
      return;
    }
    for (final child in children) {
      visit(child, topLevel);
    }
  }

  final children = (root['children'] as List).cast<Map<String, dynamic>>();
  // iOS wraps everything in a single Runner.app node.
  final top = children.length == 1 && children.single['children'] != null
      ? (children.single['children'] as List).cast<Map<String, dynamic>>()
      : children;
  for (final child in top) {
    visit(child, child['n'] as String);
  }
  return result;
}

int _value(Map<String, dynamic> node) {
  final value = node['value'] as num?;
  if (value != null) return value.toInt();
  final children = (node['children'] as List?)?.cast<Map<String, dynamic>>();
  return children?.fold<int>(0, (sum, child) => sum + _value(child)) ?? 0;
}

/// `libflutter.so (Flutter Engine)`, `sqlite3.framework`, and so on.
bool _isNativeLibrary(String name) => RegExp(r'\.(so|framework)\b').hasMatch(name);

bool _containsDartAot(Map<String, dynamic> node) {
  if ((node['n'] as String).contains('(Dart AOT)')) return true;
  final children = (node['children'] as List?)?.cast<Map<String, dynamic>>();
  return children?.any(_containsDartAot) ?? false;
}

/// `package:stream_chat/src/client.dart` → `package:stream_chat`, and the
/// snapshot's own buckets, such as `@shared`, → `dart:@shared`.
String _dartPackage(String name) {
  final slash = name.indexOf('/');
  final library = slash == -1 ? name : name.substring(0, slash);
  return library.startsWith('package:') || library.startsWith('dart:') ? library : 'dart:$library';
}

Map<String, int> _subtract(Map<String, int> variant, Map<String, int> base) {
  final result = <String, int>{};
  for (final key in {...variant.keys, ...base.keys}) {
    final delta = (variant[key] ?? 0) - (base[key] ?? 0);
    if (delta != 0) result[key] = delta;
  }
  return Map.fromEntries(
    result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
  );
}

/// `flutter pub publish --dry-run` archive size for every publishable package.
Future<Map<String, double>> _measurePubArchives() async {
  final unpublished = RegExp(r'''^publish_to:\s*['"]?none''', multiLine: true);
  final packages = _packages().where(
    (dir) => !unpublished.hasMatch(
      File('${dir.path}/pubspec.yaml').readAsStringSync(),
    ),
  );

  final sizes = <String, double>{};
  final pattern = RegExp(r'Total compressed archive size: ([\d.]+) (B|KB|MB)');
  for (final dir in packages) {
    final name = _name(dir);
    stdout.writeln('▶ pub publish --dry-run: $name');
    // A dry run exits non-zero on warnings, but still reports the size.
    final result = await Process.run(
      'flutter',
      ['pub', 'publish', '--dry-run'],
      workingDirectory: dir.path,
      runInShell: true,
    );
    final match = pattern.firstMatch('${result.stdout}${result.stderr}');
    if (match == null) {
      stderr
        ..writeln(result.stdout)
        ..writeln(result.stderr);
      _fail('No archive size reported for $name');
    }
    final value = double.parse(match.group(1)!);
    sizes[name] = switch (match.group(2)) {
      'B' => value / 1024,
      'MB' => value * 1024,
      _ => value,
    };
  }
  return sizes;
}

/// Runs a command, streaming its output, and returns its stdout.
Future<String> _run(
  String executable,
  List<String> args, {
  String? workingDirectory,
}) async {
  final process = await Process.start(
    executable,
    args,
    workingDirectory: workingDirectory,
    runInShell: true,
  );
  final output = StringBuffer();
  await Future.wait([
    process.stdout.transform(utf8.decoder).forEach((chunk) {
      output.write(chunk);
      stdout.write(chunk);
    }),
    stderr.addStream(process.stderr),
  ]);
  final code = await process.exitCode;
  if (code != 0) _fail('`$executable ${args.join(' ')}` exited with $code');
  return output.toString();
}

void _writeJson(String name, Object value) {
  File('${_resultsDir.path}/$name').writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(value)}\n',
  );
}

double _kb(int bytes) => double.parse((bytes / 1024).toStringAsFixed(1));

void _printSizes(String title, Map<String, double> sizes) {
  stdout.writeln('\n$title (KB)');
  for (final MapEntry(:key, :value) in sizes.entries) {
    stdout.writeln('  ${key.padRight(40)} ${value.toStringAsFixed(1)}');
  }
}

void _printBreakdown(String title, Map<String, int> parts) {
  stdout.writeln('\n$title, added on top of $_baseline (KB)');
  for (final MapEntry(:key, :value) in parts.entries.take(15)) {
    stdout.writeln('  ${key.padRight(60)} ${_kb(value).toStringAsFixed(1)}');
  }
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}
