import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter/src/attachment/handler/common.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler_base.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// StreamAttachmentHandler implementation for desktop.
class StreamAttachmentHandlerDesktop extends StreamAttachmentHandler {
  /// Returns the singleton instance of [StreamAttachmentHandler].
  StreamAttachmentHandlerDesktop() : super.__();

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

    // Open the native file browser so the user can select the save location.
    final saveLocation = await getSaveLocation(suggestedName: data.fileName);
    if (saveLocation == null) {
      // Operation was canceled by the user.
      return null;
    }

    // Get the path to the user's selected location.
    final path = saveLocation.path;

    // Create an XFile for proper file saving.
    final file = data.toXFile(path: path);

    // Save the file to the user's selected path.
    await file.saveTo(path);
    return path;
  }
}

/// StreamAttachmentHandler implementation for io.
class StreamAttachmentHandler extends StreamAttachmentHandlerBase {
  StreamAttachmentHandler.__();

  factory StreamAttachmentHandler._() {
    if (isDesktopDevice) {
      return StreamAttachmentHandlerDesktop();
    }
    return StreamAttachmentHandler.__();
  }

  static StreamAttachmentHandler? _instance;

  /// Returns the singleton instance of [StreamAttachmentHandler].
  // ignore: prefer_constructors_over_static_methods
  static StreamAttachmentHandler get instance =>
      _instance ??= StreamAttachmentHandler._();

  late final _imagePicker = ImagePicker();
  late final _filePicker = FilePicker.platform;

  @override
  Future<Attachment?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    final image = await _imagePicker.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
    );

    return image?.toAttachment(type: 'image');
  }

  @override
  Future<Attachment?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) async {
    final video = await _imagePicker.pickVideo(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxDuration: maxDuration,
    );

    return video?.toAttachment(type: 'video');
  }

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
  Future<String> saveAttachmentFile({
    required AttachmentFile attachmentFile,
  }) async {
    final fileName = attachmentFile.name;
    assert(fileName != null, 'Attachment file name is required');

    final tempDir = await getTemporaryDirectory();
    final tempPath = Uri.file(tempDir.path, windows: CurrentPlatform.isWindows);
    final tempFilePath = tempPath
        .resolve(fileName!)
        .toFilePath(windows: CurrentPlatform.isWindows);

    final attachmentFileBytes = attachmentFile.bytes;
    if (attachmentFileBytes == null) {
      final attachmentFilePath = attachmentFile.path!;
      final file = File(attachmentFilePath);
      return file.copy(tempFilePath).then((it) => it.path);
    } else {
      final file = File(tempFilePath);
      return file.writeAsBytes(attachmentFileBytes).then((it) => it.path);
    }
  }

  @override
  Future<void> deleteAttachmentFile({
    required AttachmentFile attachmentFile,
  }) async {
    final attachmentFilePath = attachmentFile.path;
    if (attachmentFilePath != null) {
      final file = File(attachmentFilePath);
      if (file.existsSync()) {
        await file.delete();
      }
    }
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

    final appDir = await getTemporaryDirectory();
    final ext = Uri.parse(data.downloadUrl).pathSegments.last;
    final path = '${appDir.path}/${attachment.id}.$ext';

    // Create an XFile for proper file saving.
    final file = data.toXFile(path: path);

    // Save the file to a temporary location.
    await file.saveTo(path);

    // Now that the file is saved, we need to copy it to the user's gallery
    // because the gallery only shows files that are in the gallery folder.
    await ImageGallerySaverPlus.saveFile(path);

    // Once the file is copied to the gallery, we can delete the temporary file.
    await file.delete();

    return path;
  }
}

extension on XFile {
  /// Deletes this xfile from the file system.
  Future<void> delete() async {
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }
}
