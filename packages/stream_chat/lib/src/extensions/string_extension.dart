import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:mime/mime.dart';

/// Useful extension functions for [String]
extension StringX on String {
  /// Returns the mime type from the passed file name.
  http_parser.MediaType? get mimeType {
    if (toLowerCase().endsWith('heic')) {
      return http_parser.MediaType.parse('image/heic');
    } else {
      final mimeType = lookupMimeType(this);
      if (mimeType == null) {
        return null;
      }
      return http_parser.MediaType.parse(mimeType);
    }
  }
}
