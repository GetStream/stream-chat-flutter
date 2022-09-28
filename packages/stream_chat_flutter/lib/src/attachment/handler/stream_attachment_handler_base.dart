import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

abstract class StreamAttachmentHandlerBase {
  Future<Attachment?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) {
    throw UnimplementedError('pickImage is not implemented');
  }

  Future<Attachment?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) {
    throw UnimplementedError('pickVideo is not implemented');
  }

  Future<Attachment?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    bool withData = true,
    bool withReadStream = false,
    bool lockParentWindow = true,
  }) {
    throw UnimplementedError('pickFile is not implemented');
  }

  Future<Attachment?> pickAudio() {
    throw UnimplementedError('pickAudio is not implemented');
  }

  Future<String> saveAttachmentFile({
    required AttachmentFile attachmentFile,
  }) {
    throw UnimplementedError('saveFile is not implemented');
  }

  Future<void> deleteAttachmentFile({
    required AttachmentFile attachmentFile,
  }) {
    throw UnimplementedError('deleteAttachmentFile is not implemented');
  }

  Future<String?> downloadAttachment(
    Attachment attachment, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    Options? options,
  }) {
    throw UnimplementedError('downloadAttachment is not implemented');
  }
}

class StreamAttachmentHandler extends StreamAttachmentHandlerBase {
  static StreamAttachmentHandler get instance {
    throw UnimplementedError('instance is not implemented');
  }
}
