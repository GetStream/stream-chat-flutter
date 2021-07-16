import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

/// The class that contains the information about a device
@JsonSerializable()
class Device {
  /// Constructor used for json serialization
  Device({
    required this.id,
    required this.pushProvider,
  });

  /// Create a new instance from a json
  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  /// The id of the device
  final String id;

  /// The notification push provider
  final String pushProvider;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
