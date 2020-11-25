import 'dart:async';
import 'package:video_compress/video_compress.dart';

class CompressVideoService {
  static final CompressVideoService instance = CompressVideoService._();

  CompressVideoService._();

  Future<MediaInfo> compressVideo(String path) async {
    MediaInfo mediaInfo;
    while (VideoCompress.isCompressing) {
      await Future.delayed(Duration(seconds: 1));
    }
    mediaInfo = await VideoCompress.compressVideo(
      path,
    );
    return mediaInfo;
  }
}
