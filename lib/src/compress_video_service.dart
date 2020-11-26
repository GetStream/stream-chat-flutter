import 'dart:async';
import 'package:synchronized/synchronized.dart';
import 'package:video_compress/video_compress.dart';

class CompressVideoService {
  static final CompressVideoService instance = CompressVideoService._();
  final _lock = Lock();
  CompressVideoService._();

  Future<MediaInfo> compressVideo(String path) async {
    print('VideoCompress.isCompressing: ${VideoCompress.isCompressing}');
    return _lock.synchronized(() {
      return VideoCompress.compressVideo(
        path,
      );
    });
  }
}
