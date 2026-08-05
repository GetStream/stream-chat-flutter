export 'unsupported_db.dart'
    if (dart.library.io) 'native_db.dart' // implementation using dart:io
    if (dart.library.js_interop) 'web_db.dart';
