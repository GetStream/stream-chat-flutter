/// The type of role used to filter results in
/// [StreamChatClient.searchRoles].
///
/// The server accepts only [user] or [channel]; any other value
/// returns a validation error.
extension type const RoleType(String rawType) implements String {
  /// Restricts results to roles valid as a user-level assignment
  /// (e.g. `user`, `admin`, `anonymous`).
  static const user = RoleType('user');

  /// Restricts results to roles valid as a channel-member assignment
  /// (e.g. `channel_member`, `channel_moderator`).
  static const channel = RoleType('channel');
}
