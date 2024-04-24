part of '../attachment_widget_builder.dart';


/// The default attachment builder for voice recordings
class VoiceRecordingAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) {
    final recordings = attachments[AttachmentType.voiceRecording];
    if (recordings != null && recordings.length == 1) return true;

    return false;
  }

  Duration _resolveDuration(Attachment attachment) {
    final duration = attachment.extraData['duration'] as double?;
    if (duration == null) {
      return Duration.zero;
    }

    return Duration(milliseconds: duration.round() * 1000);
  }

  List<double> _resolveWaveform(Attachment attachment) {
    final waveform =
        attachment.extraData['waveform_data'] as List<dynamic>? ?? <dynamic>[];
    return waveform
        .map((e) => double.tryParse(e.toString()))
        .whereNotNull()
        .toList();
  }


  @override
  Widget build(BuildContext context, Message message,
      Map<String, List<Attachment>> attachments) {
    final recordings = attachments[AttachmentType.voiceRecording]!;

    return StreamVoiceRecordingListPlayer(
      playList: recordings
          .map((r) => PlayListItem(
              assetUrl: r.assetUrl,
              duration: _resolveDuration(r),
              waveForm: _resolveWaveform(r),
            ),
          )
          .toList(),
      attachmentBorderRadiusGeometry: BorderRadius.circular(16),
      constraints: const BoxConstraints.tightFor(width: 400),
    );
  }
}
