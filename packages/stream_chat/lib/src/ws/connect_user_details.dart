import '../core/models/own_user.dart';
import '../core/models/privacy_settings.dart';

/// The details of the user a connection is opened for.
///
/// Sent when the connection opens, which creates the user or updates them to
/// match.
class ConnectUserDetails {
  /// Creates [ConnectUserDetails] for the user [id].
  const ConnectUserDetails({
    required this.id,
    this.name,
    this.image,
    this.language,
    this.invisible,
    this.privacySettings,
    this.custom = const {},
  });

  /// Creates [ConnectUserDetails] from [user].
  factory ConnectUserDetails.fromOwnUser(OwnUser user) {
    return ConnectUserDetails(
      id: user.id,
      name: user.name,
      image: user.image,
      language: user.language,
      invisible: user.invisible,
      privacySettings: user.privacySettings,
      custom: user.custom,
    );
  }

  /// The user's id.
  final String id;

  /// The user's display name.
  final String? name;

  /// The address of the user's profile image.
  final String? image;

  /// The user's preferred language, such as `en`.
  final String? language;

  /// Whether the user appears offline to others.
  final bool? invisible;

  /// The user's privacy preferences.
  final PrivacySettings? privacySettings;

  /// The user's custom data.
  final Map<String, Object?> custom;

  /// Serializes these details for the request that opens a connection.
  ///
  /// Leaves out unset values, and custom entries named like one of
  /// [OwnUser.topLevelFields].
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': ?name,
      'image': ?image,
      'language': ?language,
      'invisible': ?invisible,
      'privacy_settings': ?privacySettings?.toJson(),
      'custom': {
        for (final MapEntry(:key, :value) in custom.entries)
          if (!OwnUser.topLevelFields.contains(key)) key: value,
      },
    };
  }
}
