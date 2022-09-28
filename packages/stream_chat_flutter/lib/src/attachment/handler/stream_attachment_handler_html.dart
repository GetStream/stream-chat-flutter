import 'package:file_picker/file_picker.dart';
import 'package:stream_chat_flutter/src/attachment/handler/common.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler_base.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class StreamAttachmentHandler extends StreamAttachmentHandlerBase {
  StreamAttachmentHandler._();

  static StreamAttachmentHandler? _instance;

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
    bool allowCompression = true,
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
      allowCompression: allowCompression,
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
    bool deleteOnError = true,
    Options? options,
  }) {
    return downloadWebOrDesktopAttachment(
      attachment,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      options: options,
    );
  }
}
