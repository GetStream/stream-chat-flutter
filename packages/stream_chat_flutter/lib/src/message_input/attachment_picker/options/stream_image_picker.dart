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
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    Future<void> onPickImage() async {
      final pickedImage = await runInPermissionRequestLock(() {
        return StreamAttachmentHandler.instance.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          preferredCameraDevice: preferredCameraDevice,
        );
      });

      return onImagePicked.call(pickedImage);
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
                context.streamIcons.cameraLarge,
                color: colorScheme.textTertiary,
              ),
              SizedBox(height: spacing.xs),
              Text(
                context.translations.takePhotoAndShareLabel,
                style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.md),
              StreamButton(
                type: .outline,
                style: .secondary,
                onPressed: onPickImage,
                child: Text(context.translations.openCameraLabel),
              ),
            ],
          ),
        ),
        onEndOfFrame: (_) => onPickImage(),
        errorBuilder: (context, error, stacktrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 32,
                context.streamIcons.cameraLarge,
                color: colorScheme.textTertiary,
              ),
              SizedBox(height: spacing.xs),
              Text(
                context.translations.enablePhotoAndVideoAccessMessage,
                style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
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
