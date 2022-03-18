import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:stream_chat_flutter/src/video_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_compress/video_compress.dart';

/// An abstract class for creating utility classes appropriate for various
/// platforms.
///
/// TODO(Groovin): consider a "downloadMultiple()" function.
abstract class AttachmentHandler {
  /// Uploads an attachment
  Future<List<Attachment>> upload();

  /// Downloads an attachment.
  Future<bool> download(
    Attachment attachment, {
    String? suggestedName,
  });
}

/// A utility class for handling the uploading and downloading of attachments
/// on desktop platforms.
class DesktopAttachmentHandler extends AttachmentHandler {
  /// Builds a [DesktopAttachmentHandler].
  DesktopAttachmentHandler({
    this.maxAttachmentSize,
    this.compressedVideoFrameRate = 30,
    this.compressedVideoQuality = VideoQuality.DefaultQuality,
  });

  /// Max attachment size in bytes.
  ///
  /// Include this in your instance of [DesktopAttachmentHandler] when dealing
  /// with uploads.
  final int? maxAttachmentSize;

  /// The frame rate to use when compressing the videos.
  ///
  /// Include this in your instance of [DesktopAttachmentHandler] when dealing
  /// with uploads, or use the default value of `30`.
  final int? compressedVideoFrameRate;

  /// The video quality to use when compressing the videos.
  ///
  /// Include this in your instance of [DesktopAttachmentHandler] when dealing
  /// with uploads, or use the default value of [VideoQuality.DefaultQuality].
  final VideoQuality? compressedVideoQuality;

  @override
  Future<bool> download(
    Attachment attachment, {
    String? suggestedName,
  }) async {
    late http.Response response;
    String? fileName;

    /* ---IMAGES/GIFS--- */
    if (attachment.type == 'image') {
      response = await http.get(Uri.parse(attachment.imageUrl!));
      fileName = suggestedName ??
          attachment.title ??
          'attachment.${attachment.mimeType ?? 'png'}';
    }

    /* ---GIPHY's--- */
    if (attachment.type == 'giphy') {
      response = await http.get(Uri.parse((attachment.extraData.entries.first
          .value! as Map<String, dynamic>)['original']['url']));
      fileName = '${suggestedName ?? attachment.title}.gif';
    }

    /* ---FILES AND VIDEOS--- */
    if (attachment.type == 'file' || attachment.type == 'video') {
      response = await http.get(Uri.parse(attachment.assetUrl!));
      fileName = attachment.title;
    }

    // Open the native file browser so the user can select the download
    // path
    final path = await getSavePath(
      suggestedName: fileName,
    );

    // Account for canceled operation.
    if (path == null) {
      return false;
    }

    // Create an XFile for proper file saving
    final file = XFile.fromData(
      Uint8List.fromList(response.body.codeUnits),
      mimeType: attachment.mimeType,
      name: fileName,
      path: path,
    );

    try {
      // Save the file to the user's selected path.
      await file.saveTo(path);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List<Attachment>> upload() async {
    // Open the native file picker
    final files = await openFiles();
    // Account for user cancelling operation.
    if (files.isEmpty) {
      return [];
    }

    final attachments = <Attachment>[];
    for (final file in files) {
      final attachment = await _createAttachmentFromXFile(file);
      if (attachment != null) {
        attachments.add(attachment);
      }
    }
    return attachments;
  }

  /// Uploads files received via drag 'n drop.
  ///
  /// No need to open the native file system in this instance.
  Future<List<Attachment>> uploadViaDragNDrop(List<XFile> files) async {
    final attachments = <Attachment>[];
    for (final file in files) {
      final attachment = await _createAttachmentFromXFile(file);
      if (attachment != null) {
        attachments.add(attachment);
      }
    }
    return attachments;
  }

  /// Creates an [Attachment] from an [XFile] that is selected by a desktop
  /// user in their native file system.
  Future<Attachment?> _createAttachmentFromXFile(XFile file) async {
    final extraDataMap = <String, Object?>{};
    Uint8List? bytes;

    try {
      bytes = await file.readAsBytes();
    } on FileSystemException catch (e) {
      throw FileSystemException('Could not read bytes from file', e.path);
    }

    // Create the AttachmentFile to include in the Attachment
    var attachmentFile = AttachmentFile(
      size: bytes.length,
      path: file.path,
      bytes: bytes,
    );

    // Check for a mime type and set it if null
    if (file.mimeType != null) {
      extraDataMap['mime_type'] = file.mimeType;
    } else {
      extraDataMap['mime_type'] = file.name.split('.').last;
    }

    extraDataMap['file_size'] = bytes.length;

    // Create the Attachment
    final attachment = Attachment(
      file: attachmentFile,
      type: _checkAttachmentType(file.name.split('.').last),
      uploadState: const UploadState.preparing(),
      extraData: extraDataMap,
    );

    // Check file size against maxAttachmentSize and stop uploading if
    // required
    if (attachmentFile.size! > maxAttachmentSize!) {
      // Compress video
      if (attachment.type == 'video' && attachmentFile.path != null) {
        final mediaInfo = await (VideoService.compressVideo(
          attachmentFile.path!,
          frameRate: compressedVideoFrameRate!,
          quality: compressedVideoQuality!,
        ) as FutureOr<MediaInfo>);
        if (mediaInfo.filesize! > maxAttachmentSize!) {
          throw const FileSystemException(
            'File size too large after compression and '
            'exceeds maximum attachment size',
          );
        }
        attachmentFile = AttachmentFile(
          name: attachmentFile.name,
          size: mediaInfo.filesize,
          bytes: await mediaInfo.file?.readAsBytes(),
          path: mediaInfo.path,
        );
      } else {
        throw const FileSystemException(
          'File size exceeds maximum attachment size',
        );
      }
    }

    return attachment.copyWith(
      file: attachmentFile,
      extraData: {...attachment.extraData}
        ..update('file_size', (_) => attachmentFile.size!),
    );
  }

  /// A utility function for determining the "attachment type" of a file
  /// that is being uploaded to a chat.
  String _checkAttachmentType(String fileExtension) {
    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
      case 'jpe':
      case 'jif':
      case 'jfif':
      case 'jfi':
      case 'png':
      case 'gif':
      case 'webp':
      case 'tiff':
      case 'tif':
      case 'psd':
      case 'raw':
      case 'arw':
      case 'cr2':
      case 'nrw':
      case 'k25':
      case 'bmp':
      case 'heic':
      case 'heif':
      case 'indd':
      case 'ind':
      case 'indt':
      case 'jp2':
      case 'j2k':
      case 'jpf':
      case 'jpx':
      case 'jpm':
      case 'mj2':
      case 'svg':
      case 'svgz':
      case 'ai':
      case 'eps':
        return 'image';
      case 'webm':
      case 'mpg':
      case 'mp2':
      case 'mpeg':
      case 'mpe':
      case 'mpv':
      case 'ogg':
      case 'mp4':
      case 'm4p':
      case 'm4v':
      case 'avi':
      case 'wmv':
      case 'mov':
      case 'qt':
      case 'flv':
      case 'swf':
      case 'avchd':
        return 'video';
      default:
        return 'file';
    }
  }
}
