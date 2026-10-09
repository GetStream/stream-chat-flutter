import '../../../open_api/api.dart' as api;
import '../../core/models/action.dart';
import '../../core/models/attachment.dart';
import '../../core/models/attachment_file.dart';

// TODO(openapi-migration): re-point these mappers in group 10.

/// Maps a generated [api.Attachment] to an [Attachment].
extension AttachmentMapper on api.Attachment {
  // Custom keys named like one of the attachment's own fields, including the ones it keeps in its extra data or only
  // stores offline.
  static const _shadowedCustomKeys = {
    ...Attachment.topLevelFields,
    'giphy',
    'file',
    'upload_state',
  };

  /// Converts this attachment into an [Attachment].
  ///
  /// The attachment gets a new local [Attachment.id]; an id it was sent with is kept in [Attachment.extraData], beside
  /// the custom data and the [Attachment.giphy] renditions, with custom data named like one of the attachment's own
  /// fields left out.
  Attachment toModel() => Attachment(
    type: type,
    titleLink: titleLink,
    title: title,
    thumbUrl: thumbUrl,
    text: text,
    pretext: pretext,
    ogScrapeUrl: ogScrapeUrl,
    imageUrl: imageUrl,
    footerIcon: footerIcon,
    footer: footer,
    fields: fields?.map((field) => field.toJson()).toList(),
    fallback: fallback,
    color: color,
    authorName: authorName,
    authorLink: authorLink,
    authorIcon: authorIcon,
    assetUrl: assetUrl,
    actions: actions?.map((action) => action.toModel()).toList() ?? const [],
    originalWidth: originalWidth,
    originalHeight: originalHeight,
    extraData: {...custom}..removeWhere((key, _) => _shadowedCustomKeys.contains(key)),
    giphy: giphy?.toJson(),
    uploadState: const UploadState.success(),
  );
}

/// Maps a generated [api.Action] to an [Action].
extension ActionMapper on api.Action {
  /// Converts this action into an [Action].
  Action toModel() => Action(
    name: name,
    style: style ?? 'default',
    text: text,
    type: type,
    value: value,
  );
}
