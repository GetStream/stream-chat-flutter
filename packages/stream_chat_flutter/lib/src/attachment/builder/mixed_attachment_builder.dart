part of 'attachment_widget_builder.dart';

/// {@template mixedAttachmentBuilder}
/// A widget builder for Mixed attachment type.
///
/// This builder is used when a message contains both image/video/giphy and file
/// attachments.
///
/// This builder will render first image/video/giphy attachment and then render
/// the file attachments.
/// {@endtemplate}
class MixedAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro mixedAttachmentBuilder}
  MixedAttachmentBuilder({
    this.shape,
    this.padding = const EdgeInsets.all(4),
    this.onAttachmentTap,
  })  : _imageAttachmentBuilder = ImageAttachmentBuilder(
          onAttachmentTap: onAttachmentTap,
          padding: EdgeInsets.symmetric(horizontal: padding.horizontal),
        ),
        _videoAttachmentBuilder = VideoAttachmentBuilder(
          onAttachmentTap: onAttachmentTap,
          padding: EdgeInsets.symmetric(horizontal: padding.horizontal),
        ),
        _giphyAttachmentBuilder = GiphyAttachmentBuilder(
          onAttachmentTap: onAttachmentTap,
          padding: EdgeInsets.symmetric(horizontal: padding.horizontal),
        ),
        _galleryAttachmentBuilder = GalleryAttachmentBuilder(
          onAttachmentTap: onAttachmentTap,
          padding: EdgeInsets.symmetric(horizontal: padding.horizontal),
        ),
        _fileAttachmentBuilder = FileAttachmentBuilder(
          onAttachmentTap: onAttachmentTap,
          padding: EdgeInsets.symmetric(horizontal: padding.horizontal),
        );

  /// The shape of the gallery attachment.
  final ShapeBorder? shape;

  /// The padding to apply to the gallery attachment widget.
  final EdgeInsetsGeometry padding;

  /// The callback to call when the attachment is tapped.
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  late final StreamAttachmentWidgetBuilder _imageAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _videoAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _giphyAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _galleryAttachmentBuilder;
  late final StreamAttachmentWidgetBuilder _fileAttachmentBuilder;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final containsImage = attachments.keys.contains(AttachmentType.image);
    final containsVideo = attachments.keys.contains(AttachmentType.video);
    final containsGiphy = attachments.keys.contains(AttachmentType.giphy);
    final containsFile = attachments.keys.contains(AttachmentType.file);

    final containsMedia = containsImage || containsVideo || containsGiphy;

    return containsMedia && containsFile;
  }

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final files = attachments[AttachmentType.file];
    final images = attachments[AttachmentType.image];
    final videos = attachments[AttachmentType.video];
    final giphys = attachments[AttachmentType.giphy];

    final shouldBuildGallery = [...?images, ...?videos, ...?giphys].length > 1;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (files != null)
            for (final file in files)
              _fileAttachmentBuilder.build(context, message, {
                AttachmentType.file: [file],
              }),
          if (shouldBuildGallery)
            _galleryAttachmentBuilder.build(context, message, {
              if (images != null) AttachmentType.image: images,
              if (videos != null) AttachmentType.video: videos,
              if (giphys != null) AttachmentType.giphy: giphys,
            })
          else if (images != null && images.length == 1)
            _imageAttachmentBuilder.build(context, message, {
              AttachmentType.image: images,
            })
          else if (videos != null && videos.length == 1)
            _videoAttachmentBuilder.build(context, message, {
              AttachmentType.video: videos,
            })
          else if (giphys != null && giphys.length == 1)
            _giphyAttachmentBuilder.build(context, message, {
              AttachmentType.giphy: giphys,
            }),
        ].insertBetween(
          SizedBox(height: padding.vertical / 2),
        ),
      ),
    );
  }
}
