/// How thoroughly something is deleted.
///
/// A delete type without a constant here can still be named by wrapping its
/// value: `DeleteType('soft')`.
extension type const DeleteType(String rawType) implements String {
  /// Marked deleted, and can be restored.
  static const soft = DeleteType('soft');

  /// Marked deleted, and its content discarded.
  static const pruning = DeleteType('pruning');

  /// Removed for good.
  static const hard = DeleteType('hard');
}
