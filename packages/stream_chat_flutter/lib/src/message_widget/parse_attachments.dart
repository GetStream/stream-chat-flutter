import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ParseAttachments extends StatelessWidget {
  const ParseAttachments({
    Key? key,
    required this.message,
    required this.attachmentBuilders,
    required this.attachmentPadding,
  }) : super(key: key);

  final Message message;

  /// Builder for respective attachment types
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// The internal padding of an attachment
  final EdgeInsetsGeometry attachmentPadding;

  @override
  Widget build(BuildContext context) {
    final attachmentGroups = <String, List<Attachment>>{};

    message.attachments
        .where((element) =>
            (element.titleLink == null && element.type != null) ||
            element.type == 'giphy')
        .forEach((e) {
      if (attachmentGroups[e.type] == null) {
        attachmentGroups[e.type!] = [];
      }

      attachmentGroups[e.type]?.add(e);
    });

    final attachmentList = <Widget>[];

    attachmentGroups.forEach((type, attachments) {
      final attachmentBuilder = attachmentBuilders[type];

      if (attachmentBuilder == null) return;
      final attachmentWidget = attachmentBuilder(
        context,
        message,
        attachments,
      );
      attachmentList.add(attachmentWidget);
    });

    return Padding(
      padding: attachmentPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: attachmentList.insertBetween(SizedBox(
          height: attachmentPadding.vertical / 2,
        )),
      ),
    );
  }
}
