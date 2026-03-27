part of 'attachment_widget_builder.dart';

/// {@template mixedAttachmentBuilder}
/// A widget builder for Mixed attachment type.
///
/// This builder is used when a message contains a mix of media type and file
/// or url preview attachments.
///
/// This builder will render first the url preview or file attachment and then
/// the media attachments.
/// {@endtemplate}
class MixedAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro mixedAttachmentBuilder}
  MixedAttachmentBuilder({
    StreamAttachmentWidgetTapCallback? onAttachmentTap,
  }) : _imageAttachmentBuilder = ImageAttachmentBuilder(onAttachmentTap: onAttachmentTap),
       _videoAttachmentBuilder = VideoAttachmentBuilder(onAttachmentTap: onAttachmentTap),
       _giphyAttachmentBuilder = GiphyAttachmentBuilder(onAttachmentTap: onAttachmentTap),
       _galleryAttachmentBuilder = GalleryAttachmentBuilder(onAttachmentTap: onAttachmentTap),
       _fileAttachmentBuilder = FileAttachmentBuilder(onAttachmentTap: onAttachmentTap),
       _linkPreviewAttachmentBuilder = LinkPreviewAttachmentBuilder(onAttachmentTap: onAttachmentTap),
       _voiceRecordingAttachmentPlaylistBuilder = VoiceRecordingAttachmentPlaylistBuilder(
         onAttachmentTap: onAttachmentTap,
       );

  late final StreamAttachmentWidgetBuilder _imageAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _videoAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _giphyAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _galleryAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _fileAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _linkPreviewAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _voiceRecordingAttachmentPlaylistBuilder;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final types = {...attachments.keys};

    final mediaTypes = {
      AttachmentType.image,
      AttachmentType.video,
      AttachmentType.giphy,
    };

    final otherTypes = {
      AttachmentType.file,
      AttachmentType.urlPreview,
      AttachmentType.voiceRecording,
    };

    // Check if there's at least one media type and one other type
    final hasMedia = types.intersection(mediaTypes).isNotEmpty;
    final hasOther = types.intersection(otherTypes).isNotEmpty;

    return hasMedia && hasOther || types.intersection(otherTypes).length > 1;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final urls = attachments[AttachmentType.urlPreview];
    final files = attachments[AttachmentType.file];
    final voiceRecordings = attachments[AttachmentType.voiceRecording];
    final images = attachments[AttachmentType.image];
    final videos = attachments[AttachmentType.video];
    final giphys = attachments[AttachmentType.giphy];

    final shouldBuildGallery = [...?images, ...?videos, ...?giphys].length > 1;

    final spacing = context.streamSpacing;
    final crossAxisAlignment = StreamMessageLayout.crossAxisAlignmentOf(context);

    return Column(
      spacing: spacing.xs,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        if (urls != null)
          ?_linkPreviewAttachmentBuilder.build(context, message, {
            AttachmentType.urlPreview: urls,
          }),
        if (shouldBuildGallery)
          ?_galleryAttachmentBuilder.build(context, message, {
            if (images != null) AttachmentType.image: images,
            if (videos != null) AttachmentType.video: videos,
            if (giphys != null) AttachmentType.giphy: giphys,
          })
        else if (images != null && images.length == 1)
          ?_imageAttachmentBuilder.build(context, message, {
            AttachmentType.image: images,
          })
        else if (videos != null && videos.length == 1)
          ?_videoAttachmentBuilder.build(context, message, {
            AttachmentType.video: videos,
          })
        else if (giphys != null && giphys.length == 1)
          ?_giphyAttachmentBuilder.build(context, message, {
            AttachmentType.giphy: giphys,
          }),
        if (files != null)
          ?_fileAttachmentBuilder.build(context, message, {
            AttachmentType.file: files,
          }),
        if (voiceRecordings != null)
          ?_voiceRecordingAttachmentPlaylistBuilder.build(context, message, {
            AttachmentType.voiceRecording: voiceRecordings,
          }),
      ],
    );
  }
}
