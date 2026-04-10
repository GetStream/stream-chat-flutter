import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker_option.dart';

/// {@template streamAttachmentPickerOptionsBuilder}
/// Signature for a function that creates a list of [AttachmentPickerOption]s
/// to be used in the attachment picker.
///
/// The function receives the [BuildContext] and a list of [defaultOptions]
/// that can be modified or extended.
/// {@endtemplate}
typedef AttachmentPickerOptionsBuilder<T extends AttachmentPickerOption> =
    List<T> Function(BuildContext context, List<T> defaultOptions);
