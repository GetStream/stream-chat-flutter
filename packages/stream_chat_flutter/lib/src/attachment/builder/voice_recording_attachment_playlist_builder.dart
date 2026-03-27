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
    this.style,
    this.constraints,
    this.onAttachmentTap,
  });

  /// The style of the voice recording attachment container.
  ///
  /// When null, a default style with a rounded rectangle shape and border
  /// is used.
  final StreamMessageAttachmentStyle? style;

  /// The constraints to apply to the video attachment widget.
  final BoxConstraints? constraints;

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
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final playlist = attachments[AttachmentType.voiceRecording]!;

    return StreamVoiceRecordingAttachmentTheme(
      data: _StreamVoiceRecordingAttachmentDefaults(context),
      child: StreamVoiceRecordingAttachmentPlaylist(
        message: message,
        voiceRecordings: playlist,
        constraints: constraints,
        itemDecorator: (context, index, child) {
          return StreamMessageAttachment(style: style, child: child);
        },
      ),
    );
  }
}

// Default values for [StreamVoiceRecordingAttachmentThemeData] backed by stream design tokens.
class _StreamVoiceRecordingAttachmentDefaults extends StreamVoiceRecordingAttachmentThemeData {
  _StreamVoiceRecordingAttachmentDefaults(this._context);

  final BuildContext _context;

  late final _alignment = StreamMessageLayout.messageAlignmentOf(_context);
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  Color get _borderColor => switch (_alignment) {
    .start => _colorScheme.borderStrong,
    .end => _colorScheme.brand.shade300,
  };

  @override
  StreamButtonThemeStyle get controlButtonStyle => .from(borderColor: _borderColor);

  @override
  StreamPlaybackSpeedToggleStyle get speedToggleStyle => .from(borderColor: _borderColor);
}
