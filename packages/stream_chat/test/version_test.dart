import 'dart:async';
import 'dart:io';

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat/version.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

// This alphabet uses `A-Za-z0-9_-` symbols. The genetic algorithm helped
// optimize the gzip compression for this alphabet.
const _alphabet =
    'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW';

/// Generates a random String id
/// Adopted from: https://github.com/ai/nanoid/blob/main/non-secure/index.js
String randomId({int size = 21}) {
  var id = '';
  for (var i = 0; i < size; i++) {
    id += _alphabet[(math.Random().nextDouble() * 64).floor() | 0];
  }
  return id;
}


void prepareTest() {
  // https://github.com/flutter/flutter/issues/20907
  if (Directory.current.path.endsWith('/test')) {
    Directory.current = Directory.current.parent;
  }
}

void main() {
  prepareTest();
  test('stream chat version matches pubspec', () async {
    print(randomId());

    // /// Create a new instance of [StreamChatClient]
    // /// by passing the apikey obtained from your project dashboard.
    // final client = StreamChatClient('b67pax5b2wdq', logLevel: Level.INFO);
    //
    // /// Set the current user. In a production scenario, this should be done using
    // /// a backend to generate a user token using our server SDK.
    // /// Please see the following for more information:
    // /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
    // await client.connectUser(
    //   User(
    //     id: 'cool-shadow-7',
    //     extraData: {
    //       'image':
    //           'https://getstream.io/random_png/?id=cool-shadow-7&amp;name=Cool+shadow',
    //     },
    //   ),
    //   '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiY29vbC1zaGFkb3ctNyJ9.gkOlCRb1qgy4joHPaxFwPOdXcGvSPvp6QY0S4mpRkVo''',
    // );
    //
    // try {
    //   await client.banUser('asdasdas');
    // } catch (e) {
    //   print(e);
    // }

    // final pubspecPath = '${Directory.current.path}/pubspec.yaml';
    // final pubspec = File(pubspecPath).readAsStringSync();
    // // ignore: unnecessary_string_escapes
    // final regex = RegExp('version:\s*(.*)');
    // final match = regex.firstMatch(pubspec);
    // expect(match, isNotNull);
    // expect(PACKAGE_VERSION, match?.group(1)?.trim());
  });
}
