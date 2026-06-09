import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_controller.dart';

import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Signature for decorating each voice recording item in a playlist.
///
/// The [child] is the default [StreamVoiceRecordingAttachment] widget built
/// by the playlist. Return a widget that wraps [child] with the desired
/// container.
///
/// See also:
///
///  * [StreamVoiceRecordingAttachmentPlaylist.itemDecorator], which uses this
///    typedef.
typedef StreamVoiceRecordingItemDecorator = Widget Function(BuildContext context, int index, Widget child);

/// A playlist container for multiple voice recording attachments.
///
/// [StreamVoiceRecordingAttachmentPlaylist] manages audio playback across
/// multiple voice recordings using a shared controller, ensuring only one
/// recording plays at a time.
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamVoiceRecordingAttachmentPlaylist(
///   message: message,
///   voiceRecordings: voiceRecordingAttachments,
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// With a decorator to wrap each item in a message attachment container:
///
/// ```dart
/// StreamVoiceRecordingAttachmentPlaylist(
///   message: message,
///   voiceRecordings: voiceRecordingAttachments,
///   itemDecorator: (context, index, child) {
///     return StreamMessageAttachment(style: style, child: child);
///   },
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamVoiceRecordingAttachment], the individual voice recording widget
///    used for each item in the playlist.
class StreamVoiceRecordingAttachmentPlaylist extends StatefulWidget {
  /// Creates a [StreamVoiceRecordingAttachmentPlaylist].
  const StreamVoiceRecordingAttachmentPlaylist({
    super.key,
    required this.message,
    required this.voiceRecordings,
    this.padding,
    this.itemBuilder,
    this.itemDecorator,
    this.separatorBuilder = _defaultVoiceRecordingPlaylistSeparatorBuilder,
    this.constraints,
    this.voiceRecordingTitle,
  });

  /// The [Message] that the voice recordings are attached to.
  final Message message;

  /// The list of [Attachment] objects containing the voice recording
  /// information.
  final List<Attachment> voiceRecordings;

  /// The constraints to use when displaying each voice recording.
  final BoxConstraints? constraints;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// The builder to use for each voice recording.
  ///
  /// If not provided, a default implementation using
  /// [StreamVoiceRecordingAttachment] will be used.
  ///
  /// When provided, [itemDecorator] is ignored since the builder has full
  /// control over the item widget.
  final IndexedWidgetBuilder? itemBuilder;

  /// Optional decorator that wraps each default voice recording item.
  ///
  /// Use this to provide context-specific containers around each
  /// [StreamVoiceRecordingAttachment] without replacing the default
  /// item building logic.
  ///
  /// Ignored when [itemBuilder] is provided.
  final StreamVoiceRecordingItemDecorator? itemDecorator;

  /// The separator to use between the voice recordings.
  final IndexedWidgetBuilder separatorBuilder;

  /// The title to use for each voice recording.
  final String? voiceRecordingTitle;

  // Default separator builder for the voice recording playlist.
  static Widget _defaultVoiceRecordingPlaylistSeparatorBuilder(
    BuildContext context,
    int index,
  ) {
    final spacing = context.streamSpacing;
    return SizedBox(height: spacing.xxs);
  }

  @override
  State<StreamVoiceRecordingAttachmentPlaylist> createState() => _StreamVoiceRecordingAttachmentPlaylistState();
}

class _StreamVoiceRecordingAttachmentPlaylistState extends State<StreamVoiceRecordingAttachmentPlaylist>
    with WidgetsBindingObserver {
  late final _controller = StreamAudioPlaylistController(
    widget.voiceRecordings.toPlaylist(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause playback when the app goes to background or is detached.
    final isBackground = ![AppLifecycleState.resumed, AppLifecycleState.inactive].contains(state);
    if (isBackground) _controller.pause();
  }

  @override
  void didUpdateWidget(
    covariant StreamVoiceRecordingAttachmentPlaylist oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    final newPlaylist = widget.voiceRecordings.toPlaylist();
    final oldPlaylist = oldWidget.voiceRecordings.toPlaylist();
    if (!const ListEquality().equals(newPlaylist, oldPlaylist)) {
      // If the playlist have changed, update the playlist.
      _controller.updatePlaylist(newPlaylist);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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

              final child = StreamVoiceRecordingAttachment(
                track: track,
                speed: state.speed,
                showTitle: false,
                title: widget.voiceRecordingTitle,
                constraints: widget.constraints ?? const BoxConstraints(),
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
                onTrackSeekChanged: (progress) async {
                  if (state.currentIndex != index) return;

                  final duration = track.duration.inMicroseconds;
                  final seekPosition = (duration * progress).toInt();
                  final seekDuration = Duration(microseconds: seekPosition);

                  await _controller.seek(seekDuration);
                },
              );

              if (widget.itemDecorator case final decorator?) {
                return decorator(context, index, child);
              }

              return child;
            },
          ),
        );
      },
    );
  }
}
