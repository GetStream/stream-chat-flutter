import 'package:http_parser/http_parser.dart' as httpParser;
import 'package:mime/mime.dart';

class MediaUtils {
  static httpParser.MediaType getMimeType(String filename) {
    httpParser.MediaType mimeType;
    if (filename != null) {
      if (filename.toLowerCase().endsWith('heic')) {
        mimeType = httpParser.MediaType.parse('image/heic');
      } else {
        mimeType = httpParser.MediaType.parse(lookupMimeType(filename));
      }
    }

    return mimeType;
  }
}
