import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker_controller.dart';

/// Function signature for building the attachment picker option view.
typedef AttachmentPickerOptionViewBuilder = Widget Function(
  BuildContext context,
  StreamAttachmentPickerController controller,
);

/// Function signature for system attachment picker option callback.
typedef OnSystemAttachmentPickerOptionTap = Future<void> Function(
  BuildContext context,
  StreamAttachmentPickerController controller,
);

/// Base class for attachment picker options.
abstract class AttachmentPickerOption {
  /// Creates a new instance of [AttachmentPickerOption].
  const AttachmentPickerOption({
    this.key,
    required this.supportedTypes,
    required this.icon,
    this.title,
    this.isEnabled = _defaultIsEnabled,
  });

  /// A key to identify the option.
  final String? key;

  /// The icon of the option.
  final Widget icon;

  /// The title of the option.
  final String? title;

  /// The supported types of the option.
  final Iterable<AttachmentPickerType> supportedTypes;

  /// Determines if this option is enabled based on the current value.
  ///
  /// If not provided, defaults to always returning true.
  final bool Function(AttachmentPickerValue value) isEnabled;
  static bool _defaultIsEnabled(AttachmentPickerValue value) => true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AttachmentPickerOption) return false;
    if (runtimeType != other.runtimeType) return false;

    final areSupportedTypesEqual = const UnorderedIterableEquality().equals(
      supportedTypes,
      other.supportedTypes,
    );

    return key == other.key && areSupportedTypesEqual;
  }

  @override
  int get hashCode {
    final supportedTypesHash = const UnorderedIterableEquality().hash(
      supportedTypes,
    );

    return key.hashCode ^ supportedTypesHash;
  }
}

/// Attachment picker option that shows custom UI inside the attachment picker's
/// tabbed interface. Use this when you want to display your own custom
/// interface for selecting attachments.
///
/// This option is used when the attachment picker displays a tabbed interface
/// (typically on mobile when useSystemAttachmentPicker is false).
class TabbedAttachmentPickerOption extends AttachmentPickerOption {
  /// Creates a new instance of [TabbedAttachmentPickerOption].
  const TabbedAttachmentPickerOption({
    super.key,
    required super.supportedTypes,
    required super.icon,
    required this.optionViewBuilder,
    super.title,
    super.isEnabled,
  });

  /// The option view builder for custom UI.
  final AttachmentPickerOptionViewBuilder optionViewBuilder;
}

/// Attachment picker option that uses system integration
/// (file dialogs, camera, etc.).
///
/// Use this when you want to open system pickers or perform system actions.
class SystemAttachmentPickerOption extends AttachmentPickerOption {
  /// Creates a new instance of [SystemAttachmentPickerOption].
  const SystemAttachmentPickerOption({
    super.key,
    required super.supportedTypes,
    required super.icon,
    required this.title,
    required this.onTap,
    super.isEnabled,
  });

  @override
  final String title;

  /// The callback that is called when the option is tapped.
  final OnSystemAttachmentPickerOptionTap onTap;
}

/// Helpful extensions for [StreamAttachmentPickerController].
extension AttachmentPickerOptionTypeX on AttachmentPickerValue {
  /// Returns the list of enabled picker types.
  Set<AttachmentPickerType> filterEnabledTypes({
    required Iterable<AttachmentPickerOption> options,
  }) {
    final enabledTypes = <AttachmentPickerType>{};
    for (final option in options) {
      if (option.isEnabled.call(this)) {
        enabledTypes.addAll(option.supportedTypes);
      }
    }
    return enabledTypes;
  }
}

/// {@template streamAttachmentPickerType}
/// A sealed class that represents different types of attachment which a picker
/// option can support.
/// {@endtemplate}
sealed class AttachmentPickerType {
  const AttachmentPickerType();

  /// The option will allow to pick images.
  static const images = ImagesPickerType();

  /// The option will allow to pick videos.
  static const videos = VideosPickerType();

  /// The option will allow to pick audios.
  static const audios = AudiosPickerType();

  /// The option will allow to pick files or documents.
  static const files = FilesPickerType();

  /// The option will allow to create a poll.
  static const poll = PollPickerType();

  /// A list of all predefined attachment picker types.
  static const values = [images, videos, audios, files, poll];
}

/// A predefined attachment picker type that allows picking images.
final class ImagesPickerType extends AttachmentPickerType {
  /// Creates a new images picker type.
  const ImagesPickerType();
}

/// A predefined attachment picker type that allows picking videos.
final class VideosPickerType extends AttachmentPickerType {
  /// Creates a new videos picker type.
  const VideosPickerType();
}

/// A predefined attachment picker type that allows picking audios.
final class AudiosPickerType extends AttachmentPickerType {
  /// Creates a new audios picker type.
  const AudiosPickerType();
}

/// A predefined attachment picker type that allows picking files or documents.
final class FilesPickerType extends AttachmentPickerType {
  /// Creates a new files picker type.
  const FilesPickerType();
}

/// A predefined attachment picker type that allows creating polls.
final class PollPickerType extends AttachmentPickerType {
  /// Creates a new poll picker type.
  const PollPickerType();
}

/// A custom picker type that can be extended to support custom types of
/// attachments. This allows developers to create their own attachment picker
/// options for specialized content types.
///
/// Example:
/// ```dart
/// class DocumentPickerType extends CustomAttachmentPickerType {
///   const DocumentPickerType();
/// }
/// ```
abstract class CustomAttachmentPickerType extends AttachmentPickerType {
  /// Creates a new custom picker type.
  const CustomAttachmentPickerType();
}
