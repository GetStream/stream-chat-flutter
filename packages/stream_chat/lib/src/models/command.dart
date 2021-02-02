import 'package:json_annotation/json_annotation.dart';

part 'command.g.dart';

/// The class that contains the information about a command
@JsonSerializable()
class Command {
  /// The name of the command
  final String name;

  /// The description explaining the command
  final String description;

  /// The arguments of the command
  final String args;

  /// Constructor used for json serialization
  Command({
    this.name,
    this.description,
    this.args,
  });

  /// Create a new instance from a json
  factory Command.fromJson(Map<String, dynamic> json) =>
      _$CommandFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$CommandToJson(this);
}
