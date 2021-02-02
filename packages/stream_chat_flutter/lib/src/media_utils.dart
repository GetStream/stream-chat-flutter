import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:mime/mime.dart';

class MediaUtils {
  static http_parser.MediaType getMimeType(String filename) {
    http_parser.MediaType mimeType;
    if (filename != null) {
      if (filename.toLowerCase().endsWith('heic')) {
        mimeType = http_parser.MediaType.parse('image/heic');
      } else {
        mimeType = http_parser.MediaType.parse(lookupMimeType(filename));
      }
    }

    return mimeType;
  }
}
