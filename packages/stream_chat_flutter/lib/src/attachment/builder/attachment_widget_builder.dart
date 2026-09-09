import 'package:flutter/material.dart';
import '../../../stream_chat_flutter.dart';

part 'fallback_attachment_builder.dart';
part 'file_attachment_builder.dart';
part 'gallery_attachment_builder.dart';
part 'giphy_attachment_builder.dart';
part 'image_attachment_builder.dart';
part 'mixed_attachment_builder.dart';
part 'link_preview_attachment_builder.dart';
part 'unsupported_attachment_builder.dart';
part 'video_attachment_builder.dart';
part 'voice_recording_attachment_playlist_builder.dart';
part 'poll_attachment_builder.dart';

// Screen-reader label for a media attachment tile.
//
// Image, video and giphy tiles render no text of their own, so without this
// they are focusable — they open a preview on tap — but announce nothing.
//
// [index] (0-based) and [total] are announced only for a gallery, where
// otherwise identical tiles need telling apart. The type label already rides
// on the message row's own phrase ("Han Solo said, 2 photos, ..."), so the
// tiles deliberately repeat the type rather than inventing a second summary.
String _mediaAttachmentSemanticsLabel(
  BuildContext context,
  Attachment attachment, {
  int? index,
  int? total,
}) {
  final a11y = context.translations.accessibility;

  final typeLabel = switch (attachment.type) {
    AttachmentType.video => a11y.videoAttachmentLabel(title: attachment.title),
    AttachmentType.giphy => a11y.gifAttachmentLabel,
    _ => a11y.imageAttachmentLabel(title: attachment.title),
  };

  if (index == null || total == null || total < 2) return typeLabel;
  return '$typeLabel, ${a11y.attachmentPositionLabel(index: index + 1, total: total)}';
}

/// {@template streamAttachmentWidgetTapCallback}
/// Signature for a function that's called when the user taps on an attachment.
/// {@endtemplate}
typedef StreamAttachmentWidgetTapCallback =
    void Function(
      Message message,
      Attachment attachment,
    );

/// {@template attachmentWidgetBuilder}
/// A builder which is used to build a widget for a given [Message] and
/// [Attachment]'s. This can also be used to show custom attachments.
/// {@endtemplate}
///
/// See also:
///
///  * [AttachmentWidgetBuilderManager], which is used to manage a list of
///    [StreamAttachmentWidgetBuilder]'s.
abstract class StreamAttachmentWidgetBuilder {
  /// {@macro attachmentWidgetBuilder}
  const StreamAttachmentWidgetBuilder();

  /// The default list of builders used by the [AttachmentWidgetCatalog].
  ///
  /// This list contains the following builders in order:
  ///   * [MixedAttachmentBuilder]
  ///   * [GalleryAttachmentBuilder]
  ///   * [GiphyAttachmentBuilder]
  ///   * [FileAttachmentBuilder]
  ///   * [ImageAttachmentBuilder]
  ///   * [VideoAttachmentBuilder]
  ///   * [VoiceRecordingAttachmentPlaylistBuilder]
  ///   * [PollAttachmentBuilder]
  ///   * [LinkPreviewAttachmentBuilder]
  ///   * [FallbackAttachmentBuilder]
  ///
  /// You can use this list as a starting point for your own list of builders.
  ///
  /// Example:
  ///
  /// ```dart
  ///   final myBuilders = StreamAttachmentWidgetBuilder.defaultBuilders(
  ///     customAttachmentBuilders: [
  ///       MyCustomAttachmentBuilder(),
  ///       MyOtherCustomAttachmentBuilder(),
  ///     ]
  ///   );
  /// ```
  ///
  /// **Note**: The order of the builders in the list is important. The first
  /// builder that returns `true` from [canHandle] will be used to build the
  /// widget.
  static List<StreamAttachmentWidgetBuilder> defaultBuilders({
    required Message message,
    StreamAttachmentWidgetTapCallback? onAttachmentTap,
    List<StreamAttachmentWidgetBuilder>? customAttachmentBuilders,
  }) {
    return [
      ...?customAttachmentBuilders,

      // Handles poll attachments.
      const PollAttachmentBuilder(),

      // Handles a mix of image, gif, video, url, file and voice recording
      // attachments.
      MixedAttachmentBuilder(
        onAttachmentTap: onAttachmentTap,
      ),

      // Handles a mix of image, gif, and video attachments.
      GalleryAttachmentBuilder(
        onAttachmentTap: onAttachmentTap,
      ),

      // Handles file attachments.
      FileAttachmentBuilder(
        onAttachmentTap: onAttachmentTap,
      ),

      // Handles giphy attachments.
      GiphyAttachmentBuilder(
        onAttachmentTap: onAttachmentTap,
      ),

      // Handles image attachments.
      ImageAttachmentBuilder(
        onAttachmentTap: onAttachmentTap,
      ),

      // Handles video attachments.
      VideoAttachmentBuilder(
        onAttachmentTap: onAttachmentTap,
      ),

      // Handles voice recording attachments.
      VoiceRecordingAttachmentPlaylistBuilder(
        onAttachmentTap: onAttachmentTap,
      ),

      // We don't handle URL attachments if the message is a reply.
      if (message.quotedMessage == null)
        LinkPreviewAttachmentBuilder(
          onAttachmentTap: onAttachmentTap,
        ),

      // Handles unrecognised content with a visible placeholder.
      const UnsupportedAttachmentBuilder(),

      // Fallback builder should always be the last builder in the list.
      const FallbackAttachmentBuilder(),
    ];
  }

  /// Determines whether this builder can handle the given [message] and
  /// [attachments]. If this returns `true`, [build] will be called.
  /// Otherwise, the next builder in the list will be called.
  bool canHandle(Message message, Map<String, List<Attachment>> attachments);

  /// Builds a widget for the given [message] and [attachments].
  /// This will only be called if [canHandle] returns `true`.
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  );

  /// Asserts that this builder can handle the given [message] and
  /// [attachments].
  ///
  /// This is used to ensure that the [defaultBuilders] are used correctly.
  ///
  /// **Note**: This method is only called in debug mode.
  bool debugAssertCanHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(() {
      if (!canHandle(message, attachments)) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'A $runtimeType was used to build a attachment for a message, but '
            'it cant handle the message.',
          ),
          ErrorDescription(
            'The builders in the list must be checked in order. Check the '
            'documentation for $runtimeType for more details.',
          ),
        ]);
      }
      return true;
    }(), '');
    return true;
  }
}
