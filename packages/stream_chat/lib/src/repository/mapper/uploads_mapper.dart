import 'package:stream_core/stream_core.dart' show UploadedFile;

import '../../../open_api/api.dart' as api;

/// Maps a generated [api.UploadChannelResponse] to an [UploadedFile].
extension UploadChannelResponseMapper on api.UploadChannelResponse {
  /// Converts this response into an [UploadedFile].
  UploadedFile toModel() => UploadedFile(fileUrl: file, thumbUrl: thumbUrl);
}

/// Maps a generated [api.UploadChannelFileResponse] to an [UploadedFile].
extension UploadChannelFileResponseMapper on api.UploadChannelFileResponse {
  /// Converts this response into an [UploadedFile].
  UploadedFile toModel() => UploadedFile(fileUrl: file, thumbUrl: thumbUrl);
}

/// Maps a generated [api.ImageUploadResponse] to an [UploadedFile].
extension ImageUploadResponseMapper on api.ImageUploadResponse {
  /// Converts this response into an [UploadedFile].
  UploadedFile toModel() => UploadedFile(fileUrl: file, thumbUrl: thumbUrl);
}

/// Maps a generated [api.FileUploadResponse] to an [UploadedFile].
extension FileUploadResponseMapper on api.FileUploadResponse {
  /// Converts this response into an [UploadedFile].
  UploadedFile toModel() => UploadedFile(fileUrl: file, thumbUrl: thumbUrl);
}
