import 'package:freezed_annotation/freezed_annotation.dart';

import '../user.dart';

part 'create_guest_user_response.freezed.dart';

/// A newly created guest and the token that authenticates it.
@freezed
class CreateGuestUserResponse with _$CreateGuestUserResponse {
  /// Creates a new [CreateGuestUserResponse].
  const CreateGuestUserResponse({
    required this.duration,
    required this.accessToken,
    required this.user,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The token that authenticates [user].
  @override
  final String accessToken;

  /// The created guest, which has an id of its own rather than the one requested.
  @override
  final User user;
}
