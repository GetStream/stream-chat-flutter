import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class StreamFilePicker extends StatelessWidget {
  const StreamFilePicker({
    super.key,
    required this.onFilePicked,
    this.dialogTitle,
    this.initialDirectory,
    this.type = FileType.any,
    this.allowedExtensions,
    this.onFileLoading,
    this.allowCompression = true,
    this.withData = false,
    this.withReadStream = false,
    this.lockParentWindow = false,
  });

  final ValueSetter<Attachment?> onFilePicked;
  final String? dialogTitle;
  final String? initialDirectory;
  final FileType type;
  final List<String>? allowedExtensions;
  final Function(FilePickerStatus)? onFileLoading;
  final bool allowCompression;
  final bool withData;
  final bool withReadStream;
  final bool lockParentWindow;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamSvgIcon.files(
              size: 240,
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
          final pickedFile = await runInPermissionRequestLock(() {
            return StreamAttachmentHandler.instance.pickFile(
              dialogTitle: dialogTitle,
              initialDirectory: initialDirectory,
              type: type,
              allowedExtensions: allowedExtensions,
              onFileLoading: onFileLoading,
              allowCompression: allowCompression,
              withData: withData,
              withReadStream: withReadStream,
              lockParentWindow: lockParentWindow,
            );
          });

          onFilePicked.call(pickedFile);
        },
        errorBuilder: (context, error, stacktrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamSvgIcon.files(
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
