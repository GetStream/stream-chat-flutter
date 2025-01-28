import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

const _streamSvgIconsClassDocs = '''
/// Identifiers for the supported Stream SVG icons.
///
/// Use with the [StreamSvgIcon] class to show specific icons. Icons are
/// identified by their name as listed below, e.g. [StreamSvgIcons.settings].
///
/// {@tool snippet}
/// This example shows how to create a [Row] of [StreamSvgIcon]s in different
/// colors and sizes. The first [StreamSvgIcon] uses a
/// [StreamSvgIcon.semanticLabel] to announce in accessibility modes like
/// TalkBack and VoiceOver.
///
/// The following code snippet would generate a row of icons consisting of a
/// pink heart, a green musical note, and a blue umbrella, each progressively
/// bigger than the last.
///
/// ```dart
/// const Row(
///   mainAxisAlignment: MainAxisAlignment.spaceAround,
///   children: <Widget>[
///     StreamSvgIcon(
///       icon: StreamSvgIcons.settings,
///       color: Colors.pink,
///       size: 24.0,
///       semanticLabel: 'Text to announce in accessibility modes',
///     ),
///     StreamSvgIcon(
///       icon: StreamSvgIcons.lock,
///       color: Colors.green,
///       size: 30.0,
///     ),
///     StreamSvgIcon(
///       icon: StreamSvgIcons.mic,
///       color: Colors.blue,
///       size: 36.0,
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamSvgIcon]
///  * [IconButton]''';

Future<void> main() async {
  final iconsPath = path.join('lib', 'assets', 'icons');
  final svgIconFiles = await _getSvgIconFiles(iconsPath);

  final coloredIconsPath = path.join(iconsPath, 'colored');
  final coloredSvgIconFiles = await _getSvgIconFiles(coloredIconsPath);

  if (svgIconFiles.isEmpty && coloredSvgIconFiles.isEmpty) {
    print('No SVG icons found.');
    return;
  }

  final outputFile = File('lib/src/icons/stream_svg_icon.g.dart');

  final clazz = Class(
        (it) => it
      ..docs.add(_streamSvgIconsClassDocs)
      ..abstract = true
      ..modifier = ClassModifier.final$
      ..name = 'StreamSvgIcons'
      ..fields.addAll(
        [
          // The package that contains the Stream SVG icons.
          Field(
                (it) => it
              ..docs.add('/// The package that contains the Stream SVG icons.')
              ..static = true
              ..modifier = FieldModifier.constant
              ..type = refer('String')
              ..name = 'package'
              ..assignment = const Code("'stream_chat_flutter'"),
          ),
          // Icon data for each SVG file
          ...svgIconFiles.map(
                (file) {
              final iconFullName = path.basenameWithoutExtension(file.path);
              final iconName = iconFullName.replaceFirst('icon_', '');
              final camelCasedIconName = ReCase(iconName).camelCase;
              return Field(
                    (it) => it
                  ..docs.add("/// Stream SVG icon named '$camelCasedIconName'.")
                  ..static = true
                  ..modifier = FieldModifier.constant
                  ..type = refer('StreamSvgIconData')
                  ..name = camelCasedIconName
                  ..assignment = Code(
                    '''
                    StreamSvgIconData(
                      '${file.path}',
                      package: package,
                    )''',
                  ),
              );
            },
          ),
          // Icon data for each colored SVG file
          ...coloredSvgIconFiles.map(
                (file) {
              final iconFullName = path.basenameWithoutExtension(file.path);
              final iconName = iconFullName.replaceFirst('icon_', '');
              final camelCasedIconName = ReCase(iconName).camelCase;
              return Field(
                    (it) => it
                  ..docs.add("/// Stream SVG icon named '$camelCasedIconName'.")
                  ..static = true
                  ..modifier = FieldModifier.constant
                  ..type = refer('StreamSvgIconData')
                  ..name = camelCasedIconName
                  ..assignment = Code(
                    '''
                    StreamSvgIconData(
                      '${file.path}',
                      package: package,
                      preserveColors: true
                    )''',
                  ),
              );
            },
          ),
        ],
      ),
  );

  final library = Library((it) => it.body.add(clazz));
  final clazzSink = library.accept(DartEmitter.scoped());

  final formatter = DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
  );

  try {
    await outputFile.writeAsString(
      formatter.format(
        '''
      // GENERATED CODE - DO NOT MODIFY BY HAND
      // To regenerate, run: tools/stream_svg_icons_generator.dart
      
      part of 'stream_svg_icon.dart';
      
      // **************************************************************************
      // StreamSvgIconsGenerator
      // **************************************************************************
      
      $clazzSink
      ''',
      ),
    );
  } catch (e, stk) {
    print('Error generating Stream SVG icons: $e\n$stk');
  }

  print('Generated ${outputFile.path}');
}

// The pattern to match SVG icon file names. Example: icon_name.svg
//
// This pattern is as follows:
// - icon_ : The prefix of the file name
// - ([a-z0-9]+_)* : A sequence of lowercase letters or digits followed by an
//   underscore, repeated zero or more times
// - [a-z0-9]+ : A sequence of lowercase letters or digits
// - \.svg : The file extension
const _svgIconFileNamePattern = r'^icon_([a-z0-9]+_)*[a-z0-9]+\.svg$';

Future<List<File>> _getSvgIconFiles(String iconsPath) async {
  final iconsDirectory = Directory(iconsPath);

  if (!iconsDirectory.existsSync()) return [];

  final files = iconsDirectory.listSync().whereType<File>();
  final svgIconFiles = files.where(
        (file) {
      final split = file.path.split(Platform.pathSeparator);
      return split.last.contains(RegExp(_svgIconFileNamePattern));
    },
  ).toList();

  return svgIconFiles;
}
