// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UploadState _$UploadStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'preparing':
      return Preparing.fromJson(json);
    case 'inProgress':
      return InProgress.fromJson(json);
    case 'success':
      return Success.fromJson(json);
    case 'failed':
      return Failed.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'UploadState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$UploadState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() preparing,
    required TResult Function(int uploaded, int total) inProgress,
    required TResult Function() success,
    required TResult Function(String error) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? preparing,
    TResult? Function(int uploaded, int total)? inProgress,
    TResult? Function()? success,
    TResult? Function(String error)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Preparing value) preparing,
    required TResult Function(InProgress value) inProgress,
    required TResult Function(Success value) success,
    required TResult Function(Failed value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Preparing value)? preparing,
    TResult? Function(InProgress value)? inProgress,
    TResult? Function(Success value)? success,
    TResult? Function(Failed value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UploadState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadStateCopyWith<$Res> {
  factory $UploadStateCopyWith(
          UploadState value, $Res Function(UploadState) then) =
      _$UploadStateCopyWithImpl<$Res, UploadState>;
}

/// @nodoc
class _$UploadStateCopyWithImpl<$Res, $Val extends UploadState>
    implements $UploadStateCopyWith<$Res> {
  _$UploadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PreparingImplCopyWith<$Res> {
  factory _$$PreparingImplCopyWith(
          _$PreparingImpl value, $Res Function(_$PreparingImpl) then) =
      __$$PreparingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PreparingImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$PreparingImpl>
    implements _$$PreparingImplCopyWith<$Res> {
  __$$PreparingImplCopyWithImpl(
      _$PreparingImpl _value, $Res Function(_$PreparingImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$PreparingImpl extends Preparing {
  const _$PreparingImpl({final String? $type})
      : $type = $type ?? 'preparing',
        super._();

  factory _$PreparingImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreparingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'UploadState.preparing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PreparingImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() preparing,
    required TResult Function(int uploaded, int total) inProgress,
    required TResult Function() success,
    required TResult Function(String error) failed,
  }) {
    return preparing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? preparing,
    TResult? Function(int uploaded, int total)? inProgress,
    TResult? Function()? success,
    TResult? Function(String error)? failed,
  }) {
    return preparing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    if (preparing != null) {
      return preparing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Preparing value) preparing,
    required TResult Function(InProgress value) inProgress,
    required TResult Function(Success value) success,
    required TResult Function(Failed value) failed,
  }) {
    return preparing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Preparing value)? preparing,
    TResult? Function(InProgress value)? inProgress,
    TResult? Function(Success value)? success,
    TResult? Function(Failed value)? failed,
  }) {
    return preparing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (preparing != null) {
      return preparing(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PreparingImplToJson(
      this,
    );
  }
}

abstract class Preparing extends UploadState {
  const factory Preparing() = _$PreparingImpl;
  const Preparing._() : super._();

  factory Preparing.fromJson(Map<String, dynamic> json) =
      _$PreparingImpl.fromJson;
}

/// @nodoc
abstract class _$$InProgressImplCopyWith<$Res> {
  factory _$$InProgressImplCopyWith(
          _$InProgressImpl value, $Res Function(_$InProgressImpl) then) =
      __$$InProgressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int uploaded, int total});
}

/// @nodoc
class __$$InProgressImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$InProgressImpl>
    implements _$$InProgressImplCopyWith<$Res> {
  __$$InProgressImplCopyWithImpl(
      _$InProgressImpl _value, $Res Function(_$InProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uploaded = null,
    Object? total = null,
  }) {
    return _then(_$InProgressImpl(
      uploaded: null == uploaded
          ? _value.uploaded
          : uploaded // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InProgressImpl extends InProgress {
  const _$InProgressImpl(
      {required this.uploaded, required this.total, final String? $type})
      : $type = $type ?? 'inProgress',
        super._();

  factory _$InProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$InProgressImplFromJson(json);

  @override
  final int uploaded;
  @override
  final int total;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'UploadState.inProgress(uploaded: $uploaded, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InProgressImpl &&
            (identical(other.uploaded, uploaded) ||
                other.uploaded == uploaded) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uploaded, total);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InProgressImplCopyWith<_$InProgressImpl> get copyWith =>
      __$$InProgressImplCopyWithImpl<_$InProgressImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() preparing,
    required TResult Function(int uploaded, int total) inProgress,
    required TResult Function() success,
    required TResult Function(String error) failed,
  }) {
    return inProgress(uploaded, total);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? preparing,
    TResult? Function(int uploaded, int total)? inProgress,
    TResult? Function()? success,
    TResult? Function(String error)? failed,
  }) {
    return inProgress?.call(uploaded, total);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(uploaded, total);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Preparing value) preparing,
    required TResult Function(InProgress value) inProgress,
    required TResult Function(Success value) success,
    required TResult Function(Failed value) failed,
  }) {
    return inProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Preparing value)? preparing,
    TResult? Function(InProgress value)? inProgress,
    TResult? Function(Success value)? success,
    TResult? Function(Failed value)? failed,
  }) {
    return inProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InProgressImplToJson(
      this,
    );
  }
}

abstract class InProgress extends UploadState {
  const factory InProgress(
      {required final int uploaded,
      required final int total}) = _$InProgressImpl;
  const InProgress._() : super._();

  factory InProgress.fromJson(Map<String, dynamic> json) =
      _$InProgressImpl.fromJson;

  int get uploaded;
  int get total;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InProgressImplCopyWith<_$InProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$SuccessImpl extends Success {
  const _$SuccessImpl({final String? $type})
      : $type = $type ?? 'success',
        super._();

  factory _$SuccessImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuccessImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'UploadState.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SuccessImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() preparing,
    required TResult Function(int uploaded, int total) inProgress,
    required TResult Function() success,
    required TResult Function(String error) failed,
  }) {
    return success();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? preparing,
    TResult? Function(int uploaded, int total)? inProgress,
    TResult? Function()? success,
    TResult? Function(String error)? failed,
  }) {
    return success?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Preparing value) preparing,
    required TResult Function(InProgress value) inProgress,
    required TResult Function(Success value) success,
    required TResult Function(Failed value) failed,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Preparing value)? preparing,
    TResult? Function(InProgress value)? inProgress,
    TResult? Function(Success value)? success,
    TResult? Function(Failed value)? failed,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SuccessImplToJson(
      this,
    );
  }
}

abstract class Success extends UploadState {
  const factory Success() = _$SuccessImpl;
  const Success._() : super._();

  factory Success.fromJson(Map<String, dynamic> json) = _$SuccessImpl.fromJson;
}

/// @nodoc
abstract class _$$FailedImplCopyWith<$Res> {
  factory _$$FailedImplCopyWith(
          _$FailedImpl value, $Res Function(_$FailedImpl) then) =
      __$$FailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$FailedImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$FailedImpl>
    implements _$$FailedImplCopyWith<$Res> {
  __$$FailedImplCopyWithImpl(
      _$FailedImpl _value, $Res Function(_$FailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$FailedImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FailedImpl extends Failed {
  const _$FailedImpl({required this.error, final String? $type})
      : $type = $type ?? 'failed',
        super._();

  factory _$FailedImpl.fromJson(Map<String, dynamic> json) =>
      _$$FailedImplFromJson(json);

  @override
  final String error;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'UploadState.failed(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailedImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      __$$FailedImplCopyWithImpl<_$FailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() preparing,
    required TResult Function(int uploaded, int total) inProgress,
    required TResult Function() success,
    required TResult Function(String error) failed,
  }) {
    return failed(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? preparing,
    TResult? Function(int uploaded, int total)? inProgress,
    TResult? Function()? success,
    TResult? Function(String error)? failed,
  }) {
    return failed?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Preparing value) preparing,
    required TResult Function(InProgress value) inProgress,
    required TResult Function(Success value) success,
    required TResult Function(Failed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Preparing value)? preparing,
    TResult? Function(InProgress value)? inProgress,
    TResult? Function(Success value)? success,
    TResult? Function(Failed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FailedImplToJson(
      this,
    );
  }
}

abstract class Failed extends UploadState {
  const factory Failed({required final String error}) = _$FailedImpl;
  const Failed._() : super._();

  factory Failed.fromJson(Map<String, dynamic> json) = _$FailedImpl.fromJson;

  String get error;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
