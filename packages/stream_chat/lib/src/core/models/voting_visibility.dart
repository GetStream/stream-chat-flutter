/// The rule for who can see which option each user voted for in a poll.
///
/// A visibility without a constant here can still be named by wrapping its
/// value: `VotingVisibility('members_only')`.
extension type const VotingVisibility(String _) implements String {
  /// A visibility where votes are counted, but who cast them is hidden from
  /// other users.
  static const anonymous = VotingVisibility('anonymous');

  /// A visibility where everyone can see who voted for which option.
  static const public = VotingVisibility('public');
}
