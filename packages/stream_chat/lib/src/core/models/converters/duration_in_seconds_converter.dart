import 'package:json_annotation/json_annotation.dart';

/// A [JsonConverter] for durations given in seconds.
///
/// [fromJson] drops a fraction of a second; [toJson] writes whole seconds.
class DurationInSecondsConverter implements JsonConverter<Duration, num> {
  /// Creates a new [DurationInSecondsConverter].
  const DurationInSecondsConverter();

  @override
  Duration fromJson(num json) => Duration(seconds: json.toInt());

  @override
  int toJson(Duration object) => object.inSeconds;
}
