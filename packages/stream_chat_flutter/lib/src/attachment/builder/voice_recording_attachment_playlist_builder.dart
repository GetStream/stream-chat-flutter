part of 'attachment_widget_builder.dart';

/// {@template voiceRecordingAttachmentPlaylistBuilder}
/// A [StreamAttachmentWidgetBuilder] for building a voice recording attachment
/// playlist widget.
///
/// This widget is used to display a list of voice recordings in a message.
///
/// The widget is built when the message has at least one voice recording
/// attachment.
/// {@endtemplate}
class VoiceRecordingAttachmentPlaylistBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro voiceRecordingAttachmentPlaylistBuilder}
  const VoiceRecordingAttachmentPlaylistBuilder({
    this.shape,
    this.padding = const EdgeInsets.all(16),
    this.constraints = const BoxConstraints(),
    this.onAttachmentTap,
  });

  /// The shape of the video attachment.
  final ShapeBorder? shape;

  /// The padding to apply to the video attachment widget.
  final EdgeInsetsGeometry padding;

  /// The constraints to apply to the video attachment widget.
  final BoxConstraints constraints;

  /// The callback to call when the attachment is tapped.
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final playlist = attachments[AttachmentType.voiceRecording];
    return playlist != null && playlist.isNotEmpty;
  }

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final playlist = attachments[AttachmentType.voiceRecording]!;

    return Padding(
      padding: padding,
      child: StreamVoiceRecordingAttachmentPlaylist(
        shape: shape,
        message: message,
        voiceRecordings: playlist,
        constraints: constraints,
        separatorBuilder: (_, __) => SizedBox(height: padding.vertical / 2),
      ),
    );
  }
}
