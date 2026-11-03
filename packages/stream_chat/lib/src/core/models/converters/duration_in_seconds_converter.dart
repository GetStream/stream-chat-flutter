import 'package:json_annotation/json_annotation.dart';

/// A [JsonConverter] for the API's durations given in whole seconds.
///
/// [fromJson] accepts any number and drops a fraction of a second; [toJson]
/// writes whole seconds.
class DurationInSecondsConverter implements JsonConverter<Duration, num> {
  /// Creates a new [DurationInSecondsConverter].
  const DurationInSecondsConverter();

  @override
  Duration fromJson(num json) => Duration(seconds: json.toInt());

  @override
  int toJson(Duration object) => object.inSeconds;
}
