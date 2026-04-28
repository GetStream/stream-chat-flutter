import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    Future<void> onPickFile() async {
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

      return onFilePicked.call(pickedFile);
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
                context.streamIcons.file,
                color: colorScheme.textTertiary,
              ),
              SizedBox(height: spacing.xs),
              Text(
                context.translations.selectFilesToShareLabel,
                style: textTheme.bodyDefault.copyWith(
                  color: colorScheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.md),
              StreamButton(
                type: .outline,
                style: .secondary,
                onPressed: onPickFile,
                child: Text(context.translations.openFilesLabel),
              ),
            ],
          ),
        ),
        onEndOfFrame: (_) => onPickFile(),
      ),
    );
  }
}
