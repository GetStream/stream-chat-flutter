import 'package:freezed_annotation/freezed_annotation.dart';

import '../../db/data_serializable.dart';

part 'poll_option.freezed.dart';
part 'poll_option.g.dart';

/// One of the choices a poll offers to vote on.
@freezed
// TODO(openapi-migration): remove in group 10
@DataSerializable(includeIfNull: false)
class PollOption with _$PollOption {
  /// Creates a new [PollOption].
  ///
  /// An option that is about to be added to a poll has no [id] yet; one is
  /// assigned when the poll or the option is created.
  const PollOption({
    this.id,
    required this.text,
    this.extraData = const {},
  });

  /// Creates a [PollOption] from the offline-database format written by [toData].
  ///
  /// It is not a codec for API payloads.
  factory PollOption.fromData(Map<String, dynamic> json) => _$PollOptionFromJson(json);

  /// The unique identifier of this option, or null before it is created.
  @override
  final String? id;

  /// The text shown for this option.
  @override
  final String text;

  /// Custom data attached to this option.
  @override
  final Map<String, Object?> extraData;

  /// The keys an option carries besides its custom data.
  static const topLevelFields = [
    'id',
    'text',
    'text_i18n',
  ];

  /// Serializes this option to the format `stream_chat_persistence` stores.
  ///
  /// It is not a codec for API payloads.
  Map<String, dynamic> toData() => _$PollOptionToJson(this);
}
