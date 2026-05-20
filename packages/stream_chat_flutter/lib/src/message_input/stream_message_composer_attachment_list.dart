import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';
// The local [StreamMessageComposerAttachment] (chat-domain wrapper) shadows
// the same-named container from `stream_core_flutter`; this prefixed import
// lets us reach the container by its core name without renaming either side.
import 'package:stream_core_flutter/stream_core_flutter.dart' as core show StreamMessageComposerAttachment;

part 'stream_message_composer_attachment.dart';

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
class StreamMessageComposerAttachmentList extends StatelessWidget {
  /// {@macro stream_message_input_attachment_list}
  StreamMessageComposerAttachmentList({
    super.key,
    required Iterable<Attachment> attachments,
    ValueSetter<Attachment>? onRemovePressed,
  }) : props = StreamMessageComposerAttachmentListProps(attachments: attachments, onRemovePressed: onRemovePressed);

  /// List of attachments to display thumbnails for.
  ///
  /// Open graph should be filtered out.
  final StreamMessageComposerAttachmentListProps props;

  @override
  Widget build(BuildContext context) {
    return context.chatComponentBuilder<StreamMessageComposerAttachmentListProps>()?.call(context, props) ??
        DefaultMessageComposerAttachmentList(props: props);
  }
}

/// Properties for [StreamMessageComposerAttachmentList].
class StreamMessageComposerAttachmentListProps {
  /// Creates a new instance of [StreamMessageComposerAttachmentListProps].
  const StreamMessageComposerAttachmentListProps({
    required this.attachments,
    this.onRemovePressed,
  });

  /// List of attachments to display thumbnails for.
  ///
  /// Open graph should be filtered out.
  final Iterable<Attachment> attachments;

  /// Callback called when the remove button is pressed.
  final ValueSetter<Attachment>? onRemovePressed;
}

/// Default implementation of [StreamMessageComposerAttachmentList].
class DefaultMessageComposerAttachmentList extends StatefulWidget {
  /// {@macro stream_message_composer_attachment_list}
  const DefaultMessageComposerAttachmentList({
    super.key,
    required this.props,
  });

  /// Properties for the [DefaultMessageComposerAttachmentList].
  final StreamMessageComposerAttachmentListProps props;

  /// List of attachments to display thumbnails for.
  ///
  /// Open graph should be filtered out.
  Iterable<Attachment> get attachments => props.attachments;

  /// Callback called when the remove button is pressed.
  ValueSetter<Attachment>? get onRemovePressed => props.onRemovePressed;

  List<Attachment> get _audioAttachments =>
      attachments.where((it) => it.type == AttachmentType.audio || it.type == AttachmentType.voiceRecording).toList();

  @override
  State<DefaultMessageComposerAttachmentList> createState() => _DefaultMessageComposerAttachmentListState();
}

class _DefaultMessageComposerAttachmentListState extends State<DefaultMessageComposerAttachmentList> {
  late List<Attachment> _audioAttachments = widget._audioAttachments;

  StreamAudioPlaylistController? _controller;
  late final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _updateController();
  }

  @override
  void didUpdateWidget(
    covariant DefaultMessageComposerAttachmentList oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    final equals = const ListEquality().equals;
    final newAudioAttachments = widget._audioAttachments;
    if (!equals(newAudioAttachments, _audioAttachments)) {
      // If the attachments have changed, update the playlist.
      _audioAttachments = newAudioAttachments;
      _updateController();
    }
    if (oldWidget.attachments.length < widget.attachments.length) {
      // If an attachment has been added, scroll to the end.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (!_scrollController.hasClients) return;
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        },
      );
    }
  }

  void _updateController() {
    if (_audioAttachments.isNotEmpty) {
      if (_controller == null) {
        _controller = StreamAudioPlaylistController(_audioAttachments.toPlaylist());
        _controller!.initialize();
      } else {
        _controller!.updatePlaylist(_audioAttachments.toPlaylist());
      }
    } else if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attachmentsList = widget.attachments.toList();

    return MessageInputMediaAttachments(
      scrollController: _scrollController,
      attachments: attachmentsList,
      audioPlaylistController: _controller,
      onRemovePressed: widget.onRemovePressed,
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
    this.onRemovePressed,
    this.scrollController,
  });

  /// List of media type attachments to display thumbnails for.
  ///
  /// Only attachments of type `image`, `video` and `giphy` are supported. Shows
  /// a placeholder for other types of attachments.
  final List<Attachment> attachments;

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
        // ignore: deprecated_member_use
        cacheExtent: 104 * 10, // Cache 10 items ahead.
        children: attachments
            .map<Widget>(
              (attachment) => StreamMessageComposerAttachment(
                attachment: attachment,
                onRemovePressed: onRemovePressed,
                audioPlaylistController: audioPlaylistController,
              ),
            )
            .toList(),
      ),
    );
  }
}
