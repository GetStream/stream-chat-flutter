// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
UploadState _$UploadStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'preparing':
      return UploadStatePreparing.fromJson(json);
    case 'inProgress':
      return UploadStateInProgress.fromJson(json);
    case 'success':
      return UploadStateSuccess.fromJson(json);
    case 'failed':
      return UploadStateFailed.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'UploadState',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$UploadState {
  /// Serializes this UploadState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is UploadState);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UploadState()';
  }
}

/// @nodoc
class $UploadStateCopyWith<$Res> {
  $UploadStateCopyWith(UploadState _, $Res Function(UploadState) __);
}

/// @nodoc
@JsonSerializable()
class UploadStatePreparing extends UploadState {
  const UploadStatePreparing({final String? $type}) : $type = $type ?? 'preparing', super._();
  factory UploadStatePreparing.fromJson(Map<String, dynamic> json) => _$UploadStatePreparingFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$UploadStatePreparingToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is UploadStatePreparing);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UploadState.preparing()';
  }
}

/// @nodoc
class $UploadStatePreparingCopyWith<$Res> implements $UploadStateCopyWith<$Res> {
  $UploadStatePreparingCopyWith(
    UploadStatePreparing _,
    $Res Function(UploadStatePreparing) __,
  );
}

/// @nodoc
class _$UploadStatePreparingCopyWithImpl<$Res> implements $UploadStatePreparingCopyWith<$Res> {
  _$UploadStatePreparingCopyWithImpl(this._self, this._then);

  final UploadStatePreparing _self;
  final $Res Function(UploadStatePreparing) _then;
}

/// @nodoc
@JsonSerializable()
class UploadStateInProgress extends UploadState {
  const UploadStateInProgress({
    required this.uploaded,
    required this.total,
    final String? $type,
  }) : $type = $type ?? 'inProgress',
       super._();
  factory UploadStateInProgress.fromJson(Map<String, dynamic> json) => _$UploadStateInProgressFromJson(json);

  final int uploaded;
  final int total;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UploadStateInProgressCopyWith<UploadStateInProgress> get copyWith =>
      _$UploadStateInProgressCopyWithImpl<UploadStateInProgress>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$UploadStateInProgressToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UploadStateInProgress &&
            (identical(other.uploaded, uploaded) || other.uploaded == uploaded) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uploaded, total);

  @override
  String toString() {
    return 'UploadState.inProgress(uploaded: $uploaded, total: $total)';
  }
}

/// @nodoc
abstract mixin class $UploadStateInProgressCopyWith<$Res> implements $UploadStateCopyWith<$Res> {
  factory $UploadStateInProgressCopyWith(
    UploadStateInProgress value,
    $Res Function(UploadStateInProgress) _then,
  ) = _$UploadStateInProgressCopyWithImpl;
  @useResult
  $Res call({int uploaded, int total});
}

/// @nodoc
class _$UploadStateInProgressCopyWithImpl<$Res> implements $UploadStateInProgressCopyWith<$Res> {
  _$UploadStateInProgressCopyWithImpl(this._self, this._then);

  final UploadStateInProgress _self;
  final $Res Function(UploadStateInProgress) _then;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? uploaded = null, Object? total = null}) {
    return _then(
      UploadStateInProgress(
        uploaded: null == uploaded
            ? _self.uploaded
            : uploaded // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _self.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class UploadStateSuccess extends UploadState {
  const UploadStateSuccess({final String? $type}) : $type = $type ?? 'success', super._();
  factory UploadStateSuccess.fromJson(Map<String, dynamic> json) => _$UploadStateSuccessFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$UploadStateSuccessToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is UploadStateSuccess);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UploadState.success()';
  }
}

/// @nodoc
class $UploadStateSuccessCopyWith<$Res> implements $UploadStateCopyWith<$Res> {
  $UploadStateSuccessCopyWith(
    UploadStateSuccess _,
    $Res Function(UploadStateSuccess) __,
  );
}

/// @nodoc
class _$UploadStateSuccessCopyWithImpl<$Res> implements $UploadStateSuccessCopyWith<$Res> {
  _$UploadStateSuccessCopyWithImpl(this._self, this._then);

  final UploadStateSuccess _self;
  final $Res Function(UploadStateSuccess) _then;
}

/// @nodoc
@JsonSerializable()
class UploadStateFailed extends UploadState {
  const UploadStateFailed({required this.error, final String? $type}) : $type = $type ?? 'failed', super._();
  factory UploadStateFailed.fromJson(Map<String, dynamic> json) => _$UploadStateFailedFromJson(json);

  final String error;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UploadStateFailedCopyWith<UploadStateFailed> get copyWith =>
      _$UploadStateFailedCopyWithImpl<UploadStateFailed>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UploadStateFailedToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UploadStateFailed &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'UploadState.failed(error: $error)';
  }
}

/// @nodoc
abstract mixin class $UploadStateFailedCopyWith<$Res> implements $UploadStateCopyWith<$Res> {
  factory $UploadStateFailedCopyWith(
    UploadStateFailed value,
    $Res Function(UploadStateFailed) _then,
  ) = _$UploadStateFailedCopyWithImpl;
  @useResult
  $Res call({String error});
}

/// @nodoc
class _$UploadStateFailedCopyWithImpl<$Res> implements $UploadStateFailedCopyWith<$Res> {
  _$UploadStateFailedCopyWithImpl(this._self, this._then);

  final UploadStateFailed _self;
  final $Res Function(UploadStateFailed) _then;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? error = null}) {
    return _then(
      UploadStateFailed(
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
