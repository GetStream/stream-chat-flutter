import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_controller.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';

import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamVoiceRecordingAttachmentPlaylist}
/// Shows a voice recording attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamVoiceRecordingAttachmentPlaylist extends StatefulWidget {
  /// {@macro streamVoiceRecordingAttachmentPlaylist}
  const StreamVoiceRecordingAttachmentPlaylist({
    super.key,
    this.shape,
    required this.message,
    required this.voiceRecordings,
    this.padding,
    this.itemBuilder,
    this.separatorBuilder = _defaultVoiceRecordingPlaylistSeparatorBuilder,
    this.constraints = const BoxConstraints(),
  });

  /// The shape of the attachment.
  ///
  /// Defaults to [RoundedRectangleBorder] with a radius of 14.
  final ShapeBorder? shape;

  /// The [Message] that the voice recording is attached to.
  final Message message;

  /// The list of [Attachment] object containing the voice recording
  /// information.
  final List<Attachment> voiceRecordings;

  /// The constraints to use when displaying the voice recording.
  final BoxConstraints constraints;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// The builder to use for each voice recording.
  ///
  /// If not provided, a default implementation will be used.
  final IndexedWidgetBuilder? itemBuilder;

  /// The separator to use between the voice recordings.
  final IndexedWidgetBuilder separatorBuilder;

  // Default separator builder for the voice recording playlist.
  static Widget _defaultVoiceRecordingPlaylistSeparatorBuilder(
    BuildContext context,
    int index,
  ) {
    return const Empty();
  }

  @override
  State<StreamVoiceRecordingAttachmentPlaylist> createState() =>
      _StreamVoiceRecordingAttachmentPlaylistState();
}

class _StreamVoiceRecordingAttachmentPlaylistState
    extends State<StreamVoiceRecordingAttachmentPlaylist> {
  late final _controller = StreamAudioPlaylistController(
    widget.voiceRecordings.toPlaylist(),
  );

  @override
  void initState() {
    super.initState();
    _controller.initialize();
  }

  @override
  void didUpdateWidget(
    covariant StreamVoiceRecordingAttachmentPlaylist oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    final equals = const ListEquality().equals;
    if (!equals(widget.voiceRecordings, oldWidget.voiceRecordings)) {
      // If the playlist have changed, update the playlist.
      _controller.updatePlaylist(widget.voiceRecordings.toPlaylist());
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
            padding: widget.padding,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.tracks.length,
            separatorBuilder: widget.separatorBuilder,
            itemBuilder: (context, index) {
              if (widget.itemBuilder case final builder?) {
                return builder(context, index);
              }

              final track = state.tracks[index];
              return StreamVoiceRecordingAttachment(
                track: track,
                speed: state.speed,
                showTitle: true,
                shape: widget.shape,
                constraints: widget.constraints,
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
