// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageUpdate {
  MessageChangeSet? get changeSet;
  String? get oldText;

  /// Create a copy of MessageUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageUpdateCopyWith<MessageUpdate> get copyWith =>
      _$MessageUpdateCopyWithImpl<MessageUpdate>(
        this as MessageUpdate,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageUpdate &&
            (identical(other.changeSet, changeSet) ||
                other.changeSet == changeSet) &&
            (identical(other.oldText, oldText) || other.oldText == oldText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, changeSet, oldText);

  @override
  String toString() {
    return 'MessageUpdate(changeSet: $changeSet, oldText: $oldText)';
  }
}

/// @nodoc
abstract mixin class $MessageUpdateCopyWith<$Res> {
  factory $MessageUpdateCopyWith(
    MessageUpdate value,
    $Res Function(MessageUpdate) _then,
  ) = _$MessageUpdateCopyWithImpl;
  @useResult
  $Res call({MessageChangeSet? changeSet, String? oldText});
}

/// @nodoc
class _$MessageUpdateCopyWithImpl<$Res>
    implements $MessageUpdateCopyWith<$Res> {
  _$MessageUpdateCopyWithImpl(this._self, this._then);

  final MessageUpdate _self;
  final $Res Function(MessageUpdate) _then;

  /// Create a copy of MessageUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? changeSet = freezed, Object? oldText = freezed}) {
    return _then(
      MessageUpdate(
        changeSet: freezed == changeSet
            ? _self.changeSet
            : changeSet // ignore: cast_nullable_to_non_nullable
                  as MessageChangeSet?,
        oldText: freezed == oldText
            ? _self.oldText
            : oldText // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
