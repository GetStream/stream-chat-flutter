import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamVideoCapture extends StatelessWidget {
  const StreamVideoCapture({
    super.key,
    required this.onVideoCaptured,
    this.source = ImageSource.camera,
    this.preferredCameraDevice = CameraDevice.rear,
    this.maxDuration,
  });

  final ValueSetter<Attachment?> onVideoCaptured;
  final ImageSource source;
  final CameraDevice preferredCameraDevice;
  final Duration? maxDuration;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamSvgIcon.record(
              size: 148,
              color: theme.colorTheme.disabled,
            ),
            Text(
              'Stream Video Picker',
              style: theme.textTheme.body.copyWith(
                color: theme.colorTheme.textLowEmphasis,
              ),
            ),
          ],
        ),
        onEndOfFrame: (_) async {
          final pickedVideo = await runInPermissionRequestLock(() {
            return StreamAttachmentHandler.instance.pickVideo(
              source: source,
              preferredCameraDevice: preferredCameraDevice,
              maxDuration: maxDuration,
            );
          });

          onVideoCaptured.call(pickedVideo);
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
