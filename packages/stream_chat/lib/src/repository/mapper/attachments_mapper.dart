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

/// Maps an [Attachment] to the generated [api.Attachment] a request sends.
extension AttachmentRequestMapper on Attachment {
  // Extra data keys that never become custom data: the keys named like one of the attachment's own fields, including
  // the Giphy renditions, which the request carries in a field of their own, and the local id.
  static const _nonCustomKeys = {...AttachmentMapper._shadowedCustomKeys, 'id'};

  /// Converts this attachment into the shape a request sends.
  ///
  /// The extra data becomes the custom data, except the [giphy] renditions and keys named like one of the
  /// attachment's own fields. The local [id], [uploadState] and [file] are left out.
  api.Attachment toRequest() => api.Attachment(
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
    fields: _fieldsToRequest(fields),
    fallback: fallback,
    color: color,
    authorName: authorName,
    authorLink: authorLink,
    authorIcon: authorIcon,
    assetUrl: assetUrl,
    actions: actions?.map((action) => action.toRequest()).toList(),
    originalWidth: originalWidth,
    originalHeight: originalHeight,
    giphy: switch (giphy) {
      final giphy? => _imagesToRequest(giphy),
      null => null,
    },
    custom: {...extraData}..removeWhere((key, _) => _nonCustomKeys.contains(key)),
  );
}

/// Maps an [Action] to the generated [api.Action] a request sends.
extension ActionRequestMapper on Action {
  /// Converts this action into the shape a request sends.
  api.Action toRequest() => api.Action(name: name, style: style, text: text, type: type, value: value);
}

// A key missing from a field reads as its empty value.
List<api.Field>? _fieldsToRequest(Object? fields) => switch (fields) {
  final List<Object?> fields => [
    for (final field in fields)
      if (field case final Map<String, Object?> field)
        api.Field(
          title: _stringOrEmpty(field['title']),
          value: _stringOrEmpty(field['value']),
          short: switch (field['short']) {
            final bool short => short,
            _ => false,
          },
        ),
  ],
  _ => null,
};

// A rendition, or a key of one, missing from the Giphy data reads as its empty value.
api.Images _imagesToRequest(Map<String, Object?> giphy) {
  api.ImageData rendition(String name) {
    final data = switch (giphy[name]) {
      final Map<String, Object?> data => data,
      _ => const <String, Object?>{},
    };

    return api.ImageData(
      url: _stringOrEmpty(data['url']),
      width: _stringOrEmpty(data['width']),
      height: _stringOrEmpty(data['height']),
      size: _stringOrEmpty(data['size']),
      frames: _stringOrEmpty(data['frames']),
    );
  }

  return api.Images(
    original: rendition('original'),
    fixedHeight: rendition('fixed_height'),
    fixedHeightStill: rendition('fixed_height_still'),
    fixedHeightDownsampled: rendition('fixed_height_downsampled'),
    fixedWidth: rendition('fixed_width'),
    fixedWidthStill: rendition('fixed_width_still'),
    fixedWidthDownsampled: rendition('fixed_width_downsampled'),
  );
}

String _stringOrEmpty(Object? value) => switch (value) {
  final String value => value,
  _ => '',
};
