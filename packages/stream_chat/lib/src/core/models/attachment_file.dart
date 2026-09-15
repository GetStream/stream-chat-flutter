import 'dart:typed_data';

import 'package:dio/dio.dart' show MultipartFile;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:stream_core/stream_core.dart' show CurrentPlatform;
import '../util/extension.dart';

part 'attachment_file.freezed.dart';

part 'attachment_file.g.dart';

/// The class that contains the information about an attachment file
@JsonSerializable()
class AttachmentFile {
  /// Creates a new [AttachmentFile] instance.
  AttachmentFile({
    required this.size,
    this.path,
    String? name,
    this.bytes,
  }) : assert(
         path != null || bytes != null,
         'Either path or bytes should be != null',
       ),
       assert(
         !CurrentPlatform.isWeb || bytes != null,
         'File by path is not supported in web, Please provide bytes',
       ),
       assert(
         name == null || name.isEmpty || name.contains('.'),
         'Invalid file name, should also contain file extension',
       ),
       _name = name;

  /// Create a new instance from a json
  factory AttachmentFile.fromJson(Map<String, dynamic> json) => _$AttachmentFileFromJson(json);

  /// The absolute path for a cached copy of this file. It can be used to
  /// create a file instance with a descriptor for the given path.
  /// ```
  /// final File myFile = File(platformFile.path);
  /// ```
  final String? path;

  final String? _name;

  /// File name including its extension.
  String? get name {
    if (_name case final name? when name.isNotEmpty) return name;
    return path?.split(CurrentPlatform.isWindows ? r'\' : '/').last;
  }

  /// Byte data for this file. Particularly useful if you want to manipulate
  /// its data or easily upload to somewhere else.
  @JsonKey(includeToJson: false, includeFromJson: false)
  final Uint8List? bytes;

  /// The file size in bytes.
  final int? size;

  /// File extension for this file.
  String? get extension => name?.split('.').last;

  /// The mime type of this file.
  MediaType? get mediaType => name?.mediaType;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$AttachmentFileToJson(this);

  /// Converts this [AttachmentFile] to a [MultipartFile].
  ///
  /// Tries path-based creation first, which is more efficient for large files.
  /// Falls back to byte-based creation when the path is inaccessible
  /// (e.g. web platforms, or short-lived iOS photo library exports).
  Future<MultipartFile> toMultipartFile() async {
    if (path case final path?) {
      try {
        return await MultipartFile.fromFile(
          path,
          filename: name,
          contentType: mediaType,
        );
      } catch (_) {} // Path may no longer exist
    }

    if (bytes case final bytes?) {
      return MultipartFile.fromBytes(
        bytes,
        filename: name,
        contentType: mediaType,
      );
    }

    throw StateError(
      'Cannot create MultipartFile: both path and bytes are unavailable. '
      'path: $path, bytes: $bytes',
    );
  }

  /// Creates a copy of this [AttachmentFile] but with the given fields
  /// replaced with the new values.
  AttachmentFile copyWith({
    String? path,
    String? name,
    Uint8List? bytes,
    int? size,
  }) {
    return AttachmentFile(
      path: path ?? this.path,
      name: name ?? this.name,
      bytes: bytes ?? this.bytes,
      size: size ?? this.size,
    );
  }
}

/// Union class to hold various [UploadState] of a attachment.
@freezed
sealed class UploadState with _$UploadState {
  // Dummy private constructor in order to use getters
  const UploadState._();

  /// Preparing state of the union
  const factory UploadState.preparing() = UploadStatePreparing;

  /// InProgress state of the union
  const factory UploadState.inProgress({
    required int uploaded,
    required int total,
  }) = UploadStateInProgress;

  /// Success state of the union
  const factory UploadState.success() = UploadStateSuccess;

  /// Failed state of the union
  const factory UploadState.failed({required String error}) = UploadStateFailed;

  /// Creates a new instance from a json
  factory UploadState.fromJson(Map<String, dynamic> json) => _$UploadStateFromJson(json);

  /// Returns true if state is [UploadStatePreparing]
  bool get isPreparing => this is UploadStatePreparing;

  /// Returns true if state is [UploadStateInProgress]
  bool get isInProgress => this is UploadStateInProgress;

  /// Returns true if state is [UploadStateSuccess]
  bool get isSuccess => this is UploadStateSuccess;

  /// Returns true if state is [UploadStateFailed]
  bool get isFailed => this is UploadStateFailed;
}

// coverage:ignore-start

/// @nodoc
extension UploadStatePatternMatching on UploadState {
  /// @nodoc
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() preparing,
    required TResult Function(int uploaded, int total) inProgress,
    required TResult Function() success,
    required TResult Function(String error) failed,
  }) {
    final uploadState = this;
    return switch (uploadState) {
      UploadStatePreparing() => preparing(),
      UploadStateInProgress() => inProgress(uploadState.uploaded, uploadState.total),
      UploadStateSuccess() => success(),
      UploadStateFailed() => failed(uploadState.error),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? preparing,
    TResult? Function(int uploaded, int total)? inProgress,
    TResult? Function()? success,
    TResult? Function(String error)? failed,
  }) {
    final uploadState = this;
    return switch (uploadState) {
      UploadStatePreparing() => preparing?.call(),
      UploadStateInProgress() => inProgress?.call(uploadState.uploaded, uploadState.total),
      UploadStateSuccess() => success?.call(),
      UploadStateFailed() => failed?.call(uploadState.error),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    final uploadState = this;
    final result = switch (uploadState) {
      UploadStatePreparing() => preparing?.call(),
      UploadStateInProgress() => inProgress?.call(uploadState.uploaded, uploadState.total),
      UploadStateSuccess() => success?.call(),
      UploadStateFailed() => failed?.call(uploadState.error),
    };

    return result ?? orElse();
  }

  /// @nodoc
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadStatePreparing value) preparing,
    required TResult Function(UploadStateInProgress value) inProgress,
    required TResult Function(UploadStateSuccess value) success,
    required TResult Function(UploadStateFailed value) failed,
  }) {
    final uploadState = this;
    return switch (uploadState) {
      UploadStatePreparing() => preparing(uploadState),
      UploadStateInProgress() => inProgress(uploadState),
      UploadStateSuccess() => success(uploadState),
      UploadStateFailed() => failed(uploadState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadStatePreparing value)? preparing,
    TResult? Function(UploadStateInProgress value)? inProgress,
    TResult? Function(UploadStateSuccess value)? success,
    TResult? Function(UploadStateFailed value)? failed,
  }) {
    final uploadState = this;
    return switch (uploadState) {
      UploadStatePreparing() => preparing?.call(uploadState),
      UploadStateInProgress() => inProgress?.call(uploadState),
      UploadStateSuccess() => success?.call(uploadState),
      UploadStateFailed() => failed?.call(uploadState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadStatePreparing value)? preparing,
    TResult Function(UploadStateInProgress value)? inProgress,
    TResult Function(UploadStateSuccess value)? success,
    TResult Function(UploadStateFailed value)? failed,
    required TResult orElse(),
  }) {
    final uploadState = this;
    final result = switch (uploadState) {
      UploadStatePreparing() => preparing?.call(uploadState),
      UploadStateInProgress() => inProgress?.call(uploadState),
      UploadStateSuccess() => success?.call(uploadState),
      UploadStateFailed() => failed?.call(uploadState),
    };

    return result ?? orElse();
  }
}

// coverage:ignore-end
