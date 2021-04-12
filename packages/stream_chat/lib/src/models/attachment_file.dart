import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'attachment_file.freezed.dart';

part 'attachment_file.g.dart';

/// Union class to hold various [UploadState] of a attachment.
@freezed
class UploadState with _$UploadState {
  /// Preparing state of the union
  const factory UploadState.preparing() = Preparing;

  /// InProgress state of the union
  const factory UploadState.inProgress(
      {required int uploaded, required int total}) = InProgress;

  /// Success state of the union
  const factory UploadState.success() = Success;

  /// Failed state of the union
  const factory UploadState.failed({required String error}) = Failed;

  /// Creates a new instance from a json
  factory UploadState.fromJson(Map<String, dynamic> json) =>
      _$UploadStateFromJson(json);
}

/// Helper extension for UploadState
extension UploadStateX on UploadState? {
  /// Returns true if state is [Preparing]
  bool get isPreparing => this is Preparing;

  /// Returns true if state is [InProgress]
  bool get isInProgress => this is InProgress;

  /// Returns true if state is [Success]
  bool get isSuccess => this is Success;

  /// Returns true if state is [Failed]
  bool get isFailed => this is Failed;
}

Uint8List? _fromString(String? bytes) {
  if (bytes == null) return null;
  return Uint8List.fromList(bytes.codeUnits);
}

String? _toString(Uint8List? bytes) {
  if (bytes == null) return null;
  return String.fromCharCodes(bytes);
}

/// The class that contains the information about an attachment file
@JsonSerializable()
class AttachmentFile {
  /// Creates a new [AttachmentFile] instance.
  const AttachmentFile({
    this.path,
    this.name,
    this.bytes,
    this.size,
  });

  /// Create a new instance from a json
  factory AttachmentFile.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFileFromJson(json);

  /// The absolute path for a cached copy of this file. It can be used to
  /// create a file instance with a descriptor for the given path.
  /// ```
  /// final File myFile = File(platformFile.path);
  /// ```
  final String? path;

  /// File name including its extension.
  final String? name;

  /// Byte data for this file. Particularly useful if you want to manipulate
  /// its data or easily upload to somewhere else.
  @JsonKey(toJson: _toString, fromJson: _fromString)
  final Uint8List? bytes;

  /// The file size in bytes.
  final int? size;

  /// File extension for this file.
  String? get extension => name?.split('.').last;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$AttachmentFileToJson(this);
}
