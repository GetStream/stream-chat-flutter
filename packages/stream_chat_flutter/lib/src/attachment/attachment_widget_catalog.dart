import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/attachment/builder/attachment_widget_builder.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template attachmentWidgetCatalog}
/// A widget catalog which determines which attachment widget should be build
/// for a given [Message] and [Attachment] based on the list of [builders].
///
/// This is used by the [MessageWidget] to build the widget for the
/// [Message.attachments]. If you want to customize the widget used to show
/// attachments, you can use this to add your own attachment builder.
/// {@endtemplate}
///
/// See also:
///
///   * [StreamAttachmentWidgetBuilder], which is used to build a widget for a
///   given [Message] and [Attachment].
///   * [MessageWidget] which uses the [AttachmentWidgetCatalog] to build the
///   widget for the [Message.attachments].
class AttachmentWidgetCatalog {
  /// {@macro attachmentWidgetCatalog}
  const AttachmentWidgetCatalog({required this.builders});

  /// The list of builders to use to build the widget.
  ///
  /// The order of the builders is important. The first builder that can handle
  /// the message and attachments will be used to build the widget.
  final List<StreamAttachmentWidgetBuilder> builders;

  /// Builds a widget for the given [message] and [attachments].
  ///
  /// It iterates through the list of builders and uses the first builder
  /// that can handle the message and attachments.
  ///
  /// Throws an [Exception] if no builder is found for the message.
  Widget build(BuildContext context, Message message) {
    assert(!message.isDeleted, 'Cannot build attachment for deleted message');

    // The list of attachments to build the widget for.
    final attachments = message.attachments.grouped;
    for (final builder in builders) {
      if (builder.canHandle(message, attachments)) {
        return builder.build(context, message, attachments);
      }
    }

    throw Exception('No builder found for $message and $attachments');
  }
}

extension on List<Attachment> {
  /// Groups the attachments by their type.
  Map<String, List<Attachment>> get grouped {
    return groupBy(
      where((it) {
        return it.type != null;
      }),
      (attachment) => attachment.type!,
    );
  }
}
