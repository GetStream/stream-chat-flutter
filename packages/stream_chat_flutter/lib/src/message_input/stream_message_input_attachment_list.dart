import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/file_attachment.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/media_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/voice_recording_attachment.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_controller.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// WidgetBuilder used to build the message input attachment list.
///
/// see more:
///   - [StreamMessageInputAttachmentList]
typedef AttachmentListBuilder = Widget Function(
  BuildContext context,
  List<Attachment> attachments,
  ValueSetter<Attachment>? onRemovePressed,
);

/// WidgetBuilder used to build the message input attachment item.
///
/// see more:
///  - [StreamMessageInputAttachmentList]
typedef AttachmentItemBuilder = Widget Function(
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
/// [fileAttachmentListBuilder] and [mediaAttachmentListBuilder] respectively.
///
/// You can also customize the attachment item using [fileAttachmentBuilder] and
/// [mediaAttachmentBuilder] respectively.
///
/// You can override the default action of removing an attachment by providing
/// [onRemovePressed].
/// {@endtemplate}
class StreamMessageInputAttachmentList extends StatelessWidget {
  /// {@macro stream_message_input_attachment_list}
  const StreamMessageInputAttachmentList({
    super.key,
    required this.attachments,
    this.onRemovePressed,
    this.fileAttachmentBuilder,
    this.mediaAttachmentBuilder,
    this.voiceRecordingAttachmentBuilder,
    this.fileAttachmentListBuilder,
    this.mediaAttachmentListBuilder,
    this.voiceRecordingAttachmentListBuilder,
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

  /// Builder used to build the file attachment list.
  final AttachmentListBuilder? fileAttachmentListBuilder;

  /// Builder used to build the media attachment list.
  final AttachmentListBuilder? mediaAttachmentListBuilder;

  /// Builder used to build the voice recording attachment list.
  final AttachmentListBuilder? voiceRecordingAttachmentListBuilder;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  @override
  Widget build(BuildContext context) {
    final groupedAttachments = attachments.groupListsBy((it) => it.type);
    final (:files, :media, :voices) = (
      files: [...?groupedAttachments[AttachmentType.file]],
      voices: [...?groupedAttachments[AttachmentType.voiceRecording]],
      media: [
        ...?groupedAttachments[AttachmentType.image],
        ...?groupedAttachments[AttachmentType.video],
        ...?groupedAttachments[AttachmentType.giphy],
        ...?groupedAttachments[AttachmentType.audio],
      ],
    );

    // If there are no attachments, return an empty widget.
    if (files.isEmpty && media.isEmpty && voices.isEmpty) {
      return const Empty();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (media.isNotEmpty)
            Flexible(
              child: switch (mediaAttachmentListBuilder) {
                final builder? => builder(context, media, onRemovePressed),
                _ => MessageInputMediaAttachments(
                    attachments: media,
                    attachmentBuilder: mediaAttachmentBuilder,
                    onRemovePressed: onRemovePressed,
                  ),
              },
            ),
          if (voices.isNotEmpty)
            Flexible(
              child: switch (voiceRecordingAttachmentListBuilder) {
                final builder? => builder(context, voices, onRemovePressed),
                _ => MessageInputVoiceRecordingAttachments(
                    attachments: voices,
                    attachmentBuilder: voiceRecordingAttachmentBuilder,
                    onRemovePressed: onRemovePressed,
                  ),
              },
            ),
          if (files.isNotEmpty)
            Flexible(
              child: switch (fileAttachmentListBuilder) {
                final builder? => builder(context, files, onRemovePressed),
                _ => MessageInputFileAttachments(
                    attachments: files,
                    attachmentBuilder: fileAttachmentBuilder,
                    onRemovePressed: onRemovePressed,
                  ),
              },
            ),
        ].insertBetween(
          Divider(
            height: 16,
            indent: 16,
            endIndent: 16,
            thickness: 1,
            color: StreamChatTheme.of(context).colorTheme.disabled,
          ),
        ),
      ),
    );
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
      children: attachments.reversed.map<Widget>(
        (attachment) {
          // If a custom builder is provided, use it.
          final builder = attachmentBuilder;
          if (builder != null) {
            return builder(context, attachment, onRemovePressed);
          }

          // Otherwise, use the default builder.
          return StreamFileAttachment(
            message: Message(), // Dummy message
            file: attachment,
            constraints: BoxConstraints.loose(Size(
              MediaQuery.of(context).size.width * 0.65,
              56,
            )),
            trailing: Padding(
              padding: const EdgeInsets.all(8),
              child: RemoveAttachmentButton(
                onPressed: onRemovePressed != null
                    ? () => onRemovePressed!(attachment)
                    : null,
              ),
            ),
          );
        },
      ).insertBetween(const SizedBox(height: 8)),
    );
  }
}

/// Widget used to display the list of voice recording type attachments added to
/// the message input.
class MessageInputVoiceRecordingAttachments extends StatefulWidget {
  /// Creates a new MessageInputVoiceRecordingAttachments widget.
  const MessageInputVoiceRecordingAttachments({
    super.key,
    required this.attachments,
    this.attachmentBuilder,
    this.onRemovePressed,
  });

  /// List of voice recording type attachments to display thumbnails for.
  ///
  /// Only attachments of type [AttachmentType.voiceRecording] are supported.
  final List<Attachment> attachments;

  /// Builder used to build the voice recording type attachment item.
  final AttachmentItemBuilder? attachmentBuilder;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  @override
  State<MessageInputVoiceRecordingAttachments> createState() =>
      _MessageInputVoiceRecordingAttachmentsState();
}

class _MessageInputVoiceRecordingAttachmentsState
    extends State<MessageInputVoiceRecordingAttachments> {
  late final _controller = StreamAudioPlaylistController(
    widget.attachments.toPlaylist(),
  );

  @override
  void initState() {
    super.initState();
    _controller.initialize();
  }

  @override
  void didUpdateWidget(
    covariant MessageInputVoiceRecordingAttachments oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    final equals = const ListEquality().equals;
    if (!equals(widget.attachments, oldWidget.attachments)) {
      // If the attachments have changed, update the playlist.
      _controller.updatePlaylist(widget.attachments.toPlaylist());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, state, _) {
        return MediaQuery.removePadding(
          context: context,
          // Workaround for the bottom padding issue.
          // Link: https://github.com/flutter/flutter/issues/156149
          removeTop: true,
          removeBottom: true,
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.tracks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final track = state.tracks[index];

              return StreamVoiceRecordingAttachment(
                track: track,
                speed: state.speed,
                trailingBuilder: (_, __, ___, ____) {
                  final attachment = widget.attachments[index];
                  return RemoveAttachmentButton(
                    onPressed: switch (widget.onRemovePressed) {
                      final callback? => () => callback(attachment),
                      _ => null,
                    },
                  );
                },
                onTrackPause: _controller.pause,
                onChangeSpeed: _controller.setSpeed,
                onTrackPlay: () async {
                  // Play the track directly if it is already loaded.
                  if (state.currentIndex == index) return _controller.play();
                  // Otherwise, load the track first and then play it.
                  return _controller.skipToItem(index);
                },
                // Only allow seeking if the current track is the one being
                // interacted with.
                onTrackSeekStart: (_) async {
                  if (state.currentIndex != index) return;
                  return _controller.pause();
                },
                onTrackSeekEnd: (_) async {
                  if (state.currentIndex != index) return;
                  return _controller.play();
                },
                onTrackSeekChanged: (progress) async {
                  if (state.currentIndex != index) return;

                  final duration = track.duration.inMicroseconds;
                  final seekPosition = (duration * progress).toInt();
                  final seekDuration = Duration(microseconds: seekPosition);

                  return _controller.seek(seekDuration);
                },
              );
            },
          ),
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
    this.attachmentBuilder,
    this.onRemovePressed,
  });

  /// List of media type attachments to display thumbnails for.
  ///
  /// Only attachments of type `image`, `video` and `giphy` are supported. Shows
  /// a placeholder for other types of attachments.
  final List<Attachment> attachments;

  /// Builder used to build the media type attachment item.
  final AttachmentItemBuilder? attachmentBuilder;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        cacheExtent: 104 * 10, // Cache 10 items ahead.
        children: attachments.map<Widget>(
          (attachment) {
            // If a custom builder is provided, use it.
            final builder = attachmentBuilder;
            if (builder != null) {
              return builder(context, attachment, onRemovePressed);
            }

            return StreamMediaAttachmentBuilder(
              attachment: attachment,
              onRemovePressed: onRemovePressed,
            );
          },
        ).insertBetween(const SizedBox(width: 8)),
      ),
    );
  }
}

/// Widget used to display a media type attachment item.
class StreamMediaAttachmentBuilder extends StatelessWidget {
  /// Creates a new media attachment item.
  const StreamMediaAttachmentBuilder(
      {super.key, required this.attachment, this.onRemovePressed});

  /// The media attachment to display.
  final Attachment attachment;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    final shape = RoundedRectangleBorder(
      side: BorderSide(
        color: colorTheme.borders,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: BorderRadius.circular(14),
    );

    return Container(
      key: Key(attachment.id),
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(shape: shape),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            StreamMediaAttachmentThumbnail(
              media: attachment,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            if (attachment.type == AttachmentType.video)
              const Positioned(
                left: 8,
                bottom: 8,
                child: StreamSvgIcon(icon: StreamSvgIcons.videoCall),
              ),
            Positioned(
              top: 8,
              right: 8,
              child: RemoveAttachmentButton(
                onPressed: onRemovePressed != null
                    ? () => onRemovePressed!(attachment)
                    : null,
              ),
            ),
          ],
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
