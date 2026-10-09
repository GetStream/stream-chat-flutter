import 'package:freezed_annotation/freezed_annotation.dart';

part 'mark_read_response.freezed.dart';

/// The outcome of marking one or more channels, or a thread, as read.
@freezed
class MarkReadResponse with _$MarkReadResponse {
  /// Creates a new [MarkReadResponse].
  const MarkReadResponse({
    required this.duration,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;
}
