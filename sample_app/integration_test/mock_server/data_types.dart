/// Attachment kinds the participant can upload via the mock server.
enum AttachmentType {
  image('image'),
  video('video'),
  file('file');

  const AttachmentType(this.attachment);

  /// Value sent to the mock server.
  final String attachment;
}

/// Reaction kinds, mapped to the server's reaction identifiers.
enum ReactionType {
  love('love'),
  lol('haha'),
  wow('wow'),
  sad('sad'),
  like('like');

  const ReactionType(this.reaction);

  /// Value sent to the mock server.
  final String reaction;
}

/// Delivery status shown on a sent message; [nil] means no status icon.
enum MessageDeliveryStatus { read, pending, sent, failed, nil }

/// A message containing this word is rejected by the mock server.
const forbiddenWord = 'wth';
