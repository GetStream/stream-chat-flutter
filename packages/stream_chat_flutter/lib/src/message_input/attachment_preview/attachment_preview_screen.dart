import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/custom_theme/unikon_theme.dart';
import 'package:stream_chat_flutter/src/message_input/translucent_scafold.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class AttachmentPreviewScreen extends StatefulWidget {
  const AttachmentPreviewScreen({
    super.key,
    required this.effectiveController,
    required this.attachmentController,
  });
  final StreamMessageInputController effectiveController;
  final StreamAttachmentPickerController attachmentController;

  /// Callback called when the remove button is pressed.

  @override
  State<AttachmentPreviewScreen> createState() =>
      _AttachmentPreviewScreenState();
}

class _AttachmentPreviewScreenState extends State<AttachmentPreviewScreen> {
  Future<void> _onAttachmentRemovePressed(Attachment attachment) async {
    final file = attachment.file;
    final uploadState = attachment.uploadState;

    if (file != null && !uploadState.isSuccess && !isWeb) {
      await StreamAttachmentHandler.instance.deleteAttachmentFile(
        attachmentFile: file,
      );
    }

    await widget.attachmentController.removeAttachment(attachment);
    if (widget.attachmentController.value.isEmpty) {
      Navigator.of(context).pop();
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final nonOGAttachments = widget.attachmentController.value.where((it) {
      return it.titleLink == null;
    }).toList(growable: false);

    // If there are no attachments, return an empty widget
    if (nonOGAttachments.isEmpty) return const Offstage();

    // Otherwise, use the default attachment list builder.
    return TranslucentScaffold(
      appBar: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: AppBar(
          backgroundColor: UnikonColorTheme.transparent,
          leading: IconButton(
            icon: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  colors: [
                    UnikonColorTheme.backButtonLinearGradientColor1,
                    UnikonColorTheme.backButtonLinearGradientColor2
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: UnikonColorTheme.messageSentIndicatorColor,
                  size: 16,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Text(
              '${widget.attachmentController.value.length} media selected',
              style: const TextStyle(color: UnikonColorTheme.dividerColor),
            ),
          ],
        ),
      ),
      body: StreamMessageInputAttachmentList(
        attachments: nonOGAttachments,
        onRemovePressed: _onAttachmentRemovePressed,
      ),
    );
  }
}
