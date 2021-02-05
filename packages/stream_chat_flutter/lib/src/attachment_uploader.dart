import 'package:file_picker/file_picker.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'extension.dart';

abstract class AttachmentUploader {
  Future<String> uploadImage(
    PlatformFile file, {
    ProgressCallback onSendProgress,
  });

  Future<String> uploadFile(
    PlatformFile file, {
    ProgressCallback onSendProgress,
  });
}

class StreamAttachmentUploader implements AttachmentUploader {
  final Channel _channel;

  const StreamAttachmentUploader(this._channel);

  @override
  Future<String> uploadImage(
    PlatformFile file, {
    ProgressCallback onSendProgress,
  }) async {
    final filename = file.path?.split('/')?.last;
    final mimeType = filename.mimeType;
    final res = await _channel.sendImage(
      await MultipartFile.fromFile(
        file.path,
        filename: filename,
        contentType: mimeType,
      ),
      onSendProgress: onSendProgress,
    );
    return res.file;
  }

  @override
  Future<String> uploadFile(
    PlatformFile file, {
    ProgressCallback onSendProgress,
  }) async {
    final filename = file.path?.split('/')?.last;
    final mimeType = filename.mimeType;
    final res = await _channel.sendFile(
      await MultipartFile.fromFile(
        file.path,
        filename: filename,
        contentType: mimeType,
      ),
      onSendProgress: onSendProgress,
    );
    return res.file;
  }
}
