import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget used to capture video using the device camera.
class StreamVideoPicker extends StatelessWidget {
  /// Creates a [StreamVideoPicker] widget.
  const StreamVideoPicker({
    super.key,
    required this.onVideoPicked,
    this.source = ImageSource.camera,
    this.preferredCameraDevice = CameraDevice.rear,
    this.maxDuration,
  });

  /// Callback called when a video is picked.
  final ValueSetter<Attachment?> onVideoPicked;

  /// Source of the video to pick.
  final ImageSource source;

  /// Preferred camera device to use.
  final CameraDevice preferredCameraDevice;

  /// Maximum duration of the video.
  final Duration? maxDuration;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    Future<void> onPickVideo() async {
      final pickedVideo = await runInPermissionRequestLock(() {
        return StreamAttachmentHandler.instance.pickVideo(
          source: source,
          preferredCameraDevice: preferredCameraDevice,
          maxDuration: maxDuration,
        );
      });

      return onVideoPicked.call(pickedVideo);
    }

    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 32,
                context.streamIcons.video,
                color: colorScheme.textTertiary,
              ),
              SizedBox(height: spacing.xs),
              Text(
                context.translations.takeVideoAndShareLabel,
                style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.md),
              StreamButton(
                type: .outline,
                style: .secondary,
                onPressed: onPickVideo,
                child: Text(context.translations.openCameraLabel),
              ),
            ],
          ),
        ),
        onEndOfFrame: (_) => onPickVideo(),
        errorBuilder: (context, error, stacktrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 32,
                context.streamIcons.video,
                color: colorScheme.textTertiary,
              ),
              SizedBox(height: spacing.xs),
              Text(
                context.translations.enablePhotoAndVideoAccessMessage,
                style: textTheme.bodyDefault.copyWith(
                  color: colorScheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.md),
              StreamButton(
                type: .outline,
                style: .secondary,
                onPressed: PhotoManager.openSetting,
                child: Text(context.translations.allowGalleryAccessMessage),
              ),
            ],
          );
        },
      ),
    );
  }
}
