import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/src/utils/helpers.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class StreamImagePicker extends StatelessWidget {
  const StreamImagePicker({
    super.key,
    required this.onImagePicked,
    this.source = ImageSource.camera,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
  });

  final ValueSetter<Attachment?> onImagePicked;
  final ImageSource source;
  final double? maxWidth;
  final double? maxHeight;
  final int? imageQuality;
  final CameraDevice preferredCameraDevice;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamSvgIcon.camera(
              size: 148,
              color: theme.colorTheme.disabled,
            ),
            Text(
              'Stream Image Picker',
              style: theme.textTheme.body.copyWith(
                color: theme.colorTheme.textLowEmphasis,
              ),
            ),
          ],
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
