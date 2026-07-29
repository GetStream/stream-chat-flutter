enum AttachmentType {
  image('image'),
  video('video'),
  file('file');

  const AttachmentType(this.attachment);

  final String attachment;
}

enum ReactionType {
  // Emoji glyphs mirror `streamSupportedEmojis` in stream_core_flutter exactly
  // (incl. the U+FE0F variation selector on love) so `find.text` matches.
  love('love', '❤️'),
  lol('haha', '\u{1F602}'),
  wow('wow', '\u{1F62E}'),
  sad('sad', '\u{1F44E}'),
  like('like', '\u{1F44D}');

  const ReactionType(this.reaction, this.emoji);

  /// The reaction type string sent to/from the backend (e.g. `like`, `haha`).
  final String reaction;

  /// The emoji glyph the SDK renders for this reaction, used to locate the
  /// reaction on a message in the UI (the display chips expose no keys).
  final String emoji;
}

enum MessageDeliveryStatus { read, pending, sent, failed, nil }

const forbiddenWord = 'wth';
