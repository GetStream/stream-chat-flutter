import 'dart:io';

File assetFile(String name) {
  final dir = currentDirectory.path;
  return File('$dir/test/assets/$name');
}

// https://github.com/flutter/flutter/issues/20907
Directory get currentDirectory {
  var directory = Directory.current;
  if (directory.path.endsWith('/test')) {
    directory = directory.parent;
  }
  return directory;
}
