import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/media_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/voice_recording_attachment.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_controller.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/indicators/upload_progress_indicator.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// WidgetBuilder used to build the message input attachment list.
///
/// see more:
///   - [StreamMessageInputAttachmentList]
typedef AttachmentListBuilder =
    Widget Function(
      BuildContext context,
      List<Attachment> attachments,
      ValueSetter<Attachment>? onRemovePressed,
    );

/// WidgetBuilder used to build the message input attachment item.
///
/// see more:
///  - [StreamMessageInputAttachmentList]
typedef AttachmentItemBuilder =
    Widget Function(
      BuildContext context,
      Attachment attachment,
      ValueSetter<Attachment>? onRemovePressed,
    );

/// {@template stream_message_input_attachment_list}
/// Widget used to display the list of attachments added to the message input.
///
/// By default, it displays the list of file attachments and media attachments
/// separately.
///
/// You can customize the list of file attachments and media attachments using
/// [fileAttachmentListBuilder] and [attachmentListBuilder] respectively.
///
/// You can also customize the attachment item using [fileAttachmentBuilder] and
/// [mediaAttachmentBuilder] respectively.
///
/// You can override the default action of removing an attachment by providing
/// [onRemovePressed].
/// {@endtemplate}
class StreamMessageInputAttachmentList extends StatefulWidget {
  /// {@macro stream_message_input_attachment_list}
  const StreamMessageInputAttachmentList({
    super.key,
    required this.attachments,
    this.onRemovePressed,
    this.fileAttachmentBuilder,
    this.mediaAttachmentBuilder,
    this.voiceRecordingAttachmentBuilder,
    this.attachmentListBuilder,
  });

  /// List of attachments to display thumbnails for.
  ///
  /// Open graph should be filtered out.
  final Iterable<Attachment> attachments;

  /// Builder used to build the file attachment item.
  final AttachmentItemBuilder? fileAttachmentBuilder;

  /// Builder used to build the media attachment item.
  final AttachmentItemBuilder? mediaAttachmentBuilder;

  /// Builder used to build the voice recording attachment item.
  final AttachmentItemBuilder? voiceRecordingAttachmentBuilder;

  /// Builder used to build the media attachment list.
  final AttachmentListBuilder? attachmentListBuilder;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  List<Attachment> get _audioAttachments =>
      attachments.where((it) => it.type == AttachmentType.audio || it.type == AttachmentType.voiceRecording).toList();

  @override
  State<StreamMessageInputAttachmentList> createState() => _StreamMessageInputAttachmentListState();
}

class _StreamMessageInputAttachmentListState extends State<StreamMessageInputAttachmentList> {
  late List<Attachment> _audioAttachments = widget._audioAttachments;

  late final _controller = StreamAudioPlaylistController(_audioAttachments.toPlaylist());
  late final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.initialize();
  }

  @override
  void didUpdateWidget(
    covariant StreamMessageInputAttachmentList oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    final equals = const ListEquality().equals;
    final newAudioAttachments = widget._audioAttachments;
    if (!equals(newAudioAttachments, _audioAttachments)) {
      // If the attachments have changed, update the playlist.
      _audioAttachments = newAudioAttachments;
      _controller.updatePlaylist(newAudioAttachments.toPlaylist());
    }
    if (oldWidget.attachments.length < widget.attachments.length) {
      // If an attachment has been added, scroll to the end.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attachmentsList = widget.attachments.toList();

    return switch (widget.attachmentListBuilder) {
      final builder? => builder(context, attachmentsList, widget.onRemovePressed),
      _ => MessageInputMediaAttachments(
        scrollController: _scrollController,
        attachments: attachmentsList,
        attachmentBuilder: widget.mediaAttachmentBuilder,
        audioPlaylistController: _controller,
        voiceRecordingAttachmentBuilder: widget.voiceRecordingAttachmentBuilder,
        fileAttachmentBuilder: widget.fileAttachmentBuilder,
        onRemovePressed: widget.onRemovePressed,
      ),
    };
  }
}

/// Widget used to display the list of file type attachments added to the
/// message input.
class MessageInputFileAttachments extends StatelessWidget {
  /// Creates a new FileAttachments widget.
  const MessageInputFileAttachments({
    super.key,
    required this.attachments,
    this.attachmentBuilder,
    this.onRemovePressed,
  });

  /// List of file type attachments to display thumbnails for.
  final List<Attachment> attachments;

  /// Builder used to build the file type attachment item.
  final AttachmentItemBuilder? attachmentBuilder;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: attachments.reversed
          .map<Widget>(
            (attachment) {
              // If a custom builder is provided, use it.
              final builder = attachmentBuilder;
              if (builder != null) {
                return builder(context, attachment, onRemovePressed);
              }

              return MessageComposerAttachmentFile(
                fileTypeIcon: StreamFileTypeIcon.fromMimeType(mimeType: attachment.file?.mediaType?.mimeType ?? ''),
                title: attachment.title ?? context.translations.fileText,
                subtitle: _FileAttachmentSubtitle(attachment: attachment),
                onRemovePressed: onRemovePressed != null ? () => onRemovePressed!(attachment) : null,
              );
            },
          )
          .insertBetween(const SizedBox(height: 8)),
    );
  }
}

class _FileAttachmentSubtitle extends StatelessWidget {
  const _FileAttachmentSubtitle({
    required this.attachment,
  });

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final size = attachment.file?.size ?? attachment.extraData['file_size'];
    final textStyle = theme.textTheme.footnote.copyWith(
      color: theme.colorTheme.textLowEmphasis,
    );
    return attachment.uploadState.when(
      preparing: () => Text(fileSize(size), style: textStyle),
      inProgress: (sent, total) => StreamUploadProgressIndicator(
        uploaded: sent,
        total: total,
        showBackground: false,
        textStyle: textStyle,
        progressIndicatorColor: theme.colorTheme.accentPrimary,
      ),
      success: () => Text(fileSize(size), style: textStyle),
      failed: (_) => Text(
        context.translations.uploadErrorLabel,
        style: textStyle,
      ),
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
        final track = state.tracks.where((it) => it.key == attachment).first;

        return StreamVoiceRecordingAttachment(
          track: track,
          speed: state.speed,
          trailingBuilder: (_, __, ___, ____) {
            return RemoveAttachmentButton(
              onPressed: switch (onRemovePressed) {
                final callback? => () => callback(attachment),
                _ => null,
              },
            );
          },
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
        );
      },
    );
  }
}

/// Widget used to display the list of media type attachments added to the
/// message input.
class MessageInputMediaAttachments extends StatelessWidget {
  /// Creates a new MediaAttachments widget.
  const MessageInputMediaAttachments({
    super.key,
    required this.attachments,
    this.audioPlaylistController,
    this.attachmentBuilder,
    this.voiceRecordingAttachmentBuilder,
    this.fileAttachmentBuilder,
    this.onRemovePressed,
    this.scrollController,
  });

  /// List of media type attachments to display thumbnails for.
  ///
  /// Only attachments of type `image`, `video` and `giphy` are supported. Shows
  /// a placeholder for other types of attachments.
  final List<Attachment> attachments;

  /// Builder used to build the media type attachment item.
  final AttachmentItemBuilder? attachmentBuilder;

  /// Builder used to build the voice recording type attachment item.
  final AttachmentItemBuilder? voiceRecordingAttachmentBuilder;

  /// Builder used to build the file type attachment item.
  final AttachmentItemBuilder? fileAttachmentBuilder;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  /// Controller to use to control the audio playback.
  final StreamAudioPlaylistController? audioPlaylistController;

  /// Scroll controller to use to control the scroll position.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.streamSpacing.xs),
        cacheExtent: 104 * 10, // Cache 10 items ahead.
        children: attachments.map<Widget>(
          (attachment) {
            if (attachment.type == AttachmentType.file) {
              // If a custom builder is provided, use it.
              if (fileAttachmentBuilder case final builder?) {
                return builder(context, attachment, onRemovePressed);
              }

              return SizedBox(
                width: 268,
                child: MessageComposerAttachmentFile(
                  fileTypeIcon: StreamFileTypeIcon.fromMimeType(mimeType: attachment.file?.mediaType?.mimeType ?? ''),
                  title: attachment.title ?? context.translations.fileText,
                  subtitle: _FileAttachmentSubtitle(attachment: attachment),
                  onRemovePressed: onRemovePressed != null ? () => onRemovePressed!(attachment) : null,
                ),
              );
            }

            if (attachment.type == AttachmentType.audio || attachment.type == AttachmentType.voiceRecording) {
              // If a custom builder is provided, use it.
              if (voiceRecordingAttachmentBuilder case final builder?) {
                return builder(context, attachment, onRemovePressed);
              }

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

            // If a custom builder is provided, use it.
            if (attachmentBuilder case final builder?) {
              return builder(context, attachment, onRemovePressed);
            }

            return StreamMediaAttachmentBuilder(
              attachment: attachment,
              onRemovePressed: onRemovePressed,
            );
          },
        ).toList(),
      ),
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
    final mediaBadge = attachment.type == AttachmentType.video
        ? const StreamMediaBadge(type: MediaBadgeType.video)
        : null;

    return Container(
      key: Key(attachment.id),
      child: MessageComposerAttachmentMediaFile(
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

/// Material Button used for removing attachments.
class RemoveAttachmentButton extends StatelessWidget {
  /// Creates a new remove attachment button.
  const RemoveAttachmentButton({super.key, this.onPressed});

  /// Callback when the remove attachment button is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    return IconButton.filled(
      onPressed: onPressed,
      color: colorTheme.barsBg,
      padding: EdgeInsets.zero,
      icon: const StreamSvgIcon(icon: StreamSvgIcons.close),
      style: IconButton.styleFrom(
        minimumSize: const Size(24, 24),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // ignore: deprecated_member_use
        backgroundColor: colorTheme.textHighEmphasis.withOpacity(0.6),
      ),
    );
  }
}
