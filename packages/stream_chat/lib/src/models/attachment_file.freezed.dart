// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'attachment_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
UploadState _$UploadStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType'] as String) {
    case 'preparing':
      return Preparing.fromJson(json);
    case 'inProgress':
      return InProgress.fromJson(json);
    case 'success':
      return Success.fromJson(json);
    case 'failed':
      return Failed.fromJson(json);

    default:
      throw FallThroughError();
  }
}

/// @nodoc
class _$UploadStateTearOff {
  const _$UploadStateTearOff();

// ignore: unused_element
  Preparing preparing() {
    return const Preparing();
  }

// ignore: unused_element
  InProgress inProgress({int uploaded, int total}) {
    return InProgress(
      uploaded: uploaded,
      total: total,
    );
  }

// ignore: unused_element
  Success success() {
    return const Success();
  }

// ignore: unused_element
  Failed failed({@required String error}) {
    return Failed(
      error: error,
    );
  }

// ignore: unused_element
  UploadState fromJson(Map<String, Object> json) {
    return UploadState.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $UploadState = _$UploadStateTearOff();

/// @nodoc
mixin _$UploadState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult preparing(),
    @required TResult inProgress(int uploaded, int total),
    @required TResult success(),
    @required TResult failed(String error),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult preparing(),
    TResult inProgress(int uploaded, int total),
    TResult success(),
    TResult failed(String error),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult preparing(Preparing value),
    @required TResult inProgress(InProgress value),
    @required TResult success(Success value),
    @required TResult failed(Failed value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult preparing(Preparing value),
    TResult inProgress(InProgress value),
    TResult success(Success value),
    TResult failed(Failed value),
    @required TResult orElse(),
  });
  Map<String, dynamic> toJson();
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

@JsonSerializable()

/// @nodoc
class _$Preparing implements Preparing {
  const _$Preparing();

  factory _$Preparing.fromJson(Map<String, dynamic> json) =>
      _$_$PreparingFromJson(json);

  @override
  String toString() {
    return 'UploadState.preparing()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Preparing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult preparing(),
    @required TResult inProgress(int uploaded, int total),
    @required TResult success(),
    @required TResult failed(String error),
  }) {
    assert(preparing != null);
    assert(inProgress != null);
    assert(success != null);
    assert(failed != null);
    return preparing();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult preparing(),
    TResult inProgress(int uploaded, int total),
    TResult success(),
    TResult failed(String error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (preparing != null) {
      return preparing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult preparing(Preparing value),
    @required TResult inProgress(InProgress value),
    @required TResult success(Success value),
    @required TResult failed(Failed value),
  }) {
    assert(preparing != null);
    assert(inProgress != null);
    assert(success != null);
    assert(failed != null);
    return preparing(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult preparing(Preparing value),
    TResult inProgress(InProgress value),
    TResult success(Success value),
    TResult failed(Failed value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (preparing != null) {
      return preparing(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$PreparingToJson(this)..['runtimeType'] = 'preparing';
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
    Object uploaded = freezed,
    Object total = freezed,
  }) {
    return _then(InProgress(
      uploaded: uploaded == freezed ? _value.uploaded : uploaded as int,
      total: total == freezed ? _value.total : total as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$InProgress implements InProgress {
  const _$InProgress({this.uploaded, this.total});

  factory _$InProgress.fromJson(Map<String, dynamic> json) =>
      _$_$InProgressFromJson(json);

  @override
  final int uploaded;
  @override
  final int total;

  @override
  String toString() {
    return 'UploadState.inProgress(uploaded: $uploaded, total: $total)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is InProgress &&
            (identical(other.uploaded, uploaded) ||
                const DeepCollectionEquality()
                    .equals(other.uploaded, uploaded)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(uploaded) ^
      const DeepCollectionEquality().hash(total);

  @JsonKey(ignore: true)
  @override
  $InProgressCopyWith<InProgress> get copyWith =>
      _$InProgressCopyWithImpl<InProgress>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult preparing(),
    @required TResult inProgress(int uploaded, int total),
    @required TResult success(),
    @required TResult failed(String error),
  }) {
    assert(preparing != null);
    assert(inProgress != null);
    assert(success != null);
    assert(failed != null);
    return inProgress(uploaded, total);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult preparing(),
    TResult inProgress(int uploaded, int total),
    TResult success(),
    TResult failed(String error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (inProgress != null) {
      return inProgress(uploaded, total);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult preparing(Preparing value),
    @required TResult inProgress(InProgress value),
    @required TResult success(Success value),
    @required TResult failed(Failed value),
  }) {
    assert(preparing != null);
    assert(inProgress != null);
    assert(success != null);
    assert(failed != null);
    return inProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult preparing(Preparing value),
    TResult inProgress(InProgress value),
    TResult success(Success value),
    TResult failed(Failed value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (inProgress != null) {
      return inProgress(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$InProgressToJson(this)..['runtimeType'] = 'inProgress';
  }
}

abstract class InProgress implements UploadState {
  const factory InProgress({int uploaded, int total}) = _$InProgress;

  factory InProgress.fromJson(Map<String, dynamic> json) =
      _$InProgress.fromJson;

  int get uploaded;
  int get total;
  @JsonKey(ignore: true)
  $InProgressCopyWith<InProgress> get copyWith;
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

@JsonSerializable()

/// @nodoc
class _$Success implements Success {
  const _$Success();

  factory _$Success.fromJson(Map<String, dynamic> json) =>
      _$_$SuccessFromJson(json);

  @override
  String toString() {
    return 'UploadState.success()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Success);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult preparing(),
    @required TResult inProgress(int uploaded, int total),
    @required TResult success(),
    @required TResult failed(String error),
  }) {
    assert(preparing != null);
    assert(inProgress != null);
    assert(success != null);
    assert(failed != null);
    return success();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult preparing(),
    TResult inProgress(int uploaded, int total),
    TResult success(),
    TResult failed(String error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult preparing(Preparing value),
    @required TResult inProgress(InProgress value),
    @required TResult success(Success value),
    @required TResult failed(Failed value),
  }) {
    assert(preparing != null);
    assert(inProgress != null);
    assert(success != null);
    assert(failed != null);
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult preparing(Preparing value),
    TResult inProgress(InProgress value),
    TResult success(Success value),
    TResult failed(Failed value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$SuccessToJson(this)..['runtimeType'] = 'success';
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
    Object error = freezed,
  }) {
    return _then(Failed(
      error: error == freezed ? _value.error : error as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$Failed implements Failed {
  const _$Failed({@required this.error}) : assert(error != null);

  factory _$Failed.fromJson(Map<String, dynamic> json) =>
      _$_$FailedFromJson(json);

  @override
  final String error;

  @override
  String toString() {
    return 'UploadState.failed(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Failed &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $FailedCopyWith<Failed> get copyWith =>
      _$FailedCopyWithImpl<Failed>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult preparing(),
    @required TResult inProgress(int uploaded, int total),
    @required TResult success(),
    @required TResult failed(String error),
  }) {
    assert(preparing != null);
    assert(inProgress != null);
    assert(success != null);
    assert(failed != null);
    return failed(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult preparing(),
    TResult inProgress(int uploaded, int total),
    TResult success(),
    TResult failed(String error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (failed != null) {
      return failed(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult preparing(Preparing value),
    @required TResult inProgress(InProgress value),
    @required TResult success(Success value),
    @required TResult failed(Failed value),
  }) {
    assert(preparing != null);
    assert(inProgress != null);
    assert(success != null);
    assert(failed != null);
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult preparing(Preparing value),
    TResult inProgress(InProgress value),
    TResult success(Success value),
    TResult failed(Failed value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$FailedToJson(this)..['runtimeType'] = 'failed';
  }
}

abstract class Failed implements UploadState {
  const factory Failed({@required String error}) = _$Failed;

  factory Failed.fromJson(Map<String, dynamic> json) = _$Failed.fromJson;

  String get error;
  @JsonKey(ignore: true)
  $FailedCopyWith<Failed> get copyWith;
}
