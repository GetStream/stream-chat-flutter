/// Who can see which option each user voted for in a poll.
///
/// A visibility without a constant here can still be named by wrapping its
/// value: `VotingVisibility('public')`.
extension type const VotingVisibility(String rawType) implements String {
  /// Votes are counted, but who cast them is hidden from other users.
  static const anonymous = VotingVisibility('anonymous');

  /// Everyone can see who voted for which option.
  static const public = VotingVisibility('public');
}
