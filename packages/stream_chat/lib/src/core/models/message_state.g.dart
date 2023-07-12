// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageInitial _$$MessageInitialFromJson(Map<String, dynamic> json) =>
    _$MessageInitial(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageInitialToJson(_$MessageInitial instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$MessageOutgoing _$$MessageOutgoingFromJson(Map<String, dynamic> json) =>
    _$MessageOutgoing(
      state: OutgoingState.fromJson(json['state'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageOutgoingToJson(_$MessageOutgoing instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'runtimeType': instance.$type,
    };

_$MessageCompleted _$$MessageCompletedFromJson(Map<String, dynamic> json) =>
    _$MessageCompleted(
      state: CompletedState.fromJson(json['state'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageCompletedToJson(_$MessageCompleted instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'runtimeType': instance.$type,
    };

_$MessageFailed _$$MessageFailedFromJson(Map<String, dynamic> json) =>
    _$MessageFailed(
      state: FailedState.fromJson(json['state'] as Map<String, dynamic>),
      reason: json['reason'],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageFailedToJson(_$MessageFailed instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'reason': instance.reason,
      'runtimeType': instance.$type,
    };

_$Sending _$$SendingFromJson(Map<String, dynamic> json) => _$Sending(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SendingToJson(_$Sending instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$Updating _$$UpdatingFromJson(Map<String, dynamic> json) => _$Updating(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UpdatingToJson(_$Updating instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$Deleting _$$DeletingFromJson(Map<String, dynamic> json) => _$Deleting(
      hard: json['hard'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DeletingToJson(_$Deleting instance) =>
    <String, dynamic>{
      'hard': instance.hard,
      'runtimeType': instance.$type,
    };

_$Sent _$$SentFromJson(Map<String, dynamic> json) => _$Sent(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SentToJson(_$Sent instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$Updated _$$UpdatedFromJson(Map<String, dynamic> json) => _$Updated(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UpdatedToJson(_$Updated instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$Deleted _$$DeletedFromJson(Map<String, dynamic> json) => _$Deleted(
      hard: json['hard'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DeletedToJson(_$Deleted instance) => <String, dynamic>{
      'hard': instance.hard,
      'runtimeType': instance.$type,
    };

_$SendingFailed _$$SendingFailedFromJson(Map<String, dynamic> json) =>
    _$SendingFailed(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SendingFailedToJson(_$SendingFailed instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$UpdatingFailed _$$UpdatingFailedFromJson(Map<String, dynamic> json) =>
    _$UpdatingFailed(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UpdatingFailedToJson(_$UpdatingFailed instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$DeletingFailed _$$DeletingFailedFromJson(Map<String, dynamic> json) =>
    _$DeletingFailed(
      hard: json['hard'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DeletingFailedToJson(_$DeletingFailed instance) =>
    <String, dynamic>{
      'hard': instance.hard,
      'runtimeType': instance.$type,
    };
