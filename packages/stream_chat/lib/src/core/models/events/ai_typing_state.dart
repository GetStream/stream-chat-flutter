/// What an AI assistant is doing while it answers in a channel.
///
/// Any state an assistant reports is kept as it is, including ones the SDK
/// has no constant for.
extension type const AITypingState(String _) implements String {
  /// The assistant is idle.
  static const idle = AITypingState('AI_STATE_IDLE');

  /// The assistant could not answer.
  static const error = AITypingState('AI_STATE_ERROR');

  /// The assistant is checking sources.
  ///
  /// Assistants also report this as [checkingExternalSources]; consider
  /// [isCheckingSources] to match either.
  static const checkingSources = AITypingState('AI_STATE_CHECKING_SOURCES');

  /// The assistant is checking external sources.
  ///
  /// Assistants also report this as [checkingSources]; consider
  /// [isCheckingSources] to match either.
  static const checkingExternalSources = AITypingState('AI_STATE_EXTERNAL_SOURCES');

  /// The assistant is thinking.
  static const thinking = AITypingState('AI_STATE_THINKING');

  /// The assistant is generating its answer.
  static const generating = AITypingState('AI_STATE_GENERATING');

  /// Whether the assistant is checking sources, in either of the two ways it
  /// can report it.
  bool get isCheckingSources => this == checkingSources || this == checkingExternalSources;
}
