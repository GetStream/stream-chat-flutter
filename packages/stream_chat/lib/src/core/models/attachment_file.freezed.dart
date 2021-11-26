// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'attachment_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UploadState _$UploadStateFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'preparing':
      return Preparing.fromJson(json);
    case 'inProgress':
      return InProgress.fromJson(json);
    case 'success':
      return Success.fromJson(json);
    case 'failed':
      return Failed.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'type', 'UploadState', 'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
class _$UploadStateTearOff {
  const _$UploadStateTearOff();

  Preparing preparing() {
    return const Preparing();
  }

  InProgress inProgress({required int uploaded, required int total}) {
    return InProgress(
      uploaded: uploaded,
      total: total,
    );
  }

  Success success() {
    return const Success();
  }

  Failed failed({required String error}) {
    return Failed(
      error: error,
    );
  }

  UploadState fromJson(Map<String, Object?> json) {
    return UploadState.fromJson(json);
  }
}

/// @nodoc
const $UploadState = _$UploadStateTearOff();

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
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
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
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
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
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadStateCopyWith<$Res> {
  factory $UploadStateCopyWith(
          UploadState value, $Res Function(UploadState) then) =
      _$UploadStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$UploadStateCopyWithImpl<$Res> implements $UploadStateCopyWith<$Res> {
  _$UploadStateCopyWithImpl(this._value, this._then);

  final UploadState _value;
  // ignore: unused_field
  final $Res Function(UploadState) _then;
}

/// @nodoc
abstract class $PreparingCopyWith<$Res> {
  factory $PreparingCopyWith(Preparing value, $Res Function(Preparing) then) =
      _$PreparingCopyWithImpl<$Res>;
}

/// @nodoc
class _$PreparingCopyWithImpl<$Res> extends _$UploadStateCopyWithImpl<$Res>
    implements $PreparingCopyWith<$Res> {
  _$PreparingCopyWithImpl(Preparing _value, $Res Function(Preparing) _then)
      : super(_value, (v) => _then(v as Preparing));

  @override
  Preparing get _value => super._value as Preparing;
}

/// @nodoc
@JsonSerializable()
class _$Preparing implements Preparing {
  const _$Preparing({String? $type}) : $type = $type ?? 'preparing';

  factory _$Preparing.fromJson(Map<String, dynamic> json) =>
      _$$PreparingFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'UploadState.preparing()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Preparing);
  }

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
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
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
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
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
    return _$$PreparingToJson(this);
  }
}

abstract class Preparing implements UploadState {
  const factory Preparing() = _$Preparing;

  factory Preparing.fromJson(Map<String, dynamic> json) = _$Preparing.fromJson;
}

/// @nodoc
abstract class $InProgressCopyWith<$Res> {
  factory $InProgressCopyWith(
          InProgress value, $Res Function(InProgress) then) =
      _$InProgressCopyWithImpl<$Res>;
  $Res call({int uploaded, int total});
}

/// @nodoc
class _$InProgressCopyWithImpl<$Res> extends _$UploadStateCopyWithImpl<$Res>
    implements $InProgressCopyWith<$Res> {
  _$InProgressCopyWithImpl(InProgress _value, $Res Function(InProgress) _then)
      : super(_value, (v) => _then(v as InProgress));

  @override
  InProgress get _value => super._value as InProgress;

  @override
  $Res call({
    Object? uploaded = freezed,
    Object? total = freezed,
  }) {
    return _then(InProgress(
      uploaded: uploaded == freezed
          ? _value.uploaded
          : uploaded // ignore: cast_nullable_to_non_nullable
              as int,
      total: total == freezed
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InProgress implements InProgress {
  const _$InProgress(
      {required this.uploaded, required this.total, String? $type})
      : $type = $type ?? 'inProgress';

  factory _$InProgress.fromJson(Map<String, dynamic> json) =>
      _$$InProgressFromJson(json);

  @override
  final int uploaded;
  @override
  final int total;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'UploadState.inProgress(uploaded: $uploaded, total: $total)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InProgress &&
            (identical(other.uploaded, uploaded) ||
                other.uploaded == uploaded) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uploaded, total);

  @JsonKey(ignore: true)
  @override
  $InProgressCopyWith<InProgress> get copyWith =>
      _$InProgressCopyWithImpl<InProgress>(this, _$identity);

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
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
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
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
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
    return _$$InProgressToJson(this);
  }
}

abstract class InProgress implements UploadState {
  const factory InProgress({required int uploaded, required int total}) =
      _$InProgress;

  factory InProgress.fromJson(Map<String, dynamic> json) =
      _$InProgress.fromJson;

  int get uploaded;
  int get total;
  @JsonKey(ignore: true)
  $InProgressCopyWith<InProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuccessCopyWith<$Res> {
  factory $SuccessCopyWith(Success value, $Res Function(Success) then) =
      _$SuccessCopyWithImpl<$Res>;
}

/// @nodoc
class _$SuccessCopyWithImpl<$Res> extends _$UploadStateCopyWithImpl<$Res>
    implements $SuccessCopyWith<$Res> {
  _$SuccessCopyWithImpl(Success _value, $Res Function(Success) _then)
      : super(_value, (v) => _then(v as Success));

  @override
  Success get _value => super._value as Success;
}

/// @nodoc
@JsonSerializable()
class _$Success implements Success {
  const _$Success({String? $type}) : $type = $type ?? 'success';

  factory _$Success.fromJson(Map<String, dynamic> json) =>
      _$$SuccessFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'UploadState.success()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Success);
  }

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
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
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
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
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
    return _$$SuccessToJson(this);
  }
}

abstract class Success implements UploadState {
  const factory Success() = _$Success;

  factory Success.fromJson(Map<String, dynamic> json) = _$Success.fromJson;
}

/// @nodoc
abstract class $FailedCopyWith<$Res> {
  factory $FailedCopyWith(Failed value, $Res Function(Failed) then) =
      _$FailedCopyWithImpl<$Res>;
  $Res call({String error});
}

/// @nodoc
class _$FailedCopyWithImpl<$Res> extends _$UploadStateCopyWithImpl<$Res>
    implements $FailedCopyWith<$Res> {
  _$FailedCopyWithImpl(Failed _value, $Res Function(Failed) _then)
      : super(_value, (v) => _then(v as Failed));

  @override
  Failed get _value => super._value as Failed;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(Failed(
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Failed implements Failed {
  const _$Failed({required this.error, String? $type})
      : $type = $type ?? 'failed';

  factory _$Failed.fromJson(Map<String, dynamic> json) =>
      _$$FailedFromJson(json);

  @override
  final String error;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'UploadState.failed(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Failed &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  $FailedCopyWith<Failed> get copyWith =>
      _$FailedCopyWithImpl<Failed>(this, _$identity);

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
    TResult Function()? preparing,
    TResult Function(int uploaded, int total)? inProgress,
    TResult Function()? success,
    TResult Function(String error)? failed,
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
    TResult Function(Preparing value)? preparing,
    TResult Function(InProgress value)? inProgress,
    TResult Function(Success value)? success,
    TResult Function(Failed value)? failed,
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
    return _$$FailedToJson(this);
  }
}

abstract class Failed implements UploadState {
  const factory Failed({required String error}) = _$Failed;

  factory Failed.fromJson(Map<String, dynamic> json) = _$Failed.fromJson;

  String get error;
  @JsonKey(ignore: true)
  $FailedCopyWith<Failed> get copyWith => throw _privateConstructorUsedError;
}
