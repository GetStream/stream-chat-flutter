/// Reaction icon data
class ReactionIcon {
  /// Constructor for creating [ReactionIcon]
  ReactionIcon({
    required this.type,
    required this.assetName,
  });

  /// Type of reaction
  final String type;

  /// Asset to display for reaction
  final String assetName;
}
