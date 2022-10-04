import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget used to pick images from the device.
class StreamImagePicker extends StatelessWidget {
  /// Creates a [StreamImagePicker] widget.
  const StreamImagePicker({
    super.key,
    required this.onImagePicked,
    this.source = ImageSource.camera,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
  });

  /// Callback called when an image is picked.
  final ValueSetter<Attachment?> onImagePicked;

  /// Source of the image to pick.
  final ImageSource source;

  /// Maximum width of the image.
  final double? maxWidth;

  /// Maximum height of the image.
  final double? maxHeight;

  /// Quality of the image.
  final int? imageQuality;

  /// Preferred camera device to use.
  final CameraDevice preferredCameraDevice;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: StreamSvgIcon.camera(
          size: 240,
          color: theme.colorTheme.disabled,
        ),
        onEndOfFrame: (_) async {
          final pickedImage = await runInPermissionRequestLock(() {
            return StreamAttachmentHandler.instance.pickImage(
              source: source,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: imageQuality,
              preferredCameraDevice: preferredCameraDevice,
            );
          });

          onImagePicked.call(pickedImage);
        },
        errorBuilder: (context, error, stacktrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamSvgIcon.camera(
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
