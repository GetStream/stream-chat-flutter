import 'package:file_picker/file_picker.dart' show FileType;
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_file_picker.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_gallery_picker.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_image_picker.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_poll_creator.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_video_picker.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker_controller.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker_option.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker_result.dart';
import 'package:stream_chat_flutter/src/poll/creator/stream_poll_creator_dialog.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class StreamAttachmentPickerOptionsBuilder {
  /// Private constructor to prevent instantiation
  const StreamAttachmentPickerOptionsBuilder._();

  static List<TabbedAttachmentPickerOption> buildTabbedOptions({
    required BuildContext context,
    PollConfig? pollConfig,
    GalleryPickerConfig? galleryPickerConfig,
    Iterable<TabbedAttachmentPickerOption>? customOptions,
  }) {
    final pickerOptions = <TabbedAttachmentPickerOption>[
      _buildGalleryPickerOption(config: galleryPickerConfig),
      _buildTabbedFilePickerOption(),
      _buildTabbedImagePickerOption(),
      _buildTabbedVideoPickerOption(),
      _buildTabbedPollCreatorOption(config: pollConfig),
      ...?customOptions,
    ];

    return pickerOptions;
  }

  static List<SystemAttachmentPickerOption> buildSystemOptions({
    required BuildContext context,
    PollConfig? pollConfig,
    GalleryPickerConfig? galleryPickerConfig,
    Iterable<SystemAttachmentPickerOption>? customOptions,
  }) {
    final pickerOptions = <SystemAttachmentPickerOption>[
      _buildSystemImagePickerOption(context: context),
      _buildSystemVideoPickerOption(context: context),
      _buildSystemFilePickerOption(context: context),
      _buildSystemPollCreatorOption(context: context, config: pollConfig),
      ...?customOptions,
    ];

    return pickerOptions;
  }
}

TabbedAttachmentPickerOption _buildGalleryPickerOption({
  GalleryPickerConfig? config,
}) {
  return TabbedAttachmentPickerOption(
    key: 'gallery-picker',
    icon: const StreamSvgIcon(icon: StreamSvgIcons.pictures),
    supportedTypes: [AttachmentPickerType.images, AttachmentPickerType.videos],
    isEnabled: (value) {
      // Enable if nothing has been selected yet.
      if (value.isEmpty) return true;

      // Otherwise, enable only if there is at least a image or a video.
      return value.attachments.any((it) => it.isImage || it.isVideo);
    },
    optionViewBuilder: (context, controller) {
      final attachments = controller.value.attachments;
      final selectedIds = attachments.map((it) => it.id);
      return StreamGalleryPicker(
        config: config,
        selectedMediaItems: selectedIds,
        onMediaItemSelected: (media) async {
          try {
            if (selectedIds.contains(media.id)) {
              return await controller.removeAssetAttachment(media);
            }

            return await controller.addAssetAttachment(media);
          } catch (e, stk) {
            final err = AttachmentPickerError(error: e, stackTrace: stk);
            return Navigator.pop(context, err);
          }
        },
      );
    },
  );
}

Future<StreamAttachmentPickerResult> _handleSingePick(
  Attachment? attachment,
  StreamAttachmentPickerController controller,
) async {
  try {
    if (attachment != null) await controller.addAttachment(attachment);
    return AttachmentsPicked(attachments: controller.value.attachments);
  } catch (error, stk) {
    return AttachmentPickerError(error: error, stackTrace: stk);
  }
}

TabbedAttachmentPickerOption _buildTabbedFilePickerOption() {
  return TabbedAttachmentPickerOption(
    key: 'file-picker',
    icon: const StreamSvgIcon(icon: StreamSvgIcons.files),
    supportedTypes: [AttachmentPickerType.files],
    isEnabled: (value) {
      // Enable if nothing has been selected yet.
      if (value.isEmpty) return true;

      // Otherwise, enable only if there is at least a file.
      return value.attachments.any((it) => it.isFile);
    },
    optionViewBuilder: (context, controller) => StreamFilePicker(
      onFilePicked: (file) async {
        final result = await _handleSingePick(file, controller);
        return Navigator.pop(context, result);
      },
    ),
  );
}

TabbedAttachmentPickerOption _buildTabbedImagePickerOption() {
  return TabbedAttachmentPickerOption(
    key: 'image-picker',
    icon: const StreamSvgIcon(icon: StreamSvgIcons.camera),
    supportedTypes: [AttachmentPickerType.images],
    isEnabled: (value) {
      // Enable if nothing has been selected yet.
      if (value.isEmpty) return true;

      // Otherwise, enable only if there is at least a image.
      return value.attachments.any((it) => it.isImage);
    },
    optionViewBuilder: (context, controller) => StreamImagePicker(
      onImagePicked: (image) async {
        final result = await _handleSingePick(image, controller);
        return Navigator.pop(context, result);
      },
    ),
  );
}

TabbedAttachmentPickerOption _buildTabbedVideoPickerOption() {
  return TabbedAttachmentPickerOption(
    key: 'video-picker',
    icon: const StreamSvgIcon(icon: StreamSvgIcons.record),
    supportedTypes: [AttachmentPickerType.videos],
    isEnabled: (value) {
      // Enable if nothing has been selected yet.
      if (value.isEmpty) return true;

      // Otherwise, enable only if there is at least a video.
      return value.attachments.any((it) => it.isVideo);
    },
    optionViewBuilder: (context, controller) => StreamVideoPicker(
      onVideoPicked: (video) async {
        final result = await _handleSingePick(video, controller);
        return Navigator.pop(context, result);
      },
    ),
  );
}

TabbedAttachmentPickerOption _buildTabbedPollCreatorOption({
  PollConfig? config,
}) {
  return TabbedAttachmentPickerOption(
    key: 'poll-creator',
    icon: const StreamSvgIcon(icon: StreamSvgIcons.polls),
    supportedTypes: [AttachmentPickerType.poll],
    isEnabled: (value) {
      // Enable if nothing has been selected yet.
      if (value.isEmpty) return true;

      // Otherwise, enable only if there is a poll.
      return value.poll != null;
    },
    optionViewBuilder: (context, controller) {
      final initialPoll = controller.value.poll;
      return StreamPollCreator(
        poll: initialPoll,
        config: config,
        onPollCreated: (poll) {
          if (poll == null) return Navigator.pop(context);
          controller.poll = poll;

          final result = PollCreated(poll: poll);
          return Navigator.pop(context, result);
        },
      );
    },
  );
}

Future<StreamAttachmentPickerResult> _pickSystemFile(
  FileType type,
  StreamAttachmentPickerController controller,
) async {
  try {
    final file = await StreamAttachmentHandler.instance.pickFile(type: type);
    if (file != null) await controller.addAttachment(file);

    return AttachmentsPicked(attachments: controller.value.attachments);
  } catch (error, stk) {
    return AttachmentPickerError(error: error, stackTrace: stk);
  }
}

SystemAttachmentPickerOption _buildSystemImagePickerOption({
  required BuildContext context,
}) {
  return SystemAttachmentPickerOption(
    key: 'image-picker',
    supportedTypes: [AttachmentPickerType.images],
    icon: const StreamSvgIcon(icon: StreamSvgIcons.pictures),
    title: context.translations.uploadAPhotoLabel,
    onTap: (context, controller) async {
      final result = await _pickSystemFile(FileType.image, controller);
      return Navigator.pop(context, result);
    },
  );
}

SystemAttachmentPickerOption _buildSystemVideoPickerOption({
  required BuildContext context,
}) {
  return SystemAttachmentPickerOption(
    key: 'video-picker',
    supportedTypes: [AttachmentPickerType.videos],
    icon: const StreamSvgIcon(icon: StreamSvgIcons.record),
    title: context.translations.uploadAVideoLabel,
    onTap: (context, controller) async {
      final result = await _pickSystemFile(FileType.video, controller);
      return Navigator.pop(context, result);
    },
  );
}

SystemAttachmentPickerOption _buildSystemFilePickerOption({
  required BuildContext context,
}) {
  return SystemAttachmentPickerOption(
    key: 'file-picker',
    supportedTypes: [AttachmentPickerType.files],
    icon: const StreamSvgIcon(icon: StreamSvgIcons.files),
    title: context.translations.uploadAFileLabel,
    onTap: (context, controller) async {
      final result = await _pickSystemFile(FileType.any, controller);
      return Navigator.pop(context, result);
    },
  );
}

SystemAttachmentPickerOption _buildSystemPollCreatorOption({
  required BuildContext context,
  PollConfig? config,
}) {
  return SystemAttachmentPickerOption(
    key: 'poll-creator',
    supportedTypes: [AttachmentPickerType.poll],
    icon: const StreamSvgIcon(icon: StreamSvgIcons.polls),
    title: context.translations.createPollLabel(isNew: true),
    onTap: (context, controller) async {
      final initialPoll = controller.value.poll;
      final poll = await showStreamPollCreatorDialog(
        context: context,
        poll: initialPoll,
        config: config,
      );

      // If the poll is null, it means the user cancelled the dialog.
      if (poll == null) return Navigator.pop(context);

      // Otherwise, set the poll in the controller and pop the dialog.
      final result = PollCreated(poll: controller.poll = poll);
      return Navigator.pop(context, result);
    },
  );
}
