import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Base class for handling attachment related functionality.
abstract class StreamAttachmentHandlerBase {
  /// Pick an image from the device.
  Future<Attachment?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) {
    throw UnimplementedError('pickImage is not implemented');
  }

  /// Pick a video from the device.
  Future<Attachment?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) {
    throw UnimplementedError('pickVideo is not implemented');
  }

  /// Pick a file from the device.
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

  /// Pick an audio from the device.
  Future<Attachment?> pickAudio() {
    throw UnimplementedError('pickAudio is not implemented');
  }

  /// Saves the [attachmentFile] to the temporary directory.
  Future<String> saveAttachmentFile({
    required AttachmentFile attachmentFile,
  }) {
    throw UnimplementedError('saveFile is not implemented');
  }

  /// Deletes the [attachmentFile] from the temporary directory.
  Future<void> deleteAttachmentFile({
    required AttachmentFile attachmentFile,
  }) {
    throw UnimplementedError('deleteAttachmentFile is not implemented');
  }

  /// Downloads the [attachment] to the device and returns
  /// the path to the file.
  Future<String?> downloadAttachment(
    Attachment attachment, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    throw UnimplementedError('downloadAttachment is not implemented');
  }
}

/// Stub implementation of [StreamAttachmentHandlerBase].
class StreamAttachmentHandler extends StreamAttachmentHandlerBase {
  /// Returns an instance of [StreamAttachmentHandler].
  static StreamAttachmentHandler get instance {
    throw UnimplementedError('instance is not implemented');
  }
}
