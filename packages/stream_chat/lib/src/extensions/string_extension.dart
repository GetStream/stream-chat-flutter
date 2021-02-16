import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:mime/mime.dart';

/// Useful extension functions for [String]
extension StringX on String {
  /// Returns the mime type from the passed file name.
  http_parser.MediaType get mimeType {
    if (this == null) return null;
    if (toLowerCase().endsWith('heic')) {
      return http_parser.MediaType.parse('image/heic');
    } else {
      return http_parser.MediaType.parse(lookupMimeType(this));
    }
  }
}
