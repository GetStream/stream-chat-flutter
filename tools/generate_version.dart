import 'dart:io' show Directory, File;

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Updates the version constant in stream_chat/lib/version.dart based on
/// the version in its pubspec.yaml file.
Future<void> main() async {
  // Target the stream_chat package
  const packageName = 'stream_chat';
  final rootDir = Directory.current.path;
  final packageDir = p.join(rootDir, 'packages', packageName);
  final pubspecPath = p.join(packageDir, 'pubspec.yaml');
  final versionFilePath = p.join(packageDir, 'lib', 'version.dart');
  
  print('Reading version from $pubspecPath');
  
  // Read version from pubspec.yaml
  final yamlMap = loadYaml(File(pubspecPath).readAsStringSync()) as YamlMap;
  final version = yamlMap['version'] as String;
  
  print('Found version: $version');
  
  // Read the existing version file
  final versionFile = File(versionFilePath);
  if (!versionFile.existsSync()) {
    print('Error: Version file not found at $versionFilePath');
    return;
  }
  
  final fileContent = versionFile.readAsStringSync();
  
  // Update the version constant
  final updatedContent = fileContent.replaceFirst(
    RegExp('const PACKAGE_VERSION = .+;'), 
    "const PACKAGE_VERSION = '$version';",
  );
  
  // Write the changes back to the file
  await versionFile.writeAsString(updatedContent);
  
  print('✓ Successfully updated version to $version in $versionFilePath');
}