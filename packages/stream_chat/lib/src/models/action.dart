import 'package:json_annotation/json_annotation.dart';

part 'action.g.dart';

/// The class that contains the information about an action
@JsonSerializable()
class Action {
  /// Constructor used for json serialization
  Action({this.name, this.style, this.text, this.type, this.value});

  /// Create a new instance from a json
  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  /// The name of the action
  final String name;

  /// The style of the action
  final String style;

  /// The test of the action
  final String text;

  /// The type of the action
  final String type;

  /// The value of the action
  final String value;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ActionToJson(this);
}
