import 'package:json_annotation/json_annotation.dart';

part 'command.g.dart';

/// The class that contains the information about a command
@JsonSerializable()
class Command {
  /// Constructor used for json serialization
  Command({
    required this.name,
    this.description = '',
    this.args = '',
    this.set = const CommandSet(''),
  });

  /// Create a new instance from a json
  factory Command.fromJson(Map<String, dynamic> json) => _$CommandFromJson(json);

  /// The name of the command
  final String name;

  /// The description explaining the command
  final String description;

  /// The arguments of the command
  final String args;

  /// The set the command belongs to (e.g. [CommandSet.fun],
  /// [CommandSet.moderation]).
  ///
  /// Used to determine where the command can be activated; for example,
  /// commands in [CommandSet.moderation] are not available while replying
  /// to a message. An empty value means the command isn't grouped into a
  /// known set (custom commands or legacy payloads).
  @JsonKey(fromJson: _setFromJson, toJson: _setToJson)
  final CommandSet set;

  static CommandSet _setFromJson(Object? json) {
    if (json == null || json is! String) return const CommandSet('');
    return CommandSet(json);
  }

  static String _setToJson(CommandSet value) => value;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$CommandToJson(this);
}

/// Wire identifier for a [Command]'s set, returned by the backend on the
/// `set` field.
///
/// Implemented as an extension type over [String] so it serializes for free
/// and accepts custom values defined per-application, while exposing the
/// built-in sets as named constants.
extension type const CommandSet(String _) implements String {
  /// Compositional commands (e.g. `/giphy`) that operate on the user's text
  /// and remain valid alongside a quoted message.
  static const fun = CommandSet('fun_set');

  /// Action commands (e.g. `/ban`, `/mute`) that don't inherit composer
  /// context; not available while a quoted message is set.
  static const moderation = CommandSet('moderation_set');
}
