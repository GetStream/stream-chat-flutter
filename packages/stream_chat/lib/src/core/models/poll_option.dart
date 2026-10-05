import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../util/serializer.dart';

part 'poll_option.g.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// {@template streamPollOption}
/// A model class representing a poll option.
/// {@endtemplate}
@JsonSerializable()
class PollOption extends Equatable {
  /// {@macro streamPollOption}
  const PollOption({
    this.id,
    required this.text,
    this.textI18n,
    this.extraData = const {},
  });

  /// Create a new instance from a json
  factory PollOption.fromJson(Map<String, dynamic> json) => _$PollOptionFromJson(
    Serializer.moveToExtraDataFromRoot(json, topLevelFields),
  );

  /// The unique identifier of the poll option.
  @JsonKey(includeIfNull: false)
  final String? id;

  /// The text describing the poll option.
  final String text;

  /// The translations of [text], keyed as `<language>_text`, plus the
  /// `language` [text] was written in.
  ///
  /// Filled in by the server when the poll is sent to a channel with
  /// automatic translation enabled.
  @JsonKey(includeToJson: false)
  final Map<String, String>? textI18n;

  /// Map of custom poll option extraData
  final Map<String, Object?> extraData;

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(_$PollOptionToJson(this));

  /// Creates a copy of [PollOption] with specified attributes overridden.
  PollOption copyWith({
    Object? id = _nullConst,
    String? text,
    Map<String, String>? textI18n,
    Map<String, Object?>? extraData,
  }) => PollOption(
    id: id == _nullConst ? this.id : id as String?,
    text: text ?? this.text,
    textI18n: textI18n ?? this.textI18n,
    extraData: extraData ?? this.extraData,
  );

  /// Known top level fields.
  ///
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'id',
    'text',
    'text_i18n',
  ];

  @override
  List<Object?> get props => [id, text, textI18n];
}
