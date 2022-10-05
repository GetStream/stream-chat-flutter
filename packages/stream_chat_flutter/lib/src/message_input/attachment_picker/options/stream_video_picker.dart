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
    final theme = StreamChatTheme.of(context);
    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: StreamSvgIcon.record(
          size: 240,
          color: theme.colorTheme.disabled,
        ),
        onEndOfFrame: (_) async {
          final pickedVideo = await runInPermissionRequestLock(() {
            return StreamAttachmentHandler.instance.pickVideo(
              source: source,
              preferredCameraDevice: preferredCameraDevice,
              maxDuration: maxDuration,
            );
          });

          onVideoPicked.call(pickedVideo);
        },
        errorBuilder: (context, error, stacktrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamSvgIcon.record(
                size: 240,
                color: theme.colorTheme.disabled,
              ),
              Text(
                context.translations.enablePhotoAndVideoAccessMessage,
                style: theme.textTheme.body.copyWith(
                  color: theme.colorTheme.textLowEmphasis,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: PhotoManager.openSetting,
                child: Text(
                  context.translations.allowGalleryAccessMessage,
                  style: theme.textTheme.bodyBold.copyWith(
                    color: theme.colorTheme.accentPrimary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
