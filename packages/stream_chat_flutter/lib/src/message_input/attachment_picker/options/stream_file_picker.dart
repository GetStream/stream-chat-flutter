import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Widget used to pick files from the device
class StreamFilePicker extends StatelessWidget {
  /// Creates a [StreamFilePicker] widget.
  const StreamFilePicker({
    super.key,
    required this.onFilePicked,
    this.dialogTitle,
    this.initialDirectory,
    this.type = FileType.any,
    this.allowedExtensions,
    this.onFileLoading,
    this.compressionQuality = 0,
    this.withData = false,
    this.withReadStream = false,
    this.lockParentWindow = false,
  });

  /// Callback called when a file is picked.
  final ValueSetter<Attachment?> onFilePicked;

  /// Title of the file picker dialog.
  final String? dialogTitle;

  /// Initial directory of the file picker dialog.
  final String? initialDirectory;

  /// Type of the file to pick.
  final FileType type;

  /// Allowed extensions of the file to pick.
  final List<String>? allowedExtensions;

  /// Callback called when the file picker is loading a file.
  final Function(FilePickerStatus)? onFileLoading;

  /// The compression quality for the file.
  final int compressionQuality;

  /// Whether to include the file data in the [Attachment].
  final bool withData;

  /// Whether to include the file read stream in the [Attachment].
  final bool withReadStream;

  /// Whether to lock the parent window when the file picker is open.
  final bool lockParentWindow;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: StreamSvgIcon(
          size: 240,
          icon: StreamSvgIcons.files,
          color: theme.colorTheme.disabled,
        ),
        onEndOfFrame: (_) async {
          final pickedFile = await runInPermissionRequestLock(() {
            return StreamAttachmentHandler.instance.pickFile(
              dialogTitle: dialogTitle,
              initialDirectory: initialDirectory,
              type: type,
              allowedExtensions: allowedExtensions,
              onFileLoading: onFileLoading,
              compressionQuality: compressionQuality,
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
              StreamSvgIcon(
                size: 240,
                icon: StreamSvgIcons.files,
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
