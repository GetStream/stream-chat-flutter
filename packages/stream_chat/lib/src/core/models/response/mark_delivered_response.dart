import 'package:freezed_annotation/freezed_annotation.dart';

part 'mark_delivered_response.freezed.dart';

/// The outcome of sending delivery receipts.
@freezed
class MarkDeliveredResponse with _$MarkDeliveredResponse {
  /// Creates a new [MarkDeliveredResponse].
  const MarkDeliveredResponse({
    required this.duration,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;
}
