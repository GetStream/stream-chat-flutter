import 'package:file_picker/file_picker.dart';
import 'package:stream_chat_flutter/src/attachment/handler/common.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler_base.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// StreamAttachmentHandler implementation for html.
class StreamAttachmentHandler extends StreamAttachmentHandlerBase {
  StreamAttachmentHandler._();

  static StreamAttachmentHandler? _instance;

  /// Returns the singleton instance of [StreamAttachmentHandler].
  // ignore: prefer_constructors_over_static_methods
  static StreamAttachmentHandler get instance =>
      _instance ??= StreamAttachmentHandler._();

  late final _filePicker = FilePicker.platform;

  @override
  Future<Attachment?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    bool withData = true,
    bool withReadStream = false,
    bool lockParentWindow = true,
  }) async {
    final result = await _filePicker.pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      compressionQuality: compressionQuality,
      withData: withData,
      withReadStream: withReadStream,
      lockParentWindow: lockParentWindow,
    );

    return result?.files.first.toAttachment(type: type.toAttachmentType());
  }

  @override
  Future<String?> downloadAttachment(
    Attachment attachment, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final data = await downloadAttachmentData(
      attachment,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: options,
    );

    // Create an XFile for proper file saving.
    final file = data.toXFile();

    // Save the file. We are not using the path parameter because it is not
    // supported on web.
    await file.saveTo('');
    return null;
  }
}
