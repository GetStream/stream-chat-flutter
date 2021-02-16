import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_file.freezed.dart';

part 'attachment_file.g.dart';

///
@freezed
abstract class UploadState with _$UploadState {
  ///
  const factory UploadState.inProgress({int uploaded, int total}) = InProgress;

  ///
  const factory UploadState.success() = Success;

  ///
  const factory UploadState.failed({@required String error}) = Failed;

  /// Creates a new instance from a json
  factory UploadState.fromJson(Map<String, dynamic> json) =>
      _$UploadStateFromJson(json);
}

///
extension UploadStateX on UploadState {
  ///
  bool get isInProgress => this is InProgress;

  ///
  bool get isSuccess => this is Success;

  ///
  bool get isFailed => this is Failed;
}

Uint8List _fromString(String bytes) => Uint8List.fromList(bytes.codeUnits);

String _toString(Uint8List bytes) => String.fromCharCodes(bytes);

///
@JsonSerializable()
class AttachmentFile {
  ///
  const AttachmentFile({
    this.path,
    this.name,
    this.bytes,
    this.size,
  });

  /// The absolute path for a cached copy of this file. It can be used to create a
  /// file instance with a descriptor for the given path.
  /// ```
  /// final File myFile = File(platformFile.path);
  /// ```
  final String path;

  /// File name including its extension.
  final String name;

  /// Byte data for this file. Particularly useful if you want to manipulate its data
  /// or easily upload to somewhere else.
  @JsonKey(toJson: _toString, fromJson: _fromString)
  final Uint8List bytes;

  /// The file size in bytes.
  final int size;

  /// File extension for this file.
  String get extension => name?.split('.')?.last;

  /// Create a new instance from a json
  factory AttachmentFile.fromJson(Map<String, dynamic> json) {
    return _$AttachmentFileFromJson(json);
  }

  /// Serialize to json
  Map<String, dynamic> toJson() => _$AttachmentFileToJson(this);
}
