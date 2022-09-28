import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/fsm_stub.dart'
    if (dart.library.io) 'full_screen_media_desktop.dart' as desktop_fsm;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template fsmBuilder}
/// A wrapper widget for conditionally providing the proper
/// StreamFullScreenMedia widget when writing an application that targets
/// all available Flutter platforms (Android, iOS, macOS, Windows, Linux,
/// & Web).
///
/// This is required because:
/// * `package:video_player` and `package:chewie` do not support macOS, Windows,
/// & Linux, but _do_ support Android, iOS, & Web.
/// * `package:dart_vlc` _does_ support macOS, Windows, & Linux via FFI. This
/// has the unfortunate consequence of not supporting Web.
///
/// This widget makes use of dart's conditional imports to ensure that Stream's
/// desktop implementation of StreamFullScreenMedia is not imported when
/// building applications that target web. Additionally, this widget ensures
/// that applications targeting mobile platforms do not build the version of
/// StreamFullScreenMedia that targets desktop platforms (even though
/// `package:dart_vlc` technically supports iOS).
/// {@endtemplate}
class StreamFullScreenMediaBuilder extends StatelessWidget {
  /// {@macro fsmBuilder}
  const StreamFullScreenMediaBuilder({
    super.key,
    required this.mediaAttachmentPackages,
    required this.startIndex,
    required this.userName,
    this.onShowMessage,
    this.onReplyMessage,
    this.attachmentActionsModalBuilder,
    this.autoplayVideos = false,
  });

  /// The url of the image
  final List<StreamAttachmentPackage> mediaAttachmentPackages;

  /// First index of media shown
  final int startIndex;

  /// Username of sender
  final String userName;

  /// Callback for when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// Callback for when reply message is tapped
  final ReplyMessageCallback? onReplyMessage;

  /// Widget builder for attachment actions modal
  /// [defaultActionsModal] is the default [AttachmentActionsModal] config
  /// Use [defaultActionsModal.copyWith] to easily customize it
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// Auto-play videos when page is opened
  final bool autoplayVideos;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && isDesktopVideoPlayerSupported) {
      return desktop_fsm.getFsm(
        mediaAttachmentPackages: mediaAttachmentPackages,
        startIndex: startIndex,
        userName: userName,
        autoplayVideos: autoplayVideos,
        onShowMessage: onShowMessage,
        onReplyMessage: onReplyMessage,
        attachmentActionsModalBuilder: attachmentActionsModalBuilder,
      );
    }

    return StreamFullScreenMedia(
      mediaAttachmentPackages: mediaAttachmentPackages,
      startIndex: startIndex,
      userName: userName,
      onShowMessage: onShowMessage,
      onReplyMessage: onReplyMessage,
      attachmentActionsModalBuilder: attachmentActionsModalBuilder,
      autoplayVideos: autoplayVideos,
    );
  }
}
