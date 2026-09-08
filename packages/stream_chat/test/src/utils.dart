import 'dart:convert';
import 'dart:io';

import 'package:stream_chat/stream_chat.dart';

String fixture(String name) {
  final dir = currentDirectory.path;
  return File('$dir/test/fixtures/$name').readAsStringSync();
}

File assetFile(String name) {
  final dir = currentDirectory.path;
  return File('$dir/test/assets/$name');
}

Map<String, dynamic> jsonFixture(String name) => json.decode(fixture(name));

// https://github.com/flutter/flutter/issues/20907
Directory get currentDirectory {
  var directory = Directory.current;
  if (directory.path.endsWith('/test')) {
    directory = directory.parent;
  }
  return directory;
}

// Extension function to convert int into durations
extension IntX on num {
  Duration toDuration() => Duration(milliseconds: toInt());
}

// Top level util function to delay the code execution
Future delay(num milliseconds) => Future.delayed(Duration(milliseconds: milliseconds.toInt()));

/// Builds the [StreamApiException] a rejected request reports.
///
/// Defaults describe a request the server refused as malformed, which is the
/// shape most tests want when they only need "the API said no".
StreamApiException apiException({
  StreamErrorCode code = StreamErrorCode.inputError,
  int statusCode = 400,
  String message = 'The request was rejected',
}) => StreamApiException(message: message, statusCode: statusCode, code: code);
