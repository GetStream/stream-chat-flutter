enum AttachmentType {
  image('image'),
  video('video'),
  file('file');

  const AttachmentType(this.attachment);

  final String attachment;
}

enum ReactionType {
  love('love'),
  lol('haha'),
  wow('wow'),
  sad('sad'),
  like('like');

  const ReactionType(this.reaction);

  final String reaction;
}

enum MessageDeliveryStatus { read, pending, sent, failed, nil }

const forbiddenWord = 'wth';
