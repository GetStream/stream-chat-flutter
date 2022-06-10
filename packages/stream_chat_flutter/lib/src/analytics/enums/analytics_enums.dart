/// The types of action that can be taken for attachments in
/// StreamMessageInput
enum StreamMessageInputAttachmentActionType {
  /// Pick media from gallery
  gallery,

  /// Pick a file using the native file pciker
  filePicker,

  /// Use the camera to capture a photo
  capturePhoto,

  /// Use the camera to record a video
  captureVideo
}
