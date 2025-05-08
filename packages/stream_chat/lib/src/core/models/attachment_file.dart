import 'dart:typed_data';

import 'package:dio/dio.dart' show MultipartFile;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';
import 'package:stream_chat/src/core/util/extension.dart';

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
  })  : assert(
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
  factory AttachmentFile.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFileFromJson(json);

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

  /// Converts this into a [MultipartFile]
  Future<MultipartFile> toMultipartFile() async {
    return switch (CurrentPlatform.type) {
      PlatformType.web => MultipartFile.fromBytes(
          bytes!,
          filename: name,
          contentType: mediaType,
        ),
      _ => await MultipartFile.fromFile(
          path!,
          filename: name,
          contentType: mediaType,
        ),
    };
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
  const factory UploadState.preparing() = Preparing;

  /// InProgress state of the union
  const factory UploadState.inProgress({
    required int uploaded,
    required int total,
  }) = InProgress;

  /// Success state of the union
  const factory UploadState.success() = Success;

  /// Failed state of the union
  const factory UploadState.failed({required String error}) = Failed;

  /// Creates a new instance from a json
  factory UploadState.fromJson(Map<String, dynamic> json) =>
      _$UploadStateFromJson(json);

  /// Returns true if state is [Preparing]
  bool get isPreparing => this is Preparing;

  /// Returns true if state is [InProgress]
  bool get isInProgress => this is InProgress;

  /// Returns true if state is [Success]
  bool get isSuccess => this is Success;

  /// Returns true if state is [Failed]
  bool get isFailed => this is Failed;
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
      Preparing() => preparing(),
      InProgress() => inProgress(uploadState.uploaded, uploadState.total),
      Success() => success(),
      Failed() => failed(uploadState.error),
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
      Preparing() => preparing?.call(),
      InProgress() => inProgress?.call(uploadState.uploaded, uploadState.total),
      Success() => success?.call(),
      Failed() => failed?.call(uploadState.error),
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
      Preparing() => preparing?.call(),
      InProgress() => inProgress?.call(uploadState.uploaded, uploadState.total),
      Success() => success?.call(),
      Failed() => failed?.call(uploadState.error),
    };

    return result ?? orElse();
  }

  /// @nodoc
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Preparing value) preparing,
    required TResult Function(InProgress value) inProgress,
    required TResult Function(Success value) success,
    required TResult Function(Failed value) failed,
  }) {
    final uploadState = this;
    return switch (uploadState) {
      Preparing() => preparing(uploadState),
      InProgress() => inProgress(uploadState),
      Success() => success(uploadState),
      Failed() => failed(uploadState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Preparing value)? preparing,
    TResult? Function(InProgress value)? inProgress,
    TResult? Function(Success value)? success,
    TResult? Function(Failed value)? failed,
  }) {
    final uploadState = this;
    return switch (uploadState) {
      Preparing() => preparing?.call(uploadState),
      InProgress() => inProgress?.call(uploadState),
      Success() => success?.call(uploadState),
      Failed() => failed?.call(uploadState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    final uploadState = this;
    final result = switch (uploadState) {
      Preparing() => preparing?.call(uploadState),
      InProgress() => inProgress?.call(uploadState),
      Success() => success?.call(uploadState),
      Failed() => failed?.call(uploadState),
    };

    return result ?? orElse();
  }
}

// coverage:ignore-end
