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
  captureVideo,
}

/// The types of actions that can be taken on a message
enum StreamMessageActionType {
  /// directly quote and reply to the message
  reply,

  /// reply to the message and start a thread
  threadReply,

  /// flag the message
  flag,

  /// pin message to the channel
  pin,

  /// unpin the message from the channel
  unpin,

  /// delete the message from the channel
  delete,
}

/// The actions that can be taken when an attachment is open in full screen view
enum StreamAttachmentFullScreenActionType {
  /// Reply to the message containing this attachment
  reply,

  /// Show the message containing this attachment in the message listview
  showInChat,

  /// Save this attachment to device
  save,
}
