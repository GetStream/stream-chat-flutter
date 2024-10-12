import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/src/message_input/voice_notes/audio_loading_message.dart';
import 'package:stream_chat_flutter/src/message_input/voice_notes/audio_player_message.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class AudioAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  final bool isMyMessage;
  const AudioAttachmentBuilder({required this.isMyMessage});
  @override
  Widget build(BuildContext context, Message message,
      Map<String, List<Attachment>> attachments) {
    final url = attachments['voicenote']?.first.assetUrl;

    final localFilePath = attachments['voicenote']?.first.file?.path;

    final waveFormData =
        attachments['voicenote']?.first.extraData['waveForm'] as List<dynamic>?;

    List<double>? waveData;

    if (waveFormData != null) {
      waveData = waveFormData.map((e) => (e as num).toDouble()).toList();
    }

    late final Widget widget;
    if (url == null) {
      widget = const AudioLoadingMessage();
    } else {
      widget = AudioPlayerMessage(
        source: AudioSource.uri(Uri.parse(url)),
        localFilePath: localFilePath,
        id: message.id,
        fileWaveFormData: waveData,
        isMyMessage: isMyMessage,
      );
    }
    return SizedBox(
      width: 250,
      height: 60,
      child: widget,
    );
  }

  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) {
    final audioAttachments = attachments['voicenote'];
    return audioAttachments != null && audioAttachments.length == 1;
  }
}
