import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/clear_input_item_button.dart';
import 'package:stream_chat_flutter/src/message_input/input_attachment.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template inputAttachments}
/// Represents multiple [InputAttachment]s that are being uploaded to a chat.
/// {@endtemplate}
class InputAttachments extends StatefulWidget {
  /// {@macro inputAttachments}
  const InputAttachments({
    super.key,
    required this.attachments,
    this.attachmentThumbnailBuilders,
  });

  /// The attachments to build.
  final Map<String, Attachment> attachments;

  /// Map that defines a thumbnail builder for an attachment type.
  final Map<String, AttachmentThumbnailBuilder>? attachmentThumbnailBuilders;

  @override
  State<InputAttachments> createState() => _InputAttachmentsState();
}

class _InputAttachmentsState extends State<InputAttachments> {
  @override
  Widget build(BuildContext context) {
    if (widget.attachments.isEmpty) return const Offstage();
    final fileAttachments = widget.attachments.values
        .where((it) => it.type == 'file')
        .toList(growable: false);
    final remainingAttachments = widget.attachments.values
        .where((it) => it.type != 'file')
        .toList(growable: false);
    return Column(
      children: [
        if (fileAttachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: LimitedBox(
              maxHeight: 136,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: fileAttachments.reversed
                    .map<Widget>(
                      (e) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: StreamFileAttachment(
                          message: Message(), // dummy message
                          attachment: e,
                          constraints: BoxConstraints.loose(Size(
                            MediaQuery.of(context).size.width * 0.65,
                            56,
                          )),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClearInputItemButton(
                              onTap: () {
                                setState(() => widget.attachments.remove(e.id));
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                    .insertBetween(const SizedBox(height: 8)),
              ),
            ),
          ),
        if (remainingAttachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: LimitedBox(
              maxHeight: 104,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: remainingAttachments
                    .map<Widget>(
                      (attachment) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1,
                              child: SizedBox(
                                height: 104,
                                width: 104,
                                child: InputAttachment(
                                  attachment: attachment,
                                  attachmentThumbnailBuilders:
                                      widget.attachmentThumbnailBuilders,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: ClearInputItemButton(
                                onTap: () {
                                  setState(
                                    () => widget.attachments
                                        .remove(attachment.id),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .insertBetween(const SizedBox(width: 8)),
              ),
            ),
          ),
      ],
    );
  }
}
