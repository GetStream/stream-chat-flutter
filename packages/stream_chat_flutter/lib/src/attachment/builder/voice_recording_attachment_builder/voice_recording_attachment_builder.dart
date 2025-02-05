part of '../attachment_widget_builder.dart';

/// The default attachment builder for voice recordings
@Deprecated("Use 'VoiceRecordingAttachmentPlaylistBuilder' instead")
class VoiceRecordingAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) {
    final recordings = attachments[AttachmentType.voiceRecording];
    if (recordings != null && recordings.length == 1) return true;

    return false;
  }

  @override
  Widget build(BuildContext context, Message message,
      Map<String, List<Attachment>> attachments) {
    final recordings = attachments[AttachmentType.voiceRecording]!;

    return StreamVoiceRecordingListPlayer(
      playList: recordings
          .map(
            (r) => PlayListItem(
              assetUrl: r.assetUrl,
              duration: r.duration,
              waveForm: r.waveform,
            ),
          )
          .toList(),
      attachmentBorderRadiusGeometry: BorderRadius.circular(16),
      constraints: const BoxConstraints.tightFor(width: 400),
    );
  }
}
