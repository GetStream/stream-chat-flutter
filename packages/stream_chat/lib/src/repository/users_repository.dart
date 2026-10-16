import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/response/get_unread_count_response.dart';
import 'mapper/user_mapper.dart';

/// Repository dedicated to user operations.
class UsersRepository {
  /// Creates a new users repository.
  const UsersRepository(this._api);

  final api.DefaultApi _api;

  /// Gets how many unread messages and threads the current user has.
  Future<Result<GetUnreadCountResponse>> getUnreadCount() async {
    final result = await _api.unreadCounts();
    return result.map((response) => response.toModel());
  }
}
