import 'dart:async';

import 'package:synchronized/synchronized.dart';
import 'package:video_compress/video_compress.dart';

class ICompressVideoService {
  static final ICompressVideoService instance = ICompressVideoService._();
  final _lock = Lock();
  ICompressVideoService._();

  Future<MediaInfo> compressVideo(String path) async {
    return _lock.synchronized(() {
      return VideoCompress.compressVideo(
        path,
      );
    });
  }
}

ICompressVideoService get compressVideoService =>
    ICompressVideoService.instance;
