// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageInitial _$MessageInitialFromJson(Map<String, dynamic> json) =>
    MessageInitial(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MessageInitialToJson(MessageInitial instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

MessageOutgoing _$MessageOutgoingFromJson(Map<String, dynamic> json) =>
    MessageOutgoing(
      state: OutgoingState.fromJson(json['state'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MessageOutgoingToJson(MessageOutgoing instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'runtimeType': instance.$type,
    };

MessageCompleted _$MessageCompletedFromJson(Map<String, dynamic> json) =>
    MessageCompleted(
      state: CompletedState.fromJson(json['state'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MessageCompletedToJson(MessageCompleted instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'runtimeType': instance.$type,
    };

MessageFailed _$MessageFailedFromJson(Map<String, dynamic> json) =>
    MessageFailed(
      state: FailedState.fromJson(json['state'] as Map<String, dynamic>),
      reason: json['reason'],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MessageFailedToJson(MessageFailed instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'reason': instance.reason,
      'runtimeType': instance.$type,
    };

Sending _$SendingFromJson(Map<String, dynamic> json) => Sending(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$SendingToJson(Sending instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

Updating _$UpdatingFromJson(Map<String, dynamic> json) => Updating(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UpdatingToJson(Updating instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

Deleting _$DeletingFromJson(Map<String, dynamic> json) => Deleting(
      scope: json['scope'] == null
          ? MessageDeleteScope.softDeleteForAll
          : MessageDeleteScope.fromJson(json['scope'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$DeletingToJson(Deleting instance) => <String, dynamic>{
      'scope': instance.scope.toJson(),
      'runtimeType': instance.$type,
    };

Sent _$SentFromJson(Map<String, dynamic> json) => Sent(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$SentToJson(Sent instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

Updated _$UpdatedFromJson(Map<String, dynamic> json) => Updated(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UpdatedToJson(Updated instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

Deleted _$DeletedFromJson(Map<String, dynamic> json) => Deleted(
      scope: json['scope'] == null
          ? MessageDeleteScope.softDeleteForAll
          : MessageDeleteScope.fromJson(json['scope'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$DeletedToJson(Deleted instance) => <String, dynamic>{
      'scope': instance.scope.toJson(),
      'runtimeType': instance.$type,
    };

SendingFailed _$SendingFailedFromJson(Map<String, dynamic> json) =>
    SendingFailed(
      skipPush: json['skip_push'] as bool? ?? false,
      skipEnrichUrl: json['skip_enrich_url'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$SendingFailedToJson(SendingFailed instance) =>
    <String, dynamic>{
      'skip_push': instance.skipPush,
      'skip_enrich_url': instance.skipEnrichUrl,
      'runtimeType': instance.$type,
    };

UpdatingFailed _$UpdatingFailedFromJson(Map<String, dynamic> json) =>
    UpdatingFailed(
      skipPush: json['skip_push'] as bool? ?? false,
      skipEnrichUrl: json['skip_enrich_url'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UpdatingFailedToJson(UpdatingFailed instance) =>
    <String, dynamic>{
      'skip_push': instance.skipPush,
      'skip_enrich_url': instance.skipEnrichUrl,
      'runtimeType': instance.$type,
    };

PartialUpdatingFailed _$PartialUpdatingFailedFromJson(
        Map<String, dynamic> json) =>
    PartialUpdatingFailed(
      set: json['set'] as Map<String, dynamic>?,
      unset:
          (json['unset'] as List<dynamic>?)?.map((e) => e as String).toList(),
      skipEnrichUrl: json['skip_enrich_url'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$PartialUpdatingFailedToJson(
        PartialUpdatingFailed instance) =>
    <String, dynamic>{
      'set': instance.set,
      'unset': instance.unset,
      'skip_enrich_url': instance.skipEnrichUrl,
      'runtimeType': instance.$type,
    };

DeletingFailed _$DeletingFailedFromJson(Map<String, dynamic> json) =>
    DeletingFailed(
      scope: json['scope'] == null
          ? MessageDeleteScope.softDeleteForAll
          : MessageDeleteScope.fromJson(json['scope'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$DeletingFailedToJson(DeletingFailed instance) =>
    <String, dynamic>{
      'scope': instance.scope.toJson(),
      'runtimeType': instance.$type,
    };
