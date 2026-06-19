/// Defines the push level for a channel,
/// which determines how notifications are sent to users.
extension type const PushLevel(String rawType) implements String {
  /// 'All' (default):
  /// All channel members receive push notifications for every message.
  static const all = PushLevel('all');

  /// `All mentions`:
  /// Channel members only receive push notifications when explicitly mentioned,
  /// or via @channel/@here/@group/@role.
  static const allMentions = PushLevel('all_mentions');

  /// 'Direct mentions':
  /// Channel members only receive push notifications when explicitly @mentioned
  /// by username or in thread replies.
  static const directMentions = PushLevel('direct_mentions');

  /// 'None':
  /// Push notifications are completely disabled for this channel.
  static const none = PushLevel('none');
}
