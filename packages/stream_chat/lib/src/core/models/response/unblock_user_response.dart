import 'package:freezed_annotation/freezed_annotation.dart';

part 'unblock_user_response.freezed.dart';

/// The outcome of the current user unblocking another user.
///
/// Returned by [StreamChatClient.unblockUser].
@freezed
class UnblockUserResponse with _$UnblockUserResponse {
  /// Creates a new [UnblockUserResponse].
  const UnblockUserResponse({
    required this.duration,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;
}
