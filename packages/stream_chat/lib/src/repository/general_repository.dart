import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/response/og_attachment_response.dart';
import 'mapper/general_mapper.dart';

/// Repository dedicated to operations that belong to no single feature.
class GeneralRepository {
  /// Initialize a new general repository.
  const GeneralRepository(this._api);

  final api.DefaultApi _api;

  /// Scrapes `url` for the OpenGraph metadata a link preview is built from.
  ///
  /// The page is fetched remotely rather than from this device, so a URL only
  /// this device can reach comes back as a failure.
  Future<Result<OGAttachmentResponse>> enrichUrl(String url) async {
    final result = await _api.getOG(url: url);

    return result.map((response) => response.toModel(requestedUrl: url));
  }
}
