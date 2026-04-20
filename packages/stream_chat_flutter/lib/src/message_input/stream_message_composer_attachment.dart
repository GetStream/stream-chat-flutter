part of 'stream_message_composer_attachment_list.dart';

/// A widget that renders a single attachment in the message composer.
///
/// Delegates rendering to a custom builder registered via
/// [StreamChatComponentBuilder], or falls back to
/// [DefaultMessageComposerAttachment].
class StreamMessageComposerAttachment extends StatelessWidget {
  /// Creates a [StreamMessageComposerAttachment].
  StreamMessageComposerAttachment({
    super.key,
    required Attachment attachment,
    ValueSetter<Attachment>? onRemovePressed,
    StreamAudioPlaylistController? audioPlaylistController,
  }) : props = StreamMessageComposerAttachmentProps(
         attachment: attachment,
         onRemovePressed: onRemovePressed,
         audioPlaylistController: audioPlaylistController,
       );

  /// The properties for the message composer attachment.
  final StreamMessageComposerAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    return context.chatComponentBuilder<StreamMessageComposerAttachmentProps>()?.call(context, props) ??
        DefaultMessageComposerAttachment(props: props);
  }
}

/// Properties passed to [StreamMessageComposerAttachment] and its default
/// implementation [DefaultMessageComposerAttachment].
class StreamMessageComposerAttachmentProps {
  /// Creates a [StreamMessageComposerAttachmentProps].
  const StreamMessageComposerAttachmentProps({
    required this.attachment,
    required this.onRemovePressed,
    required this.audioPlaylistController,
  });

  /// The attachment to display.
  final Attachment attachment;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  /// Controller used for audio/voice-recording attachment playback.
  final StreamAudioPlaylistController? audioPlaylistController;
}

/// Default implementation of a message composer attachment widget.
///
/// Renders file, audio/voice-recording, or media attachments depending on the
/// attachment type.
class DefaultMessageComposerAttachment extends StatelessWidget {
  /// Creates a [DefaultMessageComposerAttachment].
  const DefaultMessageComposerAttachment({super.key, required this.props});

  /// The properties used to render this attachment.
  final StreamMessageComposerAttachmentProps props;

  /// The attachment to display.
  Attachment get attachment => props.attachment;

  /// Callback called when the remove button is pressed.
  ValueSetter<Attachment>? get onRemovePressed => props.onRemovePressed;

  /// Controller used for audio/voice-recording attachment playback.
  StreamAudioPlaylistController? get audioPlaylistController => props.audioPlaylistController;

  @override
  Widget build(BuildContext context) {
    if (attachment.type == AttachmentType.file) {
      return SizedBox(
        width: 268,
        child: MessageComposerFileAttachment(
          title: Text(attachment.title ?? context.translations.fileText),
          subtitle: Text(fileSize(attachment.file?.size ?? attachment.extraData['file_size'])),
          fileTypeIcon: .fromMimeType(mimeType: attachment.file?.mediaType?.mimeType),
          onRemovePressed: onRemovePressed != null ? () => onRemovePressed!(attachment) : null,
        ),
      );
    }

    if (attachment.type == AttachmentType.audio || attachment.type == AttachmentType.voiceRecording) {
      if (audioPlaylistController == null) {
        return const SizedBox.shrink();
      }

      final hasTrack = audioPlaylistController!.value.tracks.any((it) => it.key == attachment);

      if (!hasTrack) {
        return const SizedBox.shrink();
      }

      final trackIndex = audioPlaylistController!.value.tracks.indexWhere((it) => it.key == attachment);

      return SizedBox(
        width: 268,
        child: MessageInputVoiceRecordingAttachment(
          attachment: attachment,
          index: trackIndex,
          controller: audioPlaylistController!,
          onRemovePressed: onRemovePressed,
        ),
      );
    }

    return StreamMediaAttachmentBuilder(
      attachment: attachment,
      onRemovePressed: onRemovePressed,
    );
  }
}

/// Widget used to display the list of voice recording type attachments added to
/// the message input.
class MessageInputVoiceRecordingAttachment extends StatelessWidget {
  /// Creates a new MessageInputVoiceRecordingAttachments widget.
  const MessageInputVoiceRecordingAttachment({
    super.key,
    required this.attachment,
    required this.index,
    required this.controller,
    this.onRemovePressed,
  });

  /// Attachment to display.
  final Attachment attachment;

  /// Index of the track in the playlist.
  final int index;

  /// Controller to use to control the audio playback.
  final StreamAudioPlaylistController controller;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, _) {
        final track = state.tracks.firstWhereOrNull((it) => it.key == attachment);
        if (track == null) return const SizedBox.shrink();

        return StreamMessageComposerAttachmentContainer(
          onRemovePressed: switch (onRemovePressed) {
            final callback? => () => callback(attachment),
            _ => null,
          },
          child: StreamVoiceRecordingAttachment(
            title: 'Voice Message',
            showTitle: true,
            track: track,
            speed: state.speed,
            onTrackPause: controller.pause,
            onChangeSpeed: controller.setSpeed,
            onTrackPlay: () async {
              // Play the track directly if it is already loaded.
              if (state.currentIndex == index) return controller.play();
              // Otherwise, load the track first and then play it.
              return controller.skipToItem(index);
            },
            // Only allow seeking if the current track is the one being
            // interacted with.
            onTrackSeekStart: (_) async {
              if (state.currentIndex != index) return;
              return controller.pause();
            },
            onTrackSeekEnd: (_) async {
              if (state.currentIndex != index) return;
              return controller.play();
            },
            onTrackSeekChanged: (progress) async {
              if (state.currentIndex != index) return;

              final duration = track.duration.inMicroseconds;
              final seekPosition = (duration * progress).toInt();
              final seekDuration = Duration(microseconds: seekPosition);

              return controller.seek(seekDuration);
            },
          ),
        );
      },
    );
  }
}

/// Widget used to display a media type attachment item.
class StreamMediaAttachmentBuilder extends StatelessWidget {
  /// Creates a new media attachment item.
  const StreamMediaAttachmentBuilder({super.key, required this.attachment, this.onRemovePressed});

  /// The media attachment to display.
  final Attachment attachment;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  @override
  Widget build(BuildContext context) {
    final durationSecs = attachment.extraData['duration'] as num?;
    final videoDuration = durationSecs != null ? Duration(seconds: durationSecs.round()) : null;

    final mediaBadge = attachment.type == AttachmentType.video
        ? StreamMediaBadge(type: MediaBadgeType.video, duration: videoDuration)
        : null;

    return Container(
      key: Key(attachment.id),
      child: MessageComposerMediaFileAttachment(
        mediaBadge: mediaBadge,
        onRemovePressed: onRemovePressed != null ? () => onRemovePressed!(attachment) : null,
        child: StreamMediaAttachmentThumbnail(
          media: attachment,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
