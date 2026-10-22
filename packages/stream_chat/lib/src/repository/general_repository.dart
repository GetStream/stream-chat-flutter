import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/response/create_guest_user_response.dart';
import '../core/models/response/og_attachment_response.dart';
import '../core/models/user.dart';
import 'mapper/general_mapper.dart';
import 'mapper/users_mapper.dart';

/// Repository dedicated to operations that belong to no single feature.
class GeneralRepository {
  /// Initialize a new general repository.
  const GeneralRepository(this._api);

  final api.DefaultApi _api;

  /// Scrapes `url` for the OpenGraph metadata a link preview is built from.
  ///
  /// The server fetches the page itself, so a URL it cannot scrape comes back
  /// as a failure.
  Future<Result<OGAttachmentResponse>> enrichUrl(String url) async {
    final result = await _api.getOG(url: url);

    return result.map((response) => response.toModel(requestedUrl: url));
  }

  /// Creates a guest from [user] and returns it with the token that authenticates it.
  ///
  /// The returned guest has an id of its own and the `guest` role, rather than those of [user].
  Future<Result<CreateGuestUserResponse>> createGuest(User user) async {
    final result = await _api.createGuest(
      createGuestRequest: api.CreateGuestRequest(user: user.toRequest()),
    );

    return result.map((response) => response.toModel());
  }
}
