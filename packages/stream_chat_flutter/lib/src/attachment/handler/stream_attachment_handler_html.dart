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
  static StreamAttachmentHandler get instance => _instance ??= StreamAttachmentHandler._();

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
    // pickFile (singular) since file_picker 12: it returns the `PlatformFile?`
    // this method already wanted, instead of a result wrapper we immediately
    // took `.files.first` from — which threw on an empty selection.
    //
    // `withData` / `withReadStream` are no longer forwarded: file_picker 12
    // deprecated them in favour of reading through PlatformFile.readAsBytes()
    // / readAsByteStream(), which is what toAttachmentFile now does. They stay
    // in this method's signature so this is not a breaking change for callers.
    final result = await FilePicker.pickFile(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      compressionQuality: compressionQuality,
    );

    return await result?.toAttachment(type: type.toAttachmentType());
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
