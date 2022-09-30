/// Location for actions on the [StreamMessageInput].
enum ActionsLocation {
  /// Align to left
  left,

  /// Align to right
  right,

  /// Align to left but inside the [TextField]
  leftInside,

  /// Align to right but inside the [TextField]
  rightInside,
}

/// Default attachments for widget.
enum DefaultAttachmentTypes {
  /// Image Attachment
  image,

  /// Video Attachment
  video,

  /// File Attachment
  file,
}

/// Available locations for the `sendMessage` button relative to the textField.
enum SendButtonLocation {
  /// inside the textField
  inside,

  /// outside the textField
  outside,
}
