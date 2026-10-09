import 'package:freezed_annotation/freezed_annotation.dart';

import '../thread.dart';

part 'get_thread_response.freezed.dart';

/// The thread fetched by its parent message.
@freezed
class GetThreadResponse with _$GetThreadResponse {
  /// Creates a new [GetThreadResponse].
  const GetThreadResponse({
    required this.duration,
    required this.thread,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The thread that was fetched.
  @override
  final Thread thread;
}
