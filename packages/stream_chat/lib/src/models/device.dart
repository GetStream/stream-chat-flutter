import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

/// The class that contains the information about a device
@JsonSerializable()
class Device {
  /// The id of the device
  final String id;

  /// The notification push provider
  final String pushProvider;

  /// Constructor used for json serialization
  Device({
    this.id,
    this.pushProvider,
  });

  /// Create a new instance from a json
  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
