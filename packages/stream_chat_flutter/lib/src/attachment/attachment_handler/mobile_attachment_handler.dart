import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template mobileAttachmentHandler}
/// A utility class for handling the upload and download of attachments on
/// mobile platforms.
///
/// When dealing with the uploading of attachments, you *must* create your
/// instance of [MobileAttachmentHandler] using all constructor arguments.
/// {@endtemplate}
class MobileAttachmentHandler extends AttachmentHandler {
  /// {@macro mobileAttachmentHandler}
  MobileAttachmentHandler({
    this.maxAttachmentSize,
  });

  final _imagePicker = ImagePicker();

  /// Max attachment size in bytes.
  ///
  /// Include this in your instance of [MobileAttachmentHandler] when dealing
  /// with uploads.
  final int? maxAttachmentSize;

  @override
  Future<bool> download(
    Attachment attachment, {
    String? suggestedName,
    ProgressCallback? progressCallback,
  }) async {
    String? filePath;
    final appDocDir = await getTemporaryDirectory();
    final url =
        attachment.assetUrl ?? attachment.imageUrl ?? attachment.thumbUrl!;
    await Dio().download(
      url,
      (Headers responseHeaders) {
        final ext = Uri.parse(url).pathSegments.last;
        filePath ??= '${appDocDir.path}/${attachment.id}.$ext';
        return filePath!;
      },
      onReceiveProgress: progressCallback,
    );
    final result = await ImageGallerySaver.saveFile(filePath!);
    return (result as Map)['filePath'] != null;
  }

  @override
  Future<List<Attachment>> upload({
    DefaultAttachmentTypes? fileType,
    bool camera = false,
  }) async {
    AttachmentFile? file;
    String? attachmentType;

    if (fileType == DefaultAttachmentTypes.image) {
      attachmentType = 'image';
    } else if (fileType == DefaultAttachmentTypes.video) {
      attachmentType = 'video';
    } else if (fileType == DefaultAttachmentTypes.file) {
      attachmentType = 'file';
    }

    if (camera) {
      XFile? pickedFile;
      if (fileType == DefaultAttachmentTypes.image) {
        pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
      } else if (fileType == DefaultAttachmentTypes.video) {
        pickedFile = await _imagePicker.pickVideo(source: ImageSource.camera);
      }
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        file = AttachmentFile(
          size: bytes.length,
          path: pickedFile.path,
          bytes: bytes,
        );
      }
    } else {
      late FileType type;
      if (fileType == DefaultAttachmentTypes.image) {
        type = FileType.image;
      } else if (fileType == DefaultAttachmentTypes.video) {
        type = FileType.video;
      } else if (fileType == DefaultAttachmentTypes.file) {
        type = FileType.any;
      }
      final res = await FilePicker.platform.pickFiles(
        type: type,
      );
      if (res?.files.isNotEmpty == true) {
        file = res!.files.single.toAttachmentFile;
      }
    }

    if (file == null) return [];

    final mimeType = file.name?.mimeType ?? file.path!.split('/').last.mimeType;

    final extraDataMap = <String, Object>{};

    if (mimeType != null) {
      extraDataMap['mime_type'] = mimeType.mimeType;
    }

    extraDataMap['file_size'] = file.size!;

    final attachment = Attachment(
      file: file,
      type: attachmentType,
      uploadState: const UploadState.preparing(),
      extraData: extraDataMap,
    );

    if (file.size! > maxAttachmentSize!) {
      if (attachmentType == 'video' && file.path != null) {
        throw const FileSystemException(
          'File size exceeds maximum attachment size',
        );
      }
    }

    return [
      attachment.copyWith(
        file: file,
        extraData: {...attachment.extraData}
          ..update('file_size', ((_) => file!.size!)),
      ),
    ];
  }
}
