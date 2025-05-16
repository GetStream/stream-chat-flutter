// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageInitialImpl _$$MessageInitialImplFromJson(Map<String, dynamic> json) =>
    _$MessageInitialImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageInitialImplToJson(
        _$MessageInitialImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$MessageOutgoingImpl _$$MessageOutgoingImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageOutgoingImpl(
      state: OutgoingState.fromJson(json['state'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageOutgoingImplToJson(
        _$MessageOutgoingImpl instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'runtimeType': instance.$type,
    };

_$MessageCompletedImpl _$$MessageCompletedImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageCompletedImpl(
      state: CompletedState.fromJson(json['state'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageCompletedImplToJson(
        _$MessageCompletedImpl instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'runtimeType': instance.$type,
    };

_$MessageFailedImpl _$$MessageFailedImplFromJson(Map<String, dynamic> json) =>
    _$MessageFailedImpl(
      state: FailedState.fromJson(json['state'] as Map<String, dynamic>),
      reason: json['reason'],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageFailedImplToJson(_$MessageFailedImpl instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'reason': instance.reason,
      'runtimeType': instance.$type,
    };

_$SendingImpl _$$SendingImplFromJson(Map<String, dynamic> json) =>
    _$SendingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SendingImplToJson(_$SendingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$UpdatingImpl _$$UpdatingImplFromJson(Map<String, dynamic> json) =>
    _$UpdatingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UpdatingImplToJson(_$UpdatingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$DeletingImpl _$$DeletingImplFromJson(Map<String, dynamic> json) =>
    _$DeletingImpl(
      hard: json['hard'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DeletingImplToJson(_$DeletingImpl instance) =>
    <String, dynamic>{
      'hard': instance.hard,
      'runtimeType': instance.$type,
    };

_$SentImpl _$$SentImplFromJson(Map<String, dynamic> json) => _$SentImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SentImplToJson(_$SentImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$UpdatedImpl _$$UpdatedImplFromJson(Map<String, dynamic> json) =>
    _$UpdatedImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UpdatedImplToJson(_$UpdatedImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$DeletedImpl _$$DeletedImplFromJson(Map<String, dynamic> json) =>
    _$DeletedImpl(
      hard: json['hard'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DeletedImplToJson(_$DeletedImpl instance) =>
    <String, dynamic>{
      'hard': instance.hard,
      'runtimeType': instance.$type,
    };

_$SendingFailedImpl _$$SendingFailedImplFromJson(Map<String, dynamic> json) =>
    _$SendingFailedImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SendingFailedImplToJson(_$SendingFailedImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$UpdatingFailedImpl _$$UpdatingFailedImplFromJson(Map<String, dynamic> json) =>
    _$UpdatingFailedImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UpdatingFailedImplToJson(
        _$UpdatingFailedImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$DeletingFailedImpl _$$DeletingFailedImplFromJson(Map<String, dynamic> json) =>
    _$DeletingFailedImpl(
      hard: json['hard'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DeletingFailedImplToJson(
        _$DeletingFailedImpl instance) =>
    <String, dynamic>{
      'hard': instance.hard,
      'runtimeType': instance.$type,
    };
