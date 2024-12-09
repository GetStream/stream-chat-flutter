import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'poll_option.g.dart';

/// {@template streamPollOption}
/// A model class representing a poll option.
/// {@endtemplate}
@JsonSerializable()
class PollOption extends Equatable {
  /// {@macro streamPollOption}
  const PollOption({
    this.id,
    required this.text,
    this.extraData = const {},
  });

  /// Create a new instance from a json
  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(
        Serializer.moveToExtraDataFromRoot(json, topLevelFields),
      );

  /// The unique identifier of the poll option.
  @JsonKey(includeToJson: false)
  final String? id;

  /// The text describing the poll option.
  final String text;

  /// Map of custom poll option extraData
  final Map<String, Object?> extraData;

  /// Serialize to json
  Map<String, dynamic> toJson() =>
      Serializer.moveFromExtraDataToRoot(_$PollOptionToJson(this));

  /// Known top level fields.
  ///
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'id',
    'text',
  ];

  @override
  List<Object?> get props => [id, text];
}
